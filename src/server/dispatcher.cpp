/***************************************************************************
 *
 * Copyright (c) 2019 Zuoyebang.com, Inc. All Rights Reserved
 * $Id$
 *
 **************************************************************************/



/**
 * @file dispatcher.cpp
 * @author yujitai(yujitai@zuoyebang.com)
 * @version $Revision$
 * @brief
 *
 **/

#include "server/dispatcher.h"

#include <pthread.h>
#include <sys/time.h>

#include "server/event.h"
#include "server/worker.h"
#include "server/network.h"
#include "util/log.h"
#include "util/store_define.h"

namespace zf {

/**
 * @brief Dispatcher pipe message hanler
 **/
void recv_notify(EventLoop *el, IOWatcher *w, int fd, int revents, void *data) {
    UNUSED(el);
    UNUSED(w);
    UNUSED(revents);
    int msg;
    if (read(fd, &msg, sizeof(int)) != sizeof(int)) {
        log_warning("can't read from notify pipe");
        return;
    }
    GenericDispatcher *dispatcher = (GenericDispatcher*)data;
    dispatcher->process_internal_notify(msg);
}

/**
 * @brief Tcp server socket io handler
 */
void accept_new_conn(EventLoop *el, 
        IOWatcher* w, 
        int fd, 
        int revents, 
        void* data)  
{
    UNUSED(el);
    UNUSED(w);
    UNUSED(revents);
    
    struct timeval s, e, s1, e1; 
    int cfd;
    uint16_t cport;
    char cip[128];
    GenericDispatcher* dp = (GenericDispatcher*)data;
    
    gettimeofday(&s, NULL);
    cfd = tcp_accept(fd, cip, &cport); 
    if (cfd == NET_ERROR) {
        log_warning("[accept socket failed]");
        return;
    }
    
    gettimeofday(&s1, NULL);
    if (dp->dispatch_new_conn(cfd) == DISPATCHER_ERROR) {
        log_warning("[dispatch new connection failed]");
        return;
    }

    gettimeofday(&e1, NULL);
    log_debug("[dispatch new conn] cost[%luus] cfd[%d]", TIME_US_DIFF(s1, e1), cfd);

    gettimeofday(&e, NULL);
    log_debug("[accept new conn] cost[%luus] cfd[%d]", TIME_US_DIFF(s, e), cfd);
}

GenericDispatcher::GenericDispatcher(GenericServerOptions &o)
        : options(o),
          el(NULL), 
          io_watcher(NULL), 
          pipe_watcher(NULL),
          next_worker(0), 
          listen_fd(0) 
{
    el = new EventLoop((void*)this, false);
}

GenericDispatcher::~GenericDispatcher() {
    for (size_t i = 0; i < workers.size(); i++) {
        if (workers[i] != NULL) {
            delete workers[i];
            workers[i] = NULL;
        }
    }
    
    delete el;
}

int GenericDispatcher::init() {
    // set up pipe fd
    if (options.server_type == G_SERVER_PIPE 
            || options.server_type == G_SERVER_TCP 
            || options.server_type == G_SERVER_UDP) 
    {
        int fds[2];
        if (pipe(fds)) {
            log_fatal("can't create notify pipe");
            return DISPATCHER_ERROR;
        }
        notify_recv_fd = fds[0];
        notify_send_fd = fds[1];
        pipe_watcher = el->create_io_event(recv_notify, (void*)this);
        if (pipe_watcher == NULL)
            return DISPATCHER_ERROR;
        el->start_io_event(pipe_watcher, notify_recv_fd, EventLoop::READ);
    }

    // set up the tcp server socket.
    if (options.server_type == G_SERVER_TCP) {
        listen_fd = create_tcp_server(options.port, options.host);
        if (listen_fd == NET_ERROR) {
            log_fatal("Can't create tcp server on %s:%d",
                      options.host, options.port);
            return DISPATCHER_ERROR;
        }
        log_trace("start listen port %d", options.port);

        io_watcher = el->create_io_event(accept_new_conn, (void*)this);
        if (io_watcher == NULL) {
            log_fatal("Can't create io event for accept_new_conn");
            return DISPATCHER_ERROR;
        }
        el->start_io_event(io_watcher, listen_fd, EventLoop::READ);
    }

    // set up the udp server socket.
    if (options.server_type == G_SERVER_UDP) {
        int fd = create_udp_server(options.port, options.host);
        if (fd == NET_ERROR) {
            log_fatal("Can't create udp server on %s:%d",
                      options.host, options.port);
            return DISPATCHER_ERROR;
        }

        // ...
    }

    for (int i = 0; i < options.worker_num; i++) {
        if (spawn_worker() == DISPATCHER_ERROR) {
            return DISPATCHER_ERROR;
        }
    }

    return DISPATCHER_OK;
}

void GenericDispatcher::stop() {
    // stop pipe watcher
    if (pipe_watcher)
        el->delete_io_event(pipe_watcher);

    // stop event loop
    if (io_watcher)
        el->delete_io_event(io_watcher);

    el->stop();
    log_notice("event loop stopped");

    // close socket
    close(listen_fd);
    log_notice("close listening socket");

    // tell workers to quit
    join_workers();
    log_notice("joined workers");
}

void GenericDispatcher::run() {
    log_notice("dispatcher start");
    el->run();
}

// spawn a new worker and push it into the GenericDispatcher::workers
int GenericDispatcher::spawn_worker() {
    if (options.worker_factory_func == NULL) {
        log_fatal("you should specify worker_factory_func to create worker");
        return DISPATCHER_ERROR;
    }

    GenericWorker *new_worker = options.worker_factory_func(options);
    new_worker->init();
    if (create_thread(new_worker) == THREAD_ERROR) {
        log_fatal("failed to create worker thread");
        return DISPATCHER_ERROR;
    }
    std::stringstream worker_id;
    worker_id << new_worker->_thread_name << "_" << new_worker->_thread_id;
    new_worker->set_worker_id(worker_id.str());
    workers.push_back(new_worker);

    return DISPATCHER_OK;
}

int GenericDispatcher::join_workers() {
    for (size_t i = 0; i < workers.size(); i++) {
        if (workers[i] != NULL) {
            workers[i]->notify(GenericWorker::QUIT);
            if (join_thread(workers[i]) == THREAD_ERROR) {
                log_fatal("failed to join worker thread");
            }
        }
    }

    return DISPATCHER_OK;
}

int GenericDispatcher::dispatch_new_conn(int fd) {
    log_debug("[dispatch new connection] fd[%d]", fd);

    // Just use a round-robin right now.
    GenericWorker *worker = workers[next_worker];
    next_worker = (next_worker + 1) % workers.size();
    int* nfd = new int(fd);
    worker->mq_push((void*)nfd);

    // Notify worker the arrival of a new connection.
    if (worker->notify(GenericWorker::NEWCONNECTION) != WORKER_OK) {
        log_warning("[write worker notify pipe failed");
        return DISPATCHER_ERROR;             
    }
       
    return DISPATCHER_OK;
}

void GenericDispatcher::process_internal_notify(int msg) {
    switch (msg) {
        case QUIT:                       // stop
            stop();
            break;
        default:
            process_notify(msg);
            break;
    }    
}

void GenericDispatcher::process_notify(int msg) {
    log_warning("unknow notification: %d", msg);
}

int GenericDispatcher::notify(int msg) {
    int written = write(notify_send_fd, &msg, sizeof(int));     
    if (written == sizeof(int)) {
        return DISPATCHER_OK;
    } else {
        return DISPATCHER_ERROR;
    }
}

void GenericDispatcher::mq_push(void *msg) {
    mq.produce(msg);
}

bool GenericDispatcher::mq_pop(void **msg) {
    return mq.consume(msg);
}

int64_t GenericDispatcher::get_clients_count(std::string& clients_detail) {
    std::stringstream temp;
    int64_t current_count = 0;
    temp << "[";
    for (size_t i = 0; i < workers.size(); i++) {
        if (workers[i] != NULL) {
            std::string workerid_temp = workers[i]->get_worker_id();
            int64_t  count_temp = workers[i]->get_clients_count();
            current_count += count_temp;
            temp << "," << workerid_temp << ":" << count_temp;
        }
    }
    temp << "]";
    clients_detail = temp.str().c_str();
    return current_count;
}

} // namespace zf



/***************************************************************************
 *
 * Copyright (c) 2019 Zuoyebang.com, Inc. All Rights Reserved
 * $Id$
 *
 **************************************************************************/



/**
 * @file worker.h
 * @author yujitai(yujitai@zuoyebang.com)
 * @version $Revision$
 * @brief
 *
 **/

#include "server/worker.h"

#include <fcntl.h>
#include <sys/time.h>

#include "server/event.h"
#include "server/network.h"
#include "util/status.h"
#include "util/zmalloc.h"
#include "util/scoped_ptr.h"

namespace zf {

static const size_t INITIAL_FD_NUM = 1024;

static void recv_notify(EventLoop *el, 
        IOWatcher *w, 
        int fd, 
        int revents, 
        void *data) 
{
    UNUSED(el);
    UNUSED(w);
    UNUSED(revents);

    int msg;
    if (read(fd, &msg, sizeof(int)) != sizeof(int)) {
        log_warning("can't read from noitfy pipe");
        return;
    }
    GenericWorker *worker = (GenericWorker*)data;
    worker->process_internal_notify(msg);
}

/**
 * @brief Callback for connection io events 
 */
void conn_io_cb(EventLoop *el, 
        IOWatcher *w, 
        int fd, 
        int revents, 
        void *data) 
{
    UNUSED(w);
    UNUSED(data);

    GenericWorker* worker = (GenericWorker*)(el->owner);
    if (revents & EventLoop::READ) {
        worker->read_io(fd);
    }
    if (revents & EventLoop::WRITE) {
        worker->write_io(fd);
    } 
}

void conn_udp_io_cb(EventLoop *el, 
        IOWatcher *w, 
        int fd, 
        int revents, 
        void *data) 
{
    UNUSED(w);
    UNUSED(data);

    GenericWorker* worker = (GenericWorker*)(el->owner);
    if (revents & EventLoop::READ) {
        worker->udp_read_io(fd);
    }
    if (revents & EventLoop::WRITE) {
        worker->udp_write_io(fd);
    } 
}

/**
 * Connection timeout callback
 **/
void timeout_cb(EventLoop* el, TimerWatcher* w, void* data) {
    UNUSED(w);

    GenericWorker* worker = (GenericWorker*)(el->owner);
    Connection* c = (Connection*)data;
    worker->process_timeout(c);
}

/**
 * Callback for cron work
 **/
void cron_cb(EventLoop* el, TimerWatcher* w, void* data) 
{
    UNUSED(w);
    UNUSED(el);

    GenericWorker *worker = (GenericWorker*)data;
    worker->process_cron_work();
}

void GenericWorker::read_io(int fd) {
    assert(fd >= 0);
    
    if ((unsigned int)fd >= conns.size()) {
        log_warning("invalid fd: %d", fd);
        return;
    }

    Connection* c = conns[fd];
    if (c == NULL) {
        log_warning("connection not exists");
        return;
    }
  
    int rlen = c->bytes_expected;
    size_t iblen = sdslen(c->io_buffer);
    c->io_buffer = sdsMakeRoomFor(c->io_buffer, rlen);
    int r = sock_read_data(fd, c->io_buffer + iblen, rlen);
    if (r == NET_ERROR) {
        log_debug("sock_read_data: return error, close connection");
        close_conn(c);
        return;
    } else if (r == NET_PEER_CLOSED) {
        log_debug("sock_read_data: return 0, peer closed");
        close_conn(c);
        return;
    } else if (r > 0) {
        sdsIncrLen(c->io_buffer, r);
    }
    c->last_interaction = el->now();

    // Upper process.
    if (sdslen(c->io_buffer) - c->bytes_processed >= c->bytes_expected) {
        if (WORKER_OK != this->process_io_buffer(c)) {
            log_debug("read_io: user return error, close connection");
            close_conn(c);
        }
    }
}

void GenericWorker::udp_read_io(int fd) {
    assert(fd >= 0);
    
    if ((unsigned int)fd >= conns.size()) {
        log_warning("invalid fd: %d", fd);
        return;
    }

    Connection* c = conns[fd];
    if (c == NULL) {
        log_warning("connection not exists");
        return;
    }

    int rlen = c->bytes_expected;
    size_t iblen = sdslen(c->io_buffer);
    c->io_buffer = sdsMakeRoomFor(c->io_buffer, rlen);
    int r = sock_read_data(fd, c->io_buffer + iblen, rlen);
    if (r == NET_ERROR) {
        log_debug("sock_read_data: return error, close connection");
        close_conn(c);
        return;
    } else if (r == NET_PEER_CLOSED) {
        log_debug("sock_read_data: return 0, peer closed");
        close_conn(c);
        return;
    } else if (r > 0) {
        cout << "fuck udp read -> " << c->io_buffer + iblen << endl;
        sdsIncrLen(c->io_buffer, r);
    }
    c->last_interaction = el->now();
#if 0
    // Upper process.
    if (WORKER_OK != this->process_io_buffer(c)) {
        log_debug("read_io: user return error, close connection");
        close_conn(c);
    }
#endif
}

int GenericWorker::add_reply(Connection *c, const Slice& reply) {
    c->reply_list.push_back(reply);
    c->reply_list_size++;
    enable_events(c, EventLoop::WRITE);

    return c->reply_list_size;
}

int GenericWorker::reply_list_size(Connection *c) {
    return c->reply_list_size;
}

void GenericWorker::write_io(int fd) {
    assert(fd >= 0);
    if ((unsigned int)fd >= conns.size()) {
        log_warning("invalid fd: %d", fd);
        return;
    }
    Connection *c = conns[fd];
    if (c == NULL) {
        log_warning("connection not exists");
        return;
    }

    while (!c->reply_list.empty()) {
        Slice reply = c->reply_list.front();
        int w = sock_write_data(fd,
                reply.data() + c->cur_resp_pos,
                reply.size() - c->cur_resp_pos);

        if (w == NET_ERROR) {
            log_debug("sock_write_data: return error, close connection");
            close_conn(c);
            return;
        } else if(w == 0) {         /* would block */
            log_warning("write zero bytes, want[%d] fd[%d] ip[%s]", int(reply.size() - c->cur_resp_pos), c->fd, c->ip);
            return;
        } else if ((w + c->cur_resp_pos) == reply.size()) { /* finish */
            c->reply_list.pop_front();
            c->reply_list_size--;
            c->cur_resp_pos = 0;
            zfree((void*)reply.data());
        } else {
            c->cur_resp_pos += w;
        }
    }
    c->last_interaction = el->now();

    /* no more replies to write */
    if (c->reply_list.empty())
        disable_events(c, EventLoop::WRITE);
}

void GenericWorker::udp_write_io(int fd) {
    assert(fd >= 0);
    if ((unsigned int)fd >= conns.size()) {
        log_warning("invalid fd: %d", fd);
        return;
    }
    Connection *c = conns[fd];
    if (c == NULL) {
        log_warning("connection not exists");
        return;
    }

    while (!c->reply_list.empty()) {
        Slice reply = c->reply_list.front();
        int w = sock_write_data(fd,
                reply.data() + c->cur_resp_pos,
                reply.size() - c->cur_resp_pos);

        if (w == NET_ERROR) {
            log_debug("sock_write_data: return error, close connection");
            close_conn(c);
            return;
        } else if(w == 0) {         /* would block */
            log_warning("write zero bytes, want[%d] fd[%d] ip[%s]", int(reply.size() - c->cur_resp_pos), c->fd, c->ip);
            return;
        } else if ((w + c->cur_resp_pos) == reply.size()) { /* finish */
            c->reply_list.pop_front();
            c->reply_list_size--;
            c->cur_resp_pos = 0;
            zfree((void*)reply.data());
        } else {
            c->cur_resp_pos += w;
        }
    }
    c->last_interaction = el->now();

    /* no more replies to write */
    if (c->reply_list.empty())
        disable_events(c, EventLoop::WRITE);
}


void GenericWorker::disable_events(Connection *c, int events) {
    el->stop_io_event(c->watcher, c->fd, events);
}

void GenericWorker::enable_events(Connection *c, int events) {
    el->start_io_event(c->watcher, c->fd, events);
}

void GenericWorker::start_timer(Connection *c) {
    el->start_timer(c->timer, options.tick);
}

Connection* GenericWorker::new_tcp_conn(int fd) {
    assert(fd >= 0);
    log_debug("[new connection] fd[%d]", fd);

    sock_setnonblock(fd);
    sock_setnodelay(fd);  
    Connection* c = new Connection(fd);
    sock_peer_to_str(fd, c->ip, &(c->port));
    c->last_interaction = el->now();

    // create io event and timer for the connection.
    c->watcher = el->create_io_event(conn_io_cb, (void*)c);
    c->timer = el->create_timer(timeout_cb, (void*)c, true);

    // start io and timer.
    if (options.ssl_open) {
        enable_events(c, EventLoop::READ | EventLoop::WRITE);
    } else {
        enable_events(c, EventLoop::READ);
    }
    start_timer(c);

    if ((unsigned int)fd >= conns.size())
        conns.resize(fd*2, NULL);

    conns[fd] = c;

    return c;
}

Connection* GenericWorker::new_udp_conn(int fd) {
    assert(fd >= 0);
    log_debug("[new udp connection] fd[%d]", fd);

    sock_setnonblock(fd);
    Connection* c = new Connection(fd);
    c->last_interaction = el->now();

    // create io event and timer for the connection.
    c->watcher = el->create_io_event(conn_udp_io_cb, (void*)c);
    c->timer = el->create_timer(timeout_cb, (void*)c, true);

    // start io and timer.
    if (options.ssl_open) {
        enable_events(c, EventLoop::READ | EventLoop::WRITE);
    } else {
        enable_events(c, EventLoop::READ);
    }
    start_timer(c);

    if ((unsigned int)fd >= conns.size())
        conns.resize(fd*2, NULL);

    conns[fd] = c;

    return c;
}

void GenericWorker::close_conn(Connection *c) {
    log_debug("close connection");
    int fd = c->fd; 
    remove_conn(c);
    close(fd);
}

void GenericWorker::close_all_conns() {
    for (std::vector<Connection*>::iterator it = conns.begin();
         it != conns.end(); ++it)
    {
        if (*it != NULL) close_conn(*it);
    }
}

void GenericWorker::remove_conn(Connection *c) {
    c->last_interaction = el->now();
    before_remove_conn(c);
    el->delete_io_event(c->watcher);  
    el->delete_timer(c->timer);
    if (c->priv_data_destructor) {
        c->priv_data_destructor(c->priv_data);
    }
    // stat_decr("current_connections");
    conns[c->fd] = NULL;
    after_remove_conn(c);

    delete c;
}

void GenericWorker::process_cron_work() {
}

int64_t GenericWorker::get_clients_count(){
    return online_count;
}
void GenericWorker::set_clients_count(int64_t count){
     online_count = count;
     return;
}

GenericWorker::GenericWorker(const GenericServerOptions &o, 
        const std::string& thread_name)
    : Runnable(thread_name), 
      options(o), 
      el(NULL), 
      pipe_watcher(NULL), 
      cron_timer(NULL)
{
    conns.resize(INITIAL_FD_NUM, NULL);
    el = new EventLoop((void*)this, false);
    online_count = 0;
    worker_id = "";
}

GenericWorker::~GenericWorker() {
    close_all_conns();
    delete el;
    //stat_destroy();
}

void GenericWorker::set_worker_id(const std::string& id) {
    worker_id = id;
    return;
}

const std::string& GenericWorker::get_worker_id() {
    return worker_id;
}

int GenericWorker::init() {
    int fds[2];
    if (pipe(fds)) {
        log_fatal("can't create notify pipe");
        return WORKER_ERROR;
    }
    notify_recv_fd = fds[0];
    notify_send_fd = fds[1];

    // Listen for notifications from dispatcher thread
    pipe_watcher = el->create_io_event(recv_notify, (void*)this);
    if (pipe_watcher == NULL)
        return WORKER_ERROR;
    el->start_io_event(pipe_watcher, notify_recv_fd, EventLoop::READ);
    // start cron timer
    cron_timer = el->create_timer(cron_cb, (void*)this, true);
    el->start_timer(cron_timer, options.tick);

    return WORKER_OK;
}

void GenericWorker::stop() {
    el->delete_timer(cron_timer);    
    el->delete_io_event(pipe_watcher);
    close(notify_recv_fd);
    close(notify_send_fd);
    el->stop();
    for (size_t i = 0; i < conns.size(); i++) {
        if (conns[i] != NULL)
            close_conn(conns[i]);
    }
}

void GenericWorker::mq_push(void *msg) {
    mq.produce(msg);
}

bool GenericWorker::mq_pop(void **msg) {
    return mq.consume(msg);
}

void GenericWorker::run() {
    el->run();
}

int GenericWorker::notify(int msg) {
    struct timeval s, e; 
    gettimeofday(&s, NULL);
    int written = write(notify_send_fd, &msg, sizeof(int));
    gettimeofday(&e, NULL);
    log_debug("[write worker pipe] cost[%luus] msg_type[%d]", TIME_US_DIFF(s, e), msg);

    if (written == sizeof(int))
        return WORKER_OK;
    else
        return WORKER_ERROR;
}

void GenericWorker::process_internal_notify(int msg) {
    int* cfd;

    switch (msg) {
        case QUIT:          
            stop();
            break;
        case TCPCONNECTION:         
            if (mq_pop((void**)&cfd)) {
                new_tcp_conn(*cfd);
                delete cfd;
            }
            break;
        case UDPCONNECTION:
            if (mq_pop((void**)&cfd)) {
                new_udp_conn(*cfd);
                delete cfd;
            }
            break;
        default:
            process_notify(msg);
            break;
    }
}

void GenericWorker::process_notify(int msg) {
    log_warning("unknow notify: %d", msg);
}

void GenericWorker::process_timeout(Connection* c) {
    if ((el->now() - c->last_interaction) > 
            (uint64_t)options.connection_timeout)
    {
        log_debug("[time out] close fd[%d]", c->fd);
        close_conn(c);
    }
}

} // namespace zf



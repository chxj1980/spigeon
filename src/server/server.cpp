/***************************************************************************
 *
 * Copyright (c) 2019 Zuoyebang.com, Inc. All Rights Reserved
 * $Id$
 *
 **************************************************************************/



/**
 * @file server.cpp
 * @author yujitai(yujitai@zuoyebang.com)
 * @version $Revision$
 * @brief
 *
 **/

#include "server/server.h"

#include "server/dispatcher.h"
#include "util/zmalloc.h"

namespace zf {

static command_t server_cmd_table[] = {
    { "ip",
      conf_set_str_slot,
      offsetof(GenericServerOptions, ip) },

    { "port",
      conf_set_num_slot,
      offsetof(GenericServerOptions, port) },

    { "worker_num",
      conf_set_num_slot,
      offsetof(GenericServerOptions, worker_num) },

    { "bind_cpu",
      conf_set_flag_slot,
      offsetof(GenericServerOptions, bind_cpu) },

    { "server_type",
      conf_set_num_slot,
      offsetof(GenericServerOptions, server_type) },

    { "connection_timeout",
      conf_set_usec_slot,
      offsetof(GenericServerOptions, connection_timeout) },

    { "tick",
      conf_set_usec_slot,
      offsetof(GenericServerOptions, tick) },

    { "max_io_buffer_size",
      conf_set_mem_slot,
      offsetof(GenericServerOptions, max_io_buffer_size) },

    { "max_reply_list_size",
      conf_set_num_slot,
      offsetof(GenericServerOptions, max_reply_list_size) },

    null_command
};

GenericServerOptions::GenericServerOptions() 
    : ip(NULL),
      port(0),
      worker_num(8),
      bind_cpu(true),
      server_type(G_SERVER_TCP),
      connection_timeout(60*1000*1000),
      tick(1000),
      max_io_buffer_size(10*1024*1024),
      max_reply_list_size(1024),
      worker_factory_func(NULL),
      ssl_open(0)
{
}

GenericServer::GenericServer(const std::string& thread_name) 
    : Runnable(thread_name),
      _dispatcher(NULL) 
{
}

GenericServer::~GenericServer() {
    delete _dispatcher;
    _dispatcher = NULL;
}

int GenericServer::init_conf() {
    _options = GenericServerOptions();

    return SERVER_OK;
}

int GenericServer::init_conf(struct Options& o) {
    _options = (struct GenericServerOptions&)o;
    if (_options.ip == NULL)
        _options.ip = "0.0.0.0";

    return SERVER_OK;
}

int GenericServer::load_conf(const char* filename) {
    if (load_conf_file(filename, server_cmd_table, &_options) != CONFIG_OK) {
        log_fatal("failed to load config file for server module");
        return SERVER_ERROR;
    } else {
        fprintf(stderr,
                "Server Options:\n"
                "ip: %s\n"
                "port: %d\n"
                "worker_num: %d\n"
                "bind_cpu: %d\n"
                "server_type: %d\n"
                "connection_timeout: %lld\n"
                "tick: %lld\n"
                "max_io_buffer_size: %lld\n"
                "max_reply_list_size: %d\n",
                _options.ip,
                _options.port,
                _options.worker_num,
                _options.bind_cpu,
                _options.server_type,
                _options.connection_timeout,
                _options.tick,
                _options.max_io_buffer_size,
                _options.max_reply_list_size);
        fprintf(stderr, "\n");

        return SERVER_OK;
    }
}

int GenericServer::validate_conf() {
    return SERVER_OK;
}

int GenericServer::initialize() {
    _dispatcher = new GenericDispatcher(_options);
    if (_dispatcher->initialize() != DISPATCHER_OK) {
        log_fatal("Init dispatcher failed.");
        return SERVER_ERROR;
    }

    return SERVER_OK;
}
  
void GenericServer::run() {
    _dispatcher->run();
}

void GenericServer::stop() {
    _dispatcher->notify(GenericDispatcher::QUIT);
}

// TODO:测试
int64_t GenericServer::get_clients_count(std::string& clients_detail) {
    return _dispatcher->get_clients_count(clients_detail);
}

} // namespace zf



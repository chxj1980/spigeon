/***************************************************************************
 * 
 * Copyright (c) 2019 Zuoyebang.com, Inc. All Rights Reserved
 * $Id$ 
 * 
 **************************************************************************/
 
 
 
/**
 * @file network.cpp
 * @author yujitai(yujitai@zuoyebang.com)
 * @version $Revision$ 
 * @brief 
 *  
 **/

#include "server/network.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <netdb.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>

#include "util/log.h"

namespace zf {

static int create_socket(int domain, int type) {
    int s; 
    int on = 1;
    if ((s = socket(domain, type, 0)) == -1) {
        log_warning("creating socket: %s", strerror(errno));
        return NET_ERROR;
    }

    if (setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) == -1) {
        log_warning("setsockopt SO_REUSEADDR: %s", strerror(errno));
        return NET_ERROR;
    }

    return s;
}

static int socket_listen(int s, struct sockaddr *sa, socklen_t len) {
    if (bind(s,sa,len) == -1) {
        log_warning("bind: %s", strerror(errno));
        close(s);
        return NET_ERROR;
    }

    /* Use a backlog of 512 entries. We pass 511 to the listen() call because
     * the kernel does: backlogsize = roundup_pow_of_two(backlogsize + 1);
     * which will thus give us a backlog of 512 entries */
    if (listen(s, 4095) == -1) {
        log_warning("listen: %s", strerror(errno));
        close(s);
        return NET_ERROR;
    }

    return NET_OK;
}

int create_udp_server(int port, const char* bind_addr) {
    int s;
    struct sockaddr_in sa;

    if ((s = create_socket(AF_INET, SOCK_DGRAM)) == NET_ERROR)
        return NET_ERROR;

    memset(&sa,0,sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    sa.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind_addr && inet_aton(bind_addr, &sa.sin_addr) == 0) {
        log_warning("invalid bind address");
        close(s);
        return NET_ERROR;
    }

    return s;
}

int create_tcp_server(int port, const char* bind_addr) {
    int s;
    struct sockaddr_in sa;

    if ((s = create_socket(AF_INET, SOCK_STREAM)) == NET_ERROR)
        return NET_ERROR;

    memset(&sa,0,sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    sa.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind_addr && inet_aton(bind_addr, &sa.sin_addr) == 0) {
        log_warning("invalid bind address");
        close(s);
        return NET_ERROR;
    }

    if (socket_listen(s,(struct sockaddr*)&sa,sizeof(sa)) == NET_ERROR)
        return NET_ERROR;

    return s;
}

static int generic_accept(int s, struct sockaddr *sa, socklen_t *len) {
    int fd;
    while(1) {
        fd = accept(s, sa, len);
        if (fd == -1) {
            if (errno == EINTR)
                continue;
            else {
                log_warning("accept: %s", strerror(errno));
                return NET_ERROR;
            }
        }
        break;
    }

    return fd;
}

int tcp_accept(int s, char *ip, int *port) {
    int fd;
    struct sockaddr_in sa;
    socklen_t salen = sizeof(sa);
    if ((fd = generic_accept(s,(struct sockaddr*)&sa,&salen)) == NET_ERROR)
        return NET_ERROR;

    if (ip) strcpy(ip,inet_ntoa(sa.sin_addr));
    if (port) *port = ntohs(sa.sin_port);

    return fd;
}

int sock_setnonblock(int fd) {
    int flags;

    /** 
     * Set the socket nonblocking.
     * Note that fcntl(2) for F_GETFL and F_SETFL can't be
     * interrupted by a signal. 
     */
    if ((flags = fcntl(fd, F_GETFL)) == -1) {
        log_warning("fcntl(F_GETFL): %s", strerror(errno));
        return NET_ERROR;
    }
    if (fcntl(fd, F_SETFL, flags | O_NONBLOCK) == -1) {
        log_warning("fcntl(F_SETFL, O_NONBLOCK): %s", strerror(errno));
        return NET_ERROR;
    }
    return NET_OK;
}

int sock_setnodelay(int fd) {
    int yes = 1;
    if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &yes, sizeof(yes)) == -1) {
        log_warning("setsockopt TCP_NODELAY: %s", strerror(errno));
        return NET_ERROR;
    }

    return NET_OK;
}

int sock_read_data(int fd, char* buf, size_t len) {
    int r = read(fd, buf, len);
    if (r == -1) {
        if (errno == EAGAIN)
            r = 0;
        else {
            log_debug("read: %s", strerror(errno));
            return NET_ERROR;
        }
    } else if (r == 0) {
        log_debug("read: peer closed");
        return NET_PEER_CLOSED;
    }

    return r;
}

int sock_write_data(int fd, const char* buf, size_t len) {
    int w = write(fd, buf, len);
    if (w == -1) {
        if (errno == EAGAIN)
            w = 0;
        else {
            log_debug("write: %s", strerror(errno));
            return NET_ERROR;
        }
    }

    return w;
}

int tcp_connect(const char *addr, int port) {
    int s = create_socket(AF_INET, SOCK_STREAM);
    if (s == NET_ERROR)
        return NET_ERROR;
    struct sockaddr_in sa;
    sa.sin_family = AF_INET;
    sa.sin_port = htons(port);
    if (inet_aton(addr, &sa.sin_addr) == 0) {
        struct hostent *he;

        he = gethostbyname(addr);
        if (he == NULL) {
            log_warning("can't resolve: %s", addr);
            close(s);
            return NET_ERROR;
        }
        memcpy(&sa.sin_addr, he->h_addr, sizeof(struct in_addr));
    }
    if (connect(s, (struct sockaddr*)&sa, sizeof(sa)) == -1) {
        log_warning("connect: %s", strerror(errno));
        close(s);
        return NET_ERROR;
    }

    return s;
}

int sock_get_name(int fd, char *ip, int *port) {
    struct sockaddr_in sa;
    socklen_t salen = sizeof(sa);

    if (getsockname(fd, (struct sockaddr*)&sa, &salen) == -1) {
        *port = 0;
        ip[0] = '?';
        ip[1] = '\0';
        return NET_ERROR;
    }
    if (ip) strcpy(ip, inet_ntoa(sa.sin_addr));
    if (port) *port = ntohs(sa.sin_port);

    return NET_OK;
}

int sock_peer_to_str(int fd, char *ip, int *port) {
    struct sockaddr_in sa;
    socklen_t salen = sizeof(sa);

    if (getpeername(fd,(struct sockaddr*)&sa,&salen) == -1) {
        *port = 0;
        ip[0] = '?';
        ip[1] = '\0';
        return NET_ERROR;
    }
    if (ip) strcpy(ip,inet_ntoa(sa.sin_addr));
    if (port) *port = ntohs(sa.sin_port);

    return NET_OK;
}

} // namespace zf


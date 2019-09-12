/***************************************************************************
 * 
 * Copyright (c) 2019 Zuoyebang.com, Inc. All Rights Reserved
 * $Id$ 
 * 
 **************************************************************************/
 
 
 
/**
 * @file udp_connection.h
 * @author yujitai(yujitai@zuoyebang.com)
 * @version $Revision$ 
 * @brief 
 *  
 **/


#ifndef  __UDP_CONNECTION_H_
#define  __UDP_CONNECTION_H_

namespace zf {

/**
 * UDPConnection
 */
class UDPConnection : public Connection {
public:
    UDPConnection();
    virtual ~UDPConnection() override;
};

} // namespace zf

#endif  //__UDP_CONNECTION_H_


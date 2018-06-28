//
//  Server.m
//  APIDemo
//
//  Created by Chan on 2018/6/26.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "Server.h"

@interface Server () <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *_server;
}

@end

@implementation Server

- (void)viewDidLoad {
    [super viewDidLoad];
    _server = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() ];
    //监听客户端的端口号
    NSError *error = nil;
    [_server  acceptOnPort:8080
                     error:&error];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

// MARK: - 监听到客户端
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
 
}


@end

//
//  ClientVC.m
//  APIDemo
//
//  Created by Chan on 2018/6/26.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ClientVC.h"
#import "LocalPushCenter.h"

@interface ClientVC () <GCDAsyncSocketDelegate> {
    NSTimer *_timer;
}

@end

@implementation ClientVC

// MARK: - viewControlelr'view's lifeCircle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_client disconnect];
    [_timer  invalidate];
    _timer = nil;
    NSLog(@"socket断开了连接！");
}

- (void)readData {
    [_client readDataToLength:1000 withTimeout:-1 tag:123];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _client = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    //连接服务端 IP和Port
    [_client  connectToHost:@"192.168.2.135"
                     onPort:8080
                      error:&error];
    if (error) {
        NSLog(@"链接服务端失败!");
    } else{
        
    }
    if (@available(iOS 10.0, *)) {
        __weak typeof(self)weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            ClientVC *strongSelf = weakSelf;
            //向服务器发送数据
            
            [strongSelf sendDataToServer];
        }];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendDataToServer) userInfo:nil repeats:YES];
    }
    [_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"readData" style:UIBarButtonItemStylePlain target:self action:@selector(readData)];
    //监听接收服务端传过来的数据
    [_client readDataWithTimeout:-1 tag:123];
}

-(void)sendDataToServer {
    [_client writeData:[@"HelloWord!" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1.0 tag:123];
}

// MARK: -GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接上了服务端!");
}

// MARK: - 数据接收
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *recieveStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.navigationItem.title = recieveStr;
    NSLog(@"接收到服务端的数据:%@",recieveStr);
    //监听服务端发送过来的数据
    [_client readDataWithTimeout:-1 tag:123];
    //本地推送一波
    [LocalPushCenter localPushForDate:[NSDate date]
                               forKey:recieveStr
                            alertBody:recieveStr
                          alertAction:recieveStr
                            soundName:nil
                          launchImage:nil
                             userInfo:@{@"info":recieveStr}
                           badgeCount:1
                       repeatInterval:NSCalendarUnitDay];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
}

// MARK: - 数据发送
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"向服务端发送数据!");
}

// MARK: - 与服务端断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"与服务端断开了!");
}

// MARK: - memory management
-(void)dealloc {
    [_timer invalidate];
    _timer = nil;
    _client.delegate = nil;
    [_client disconnect];
    _client = nil;
}
@end

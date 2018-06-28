//
//  HttpClient.m
//  APIDemo
//
//  Created by Chan on 2018/6/21.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "HttpClient.h"
@implementation HttpClient

+ (instancetype)shareClient {
   static HttpClient *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    return shareInstance;
}
@end

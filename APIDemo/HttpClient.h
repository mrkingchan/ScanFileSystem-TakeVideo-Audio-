//
//  HttpClient.h
//  APIDemo
//
//  Created by Chan on 2018/6/21.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#define kHttpClient [HttpClient shareClient]
@interface HttpClient : AFHTTPSessionManager

+ (instancetype)shareClient;

@end

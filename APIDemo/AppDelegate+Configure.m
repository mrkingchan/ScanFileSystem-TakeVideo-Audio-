//
//  AppDelegate+Configure.m
//  APIDemo
//
//  Created by Macx on 2018/6/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate+Configure.h"

@implementation AppDelegate (Configure)

-(void)configureApplicationWithComplete:(void (^)(void))complete {
    [UMConfigure  initWithAppkey:kAppKey channel:nil];
    [UMConfigure setLogEnabled:YES];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWeChatKey
                                       appSecret:kWeChatSecrectKey
                                     redirectURL:kBaseURL];
}
@end
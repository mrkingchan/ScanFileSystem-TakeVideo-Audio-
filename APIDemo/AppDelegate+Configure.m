//
//  AppDelegate+Configure.m
//  APIDemo
//
//  Created by Chan on 2018/6/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate+Configure.h"

@implementation AppDelegate (Configure)

-(void)configureApplicationWithComplete:(void (^)(void))complete {
    [UMConfigure  initWithAppkey:kAppKey channel:nil];
    [UMConfigure setLogEnabled:YES];
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:kAppKey];
    [[UMSocialManager defaultManager] setUmSocialAppSecret:kAppSecrectKey];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:kWeChatKey
                                       appSecret:kWeChatSecrectKey
                                     redirectURL:kBaseURL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite
                                          appKey:kWeChatKey
                                       appSecret:kWeChatSecrectKey
                                     redirectURL:kBaseURL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine
                                          appKey:kWeChatKey
                                       appSecret:kWeChatSecrectKey
                                     redirectURL:kBaseURL];
}
@end

//
//  AppDelegate+Configure.h
//  APIDemo
//
//  Created by Chan on 2018/6/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Configure)


/**
 配置一些三方

 @param complete 完成之后的回调 
 */
- (void)configureApplicationWithComplete:(void(^)(void))complete;


@end

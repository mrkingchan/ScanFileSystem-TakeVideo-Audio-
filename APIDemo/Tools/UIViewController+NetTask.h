//
//  UIViewController+NetTask.h
//  RenCaiYingHang
//
//  Created by Macx on 2018/8/16.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NetTask)

@property(nonatomic,strong)NSMutableArray <NSURLSessionDataTask *> *tasks;

/**
 添加网络操作

 @param task 网络操作
 */
- (void)addNetWork:(NSURLSessionDataTask *)task;


/**
 释放网络操作
 */
- (void)releaseNetWork;


@end

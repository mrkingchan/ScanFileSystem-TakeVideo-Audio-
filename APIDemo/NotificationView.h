//
//  NotificationView.h
//  APIDemo
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeBlock)(NSArray *contents);

@interface NotificationView : UIView

+ (instancetype)notificationViewWithContent:(NSArray *)contents complete:(completeBlock)complete;

@end

//
//  BadgeView.h
//  APIDemo
//
//  Created by Macx on 2018/7/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeView : UIView

- (void)updateCount:(NSInteger)count;

@property(nonatomic,assign) NSInteger count;


@end

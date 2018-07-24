//
//  SeperateLine.m
//  APIDemo
//
//  Created by Macx on 2018/7/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SeperateLine.h"

@implementation SeperateLine

- (instancetype)initWithY:(CGFloat)Y {
    if (self = [super initWithFrame:CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width- 80, 1.0)]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat itemW = [UIScreen mainScreen].bounds.size.width / 100;
        for (int i = 0 ; i < 80; i ++ ) {
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(i * itemW, 0, itemW, 1.0)];
            subView.backgroundColor = i%2 == 0 ? [UIColor blackColor]:[UIColor clearColor];
            [self addSubview:subView];
        }
    }
    return self;
}
@end

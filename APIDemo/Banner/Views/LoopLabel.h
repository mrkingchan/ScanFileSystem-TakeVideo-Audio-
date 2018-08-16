//
//  LoopLabel.h
//  APIDemo
//
//  Created by Chan on 2018/8/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectTextBlock)(NSString *selectString, NSInteger index);

@interface LoopLabel : UIView


+ (instancetype)loopLabelWith:(NSArray *)dataSource loopInterval:(NSTimeInterval)timeInterval initWithFrame:(CGRect)frame selectBlock:(selectTextBlock)selectBlock;

@end

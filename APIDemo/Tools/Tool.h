//
//  Tool.h
//  APIDemo
//
//  Created by Chan on 2018/7/26.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font;

@end

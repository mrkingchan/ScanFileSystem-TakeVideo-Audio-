//
//  GuideVC.h
//  APIDemo
//
//  Created by Chan on 2018/6/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideVC : UIViewController

@property(nonatomic,copy) void (^completeBlock)(void);

@end

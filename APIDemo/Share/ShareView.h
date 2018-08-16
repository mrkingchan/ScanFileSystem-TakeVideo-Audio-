//
//  ShareView.h
//  YQ
//
//  Created by Chan on 2018/7/9.
//  Copyright © 2018年 annkey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeHandel)(NSInteger index);

@interface ShareView : UIView

@property(nonatomic,copy) completeHandel complete;


/**
 默认微信三个+ 微博

 @param complete 点击回调
 @return ShareView
 */
+ (instancetype)shareViewWithCompleteHandel:(completeHandel)complete;



/**
 带指定种类的分享面板

 @param items items
 @param completeHandel  点击之后的回调
 @return ShareView
 */
+ (instancetype)shareViewWithItemsArray:(NSArray *)items completeHandel:(completeHandel)completeHandel;

@end

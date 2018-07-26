//
//  ContainerView.h
//  APIDemo
//
//  Created by Macx on 2018/7/26.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurModel.h"

@class ContainerView;

@protocol TagClickedDelegate<NSObject>

@required

- (void)tagClickedWithContainerView:(ContainerView *)containerView tagStr:(NSString *)tagStr;


@end

@interface ContainerView : UIView

@property(nonatomic,weak)id <TagClickedDelegate>delegate;

- (void)setContainerViewWithData:(BlurModel *)model;

+ (CGFloat)containerHeightWithData:(BlurModel *)model;

@end

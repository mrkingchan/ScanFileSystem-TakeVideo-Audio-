//
//  BlurCell.h
//  APIDemo
//
//  Created by Chan on 2018/7/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurModel.h"
#import "ContainerView.h"


@interface BlurCell : UITableViewCell

@property(nonatomic,strong)BlurModel *model;

@property(nonatomic,copy) void (^completeBlock)(NSString *tagStr);

@property(nonatomic,strong)ContainerView *containerView;


-(void)setCellWithData:(BlurModel*)model;

+ (CGFloat)cellHeightWithModel:(BlurModel *)mdoel;

+ (NSString * )cellIdentifier;

@end

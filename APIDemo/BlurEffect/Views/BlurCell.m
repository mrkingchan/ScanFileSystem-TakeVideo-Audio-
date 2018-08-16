//
//  BlurCell.m
//  APIDemo
//
//  Created by Chan on 2018/7/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BlurCell.h"
#define kgap 10
#define kitemH 30

@interface BlurCell() {
    BlurModel*_model;
    UIButton *_items[100];
    UIVisualEffectView *_effectView[100];
}
@end


@implementation BlurCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    /*NSInteger column = 0;
    for (int i = 0 ; i < _model.items.count; i ++) {
        BOOL changeColumn = i == 0 ?NO:_items[i - 1].right + kgap + [[self class] widthWithString:_model.items[i] font:KSFont(13)] > kAppWidth - 20;
        if (changeColumn) {
            column ++;
        }
        _items[i] = kInsertButtonWithType(self, CGRectMake(i == 0 ? kgap:changeColumn?kgap:_items[i - 1].right + kgap ,kgap *(column + 1) + (column * kitemH), [[self class] widthWithString:_model.items[i] font:KSFont(13)], kitemH), i + 100000, self, @selector(buttonAction:), UIButtonTypeCustom);
        _items[i].backgroundColor = [[self class] colorWithHexString:_model.colorStr];
        //加毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView[i] = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView[i].frame = CGRectMake(0, 0, _items[i].frame.size.width, _items[i].frame.size.height);
        [_items[i] addSubview:_effectView[i]];
        _effectView[i].userInteractionEnabled = YES;
        _effectView[i].tag = i + 100000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
        [_effectView[i] addGestureRecognizer:tap];
        _items[i].clipsToBounds = YES;
        _items[i].layer.cornerRadius = 4.0;
        [_items[i] setTitleColor:[[self class]colorWithHexString:_model.colorStr] forState:UIControlStateNormal];
        _items[i].titleLabel.font = KSFont(13);
        _items[i].titleLabel.textAlignment = 1;
     _items[i].layer.borderColor = [[self class] colorWithHexString:_model.colorStr].CGColor;
        _items[i].layer.borderWidth = 1.0;
    }*/

    _containerView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth,0)];
    [self.contentView addSubview:_containerView];
}

// MARK: - private Method
- (void)setCellWithData:(BlurModel *)model {
    _model = model;
    _containerView.frame  = CGRectMake(0, 0, kAppWidth,[ContainerView containerHeightWithData:model]);
    [_containerView setContainerViewWithData:model];
    
    /*for (int i = 0 ; i < model.items.count; i ++) {
        [_items[i] setTitle:model.items[i] forState:UIControlStateNormal];
    }*/
}

// MARK: - cellHeight
+(CGFloat)cellHeightWithModel:(BlurModel *)model {
    /*NSInteger column = 0;
     CGFloat itemR = 0;
     for (int i = 0; i< model.items.count; i ++) {
     itemR  = itemR + kgap + [[self class] widthWithString:model.items[i] font:KSFont(13)];
     BOOL changeColumn = itemR > kAppWidth - 20;
     if (changeColumn) {
     column ++;
     itemR = 0;
     }
     }
     return kgap *(column + 1) + ((column+1) * kitemH) + kgap;*/
    return [ContainerView containerHeightWithData:model];
}

+ (NSString * )cellIdentifier {
    return NSStringFromClass([self class]);
}

// MARK: - private Method
- (void)buttonAction:(UITapGestureRecognizer  *)tap {
    NSInteger index = tap.view.tag -100000;
    if (_completeBlock) {
        _completeBlock(_model.items[index]);
    }
}

@end

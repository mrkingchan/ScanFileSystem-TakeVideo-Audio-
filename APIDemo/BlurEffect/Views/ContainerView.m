//
//  ContainerView.m
//  APIDemo
//
//  Created by Macx on 2018/7/26.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ContainerView.h"
#define kgap 10
#define kitemH 30
@interface ContainerView() {
    UIButton *_items[30];
    UIVisualEffectView *_effectView[30];
    BlurModel *_model;

}
@end

@implementation ContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        for (int i = 0 ; i < 30; i ++) {
            _items[i] = kInsertButtonWithType(self, CGRectZero, i + 100000, self, @selector(buttonAction:), UIButtonTypeCustom);
            //加毛玻璃效果
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            _effectView[i] = [[UIVisualEffectView alloc] initWithEffect:effect];
            [_items[i] addSubview:_effectView[i]];
            _effectView[i].userInteractionEnabled = YES;
            _effectView[i].tag = i + 100000;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
            [_effectView[i] addGestureRecognizer:tap];
            _items[i].clipsToBounds = YES;
            _items[i].layer.cornerRadius = 4.0;
            _items[i].titleLabel.font = KSFont(15);
            _items[i].titleLabel.textAlignment = 1;
        }
    }
    return self;
}

// MARK: - private Method
- (void)setContainerViewWithData:(BlurModel *)model {
    for (int i =  0; i < 30; i ++) {
        _items[i].hidden = YES;
    }
    _model = model;
    NSInteger  column = 0;
    for (int i = 0 ; i < model.items.count; i ++) {
        _items[i].hidden = NO;
        BOOL changeColumn = i == 0 ?NO:_items[i - 1].right + kgap + [Tool widthWithString:model.items[i] font:KSFont(15)] > kAppWidth - 20;
        if (changeColumn) {
            column ++;
        }
        _items[i].frame = CGRectMake(i == 0 ? kgap:changeColumn?kgap:_items[i - 1].right + kgap ,kgap *(column + 1) + (column * kitemH), [Tool widthWithString:model.items[i] font:KSFont(15)], kitemH);
        [_items[i] setTitle:model.items[i] forState:UIControlStateNormal];
        [_items[i] setTitleColor:[Tool colorWithHexString:model.colorStr] forState:UIControlStateNormal];
        _items[i].backgroundColor = [Tool colorWithHexString:model.colorStr];
        _effectView[i].frame = _items[i].bounds;
    }
}

// MARK: - buttonAction
-(void)buttonAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag -100000;
    if (_delegate && [_delegate respondsToSelector:@selector(tagClickedWithContainerView:tagStr:)]) {
        [_delegate tagClickedWithContainerView:self tagStr:_model.items[index]];
    }
}

+ (CGFloat)containerHeightWithData:(BlurModel *)model {
    NSInteger column = 0;
    CGFloat itemR = 0;
    for (int i = 0; i< model.items.count; i ++) {
        itemR  = itemR + kgap + [Tool widthWithString:model.items[i] font:KSFont(15)];
        BOOL changeColumn = itemR > kAppWidth - 20;
        if (changeColumn) {
            column ++;
            itemR = 0;
        }
    }
    return kgap *(column + 1) + ((column+1) * kitemH) + kgap;
}

@end

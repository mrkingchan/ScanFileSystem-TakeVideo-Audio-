//
//  ShareView.m
//  YQ
//
//  Created by Chan on 2018/7/9.
//  Copyright © 2018年 annkey. All rights reserved.
//

#import "ShareView.h"

@interface ShareView () {
    UIView *_containerView;
    UIButton *_cancel;
    NSArray *_itemsArray;
}
@end

@implementation ShareView

+ (instancetype)shareViewWithCompleteHandel:(completeHandel)complete {
    return [[ShareView alloc] initWithItemsArray:nil CompleteHandel:complete];
}

+ (instancetype)shareViewWithItemsArray:(NSArray *)items completeHandel:(completeHandel)completeHandel {
    return [[ShareView alloc] initWithItemsArray:items CompleteHandel:completeHandel];
}


// MARK: - initialized Method
- (instancetype)initWithItemsArray:(NSArray *)items
                    CompleteHandel:(completeHandel)complete {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _itemsArray = items;
        _complete = complete;
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
        NSInteger rows = _itemsArray == nil ? 0:_itemsArray.count / 4 + 1;
        _containerView.frame = CGRectMake(15, kScreenHeight, kScreenWidth - 30,items == nil ? 180:rows * 105 + 60);
        _containerView.clipsToBounds = YES;
        _containerView.layer.cornerRadius = 8.0;
        [self addSubview:_containerView];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self setUI];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

// MARK: - setUI
- (void)setUI {
    if (_itemsArray == nil) {
        CGFloat gapW = (kScreenWidth - 30 - 150)/4;
        _containerView.userInteractionEnabled = YES;
        NSArray *titles = @[@"微信朋友",@"微信朋友圈",@"微信收藏"];
        UIImageView *imageViews[3];
        UILabel *titleLabels[3];
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
        tip.textColor = [UIColor blackColor];
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = 1;
        tip.text = @"分享至";
        [_containerView addSubview:tip];
        for (int i = 0 ;i < 3; i ++) {
            imageViews[i] = [[UIImageView alloc] initWithFrame:CGRectMake(i == 0 ? gapW : imageViews[i  - 1].right + gapW, tip.bottom +  10, 55, 55)];
            imageViews[i].image = [UIImage imageNamed:[NSString stringWithFormat:@"share_%i",i + 1]];
            imageViews[i].tag = 1000 + i;
            imageViews[i].userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
            [imageViews[i] addGestureRecognizer:tap];
            [_containerView addSubview:imageViews[i]];
            
            titleLabels[i] = [[UILabel alloc] initWithFrame:CGRectMake(imageViews[i].left - 12.5, imageViews[i].bottom + 8, 80, 20)];
            titleLabels[i].textAlignment = 1;
            titleLabels[i].font = [UIFont systemFontOfSize:12];
            titleLabels[i].textColor = [UIColor blackColor];
            titleLabels[i].text = titles[i];
            [_containerView addSubview:titleLabels[i]];
            if ( i ==  2) {
                UILabel *titleLabel = titleLabels[0];
                UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 8, kScreenWidth, 1)];
                separatorView.backgroundColor = [UIColor lightGrayColor];
                [_containerView addSubview:separatorView];
                
                _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 10, kScreenWidth, 30)];
                [_cancel setTitle:@"取消" forState:UIControlStateNormal];
                [_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _cancel.titleLabel.textAlignment = 1;
                _cancel.titleLabel.font = [UIFont systemFontOfSize:15];
                [_containerView addSubview:_cancel];
                [_cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            ShareView *strongSelf = weakSelf;
            strongSelf-> _containerView.top = kScreenHeight - 180 - 8;
        }];
    } else {
        //自定义items  数据格式  @[[@"weChatSession",@"微信分享"],[....]]
        CGFloat itemW= (kAppWidth - 30) / 4.0;
        CGFloat itemH = 105;
        UIView *_views[_itemsArray.count];
        UIImageView *imageviews[_itemsArray.count];
        UILabel *titles[_itemsArray.count];
        
        for (int i = 0 ; i < _itemsArray.count; i ++) {
            NSInteger column = i %4;
            NSInteger row = i /4;
            _views[i] = [[UIView alloc] initWithFrame:CGRectMake(column * itemW, row * itemH , itemW, itemH)];
            _views[i].tag = 1000 + i;
            _views[i].userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)];
            [_views[i] addGestureRecognizer:tap];
            [_containerView addSubview:_views[i]];
            
            //图片
            imageviews[i] = [[UIImageView alloc] initWithFrame:CGRectMake(itemW / 2 - 27.5, 15, 55, 55)];
            imageviews[i].image = [UIImage imageNamed:_itemsArray[i][0]];
            [_views[i] addSubview:imageviews[i]];
            
            //标题
            titles[i] = [[UILabel alloc] initWithFrame:CGRectMake(itemW / 2 - 40, imageviews[i].frame.origin.y + 55 + 5, 80, 25)];
            titles[i].textAlignment  = 1;
            titles[i].font = [UIFont systemFontOfSize:13];
            titles[i].text = _itemsArray[i][1];
            [_views[i] addSubview:titles[i]];
        }
        
        
        //分割线
        
        UIView *sepratorLine = [[UIView alloc] initWithFrame:CGRectMake(0, _views[_itemsArray.count - 1].frame.origin.y + 105 + 6, kAppWidth - 30, 1)];
        sepratorLine.backgroundColor = [UIColor lightGrayColor];
        [_containerView addSubview:sepratorLine];
        
        //cancel
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, _views[_itemsArray.count - 1].frame.origin.y + 105 + 10, kScreenWidth - 30, 40)];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancel.titleLabel.textAlignment = 1;
        _cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_containerView addSubview:_cancel];
        [_cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            ShareView *strongSelf = weakSelf;
            NSInteger rows =strongSelf->_itemsArray.count / 4 + 1;
            strongSelf-> _containerView.top = kScreenHeight - (rows * 105 + 60) - 8;
        }];
    }
}

// MARK: - touch Method
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (!CGRectContainsPoint(_containerView.frame, location)) {
        [self hide];
    }
}

// MARK: - private Method
- (void)buttonAction:(UITapGestureRecognizer *)tap  {
    UIImageView *imageView = (UIImageView *) tap.view;
    NSInteger index = imageView.tag - 1000;
    if (_complete) {
        _complete(index);
    }
    [self hide];
}

// MARK: - hide
- (void)hide {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        ShareView *strongSelf = weakSelf;
       strongSelf->_containerView.top = kScreenHeight;
    }];
    [self removeFromSuperview];
}

// MARK: - memory management
- (void)dealloc {
    if (_containerView) {
        _containerView = nil;
    }
    if (_complete) {
        _complete = nil;
    }
}
@end


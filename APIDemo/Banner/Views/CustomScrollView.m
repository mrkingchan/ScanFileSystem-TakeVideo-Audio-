
//
//  CustomScrollView.h
//  APIDemo
//
//  Created by Macx on 2018/8/3.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "CustomScrollView.h"
@interface CustomScrollView ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView    *scrollView;
@property (strong,nonatomic) UIImageView    *backImageView;

@property (strong,nonatomic) UIImageView    *leftIamgeView;
@property (strong,nonatomic) UIImageView    *middleImageView;
@property (strong,nonatomic) UIImageView    *rightImageView;

@property (strong,nonatomic) UIPageControl    *pageControl;

//高度
@property (assign,nonatomic) CGFloat  scrollViewHeight;

//手动造成的偏移量
@property (assign,nonatomic) CGFloat  offsetX;

@property (strong,nonatomic) NSTimer    *timer;

//属于计时器方法动画持续时间 ？
@property (assign,nonatomic) BOOL  timerAnimation;

@end
//左右内容的最大偏移量
#define OFFSET_MAX          ([UIScreen mainScreen].bounds.size.width-64)*0.9

@implementation CustomScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollViewHeight = frame.size.height;
        [self addSubview:self.backImageView];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.with.mas_equalTo(self);
        }];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.with.mas_equalTo(self);
        }];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(@20);
        }];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }
    return self;
}

- (NSArray *)imageArr {
    if (!_imageArr) {
        _imageArr = @[@"AppIcon",@"AppIcon",@"AppIcon"];
    }
    return _imageArr;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"AppIcon"];
    }
    return _backImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth+2*OFFSET_MAX, self.scrollViewHeight);
        [_scrollView setContentOffset:CGPointMake(OFFSET_MAX, 0)];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        _leftIamgeView = [[UIImageView alloc] init];
        _leftIamgeView.image = [UIImage imageNamed:self.imageArr[0]];
        _leftIamgeView.layer.cornerRadius = 5;
        _leftIamgeView.layer.masksToBounds = YES;
        
        
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.image = [UIImage imageNamed:self.imageArr[1]];
        _middleImageView.layer.cornerRadius = 5;
        _middleImageView.layer.masksToBounds = YES;
        
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:self.imageArr[2]];
        _rightImageView.layer.cornerRadius = 5;
        _rightImageView.layer.masksToBounds = YES;
        
        
        [_scrollView addSubview:_leftIamgeView];
        [_scrollView addSubview:_middleImageView];
        [_scrollView addSubview:_rightImageView];
        
        @weakify(self);
        [_leftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth-64)*0.9, self.scrollViewHeight*0.9));
            make.centerY.mas_equalTo(self->_scrollView);
            make.right.mas_equalTo(self->_middleImageView.mas_left).offset(-20);
        }];
        
        [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-64, self.scrollViewHeight));
            make.centerY.mas_equalTo(self->_scrollView);
            make.left.mas_equalTo(self->_scrollView).offset(OFFSET_MAX+64/2);
        }];
        
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(self->_leftIamgeView);
            make.centerY.mas_equalTo(self->_scrollView);
            make.left.mas_equalTo(self->_middleImageView.mas_right).offset(20);
        }];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.imageArr.count;
        _pageControl.enabled = NO;
        _pageControl.currentPage = 0;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.timerAnimation) {
        return;
    }
    CGFloat offScale = scrollView.contentOffset.x - OFFSET_MAX;
    if (offScale < 0) {
        //右滑
//        self.leftIamgeView.layer.transformScale = 1 + 1.0/9*(fabs(offScale)/OFFSET_MAX;
//        self.middleImageView.layer.transformScale = 1 - 0.1*(fabs(offScale)/OFFSET_MAX;
        self.leftIamgeView.layer.affineTransform = CGAffineTransformMakeScale(1 + 1.0/9*(fabs(offScale)/OFFSET_MAX),1 + 1.0/9*(fabs(offScale)/OFFSET_MAX));
        self.middleImageView.layer.affineTransform =CGAffineTransformMakeScale (1 - 0.1*(fabs(offScale)/OFFSET_MAX),1 - 0.1*(fabs(offScale)/OFFSET_MAX));
    } else {
        //左滑
//        self.rightImageView.layer.transformScale = 1 + 1.0/9*(fabs(offScale)/OFFSET_MAX);
//        self.middleImageView.layer.transformScale = 1 - 0.1*(fabs(offScale)/OFFSET_MAX);
        self.rightImageView.layer.affineTransform = CGAffineTransformMakeScale(1 + 1.0/9*(fabs(offScale)/OFFSET_MAX), 1 + 1.0/9*(fabs(offScale)/OFFSET_MAX));
     self.middleImageView.layer.affineTransform = CGAffineTransformMakeScale (1 - 0.1*(fabs(offScale)/OFFSET_MAX),1 - 0.1*(fabs(offScale)/OFFSET_MAX));

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint offset = scrollView.contentOffset;
    
    self.offsetX = offset.x;
    
    if ((fabs(self.offsetX-OFFSET_MAX) >= OFFSET_MAX*0.5)) {
        if (!decelerate) {
            //替换图片
            [self exchangeImage];
        }
    } else {
        //回弹复位
        [scrollView setContentOffset:CGPointMake(OFFSET_MAX, 0) animated:YES];
        self.leftIamgeView.layer.transform = CATransform3DIdentity;
        self.middleImageView.layer.transform = CATransform3DIdentity;
        self.rightImageView.layer.transform = CATransform3DIdentity;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //替换图片
    [self exchangeImage];
}

//替换图片
- (void)exchangeImage {
    if (self.offsetX-OFFSET_MAX < 0) {
        //右滑
        UIImage *rightImage = self.rightImageView.image;
        self.rightImageView.image = self.middleImageView.image;
        self.middleImageView.image = self.leftIamgeView.image;
        self.leftIamgeView.image = rightImage;
        
        if (self.pageControl.currentPage - 1 < 0) {
            self.pageControl.currentPage = self.pageControl.numberOfPages-1;
        } else {
            self.pageControl.currentPage -= 1;
        }
        
    } else {
        //左滑
        UIImage *leftImage = self.leftIamgeView.image;
        self.leftIamgeView.image = self.middleImageView.image;
        self.middleImageView.image = self.rightImageView.image;
        self.rightImageView.image = leftImage;
        
        if (self.pageControl.currentPage + 1 >= self.pageControl.numberOfPages) {
            self.pageControl.currentPage = 0;
        } else {
            self.pageControl.currentPage += 1;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(OFFSET_MAX, 0)];
    self.leftIamgeView.layer.transform = CATransform3DIdentity;
    self.middleImageView.layer.transform = CATransform3DIdentity;
    self.rightImageView.layer.transform = CATransform3DIdentity;
}

- (void)timerAction {
    self.offsetX = kScreenWidth+OFFSET_MAX-64;
    self.timerAnimation = YES;
    [UIView animateWithDuration:0.8 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.offsetX, 0)];
        self.rightImageView.layer.affineTransform = CGAffineTransformMakeScale(10/9.0, 10/9.0);
//        self.rightImageView.layer.transformScale = 10/9.0;
//        self.middleImageView.layer.transformScale = 0.9;
        self.middleImageView.layer.affineTransform = CGAffineTransformMakeScale(0.9, 0.9);

    } completion:^(BOOL finished) {
        self.timerAnimation = NO;
        [self exchangeImage];
        self.rightImageView.layer.transform = CATransform3DIdentity;
        self.middleImageView.layer.transform = CATransform3DIdentity;
    }];
}

@end


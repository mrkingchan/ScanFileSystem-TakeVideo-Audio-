//
//  NotificationView.m
//  APIDemo
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationView () {
    UIView *_contentView;
    NSArray *_contents;
    NSTimer *_timer;
    
}
@end

@implementation NotificationView

+ (instancetype)notificationViewWithContent:(NSArray *)contents complete:(completeBlock)complete {
    return [[NotificationView alloc] initWithContent:contents complete:complete];
}

- (instancetype)initWithContent:(NSArray *)contents complete:(completeBlock)complete {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        _contents = contents;
        [self setUI];
    }
    return self;
}

// MARK: - setUI
- (void)setUI {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(25, -((_contents.count + 1) * 20 + (_contents.count * 30)) - 50, kAppWidth - 50, (_contents.count + 1) * 20 + (_contents.count * 30) + 50)];
    _contentView.clipsToBounds = YES;
    _contentView.layer.cornerRadius = 6.0;
    _contentView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_contentView];
    
    for (int i = 0 ; i < _contents.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, i == 0 ? _contentView.frame.size.height / 2 - 15 :20 * (i + 1) +  (i * 30), kAppWidth - 50 - 50, 30)];
        label.backgroundColor = _contentView.backgroundColor;
        label.textAlignment = 1;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = _contents[i];
        [_contentView addSubview:label];
        if (i == _contents.count - 1) {
            _contentView.frame = CGRectMake(25, 20, kAppWidth - 50, (_contents.count + 1) * 20 +50);
        }
    }
    AudioServicesPlaySystemSound(1007);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
    
}

- (void)hide {
    CABasicAnimation *animataion = [CABasicAnimation animationWithKeyPath:@"position"];
    animataion.duration = 1.0;
    animataion.speed = 0.8;
    animataion.repeatCount = 1;
    animataion.fromValue =  [NSValue valueWithCGRect:_contentView.frame];
    animataion.toValue = [NSValue valueWithCGRect:CGRectMake(25, -CGFLOAT_MAX, kAppWidth - 50, 0)];
    animataion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animataion.fillMode =  kCAFillModeForwards;
    animataion.removedOnCompletion = YES;
    [_contentView.layer addAnimation:animataion forKey:@"hideAnimation"];
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}
@end

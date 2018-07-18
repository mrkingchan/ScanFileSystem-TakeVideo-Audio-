//
//  BadgeView.m
//  APIDemo
//
//  Created by Macx on 2018/7/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView () {
    UILabel *_countLabel;
}
@end

@implementation BadgeView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _count = 0;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2;
    
        self.backgroundColor = [UIColor redColor];
        _countLabel = [UILabel new];
        _countLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.textAlignment = 1;
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.text = [NSString stringWithFormat:@"%zd",_count];
        self.hidden = YES;
        [self addSubview:_countLabel];
    }
    return self;
}

// MARK: - 更新提示数量
- (void)updateCount:(NSInteger)count {
    _count = count;
    if (count <= 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        //播放系统音效
        // 系统声音
        AudioServicesPlaySystemSound(1007);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        _countLabel.text = [NSString stringWithFormat:@"%zd",_count];
    }
}
@end

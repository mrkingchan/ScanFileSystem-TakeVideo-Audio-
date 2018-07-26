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
        BOOL changeColumn = i == 0 ?NO:_items[i - 1].right + kgap + [[self class] widthWithString:model.items[i] font:KSFont(15)] > kAppWidth - 20;
        if (changeColumn) {
            column ++;
        }
        _items[i].frame = CGRectMake(i == 0 ? kgap:changeColumn?kgap:_items[i - 1].right + kgap ,kgap *(column + 1) + (column * kitemH), [[self class] widthWithString:model.items[i] font:KSFont(15)], kitemH);
        [_items[i] setTitle:model.items[i] forState:UIControlStateNormal];
        [_items[i] setTitleColor:[[self class] colorWithHexString:model.colorStr] forState:UIControlStateNormal];
        _items[i].backgroundColor = [[self class] colorWithHexString:model.colorStr];
        _effectView[i].frame = _items[i].bounds;
    }
}

-(void)buttonAction:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag -100000;
    if (_delegate && [_delegate respondsToSelector:@selector(tagClickedWithContainerView:tagStr:)]) {
        [_delegate tagClickedWithContainerView:self tagStr:_model.items[index]];
    }
}

+(CGFloat)containerHeightWithData:(BlurModel *)model {
    NSInteger column = 0;
    CGFloat itemR = 0;
    for (int i = 0; i< model.items.count; i ++) {
        itemR  = itemR + kgap + [[self class] widthWithString:model.items[i] font:KSFont(15)];
        BOOL changeColumn = itemR > kAppWidth - 20;
        if (changeColumn) {
            column ++;
            itemR = 0;
        }
    }
    return kgap *(column + 1) + ((column+1) * kitemH) + kgap;
}

// MARK: - class Method
+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (CGFloat)widthWithString:(NSString *)string font:(UIFont *)font {
    CGSize rtSize;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        rtSize = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return ceil(rtSize.width) + 0.5;
    } else {
        rtSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return rtSize.width;
    }
}

@end

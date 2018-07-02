//
//  PreViewCell.m
//  APIDemo
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PreViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PreViewCell () {
    UIImageView *_imageView;
}
@end
@implementation PreViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self  addSubview:_imageView];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)setCellWithData:(id)model {
    if ([model isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = (ALAsset *)model;
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        CGSize size = [image size];
        _imageView.image = image;
        _imageView.frame = CGRectMake(self.bounds.size.width / 2 - (size.width / 2), self.bounds.size.height / 2 - (size.height / 2), size.width, size.height);
    }
}

@end

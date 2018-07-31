//
//  PhotoCell.m
//  APIDemo
//
//  Created by Macx on 2018/6/27.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface PhotoCell() {
    UIImageView *_imageView;
}
@end

@implementation PhotoCell

// MARK: - initialize Method
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

// MARK: - setCellWithData
-(void)setCellWithData:(id)model {
    if ([model isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = (ALAsset *)model;
        //缩略图
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        _imageView.image = image;
    }
}

// MARK: - memory management

- (void)dealloc {
    if (_imageView) {
        _imageView = nil;
    }
}
@end

//
//  PageEnableLayout.m
//  APIDemo
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PageEnableLayout.h"

@implementation PageEnableLayout

- (void)prepareLayout{
    [super prepareLayout];
}

- (id)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0.0f;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
        self.itemSize = CGSizeMake(kAppWidth ,kAppHeight);
    }
    return self;
}

// MARK: - 重写布局方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        // 有交错
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            if (visibleRect.origin.x == 0) {
                //还未滑动
            }else{
                // 除法取整 取余数
                div_t x = div(visibleRect.origin.x,visibleRect.size.width);
                if (x.quot > 0 && x.rem > 0) {
                    
                }
                if (x.quot > 0 && x.rem == 0) {
                    
                }
            }
        }
    }
    return attributes;
}

@end

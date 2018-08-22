//
//  UIViewController+NetTask.m
//  RenCaiYingHang
//
//  Created by Macx on 2018/8/16.
//  Copyright © 2018年 Macx. All rights reserved.
//

#import "UIViewController+NetTask.h"

@implementation UIViewController (NetTask)

@dynamic tasks;

// MARK: - setter &getter
-(void)setTask:(NSMutableArray<NSURLSessionDataTask *> *)tasks {
    objc_setAssociatedObject(self
                             , @selector(tasks)
                             , tasks
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSURLSessionDataTask *> *)tasks {
    return objc_getAssociatedObject(self, @selector(tasks));
}

// MARK: - private Method
-(void)addNetWork:(NSURLSessionDataTask *)task {
    if (!self.tasks) {
        self.tasks = [NSMutableArray new];
    }
    [self.tasks addObject:task];
}

- (void)releaseNetWork {
    if (self.tasks.count) {
        [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(cancel)]) {
                //释放网络操作队列，释放资源
                [obj cancel];
            }
        }];
    }
    //清空
    [self.tasks removeAllObjects];
}
@end

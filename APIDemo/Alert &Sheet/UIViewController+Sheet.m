//
//  UIViewController+Sheet.m
//  Chan
//
//  Created by Chan on 2018/8/16.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UIViewController+Sheet.h"

@implementation UIViewController (Sheet)

- (void)sheetWithMessage:(NSString *)messageStr
                button1:(NSString *)title1
              complete1:(void (^)(void))complete1
                button2:(NSString *)title2
              complete2:(void (^)(void))complete2 {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:messageStr message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0 ; i < 3;i  ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:i == 0 ? title1:i == 1 ? title2:@"取消" style:i == 2 ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:title1]) {
                if (complete1) {
                    complete1();
                }
            } else if ([action.title isEqualToString:title2]) {
                if (complete2) {
                    complete2();
                }
            }
        }];
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

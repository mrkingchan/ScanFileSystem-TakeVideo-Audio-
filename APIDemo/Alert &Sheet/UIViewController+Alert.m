//
//  UIViewController+Alert.m
//  Chan
//
//  Created by Chan on 2018/8/16.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)alertWithTitle:(NSString *)titleStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)alertWithTitle:(NSString *)titleStr
               button1:(NSString *)title1
        completeBlock1:(void (^)())complete1
               button2:(NSString *)title2
        completeBlock2:(void (^)())complete2 {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr
                                                                             message:nil preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0 ; i < 2; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:i ==0 ? title1:title2 style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if ([action.title rangeOfString:title1].location != NSNotFound) {
                                                               if (complete1) {
                                                                   complete1();
                                                               }
                                                           } else if ([action.title rangeOfString:title2].location != NSNotFound)  {
                                                               if (complete2) {
                                                                   complete2();
                                                               }
                                                           }
                                                       }];
        
        //add Action
        [alertController addAction:action];
    }
    // present the alertController
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

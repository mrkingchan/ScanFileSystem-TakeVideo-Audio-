//
//  UIViewController+Alert.h
//  Chan
//
//  Created by Chan on 2018/8/16.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)


/**
 with the default button- >"确定"

 @param titleStr titleStr description
 */
- (void)alertWithTitle:(NSString *)titleStr  API_AVAILABLE(ios(8.0));


/**
 return void

 @param titleStr titleStr description
 @param title1 title1 description
 @param complete1 complete1 description
 @param button2 button2 description
 @param complete2 complete2 description
 */
- (void)alertWithTitle:(NSString *)titleStr
               button1:(NSString *)title1
        completeBlock1:(void (^)())complete1
               button2:(NSString *)title2
        completeBlock2:(void (^)())complete2  API_AVAILABLE(ios(8.0)) ;

@end

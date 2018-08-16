//
//  UIViewController+Sheet.h
//  Chan
//
//  Created by Chan on 2018/8/16.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Sheet)


/**
 present the ActionSheet with 3 buttons ( cancel + 2)

 @param messageStr messageStr
 @param title1 title1 description
 @param complete1 complete1 description
 @param title2 title2 description
 @param complete2 complete2 description
 */
- (void)sheetWithMessage:(NSString *)messageStr
                 button1:(NSString *)title1
               complete1:(void (^) (void))complete1
                 button2:(NSString *)title2
               complete2:(void (^) (void))complete2;


@end

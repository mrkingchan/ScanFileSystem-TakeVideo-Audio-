//
//  LocalPushCenter.m
//  JETIN
//
//  Created by Chan on 2017/3/23.
//  Copyright © 2017年 Chan. All rights reserved.
//

#import "LocalPushCenter.h"

@implementation LocalPushCenter

+ (NSDate *)fireDateWithWeek:(NSInteger)week
                        hour:(NSInteger)hour
                      minute:(NSInteger)minute
                      second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    unsigned currentFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitSecond;
    NSDateComponents *component = [calendar components:currentFlag fromDate:[NSDate date]];
    if (week) {
        component.weekday = week;
    }
    if (hour) {
        component.hour = hour;
    }
    if (minute) {
        component.minute = minute;
    }
    if (second) {
        component.second = second;
    } else {
        component.second = 0;
    }
    
    return [[calendar dateFromComponents:component] dateByAddingTimeInterval:0];
}

#pragma mark - 本地推送
+ (void)localPushForDate:(NSDate *)fireDate
                  forKey:(NSString *)key
               alertBody:(NSString *)alertBody
             alertAction:(NSString *)alertAction
               soundName:(NSString *)soundName
             launchImage:(NSString *)launchImage
                userInfo:(NSDictionary *)userInfo
              badgeCount:(NSUInteger)badgeCount
          repeatInterval:(NSCalendarUnit)repeatInterval {
    UILocalNotification *localNotification = [UILocalNotification new];
    if (!localNotification) {
        return;
    }
    [self cancleLocalPushWithKey:key];

    NSUInteger notificationType; //UIUserNotificationType(>= iOS8) and UIRemoteNotificatioNType(< iOS8) use same value
    UIApplication *application = [UIApplication sharedApplication];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        notificationType = [[application currentUserNotificationSettings] types];
    } else {
        notificationType = [application enabledRemoteNotificationTypes];
    }
    if (notificationType == UIRemoteNotificationTypeNone) {
        return;
    }
    // ios8 授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        localNotification.alertBody        = alertBody;
        localNotification.alertAction      = alertAction;
        localNotification.alertLaunchImage = launchImage;
        localNotification.repeatInterval   = repeatInterval;
//        localNotification.alertTitle = alertBody;
    } else {
        localNotification.alertBody        = alertBody;
        localNotification.alertAction      = alertAction;
        localNotification.alertLaunchImage = launchImage;
        localNotification.repeatInterval   = repeatInterval;
//        localNotification.alertTitle = alertBody;
    }
    
    //Sound
    if (soundName) {
        localNotification.soundName = soundName;
    } else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    //Badge
    if ((notificationType & UIRemoteNotificationTypeBadge) != UIRemoteNotificationTypeBadge) {
    } else {
        localNotification.applicationIconBadgeNumber = badgeCount;
    }
    localNotification.userInfo = userInfo;
    //触发日期
    if (!fireDate) {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    } else {
        localNotification.fireDate = fireDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

#pragma mark - 退出
+ (void)cancelAllLocalPhsh {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark -----取消指定key的通知
+ (void)cancleLocalPushWithKey:(NSString *)key {
    NSArray *notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notiArray) {
        for (UILocalNotification *notification in notiArray) {
            NSDictionary *dic = notification.userInfo;
            if (dic) {
                for (NSString *key in dic) {
                    if ([key isEqualToString:key]) {
                        [[UIApplication sharedApplication] cancelLocalNotification:notification];
                    }
                }
            }
        }
    }
}
@end

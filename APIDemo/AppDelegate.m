//
//  AppDelegate.m
//  APIDemo
//
//  Created by Chan on 2018/6/13.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GuideVC.h"
#import "AppDelegate+Configure.h"
#import "WebVC.h"

@interface AppDelegate () {
    BOOL _versionUpdate;
    NSString *_messageStr;
    UIAlertController *_alertVC;
    
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [UIWindow new];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [UIColor whiteColor];
    //有版本更新就去服务器拉启动图
    /*if ([kUserDefaultsForKey(@"lanunched") integerValue] == 0 ) {
        //去拉服务器的启动图
      GuideVC *VC = [GuideVC new];
        _window.rootViewController = VC;
        __weak typeof(self)weakSelf = self;
        VC.completeBlock = ^{
            kUserDefaultSet(@(1), @"lanunched");
            AppDelegate *strongSelf = weakSelf;
          strongSelf->_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
        };
    } else {*/
        //主页
//        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    _window.rootViewController = [WebVC new];
//    }
    [self checkUpdateInfo];
    [self configureApplicationWithComplete:^{
        
    }];
    [self configureAVFile];
    [_window makeKeyAndVisible];
    [self configurePush];
    return YES;
}

// MARK: - videos audios文件夹

-(void)configureAVFile {
    //创建audios videos文件夹 用以存储 视频和音频文件
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSLog(@"documentsPath = %@",documentPath);
    NSString *audios = [documentPath stringByAppendingPathComponent:@"audios"];
    NSString *videos = [documentPath stringByAppendingPathComponent:@"videos"];
    [[NSFileManager defaultManager] createDirectoryAtPath:audios withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:videos withIntermediateDirectories:YES attributes:nil error:nil];
}

// MARK: - 配置推送
- (void)configurePush {
    //8.0以上的需要注册用户通知
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        //注册用户通知·
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        //注册远程通知
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
}

// MARK: - 检查更新
- (void)checkUpdateInfo {
    __weak typeof(self)weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        AppDelegate *strongSelf = weakSelf;
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([dic[@"results"] count]) {
                NSDictionary *results = dic[@"results"][0];
                //App更新
                if ([results[@"version"] floatValue] > [kAppVersion() floatValue]) {
                   strongSelf-> _versionUpdate = YES;
                    NSString *messageStr = [[results[@"releaseNotes"]  componentsSeparatedByString:@"。"]firstObject];
                    NSArray *titleArray = [messageStr componentsSeparatedByString:@"\n"];
                    NSMutableString *newStr = [NSMutableString new];
                    [newStr appendString:@" \n"];
                    for (NSString *subStr in titleArray) {
                        [newStr appendFormat:@"%@\n",subStr];
                    }
                    strongSelf->_messageStr = newStr;
                    //更新弹框
                    strongSelf->_alertVC = [UIAlertController alertControllerWithTitle:@"应用有新版本" message:newStr preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //更新跳转 这里跳转的url是中文转码的url
                        NSString *downloadURL = @"https://itunes.apple.com/us/app/%E4%BA%BA%E6%89%8D%E8%B5%A2%E8%A1%8C/id1334606367?l=zh&ls=1&mt=8";
                        NSURL *appStoreURL = [NSURL URLWithString:downloadURL];
                        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                            //跳转appstore
                            [[UIApplication sharedApplication] openURL:appStoreURL];
                        }
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"下次" style:UIAlertActionStyleDefault handler:nil];
                    [strongSelf->_alertVC addAction:action1];
                    [strongSelf-> _alertVC addAction:action2];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:strongSelf->_alertVC animated:YES completion:nil];
                    });
                }
            }
        } else {
            NSLog(@"update Error = %@",error.localizedDescription);
        }
    }]resume];
}

-(void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end

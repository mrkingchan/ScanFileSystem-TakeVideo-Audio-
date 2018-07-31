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
#import <UserNotifications/UserNotifications.h>
#import "MainTabbarVC.h"

@interface AppDelegate ()<WXApiDelegate,WeiboSDKDelegate,JPUSHRegisterDelegate>{
    BOOL _versionUpdate;
    NSString *_messageStr;
    UIAlertController *_alertVC;
    BOOL _switchRoot;
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
        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//    _window.rootViewController = [MainTabbarVC new];
//    _window.rootViewController = [WebVC new];
//    }
    //检查更新
    [self checkUpdateInfo];
    
    //配置三方
    [self configureApplicationWithComplete:^{
        
    }];
    [self configureAVFile];
    [_window makeKeyAndVisible];
    //推送
    [self configurePush];
    
    //监听被杀死的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crashAction) name:UIApplicationWillTerminateNotification object:nil];

    //app共享路径
  NSURL *url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"com.bundel.subApp"];
    /*@weakify(self);
    [NSTimer scheduledTimerWithTimeInterval:10.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self);
        self->_switchRoot = !self->_switchRoot;
        if (self->_switchRoot) {
            self->_window.rootViewController = [ViewController new];
        } else {
            self->_window.rootViewController = [MainTabbarVC new];
        }
    }];*/
    /*
    //极光推送
    JPUSHRegisterEntity * entity = [JPUSHRegisterEntity new];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushKey
                          channel:nil
                 apsForProduction:DEBUG ? NO :YES
            advertisingIdentifier:nil];
    
   // MARK: - 未经过APNS的socket发过来的数据 相当于是socket长链接接收到的数据，没经过APNS，那就是不会出现通知的下拉横幅
    [[NSNotificationCenter defaultCenter] addObserverForName:kJPFNetworkDidReceiveMessageNotification object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      iToastText([note.userInfo mj_JSONString]);
                                                  }];
     */
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)crashAction {
    puts(__func__);
}
// MARK: - videos audios文件夹

-(void)configureAVFile {
    //创建audios videos文件夹 用以存储 视频和音频文件
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    ///var/mobile/Containers/Data/Application/B1BAC66A-ECA0-4B0A-AD42-AF6039F1F85B/Documents

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //iOS8以下的通知
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
#pragma clang diagnostic pop
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

// MARK: - 远程推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// MARK: -  本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
   __block NSMutableString *contentStr = [NSMutableString new];
    [userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentStr appendString:[NSString stringWithFormat:@"%@:%@\n",key,obj]];
    }];
    /*[NotificationView notificationViewWithContent:items
                                         complete:^(NSArray *contents) {
                                             
                                         }];*/
    if ([ UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //前台状态下模拟远程推送下的下拉通知

//        [EBBannerView showWithContent:items];
        [[EBBannerView  bannerWithBlock:^(EBBannerViewMaker *make) {
            make.style = EBBannerViewStyleiOS10;
            make.content = contentStr;
        }]show];
    }
}

// MARK: - 处理三方跳转回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
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

// MARK: - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}

@end

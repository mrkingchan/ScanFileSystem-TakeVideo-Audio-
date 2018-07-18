//
//  WebVC.m
//  APIDemo
//
//  Created by Chan on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>
#import "KSTakePhotoViewController.h"
#import "KSTakeVideoViewController.h"
#import "ScanVideoVC.h"
#import "IQAudioRecorderViewController.h"
#import "ScanAudioVC.h"
#import "ScanVC.h"
#import "ClientVC.h"
#import "ScanPhotoVC.h"
#import "SGScanningQRCodeVC.h"
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

@interface WebVC () <WKScriptMessageHandler,WKNavigationDelegate,KSTakePhotoDelegate,KSTakeVideoDelegate,IQAudioRecorderViewControllerDelegate,SGScanningQRCodeVCDelegate,TZImagePickerControllerDelegate> {
    WKWebView*_webView;
    UIProgressView *_progressView;
    
}
@end

@implementation WebVC

// MARK: -viewController's view's lifeCirle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"加载中...";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, iPhoneX_BOTTOM_HEIGHT, 0);
    }
    
    _progressView =  [[UIProgressView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kAppWidth, 2)];
    _progressView.progressTintColor = [UIColor redColor];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:_progressView];
    
    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    // CSS选中样式取消
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    
    //JS
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:noneSelectScript];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kAppWidth, kAppHeight - kStatusBarHeight ) configuration:configuration];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    //    @"http://192.168.1.3/"
    [_webView loadRequest:[NSURLRequest requestWithURL:kURL(@"https://www.atmex.io")]];
    if (@available(iOS 11.0, *)) {
        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, iPhoneX_BOTTOM_HEIGHT, 0);
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    @weakify(self);
    [_webView.scrollView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_webView.scrollView.header endRefreshing];
        });
        [self->_webView reload];
    }];
    
    //注册监听
    [configuration.userContentController addScriptMessageHandler:self name:@"photograph"];
    //拍摄视频
    [configuration.userContentController addScriptMessageHandler:self name:@"video"];
     //扫描视频
    [configuration.userContentController addScriptMessageHandler:self name:@"sfsVideo"];
    [configuration.userContentController addScriptMessageHandler:self name:@"sphoneAlbum"];
    [configuration.userContentController addScriptMessageHandler:self name:@"sfsPhotos"];

    [configuration.userContentController addScriptMessageHandler:self name:@"sRecording"];
    [configuration.userContentController addScriptMessageHandler:self name:@"sfsRecordingfile"];

    [configuration.userContentController addScriptMessageHandler:self name:@"sQRCode"];

    [configuration.userContentController addScriptMessageHandler:self name:@"tpSharing"];
    [configuration.userContentController addScriptMessageHandler:self name:@"tpLogin"];
    [configuration.userContentController addScriptMessageHandler:self name:@"portCommunication"];
    [configuration.userContentController  addScriptMessageHandler:self name:@"dialog"];

    for (id subview in _webView.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
        }
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

// MARK: - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //加载进度条
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _progressView.progress = _webView.estimatedProgress;
        if (_progressView.progress == 1) {
            @weakify(self);
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                @strongify(self);
                self->_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                self->_progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// MARK: - WKNavigationActionDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    iToastLoding;
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _progressView.hidden = NO;
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:_progressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    iToastHide;
    self.navigationItem.title =  webView.title;
    [webView evaluateJavaScript:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.imageUrl.bitUrl(this.src);}\
     }\
     }"
              completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                  if (error) {
                      
                  }
              }];
    [_webView evaluateJavaScript:@"registerImageClickAction();"
               completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                   
               }];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    iToastText(error.localizedDescription);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

// MARK: - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    id data = message.body;
    iToastText(message.name);
    if ([message.name isEqualToString:@"photograph"]) {
        //拍照
        KSTakePhotoViewController *VC = [[KSTakePhotoViewController alloc] initWithType:KSTakePhotoNormal];
        VC.delegate = self;
        [self.navigationController presentViewController:VC animated:YES completion:nil];
    } else if ([message.name isEqualToString:@"video"]) {
        //拍视频
        KSTakeVideoViewController *VC = [KSTakeVideoViewController new];
        VC.delegate = self;
        [self.navigationController presentViewController:VC animated:YES completion:nil];
    } else if ([message.name isEqualToString:@"sfsVideo"]) {
        //扫描文件系统视频
        //扫描视频
        ScanVideoVC *VC = [ScanVideoVC new];
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([message.name isEqualToString:@"sphoneAlbum"]) {
        //扫描系统照片
        TZImagePickerController *VC = [[TZImagePickerController alloc] initWithMaxImagesCount:10000 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        VC.alwaysEnableDoneBtn = YES;
        [self.navigationController presentViewController:VC animated:YES completion:nil];
    } else if ( [message.name isEqualToString:@"sfsPhotos"]) {
        [self.navigationController pushViewController:[ScanPhotoVC new] animated:YES];

    } else if ([message.name isEqualToString:@"sRecording"]) {
        IQAudioRecorderViewController *VC = [IQAudioRecorderViewController new];
        VC.delegate = self;
        VC.title = @"录音";
        VC.maximumRecordDuration = 60;
        [self.navigationController presentAudioRecorderViewControllerAnimated:VC];
    } else if ([message.name isEqualToString:@"sfsRecordingfile"]) {
        [self.navigationController pushViewController:[ScanAudioVC new] animated:YES];
    } else if ([message.name isEqualToString:@"sQRCode"]) {
        
        //扫描二维码
        SGScanningQRCodeVC *VC = [SGScanningQRCodeVC new];
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
        
    } else if ([message.name isEqualToString:@"tpSharing"]) {
        //分享
        NSString *jsonStr = message.body;
        NSDictionary *jsonDic = [jsonStr mj_JSONObject];
        __block NSMutableString *contentStr = [NSMutableString new];
        [jsonDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [contentStr appendString:[NSString stringWithFormat:@"%@\n",obj]];
        }];

        
        NSMutableArray *items = [NSMutableArray new];
        if ([WXApi isWXAppInstalled] && [WXApi  isWXAppSupportApi]) {
            [items addObject:@(UMSocialPlatformType_WechatFavorite)];
            [items addObject:@(UMSocialPlatformType_WechatSession)];
            [items addObject:@(UMSocialPlatformType_WechatTimeLine)];
        }
        if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP]) {
            [items addObject:@(UMSocialPlatformType_Sina)];
        }
        
        if (!items.count) {
            iToastText(@"无可用分享平台!");
            return;
        }
        // MARK: - Appstore的审核必须加上预定义平台 在审核期间的未安装App是不能出现点击微信的按钮
        [UMSocialUIManager setPreDefinePlatforms:items];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject new];
            messageObject.title = jsonDic[@"title"];
            messageObject.text = jsonDic[@"content"];
          UMShareImageObject *image =  [UMShareImageObject new];
            image.shareImage = jsonDic[@"image"];
            messageObject.shareObject = image;
            [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                messageObject:messageObject currentViewController:self
                                                   completion:^(id result, NSError *error) {
                                                       if (error) {
                                                           iToastText(error.localizedDescription);
                                                       } else {
                                                           if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                               //分享结果
                                                               NSLog(@"shareResult = %@",((UMSocialShareResponse *) result).message);
                                                           }
                                                       }
                                                   }];
        }];
    } else if ([message.name isEqualToString:@"tpLogin"]) {
        //三方登录
        if (![WXApi isWXAppInstalled]) {
            iToastText(@"无登录相关平台!");
            return;
        }
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                UMSocialUserInfoResponse *response = (UMSocialUserInfoResponse *)result;
                NSLog(@"userInfo = %@%@%@%@",response.name,response.iconurl,response.unionGender,response.gender);
            }
        }];
    } else if ([message.name isEqualToString:@"portCommunication"]) {
        [self.navigationController pushViewController:[ClientVC new] animated:YES];
    } else if ([message.name isEqualToString:@"dialog"]) {
        NSString *tel = message.body;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            iToastText(@"电话打不通！");
        }
    }
}


// MARK: - SGQRCodeScanControllerDelegate
- (void)scanSuccessBarcodeJump:(NSString *)str {
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        iToastText(str);
    }
}
// MARK: - IQAudioEcorderViewContorllerDelegate
- (void)presentAudioRecorderViewControllerAnimated:(IQAudioRecorderViewController *)audioRecorderViewController {
    
}

- (void)audioRecorderControllerDidCancel:(IQAudioRecorderViewController *)controller  {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)audioRecorderController:(IQAudioRecorderViewController *)controller didFinishWithAudioAtPath:(NSString *)filePath {
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"filePath = %@",filePath);
}



// MARK: - TZImagePickerControllerDelegate

//视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
}

//GIF
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
}

//图片
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    //上传
    [NetTool postImagesWithPath:kBaseURL
                         params:@{}
                     imageArray:photos
                       fileName:@"file[]"
                         sucess:^(id responseObject) {
                             
                         }];
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {

}

-(void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - KSTakeVideoDelegate

- (void)takeVideoFinish:(NSString *)videoPath {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"videoPath = %@",videoPath);
}

// MARK: - KSTakePhotoDelegate
- (void)takePhotoFinish:(UIImage *)image {
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// MARK: - 保存至相册必须实现的协议方法，不然会出现奔溃情况
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

// MARK: - memory management
-(void)dealloc {
    if (_webView) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        _webView = nil;
    }
}
@end

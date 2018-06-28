//
//  ScanVC.m
//  GoldenField
//
//  Created by Chan on 2018/5/7.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScanVC.h"
#import <SGQRCode/SGQRCode.h>

@interface ScanVC () <SGQRCodeScanManagerDelegate,SGQRCodeAlbumManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation ScanVC

// MARK: - viewController's view's lifeCircle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //扫描view
    self.scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
    self.scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
    self.scanningView.cornerColor = [UIColor orangeColor];
    [self.view addSubview:self.scanningView];
    
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
    [self.view addSubview:self.promptLabel];
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}

- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    if ([result hasPrefix:@"http"]) {
        iToastText(result);
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] openURL:kURL(result)];
    }
}

- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        AVMetadataMachineReadableCodeObject *result = metadataObjects.firstObject;
        NSLog(@"scan result = %@",result.stringValue);
        /*NSData *jsonData = [result.stringValue dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:kNilOptions
                                                    error:nil];*/
        if (result.stringValue.length) {
            //扫描到url 做内部跳转
            iToastText(result.stringValue);
            [self.navigationController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication] openURL:kURL(result.stringValue)];

        }
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"simulator can't support QRCode scaning! ");
#elif TARGET_OS_IPHONE
        NSLog(@"scan result = %@",result.stringValue);
#endif
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

// MARK: - memory management
- (void)dealloc {
    NSLog(@"WBQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

@end

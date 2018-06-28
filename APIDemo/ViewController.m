//
//  ViewController.m
//  APIDemo
//
//  Created by Chan on 2018/6/13.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ViewController.h"
#import "KSTakePhotoViewController.h"
#import "KSTakeVideoViewController.h"
#import "ScanVideoVC.h"
#import "IQAudioRecorderViewController.h"
#import "ScanAudioVC.h"
#import "ScanVC.h"
#import "ClientVC.h"
#import "WebVC.h"
#import "ScanPhotoVC.h"

@interface ViewController () <KSTakePhotoDelegate,KSTakeVideoDelegate,UITableViewDelegate,UITableViewDataSource,IQAudioRecorderViewControllerDelegate,TZImagePickerControllerDelegate> {

    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation ViewController

// MARK: - viewController'view's lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //都要做文件缓存处理 
    _dataArray = [NSMutableArray arrayWithArray:@[@"拍照",@"拍视频",@"扫描文件系统视频",@"扫描手机相册",@"扫描文件系统照片",@"录音",@"扫描文件系统录音文件",@"扫描二维码",@"三方分享",@"三方登录",@"端口通信",@"webView测试"]];
}

// MARK: - loadData (GET)
- (void)loadData {
  NSURLSessionDataTask *task =  [kHttpClient GET:kBaseURL
          parameters:@{}
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
    if ([task respondsToSelector:@selector(resume)]) {
        [task resume];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// MARK: - 图片处理
- (void)takePicture {
    KSTakePhotoViewController *VC = [[KSTakePhotoViewController alloc] initWithType:KSTakePhotoNormal];
    VC.delegate = self;
    [self.navigationController presentViewController:VC animated:YES completion:nil];
}

// MARK: - KSTakePhotoDelegate
- (void)takePhotoFinish:(UIImage *)image {
    NSData  *imageData = UIImageJPEGRepresentation(image,0.3);
    //上传
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)takeVideo {
    KSTakeVideoViewController *VC = [KSTakeVideoViewController new];
    VC.delegate = self;
    [self.navigationController presentViewController:VC animated:YES completion:nil];
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

// MARK: - UITableViewDatasource &Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self takePicture];
        }
            break;
        case 1:
        {
            [self takeVideo];
        }
            break;
        case 2:
        {
            //扫描视频
            ScanVideoVC *VC = [ScanVideoVC new];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
            //扫描系统照片
            TZImagePickerController *VC = [[TZImagePickerController alloc] initWithMaxImagesCount:10000 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
            VC.alwaysEnableDoneBtn = YES;
            [self.navigationController presentViewController:VC animated:YES completion:nil];
            
        }
            break;
            case 4:
        {
            //扫描文件系统照片
            [self.navigationController pushViewController:[ScanPhotoVC new] animated:YES];
         
        }
            break;
            case 5:
        {
            IQAudioRecorderViewController *VC = [IQAudioRecorderViewController new];
            VC.delegate = self;
            VC.title = @"录音";
            VC.maximumRecordDuration = 60;
            [self.navigationController presentAudioRecorderViewControllerAnimated:VC];
        }
            break;
        case 6: {
            //扫描沙盒后缀.m4a文件
            [self.navigationController pushViewController:[ScanAudioVC new] animated:YES];
        }
            break;
        case 7:{
            //扫描二维码
            [self.navigationController pushViewController:[ScanVC new] animated:YES];
            
        }
            break;
        case 8: {
            
            //分享
            NSMutableArray *items = [NSMutableArray new];
            if ([WXApi isWXAppInstalled] && [WXApi  isWXAppSupportApi]) {
                [items addObject:@(UMSocialPlatformType_WechatFavorite)];
                [items addObject:@(UMSocialPlatformType_WechatSession)];
                [items addObject:@(UMSocialPlatformType_WechatTimeLine)];
            }
            if (!items.count) {
                iToastText(@"无可用分享平台!");
                return;
            }
            [UMSocialUIManager setPreDefinePlatforms:items];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                UMSocialMessageObject *messageObject = [UMSocialMessageObject new];
                messageObject.text = @"xxx";
                messageObject.shareObject = [UMShareObject shareObjectWithTitle:@"xxx" descr:@"xxx" thumImage:nil];
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:messageObject currentViewController:self
                                                       completion:^(id result, NSError *error) {
                                                           if (error) {
                                                               
                                                           } else {
                                                               if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                                                   //分享结果
                                                                   NSLog(@"shareResult = %@",((UMSocialShareResponse *) result).message);
                                                               }
                                                           }
                                                       }];
            }];
        }
            break;
        case 9: {
            
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
        }
            break;
            case 10:
        {
            [self.navigationController pushViewController:[ClientVC new] animated:YES];
        }
            break;
        case 11: {
            [self.navigationController pushViewController:[WebVC new] animated:YES];
        }
        default:
            
            break;
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

// MARK: - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    long long fileSize = 0.0f;
     //计算缓存大小
    for (NSString *fileName in [[NSFileManager defaultManager] subpathsAtPath:kVideosFilePath]) {
        fileSize = fileSize + [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",kVideosFilePath,fileName] error:nil] fileSize];
    }
    for (NSString *fileName in [[NSFileManager defaultManager] subpathsAtPath:kAudiosFilePath]) {
        fileSize = fileSize + [[[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",kAudiosFilePath,fileName] error:nil] fileSize];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小:%.2fMB",fileSize/1024.0/1024.0];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.navigationItem.title = @"数据管理";
}

// MARK: - memory management

- (void)dealloc {
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableView = nil;
    }
}
@end

//
//  GuideVC.m
//  APIDemo
//
//  Created by Chan on 2018/6/22.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC () <UIScrollViewDelegate> {
    UIScrollView *_contentView;
    NSMutableArray *_images;
}

@end

@implementation GuideVC

// MARK: - viewController's view lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

// MARK: - setUI
- (void)setUI {
    _images = [NSMutableArray new];
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    _contentView.contentSize = CGSizeMake(3 * kAppWidth,0);
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    [self.view addSubview:_contentView];
    for (int i = 0 ; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kAppWidth, 0, kAppWidth, kAppHeight)];
        [imageView sd_setImageWithURL:kURL(_images[i])];
        [_contentView addSubview:imageView];
    }
    [_contentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

// MARK: - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSLog(@"value = %@",[change objectForKey:NSKeyValueChangeNewKey]);
        CGFloat X = _contentView.contentOffset.x;
        if (X> 3 * kAppWidth) {
            if (_completeBlock) {
                _completeBlock();
            }
        }
    }
}

// MARK: - 拉取引导图图片
-(void)loadData {
    //拉取引导图
    __weak typeof(self)weakSelf = self;
    [kHttpClient GET:kBaseURL
          parameters:@{}
            progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 //转json
                 GuideVC *strongSelf = weakSelf;
                 NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                 if ([jsonDic[@"images"] count]) {
                     //服务器拉
                     [strongSelf->_images addObjectsFromArray:jsonDic[@"images"]];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self setUI];
                     });
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
             }];
}

// MARK: - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat X = scrollView.contentOffset.x;
    if (X > (3 *kAppWidth)) {
        if (_completeBlock) {
            _completeBlock();
        }
    }
}

// MARK: - memoryManagent
-(void)dealloc {
    if (_contentView) {
        _contentView.delegate = nil;
        _contentView = nil;
    }
    if (_images) {
        _images = nil;
    }
    [_contentView removeObserver:self forKeyPath:@"contentOffset"];
}
@end

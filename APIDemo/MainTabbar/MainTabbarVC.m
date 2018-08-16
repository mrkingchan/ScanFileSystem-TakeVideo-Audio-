//
//  MainTabbarVC.m
//  APIDemo
//
//  Created by Chan on 2018/7/18.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "MainTabbarVC.h"
#import "BadgeView.h"

@interface MainTabbarVC () {
    NSMutableArray *_badgeViews;
    NSInteger count;
}

@end

@implementation MainTabbarVC

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *naviControllers = [NSMutableArray new];
    _badgeViews = [NSMutableArray new];
    CGFloat itemW = kAppWidth / 4;
    for (int i = 0 ; i < 4; i ++) {
        UIViewController *viewConroller = [self viewControlleWithtitle:[NSString stringWithFormat:@"%i",i] normalimage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%i",i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%i_s",i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:viewConroller];
        [naviControllers addObject:naviController];
    }
    self.viewControllers = naviControllers;
    for (int i = 0; i <4; i ++) {
        BadgeView * badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(i * itemW +  (itemW /2 + 7.5), 2, 15, 15)];
        badgeView.tag = 1000 + i;
        [self.tabBar addSubview:badgeView];
        [_badgeViews  addObject:badgeView];
    }
    __block int  i = 0;
    @weakify(self);
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            i ++ ;
            @strongify(self);
            for (BadgeView *dotView in self->_badgeViews) {
                [dotView updateCount:i];
            }
        }];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    }
}

// MARK: - private Method
-(void)timeAction:(NSTimer *)timer {
    count ++ ;
    for (BadgeView *dotView in _badgeViews) {
        [dotView updateCount:count];
    }
}
// MARK: - UITabbarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (_badgeViews.count) {
        //置空
        [((BadgeView *) _badgeViews[index]) updateCount:0];
    }
}

/**
 build the viewController with the given title,normalImage,selectedImage

 @param title title
 @param normalImage normalImage
 @param selectedImage selectedImage
 @return viewController with the given paramters
 */
- (UIViewController *)viewControlleWithtitle:(NSString *)title
                                 normalimage:(UIImage *)normalImage
                               selectedImage:(UIImage *)selectedImage {
    UIViewController *viewControler = [UIViewController new];
    viewControler.view.backgroundColor = kRandomColor;
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:normalImage
                                               selectedImage:selectedImage];
    viewControler.tabBarItem = item;
    return viewControler;
}
@end

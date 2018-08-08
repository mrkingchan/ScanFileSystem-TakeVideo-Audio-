//
//  UIVC.m
//  APIDemo
//
//  Created by Macx on 2018/8/8.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "UIVC.h"

@interface UIVC () {
    UIButton *_button;
    UILabel *_label;
    UIImageView *_imageView;
    UIView *_view;
    UIScrollView *_scrollView;
    
}

@end

@implementation UIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _button = kInsertButtonWithType(self.view, CGRectMake(0, 20,100 ,40 ), 38932, nil, @selector(buttonAction:), UIButtonTypeCustom);
    [_button setTitle:@"button" forState:UIControlStateNormal];
    [_button setBackgroundImage:kIMAGE(@"AppIcon") forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self analyseButton];
    [self dyamaticCreateAClass];
}

- (void)buttonAction:(id)sender {
    puts(__func__);
}

- (void)analyseButton {
    unsigned int count = 0;
    Ivar*vars = class_copyIvarList([UIButton class], &count);
    for (int i = 0 ; i < count; i ++) {
//        id value = object_getIvar(_button, vars[i]);
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        NSString *varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(vars[i])];
//        NSLog(@"varName = %@ -- varType = %@,value = %@",varName,varType,value);
    }
    
    /*
     <UIButtonLabel: 0x7f848b63e9f0; frame = (23.3333 9.33333; 53.3333 21.6667); text = 'button'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x6000004844c0>>
     Printing description of $16:
     <UIImageView: 0x7f848b615240; frame = (0 0; 100 40); clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x600000429e40>>
     */
    NSArray *items = _button.subviews;
    for (int i = 0 ; i < items.count; i ++) {
        if ([items[i]  isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
            unsigned int count2  = 0;
            Ivar *vars = class_copyIvarList(NSClassFromString(@"UIButtonLabel"), &count2);
            for (int i = 0 ; i < count2; i ++) {
                NSLog(@"name = %@",[NSString stringWithUTF8String:ivar_getName(vars[i])]);
            }
        }
    }
}

- (void)dyamaticCreateAClass {
    //创建一个类
    Class People = objc_allocateClassPair([NSObject class], "People", 0);
    //添加成员变量
    BOOL addNameSucess = class_addIvar(People, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    if (addNameSucess) {
        NSLog(@"变量添加成功,_name");
    }
    
    BOOL addAgeSucess = class_addIvar(People, "_age", sizeof(int), log2(sizeof(int)), @encode(int));
    if (addAgeSucess) {
        NSLog(@"变量添加成功,_age");
    }
    //完成People类的创建
    objc_registerClassPair(People);
    
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList(People, &count);
    for (int i = 0 ; i < count; i ++) {
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(vars[i])];
        NSString *varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(vars[i])];
        NSLog(@"varName = %@,varType = %@",varName,varType);
    }
    
    //释放
    free(vars);
    //为变量赋值
    id Chan = [People new];
    Ivar nameVar = class_getInstanceVariable(People, "_name");
    object_setIvar(Chan, nameVar, @"Chan");
    
    Ivar ageVar =  class_getInstanceVariable(People, "_age");
    object_setIvar(Chan, ageVar, @(24));
    NSLog(@"name = %@,age = %@",object_getIvar(Chan, nameVar),object_getIvar(Chan, ageVar));
    /*
     2018-08-08 11:29:08.909155+0800 APIDemo[4719:180037] 变量添加成功,_name
     2018-08-08 11:29:08.909481+0800 APIDemo[4719:180037] 变量添加成功,_age
     2018-08-08 11:29:08.909631+0800 APIDemo[4719:180037] varName = _name,varType = @
     2018-08-08 11:29:08.909734+0800 APIDemo[4719:180037] varName = _age,varType = i
     2018-08-08 11:29:42.682061+0800 APIDemo[4719:180037] name = Chan,age = 24
     */
    
}
@end

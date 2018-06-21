//
//  WebVC.m
//  APIDemo
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "WebVC.h"
#import <WebKit/WebKit.h>

@interface WebVC () {
    WKWebView*_webView;
}

@end

@implementation WebVC

// MARK: - lifeCirle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    
    // CSS选中样式取消
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    
    // javascript注入
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:noneSelectScript];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) configuration:configuration];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:_webView];
}

// MARK: - memory management

-(void)dealloc {
    if (_webView) {
        _webView = nil;
    }
}
@end
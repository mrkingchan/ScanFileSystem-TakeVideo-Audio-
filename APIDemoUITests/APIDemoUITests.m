//
//  APIDemoUITests.m
//  APIDemoUITests
//
//  Created by Chan on 2018/6/13.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface APIDemoUITests : XCTestCase

@end

@implementation APIDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    puts(__func__);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    puts(__func__);
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    puts(__func__);
    XCTAssert(YES,@"passed!");
}

// MARK: - 逐一编写测试用例
- (void)testCellClick {
    XCUIApplication *application  = [[XCUIApplication alloc] init];
    //找到tableView
    XCUIElement *tableView = [application.tables elementBoundByIndex:0];
    NSInteger count = tableView.cells.count;
    for (int i = 0 ; i <count ; i ++) {
        XCUIElement *cell = [tableView.cells elementBoundByIndex:i];
        [cell tap];
    }
}

- (void)testNavigationitemClick {
    XCUIApplication *application = [XCUIApplication new];
    XCUIElement *navigationBar = [application.navigationBars elementBoundByIndex:0];
    for (int i = 0 ; i < 10; i ++) {
        [navigationBar.buttons[@"推送测试"] tap];
    }
    [navigationBar.buttons[@"清除缓存"] tap];
}

- (void)testRecording {
    XCUIElement *appliction = [XCUIApplication new];
    XCUIElement *tableView = [appliction.tables elementBoundByIndex:0];
    for (int i = 0 ; i < tableView.cells.count; i ++) {
        
    }
}
- (void)clearCache {
    NSString *cmdStr = NSStringFromSelector(_cmd);
    if ([cmdStr rangeOfString:@"location"].location != NSNotFound) {
        
    }
}
@end

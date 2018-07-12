//
//  InvoicePaperVC.m
//  APIDemo
//
//  Created by Macx on 2018/7/11.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "InvoicePaperVC.h"
#import "InvoicePaperView.h"
#import <QuartzCore/QuartzCore.h>

#define kAppW  [UIScreen mainScreen].bounds.size.width
#define kAppH [UIScreen mainScreen].bounds.size.height
#define kitemW  58/103*[UIScreen mainScreen].bounds.size.width

@interface InvoicePaperVC () <UIPrintInteractionControllerDelegate>

@end

@implementation InvoicePaperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *jsonDic = @{
                          @"food":
                              @[
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"},
                                  @{@"name":@"啤酒鸭啤酒鸭啤酒鸭",@"number":@"2",@"price":@"123"}
                              ],
                          @"orderTime":@"下单时间：2018-07-12 12:00",
                          @"totalPrice":@"总价共计:                       900 RMB",
                          @"resturantName":@"松哥油焖大虾",
                          @"resturantAddress":@"地址:大连沙河口区海星广场25号地铁D出口东行110米行110米行110米"
                          };
    InvoicePaperView *subView = [[InvoicePaperView alloc] initWithFrame:CGRectMake(40 , 0, kAppW - 80, [jsonDic[@"food"] count] * 30) JsonData:jsonDic];
    [self.view addSubview:subView];
    NSDictionary *json =    @{@"bottomTabbarData":@[
                                      @{@"icon":@"http://wwww.xxx.png",
                                        @"title":@"xxx",
                                        @"loadUrl":@"http://www.xxx.com"
                                        },
                                      
                                      @{@"icon":@"http://wwww.xxx.png",
                                        @"title":@"xxx",
                                        @"loadUrl":@"http://www.xxx.com"
                                        },
                                      @{@"icon":@"http://wwww.xxx.png",
                                        @"title":@"xxx",
                                        @"loadUrl":@"http://www.xxx.com"
                                        },
                                      @{@"icon":@"http://wwww.xxx.png",
                                        @"title":@"xxx",
                                        @"loadUrl":@"http://www.xxx.com"
                                        },
                                      @{@"icon":@"http://wwww.xxx.png",
                                        @"title":@"xxx",
                                        @"loadUrl":@"http://www.xxx.com"
                                        },
                                      ]};
  NSString *filePath =  [self createPDFfromUIView:self.view saveToDocumentsWithFileName:[NSString stringWithFormat:@"%@.pdf",json[@"resturantName"]]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(printAction:)];
    
    // 打印PDF
}

// MARK: - prtin
- (void)printAction:(UIButton *)sender {
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    if(printController) {
        printController.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.jobName = @"Preview";
        printInfo.orientation = UIPrintInfoOrientationPortrait;
        printInfo.outputType = UIPrintInfoOutputGrayscale;
        printController.showsPageRange = YES;
        printController.printInfo = printInfo;
        printController.printingItem = [[self class] imageWithView:self.view];
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error)
            {
                NSLog(@"PRINT FAILED: %@", [error description]);
            }
        };
        
        [printController presentAnimated:YES completionHandler:completionHandler];
    }
}


// MARK: - 由于打印机器只能打印PDF doc png等等格式
+ (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

-(NSString *)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename {
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return documentDirectoryFilename;
}
    @end

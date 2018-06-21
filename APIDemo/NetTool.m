//
//  NetTool.m
//  APIDemo
//
//  Created by Macx on 2018/6/21.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "NetTool.h"
#import "HttpClient.h"

@implementation NetTool

+ (NSURLSessionDataTask *)postImagesWithPath:(NSString *)path
                                      params:(NSDictionary *)dic
                                  imageArray:(NSArray *)imageArray
                                    fileName:(NSString *)fileName
                                      sucess:(complete)sucess {
    NSURLSessionDataTask *task = [kHttpClient POST:path
                                        parameters:dic
                         constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                             //追加ImageData
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"yyyyMMddHHmmss"];
                             for (int i = 0; i < imageArray.count; i++) {
                                 UIImage *image = imageArray[i];
                                 //压缩
                                 NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                                 //文件命名格式 时间戳命名
                                 NSString *dateString = [formatter stringFromDate:[NSDate date]];
                                 NSString *serverImageName = [NSString  stringWithFormat:@"%@.png", dateString];
                                 [formData appendPartWithFileData:imageData name:fileName fileName:serverImageName mimeType:@"image/png"];
                             }
                         } progress:^(NSProgress * _Nonnull uploadProgress) {
                             NSString *sub = @"%";
#ifndef __OPTIMIZE__
                             NSLog(@"上传进度-----:%@ %.2lld",sub,uploadProgress.completedUnitCount / uploadProgress.totalUnitCount * 100);
#endif
                         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             //转json
                             id json = @{};
                             if ([responseObject isKindOfClass:[NSData class]]) {
                                 json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                             } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                 json = responseObject;
                             }
                             if (sucess) {
                                 sucess(json);
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         }];
    return task;
}
@end

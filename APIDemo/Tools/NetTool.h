//
//  NetTool.h
//  APIDemo
//
//  Created by Chan on 2018/6/21.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^complete)(id responseObject);

@interface NetTool : NSObject
/**
 图片上传
 
 @param path 路径
 @param dic 参数
 @param imageArray 图片数组
 @param fileName 文件名
 @param sucess sucess成功回调
 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)postImagesWithPath:(NSString *)path
                                      params:(NSDictionary *)dic
                                  imageArray:(NSArray *)imageArray
                                    fileName:(NSString *)fileName
                                      sucess:(complete)sucess;


/**
 post请求

 @param path 路径
 @param dic 参数
 @param success 成功回调
 @return 网络请求任务
 */
+ (NSURLSessionDataTask *)innerPostWithPath:(NSString *)path
                                     params:(NSDictionary*)dic
                                     sucess:(complete)success;

@end

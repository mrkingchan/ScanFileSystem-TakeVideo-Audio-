//
//  AVTool.h
//  APIDemo
//
//  Created by Chan on 2018/6/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVTool : NSObject

////视频和音频的操作 在这个工具类中的操作就是删除和查询，增加在UI层面

/**
 删除指定文件名

 @param fileName 相对文件名
 @param isVideo 是否属于视频文件mp4
 @param resultComplete 删除结果回调
 */
+ (void)deleteFileWithFileName:(NSString *)fileName isVideo:(BOOL)isVideo  deleteResult:(void (^)(BOOL))resultComplete;


/**
 查询指定文件名

 @param fileName 文件名
 @param isVideo 是否是视频
 @param queryCompletePath 文件绝对路径
 */
+ (void)queryFileWithFileName:(NSString*)fileName isVideo:(BOOL)isVideo withCompleteFilePath:(void (^)(NSString *))queryCompletePath;

@end

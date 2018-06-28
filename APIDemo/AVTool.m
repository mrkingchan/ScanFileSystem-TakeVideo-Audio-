//
//  AVTool.m
//  APIDemo
//
//  Created by Chan on 2018/6/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "AVTool.h"

@implementation AVTool

+ (void)deleteFileWithFileName:(NSString *)fileName isVideo:(BOOL)isVideo deleteResult:(void (^)(BOOL))resultComplete  {
    
 BOOL deleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:isVideo ? [kVideosFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]:[kAudiosFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]
                                               error:nil];
    resultComplete(deleteSuccess);
}

+ (void)queryFileWithFileName:(NSString *)fileName
                      isVideo:(BOOL)isVideo
         withCompleteFilePath:(void (^)(NSString *))queryCompletePath {
    NSString *filePath = isVideo ? [kVideosFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]]:[kAudiosFilePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    queryCompletePath(filePath);
}

@end

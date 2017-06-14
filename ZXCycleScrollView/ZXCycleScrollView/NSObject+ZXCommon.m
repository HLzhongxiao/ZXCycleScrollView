//
//  NSObject+ZXCommon.m
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/24.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import "NSObject+ZXCommon.h"

@implementation NSObject (ZXCommon)

/**
 获取fileName的完整地址
 */
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    
    return [cachePath stringByAppendingPathComponent:fileName];
}


/**
 获取缓存文件夹
 */
+ (BOOL)createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if(!(isDir == YES && existed == YES))
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(existed)
    {
        isCreated = YES;
    }
    return isCreated;
}

+ (BOOL)deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}


@end

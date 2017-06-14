//
//  NSData+ZXCommon.m
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/24.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import "NSData+ZXCommon.h"
#import "NSObject+ZXCommon.h"
#import "NSString+ZXCommon.h"

#define ZXMaxCacheFileAmount 20
#define ZXDataCache @"zxDataCache"

@implementation NSData (ZXCommon)

+ (NSString *)cachePath
{
    NSString *path;
    if([NSData createDirInCache:ZXDataCache])
    {
        path = [NSData pathInCacheDirectory:ZXDataCache];
    }
    return path;
}

+ (NSData *)getDataCacheWithIdentifier:(NSString *)identifier
{
    NSString *path = [[self cachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[identifier md5Str]]];

    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *dataArr = [manager contentsOfDirectoryAtPath:path error:nil];
    if(dataArr.count > ZXMaxCacheFileAmount)
    {
        [manager removeItemAtPath:[self cachePath] error:nil];
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (void)saveDataCacheWithIdentifier:(NSString *)identifier
{
    NSString *path = [NSData cachePath];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[identifier md5Str]]];
    [self writeToFile:path atomically:YES];
}

+ (void)clearCache
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[self cachePath] error:nil];
}

@end

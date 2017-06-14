//
//  NSObject+ZXCommon.h
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/24.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZXCommon)

+ (BOOL)createDirInCache:(NSString *)dirName;
+ (NSString* )pathInCacheDirectory:(NSString *)fileName;

@end

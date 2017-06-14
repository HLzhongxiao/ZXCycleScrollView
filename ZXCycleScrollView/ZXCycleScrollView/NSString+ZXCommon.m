//
//  NSString+ZXCommon.m
//  ZXCycleScrollView
//
//  Created by 忠晓 on 2017/3/24.
//  Copyright © 2017年 忠晓. All rights reserved.
//

#import "NSString+ZXCommon.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@implementation NSString (ZXCommon)
- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)stringEncoding
{
    if(SYSTEM_VERSION_GREATER_THAN(@"iOS 9.0"))
    {
        return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        return [self stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
}

@end

//
//  NT_Utils.h
//  NaiTangApp
//
//  Created by 张正超 on 14-2-26.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
// 获取文件大小

#import <Foundation/Foundation.h>

// 读取文件
NSString *getFilePath(NSString* filename, NSString* ext);
NSString *getBundleFilePath(NSString* filename, NSString* ext);

static inline void showAlert (NSString *msg) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定",nil];
    [alert show];
#if __has_feature(objc_arc)
#else
    [alert autorelease];
#endif
}

static inline NSString *NSStringFromSize(double bSize)
{
    if (bSize < 1024) {
        return [NSString stringWithFormat:@"%.1fB",bSize];
    }
    bSize /= 1024;
    if (bSize < 1024) {
        return [NSString stringWithFormat:@"%.1fKB",bSize];
    }
    bSize /= 1024;
    if (bSize < 1024) {
        return [NSString stringWithFormat:@"%.1fMB",bSize];
    }
    bSize /= 1024;
    if (bSize < 1024) {
        return [NSString stringWithFormat:@"%.1fGB",bSize];
    }
    return @"1.25G";
}

static inline NSString *NSStringFromNumber(double bSize)
{
    if (bSize < 10000) {
        return [NSString stringWithFormat:@"%.0f",bSize];
    }
    bSize /= 10000;
    if (bSize < 10000) {
        return [NSString stringWithFormat:@"%.1fW",bSize];
    }
    return @"10.2W";
}

static inline NSString *NSStringFromSpeed(double speed)
{
    NSString *speedStr = @"";
    if (speed>1024*1024) {
        speed /= 1024*1024;
        speedStr = [NSString stringWithFormat:@"%.fMb/s",speed];
    }else if (speed > 1024)
    {
        speed /= 1024;
        speedStr = [NSString stringWithFormat:@"%.fKb/s",speed];
    }else
    {
        speedStr = [NSString stringWithFormat:@"%.fb/s",speed];
    }
    return speedStr;
}


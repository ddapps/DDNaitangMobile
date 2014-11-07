//
//  NT_UpdateAppInfo.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-2.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_UpdateAppInfo.h"

@implementation NT_UpdateAppInfo

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.download_addr forKey:@"UpdateAppInfoAddr"];
    [aCoder encodeObject:self.game_name forKey:@"UpdateAppInfoGameName"];
    [aCoder encodeObject:self.package forKey:@"UpdateAppInfoPackage"];
    [aCoder encodeObject:self.version_code forKey:@"UpdateAppInfoVersionCode"];
    [aCoder encodeObject:self.version_name forKey:@"UpdateAppInfoVersionName"];
    [aCoder encodeObject:self.fileSize forKey:@"UpdateAppInfoFileSize"];
    [aCoder encodeObject:self.iconName forKey:@"UpdateAppInfoIconName"];
    [aCoder encodeObject:self.appId forKey:@"UpdateAppInfoAppID"];
    [aCoder encodeObject:self.news_version forKey:@"UpdateAppInfoNewVersion"];
    [aCoder encodeInt:self.updateState forKey:@"UpdateAppInfoUpdateState"];
    [aCoder encodeBool:self.isUpdateIgnore forKey:@"UpdateAppInfoIsUpdateIgnore"];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.download_addr = [aDecoder decodeObjectForKey:@"UpdateAppInfoAddr"];
        self.game_name = [aDecoder decodeObjectForKey:@"UpdateAppInfoGameName"];
        self.package = [aDecoder decodeObjectForKey:@"UpdateAppInfoPackage"];
        self.version_code = [aDecoder decodeObjectForKey:@"UpdateAppInfoVersionCode"];
        self.version_name = [aDecoder decodeObjectForKey:@"UpdateAppInfoVersionName"];
        self.fileSize = [aDecoder decodeObjectForKey:@"UpdateAppInfoFileSize"];
        self.iconName = [aDecoder decodeObjectForKey:@"UpdateAppInfoIconName"];
        self.appId = [aDecoder decodeObjectForKey:@"UpdateAppInfoAppID"];
        self.news_version = [aDecoder decodeObjectForKey:@"UpdateAppInfoNewVersion"];
        self.updateState = [aDecoder decodeIntForKey:@"UpdateAppInfoUpdateState"];
        self.isUpdateIgnore = [aDecoder decodeBoolForKey:@"UpdateAppInfoIsUpdateIgnore"];
    }
    return self;
}

+ (NT_UpdateAppInfo *)dictToInfo:(NSDictionary *)dic
{
    NT_UpdateAppInfo *info = [[NT_UpdateAppInfo alloc] init];
    info.download_addr = [[dic objectForKey:@"download_addr"] nullTonil];
    info.game_name = [[dic objectForKey:@"game_name"] nullTonil];
    info.package = [[dic objectForKey:@"app_package"] nullTonil];
    info.version_code = [[dic objectForKey:@"version_code"] nullTonil];
    NSString *versionName = [[dic objectForKey:@"version_name"] nullTonil];
    if (versionName.length >= 6)
    {
        versionName = [versionName substringToIndex:6];
    }
    info.version_name = versionName;
    info.fileSize = [[dic objectForKey:@"size"] nullTonil];
    info.iconName = [[dic objectForKey:@"round_pic"] nullTonil];
    info.appId = [[dic objectForKey:@"id"] nullTonil];
    info.news_version = [[dic objectForKey:@"new_version"] nullTonil];
    info.updateState = 0;
    info.isUpdateIgnore = NO;
    return info;
}

+ (BOOL)versionCompare:(NSString *)firstVersion and:(NSString *)secondVersion
{
    NSArray *firstArr = [firstVersion componentsSeparatedByString:@"."];
    NSArray *secondArr = [secondVersion componentsSeparatedByString:@"."];
    BOOL flag = NO;
    int i = 0;
    for (; i<MIN(firstArr.count, secondArr.count); i++) {
        if ([[firstArr objectAtIndex:i] intValue]>[[secondArr objectAtIndex:i] intValue]) {
            flag = YES;
            break;
        }else if ([[firstArr objectAtIndex:i] intValue]<[[secondArr objectAtIndex:i] intValue])
        {
            flag = NO;
            break;
        }
    }
    if (i == MIN(firstArr.count, secondArr.count)) {
        flag = firstArr.count>secondArr.count?YES:NO;
    }
    return flag;
}


@end

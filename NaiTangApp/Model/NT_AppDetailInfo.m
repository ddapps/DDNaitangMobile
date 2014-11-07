//
//  NT_AppDetailInfo.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_AppDetailInfo.h"

@implementation NT_AppDetailInfo

+ (NT_AppDetailInfo *)inforFromDetailDic:(NSDictionary *)dic
{
    if ([dic objectForKey:@"id"]==[NSNull null]) {
        return nil;
    }
    NT_AppDetailInfo *info = [[NT_AppDetailInfo alloc] init];
    if ([[dic objectForKey:@"download_addr"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [dic objectForKey:@"download_addr"];
        info.downloadArray = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (int i = 0; i < [arr count]; i++) {
            NT_DownloadAddInfo *downloadAddInfo = [NT_DownloadAddInfo inforFromDetailDic:[arr objectAtIndex:i]];
            [info.downloadArray addObject:downloadAddInfo];
        }
    }else
    {
        info.downloadArray = [NSMutableArray array];
    }
    info.fee = [[dic objectForKey:@"fee"] nullTonil];
    //info.app_version_name = [[dic objectForKey:@"app_version_name"] nullTonil];
    NSString *versionName = [[dic objectForKey:@"app_version_name"] nullTonil];
    if (versionName.length >= 6)
    {
        versionName = [versionName substringToIndex:6];
    }
    info.app_version_name = versionName;
    
    if (info.app_version_name == nil)
    {
        NSString *version = [[dic objectForKey:@"version"] nullTonil];
        if (version.length >= 6)
        {
            version = [version substringToIndex:6];
        }
        info.app_version_name = version;
    }
    info.apple_id = [[dic objectForKey:@"app_id"] nullTonil];
    info.game_name = [dic objectForKey:@"game_name"];
    info.round_pic = [dic objectForKey:@"round_pic"];
    float score = [[dic objectForKey:@"score"] floatValue];
    info.score = [NSString stringWithFormat:@"%.1f",score];
    info.is_much_money = [dic objectForKey:@"is_much_money"];
    info.appId = [dic objectForKey:@"id"];
    if ([dic objectForKey:@"size"]!=[NSNull null]) {
        double bSize = [[dic objectForKey:@"size"] doubleValue];
        info.size = NSStringFromSize(bSize);
    }
    info.star_count = [[dic objectForKey:@"star_count"] nullTonil];
    info.descriptionString = [dic[@"description"] nullTonil];
    if ( info.descriptionString == nil) {
        info.descriptionString = dic[@"summary"];
    }
    info.package = dic[@"package"]==[NSNull null]?@"":dic[@"package"];
    if (!info.package.length) {
        info.package = nil;
    }
    info.categoryID = dic[@"categoryId"]==[NSNull null]?@"":dic[@"categoryId"];
    info.categoryName = dic[@"categoryName"]==[NSNull null]?@"":dic[@"categoryName"];
    info.stypeName = dic[@"stypeName"]==[NSNull null]?@"":dic[@"stypeName"];

    //截取兼容字段 最低版本号
    NSString *jre = dic[@"jre"] == [NSNull null]?@"":dic[@"jre"];
    info.jre = jre;
    if (jre.length>0)
    {
        NSRange fromRang = [jre rangeOfString:@"iOS"];
        NSRange toRang = [jre rangeOfString:@"或"];
        if (fromRang.location != NSNotFound)
        {
            if (toRang.location != NSNotFound)
            {
                //jre中文 最低版本
                jre = [jre substringWithRange:NSMakeRange(fromRang.location+fromRang.length, toRang.location-(fromRang.length+fromRang.location))];
                
            }
            else
            {
                //jre英文
                toRang = [jre rangeOfString:@"or"];
                jre = [jre substringWithRange:NSMakeRange(fromRang.location+fromRang.length, toRang.location - (fromRang.location+fromRang.length))];
                
            }
            //默认最低5.0
            info.minVersion = jre ? jre : @"5.0";
            //NSString *ver = [NSString stringWithFormat:@"%.2f",[jre floatValue]];
            //info.minVersion = [ver floatValue] > 0 ? [ver floatValue] : 5.0;
            
        }
       
        /*
        if (rang.location == NSNotFound)
        {
            //找jre英文描述
            rang = [jre rangeOfString:@"or"];
            jre = [jre substringWithRange:NSMakeRange(13, rang.location-13)];
        }
        else
        {
            jre = [jre substringWithRange:NSMakeRange(6, rang.location-6)];
        }
        //默认最低5.0
        info.minVersion = [jre floatValue] > 0 ? [jre floatValue] : 5.0;
        NSLog(@"jre:%@",jre);
         */
    }
    return info;
}

@end

@implementation NT_DownloadAddInfo
+ (NT_DownloadAddInfo *)inforFromDetailDic:(NSDictionary *)dic
{
    NT_DownloadAddInfo *info = [[NT_DownloadAddInfo alloc] init];
    info.download_addr = [[dic objectForKey:@"download_addr"] nullTonil];
    info.version_name = [[dic objectForKey:@"version_name"] nullTonil];
    info.versionType = [[dic[@"version_type"] nullTonil] intValue];
    info.archives_name = [[dic objectForKey:@"archives_name"] nullTonil];
    if (info.versionType == DownloadTypeAppStore) {
        info.version_name = [info.version_name substringToIndex:4];
    }
    return info;
}
- (DownloadType)downloadType
{
    if (self.versionType != DownloadTypeUnknow) {
        return self.versionType;
    }
    if ([self.version_name hasPrefix:@"纯净正版"]) {
        return DownloadTypeAppStore;
    }
    else if([self.version_name isEqualToString:@"纯净版"])
    {
        return DownloadTypeNormalIpa;
    }
    else if([self.version_name isEqualToString:@"无限金币版"])
    {
        return ([[UIDevice currentDevice] isJailbroken]?DownloadTypeNolimitGold:NOBreakDownloadTypeNolimitGold);
    }
    return DownloadTypeUnknow;
}

@end


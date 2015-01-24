//
//  NT_NaiTangUpdateInfo.m
//  NaiTangApp
//
//  Created by 张正超 on 14-4-21.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_NaiTangUpdateInfo.h"

@implementation NT_NaiTangUpdateInfo

- (NT_NaiTangUpdateInfo *)updateInfoWithDic:(NSDictionary *)dic
{
    NT_NaiTangUpdateInfo *updateInfo = [[NT_NaiTangUpdateInfo alloc] init];
    updateInfo.naitangAppId = [dic objectForKey:@"id"];
    updateInfo.version_name = [dic objectForKey:@"version_name"];
    updateInfo.version_code = [dic objectForKey:@"version_code"];
    updateInfo.type = [dic objectForKey:@"type"];
    updateInfo.app_file = [dic objectForKey:@"app_file"];
    updateInfo.desc = [dic objectForKey:@"desc"];
    updateInfo.file_md5 = [dic objectForKey:@"file_md5"];
    updateInfo.plist1 = [dic objectForKey:@"plist_1"];
    updateInfo.plist2 = [dic objectForKey:@"plist_2"];
    return updateInfo;
}

@end

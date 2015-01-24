//
//  NT_BaseAppDetailInfo.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_BaseAppDetailInfo.h"
#import "NT_AppDetailInfo.h"

@implementation NT_DevGameInfo
+ (NT_DevGameInfo *)devGameInfoFrom:(NSDictionary *)dic
{
    NT_DevGameInfo *info = [[NT_DevGameInfo alloc] init];
    //info.apple_id = [dic objectForKey:@"apple_id"];
    info.apple_id = [dic objectForKey:@"app_id"];
    info.game_name = [dic objectForKey:@"game_name"];
    info.infoId = [dic objectForKey:@"id"];
    info.round_pic = [dic objectForKey:@"round_pic"];
    return info;
}

+ (NT_DevGameInfo *)devGameInfoInSearchFrom:(NSDictionary *)dic
{
    NT_DevGameInfo *info = [[NT_DevGameInfo alloc] init];
    info.game_name = [dic objectForKey:@"game_name"];
    info.infoId = [dic objectForKey:@"id"];
    info.round_pic = [dic objectForKey:@"round_pic"];
    return info;
}

@end

@implementation NT_DevGame
+ (NT_DevGame *)devGameFromDic:(NSMutableDictionary *)dic
{
    NT_DevGame *info = [[NT_DevGame alloc] init];
    info.devArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[dic allKeys] count]; i++) {
        
        NSString *key = [[dic allKeys] objectAtIndex:i];
        NT_DevGameInfo *gameInfo = [NT_DevGameInfo devGameInfoFrom:[dic objectForKey:key]];
        [info.devArray addObject:gameInfo];
    }
    return info;
}

@end

@implementation NT_GameInfo

+ (NT_GameInfo *)gameInfoFromDic:(NSDictionary *)dic
{
    NT_GameInfo *info = [[NT_GameInfo alloc] init];
    info.admin_avatar = [dic objectForKey:@"admin_avatar"];
    //info.app_version_name = [dic objectForKey:@"app_version_name"];
    NSString *versionName = [dic objectForKey:@"app_version_name"];
    if (versionName.length >= 6)
    {
        versionName = [versionName substringToIndex:6];
    }
    info.app_version_name = versionName;
    info.comment = [dic objectForKey:@"comment"];
    info.app_id = [dic objectForKey:@"app_id"];
    info.dev = [dic objectForKey:@"dev"];
    info.devName = [dic objectForKey:@"devName"];
    info.game_name = [dic objectForKey:@"game_name"];
    info.is_much_money = [dic objectForKey:@"is_much_money"];
    info.pic_all = [dic objectForKey:@"pic_all"];
    info.rec_desc = [[dic objectForKey:@"rec_desc"] nullTonil];
    info.package = [[dic objectForKey:@"package"] nullTonil];
    info.round_pic = [dic objectForKey:@"round_pic"];
    float score =  [[dic objectForKey:@"score"] floatValue];
    info.score =[NSString stringWithFormat:@"%.1f",score];
    info.size = [dic objectForKey:@"size"];
    info.size = NSStringFromSize([info.size doubleValue]);
    info.summary = [dic objectForKey:@"description"] ;
    //长简介
    /*
    NSString *desc = [[dic objectForKey:@"description"] stringByConvertingHTMLToPlainText];
    NSLog(@"description:%@",[dic objectForKey:@"description"]);
    info.summary = desc;
    NSLog(@"summary:%@",info.summary);
     */
    
    if (info.summary==nil)
    {
        info.summary = [dic objectForKey:@"summary"];
        info.summary = [NSString stringWithFormat:@"应用简介：%@",info.summary];
    }
    //info.jre = [[dic objectForKey:@"jre"] nullTonil]==nil?@"":[dic objectForKey:@"jre"];
    
    //截取兼容字段 最低版本号
    NSString *jre = [[dic objectForKey:@"jre"] nullTonil]==nil?@"":[dic objectForKey:@"jre"];
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
            //info.minVersion = [ver floatValue] > 0 ? [ver floatValue] : 5.0;
        }
    }
    
    info.lang = [[dic objectForKey:@"lang"] nullTonil] == nil?@"":[dic objectForKey:@"lang"];
    info.category_id = [[dic objectForKey:@"category_id"] nullTonil] == nil?@"":[dic objectForKey:@"category_id"];
    info.categoryName = [[dic objectForKey:@"categoryName"] nullTonil] == nil?@"":[dic objectForKey:@"categoryName"];
    info.update_date = [[dic objectForKey:@"update_date"] nullTonil];
    
    if ([[dic objectForKey:@"download_addr"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [[dic objectForKey:@"download_addr"] nullTonil];
        info.downloadArray = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (int i = 0; i < [arr count]; i++) {
            NT_DownloadAddInfo *downloadAddInfo = [NT_DownloadAddInfo inforFromDetailDic:[arr objectAtIndex:i]];
            [info.downloadArray addObject:downloadAddInfo];
        }
    }
    return info;
}

- (NSArray *)screenShotUrlArray
{
    if ([self.pic_all nullTonil]) {
        NSArray *arr = nil;
        if (self.pic_all.length > 0) {
            arr = [self.pic_all componentsSeparatedByString:@","];
        }
        return arr;
    }
    return nil;
}
- (NSString *)updateTimeAndVersionString
{
    if (self.update_date!= nil)
    {
        return [NSString stringWithFormat:@"更新:%@  版本:%@",[self.update_date substringToIndex:10],self.app_version_name];
    }
    
    return nil;
}
@end

@implementation NT_BaseAppDetailInfo

+ (NT_BaseAppDetailInfo *)appDetailInfoFrom:(NSDictionary *)dic
{
    NT_BaseAppDetailInfo *info = [[NT_BaseAppDetailInfo alloc] init];
    NSMutableArray *arr = [[dic objectForKey:@"devGame"] nullTonil];
    if (arr!=nil) {
        
        
        info.devGameArray = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        
        for (int i = 0; i < [arr count]; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            NT_DevGameInfo *devGameInfo = [NT_DevGameInfo devGameInfoFrom:dic];
            [info.devGameArray addObject:devGameInfo];
        }

    }
    info.gameInfo = [NT_GameInfo gameInfoFromDic:[dic objectForKey:@"gameInfo"]];
    return info;
    
}

+ (NT_BaseAppDetailInfo *)appDetailInfoInSearchFrom:(NSDictionary *)dic
{
    NT_BaseAppDetailInfo *info = [[NT_BaseAppDetailInfo alloc] init];
    NSMutableArray *arr = [dic objectForKey:@"commend"];
    info.devGameArray = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    for (int i = 0; i < [arr count]; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        NT_DevGameInfo *devGameInfo = [NT_DevGameInfo devGameInfoInSearchFrom:dic];
        [info.devGameArray addObject:devGameInfo];
    }
    return info;
    
}

@end

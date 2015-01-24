//
//  NT_BaseAppDetailInfo.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NT_BaseAppDetailInfo.h"

//开发商信息
@interface NT_DevGameInfo : NSObject

@property (nonatomic,retain) NSString *apple_id,*game_name,*infoId,*round_pic;
+ (NT_DevGameInfo *)devGameInfoFrom:(NSDictionary *)dic;
+ (NT_DevGameInfo *)devGameInfoInSearchFrom:(NSDictionary *)dic;
@end

//开发商其他游戏
@interface NT_DevGame : NSObject

@property (nonatomic,retain) NSMutableArray *devArray;
+ (NT_DevGame *)devGameFromDic:(NSMutableDictionary *)dic;

@end

//游戏信息
@interface NT_GameInfo : NSObject

@property (nonatomic,retain) NSString *admin_avatar,*app_id,*app_version_name,*comment,*dev,*game_name,*package,*jre,*lang,*categoryName,*category_id,
*is_much_money,*pic_all,*rec_desc,*round_pic,*score,*size,*summary,*update_date,*minVersion,*devName;
@property (nonatomic,retain) NSString *aid,*giftname;
@property (nonatomic,retain) NSMutableArray *downloadArray;
//@property (nonatomic,assign) CGFloat minVersion;
+ (NT_GameInfo *)gameInfoFromDic:(NSDictionary *)dic;
- (NSArray *)screenShotUrlArray;
- (NSString *)updateTimeAndVersionString;
@end

//游戏详情
@interface NT_BaseAppDetailInfo : NSObject

@property (nonatomic,strong) NSMutableArray *giftMutArray;
@property (nonatomic,retain) NSMutableArray *devGameArray;
@property (nonatomic,retain) NT_GameInfo *gameInfo;
+ (NT_BaseAppDetailInfo *)appDetailInfoFrom:(NSDictionary *)dic;
+ (NT_BaseAppDetailInfo *)appDetailInfoInSearchFrom:(NSDictionary *)dic;

@end


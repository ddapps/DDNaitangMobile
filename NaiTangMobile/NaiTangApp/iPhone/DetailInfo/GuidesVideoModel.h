//
//  GuidesVideoModel.h
//  NaiTangApp
//
//  Created by 小远子 on 14-3-13.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuidesVideoModel : NSObject

/**
 攻略资料，游戏视频，资料分组等所有字段。
 */
@property (nonatomic,strong) NSString * gameID;
@property (nonatomic,strong) NSString * gameName;
@property (nonatomic,strong) NSString * description;
@property (nonatomic,strong) NSString * Videotitle;
@property (nonatomic,strong) NSString * source;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * pid;
@property (nonatomic,strong) NSString * pubdate;
@property (nonatomic,strong) NSString * link;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * countStr;
@property (nonatomic,strong) NSString * strId;
- (id)initWithDictionary:(NSDictionary *)dictionary;


@end

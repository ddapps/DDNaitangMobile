//
//  NT_DetailCell.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-6.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  详情信息 攻略 视频信息

#import <UIKit/UIKit.h>
#import "NT_DetailInfoView.h"

@class NT_BaseAppDetailInfo,NT_DetailInfoView,NT_GuidesView,NT_VideoView;
@protocol NT_DetailCellDelegate,NT_DetailInfoViewDelegate;

@interface NT_DetailCell : UITableViewCell <UIScrollViewDelegate,NT_DetailInfoViewDelegate>
{
    //NT_DetailInfoView *_detailInfoView;
    NT_GuidesView *_guidesView;
    NT_VideoView *_videoView;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *infoTableView;
@property (nonatomic,strong) UITableView *guidesTableView;
@property (nonatomic,strong) UITableView *videoTableView;
//@property (nonatomic,strong) UIImageView *sliperImageView;
@property (nonatomic,strong) UIView *sliperImageView;

@property (nonatomic,strong) NSArray *otherGameArray,*newsInfoArray;
@property (nonatomic,strong) NT_BaseAppDetailInfo *appDetailInfo;
@property (nonatomic,weak) id detailCellDelegate;
@property (nonatomic,strong) NT_DetailInfoView *detailInfoView;
@property (nonatomic,assign) CGFloat expansionHeight;
@property (nonatomic,assign) BOOL isExpansion;

@property (nonatomic,strong) UITableView * tableView;
@property (assign) NSInteger tableHeight;
@property (nonatomic,strong) NSString * strID;
@property (nonatomic,strong) NSString * imgUrl;
@property (nonatomic,strong) NSString * gameName;
@property (nonatomic,strong) NSString * category_id;
@property (assign) BOOL isTemp;

@property (nonatomic,strong) NSMutableArray * arrayGuides;
@property (nonatomic,strong) NSMutableArray * arrayVideo;
@property (nonatomic,copy) NSString *guidesType;

//滚动视图有几项内容
@property (nonatomic,strong) NSMutableArray *scrollDataArr;

- (void)loadScrollView:(CGFloat)height;
//加载游戏介绍
- (void)loadIntroData:(CGFloat)height;

@end

@protocol NT_DetailCellDelegate <NSObject>

//大家还喜欢的游戏
- (void)getOtherGamesInfo:(NSInteger)appID isOtherGames:(BOOL)flag;

//展开、收起游戏信息高度
- (void)expansionDetailInfoViewDelegate:(CGFloat)height expansion:(BOOL)flag;
//计算资讯 大家还喜欢 是否有数据时显示高度
- (void)loadDefaultDetailHeight:(CGFloat)defaultHeight;

@end

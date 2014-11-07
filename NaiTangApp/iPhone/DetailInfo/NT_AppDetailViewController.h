//
//  NT_AppDetailViewController.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NT_AppDetailInfo.h"
#import "NT_BaseAppInfo.h"
#import "NT_BaseAppDetailInfo.h"
#import <StoreKit/SKStoreProductViewController.h>
#import "NT_DetailInfoView.h"
#import "NT_BaseCell.h"
#import "NT_DetailCell.h"

typedef enum
{
    news = 31,    //资讯
    guides = 28,  //攻略
    video = 19    //视频
}detailType;

@protocol NT_BaseCellDelegate;
@protocol NT_DetailCellDelegate;

@interface NT_AppDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate,NT_BaseCellDelegate,NT_DetailCellDelegate>

@property (nonatomic,strong) NT_AppDetailInfo *infosDetail;
@property (nonatomic,strong) NT_BaseAppDetailInfo *baseDetailInfo;
@property (nonatomic,assign) NSInteger appID;
@property (nonatomic,strong) UIButton *downloadBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isShowGold,isOnlineGame;
@property (nonatomic,strong) UIButton *downloadButton;
@property (nonatomic,assign) BOOL isExpansion;
@property (nonatomic,assign) CGFloat expansionHeight;
@property (nonatomic,assign) CGFloat dataHeight;
@property (nonatomic,strong) UIButton *badgeButton;

//滚动视图 攻略，视频
@property (nonatomic,strong) NSMutableArray *scrollDataArr;
@property (nonatomic,strong) NSMutableArray *guidesMutArr;
@property (nonatomic,copy) NSString *guidesType;
@property (nonatomic,strong) NSMutableArray *videoMutArr;

// 用来表明当前的游戏属于“限免，必备，网游，排行”中的哪一个
@property int typeTag;

//礼包
@property (nonatomic,strong) NSArray *giftArray;

//获取详情信息
- (void)getData:(NSInteger)appID;

@end



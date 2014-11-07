//
//  NT_MainView.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  主页-游戏列表显示

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>
#import "NT_MainView.h"
#import "NT_MainCell.h"
#import "NT_MainSecondCell.h"
#import "EGORefreshTableHeaderView.h"
#import "NT_AdView.h"
#import "SwitchTableView.h"
#import "NT_MacroDefine.h"

#define KRankingViewTag  1212

typedef enum {
    AppListTypeHomeLastest,
    AppListTypeHomeHot,
    AppListTypeTopUp,
    AppListTypeTopHot,
    AppListTypeTopClassical,
    AppListTypeGameOnlineLastest,
    AppListTypeGameOnlineHot,
    AppListTypeDevAppsList,
    APPlistTypeRecommend,
}AppListType;

@protocol NTMainViewDelegate,NT_AdViewDelegate;

@interface NT_MainView : UIView <UITableViewDataSource,UITableViewDelegate,NT_MainCellDelegate,NT_MainSecondCellDelegate,EGORefreshTableHeaderDelegate,SKStoreProductViewControllerDelegate,NT_AdViewDelegate>
{
    int _pageNum;
    int _totalPageNum;
    BOOL _isLoading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _isRefreshing;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int selectedIndex;
@property (nonatomic) AppListType type;
@property (nonatomic,assign)BOOL isOnlineGame;
@property (nonatomic,weak) id <NTMainViewDelegate> delegate;
@property (nonatomic,strong) SwitchTableView *switchTableView;
//底部红色提示高度
@property (nonatomic,assign) CGFloat bottomRedHeight;

- (id)initWithFrame:(CGRect)frame type:(AppListType)type;
//加载数据
- (void)getDataForPage:(int)page;
- (void)getDataFinishedWithDic:(NSDictionary *)dic forPage:(int)page;
- (void)startLoadingMore;
- (void)stopLoadingMore;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
- (void)openAppWithIdentifier:(NSString *)appId;

//进入前台刷新
- (void)refreshdataWithEntryForegroud;
- (void)hideInstallCell:(id)sender;

@end

@protocol NTMainViewDelegate <NSObject>

//push to next viewcontroller
- (void)pushNextViewController:(UIViewController *)nextViewController;
@optional
- (void)presentNextViewController:(UIViewController *)nextViewController;
//present to itunes
- (void)presentToItunes:(NSString *)appleID itunesButton:(UIButton *) btn;

@end

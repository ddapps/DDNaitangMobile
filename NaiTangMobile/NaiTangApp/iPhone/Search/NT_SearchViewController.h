//
//  NT_SearchViewController.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-2.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>
#import "NT_BaseViewController.h"
#import "NT_HotKeyCell.h"
#import "NT_MainCell.h"
#import "NT_MainSecondCell.h"

@interface NT_SearchViewController : NT_BaseViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SKStoreProductViewControllerDelegate,NT_MainCellDelegate,NT_MainSecondCellDelegate,NTHotKeyCellDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *hotKeysTableView;
@property (nonatomic,strong) UITableView *searchResultTableView;
@property (nonatomic,strong) UITableView *searchHistoryTableView;
@property (nonatomic,strong) UITableView *searchNoticeTableView;
@property (nonatomic,strong) UITableView *searchNoDataTableView;

//搜索数据显示
@property (nonatomic,strong) UIView *whiteBgView;
@property (nonatomic,strong) NSString *searchValue;

@property (nonatomic,strong) NSMutableArray *searchHistroyArray;

//搜索总数量
@property (nonatomic,assign) NSInteger searchTotalCount;
@property (nonatomic,assign) BOOL isOnlineGame;


@end

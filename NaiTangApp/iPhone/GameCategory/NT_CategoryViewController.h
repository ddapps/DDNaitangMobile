//
//  NT_CategoryViewController.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-2.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "NT_BaseViewController.h"
#import "SwitchTableView.h"
#import "NT_CategoryBaseCell.h"

@interface NT_CategoryViewController : NT_BaseViewController  <EGORefreshTableHeaderDelegate,NT_CategoryCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isLoading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _isRefreshing;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *categoryArray;
@property (nonatomic,strong) SwitchTableView *switchTableView;
@property (nonatomic,strong) UITableView *tableView;

@end

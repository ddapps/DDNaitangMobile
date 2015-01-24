//
//  NT_DownloadingTableView.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-9.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  下载中

#import <UIKit/UIKit.h>
#import "NT_DownloadManager.h"
#import "NT_HeaderView.h"

@class NT_HeaderCell;

@interface NT_DownloadingTableView : UITableView <UITableViewDataSource,UITableViewDelegate,NT_DownLoadManagerDelegate>

@property (nonatomic,strong) NT_HeaderCell *headerCell;

@end

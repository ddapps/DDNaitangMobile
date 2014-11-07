//
//  NT_HeaderCell.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-9.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  下载管理-表头

#import <UIKit/UIKit.h>

@class UIProgressBar;

@interface NT_HeaderCell : UITableViewCell

@property (nonatomic,strong) UILabel *usedLabel;
@property (nonatomic,strong) UILabel *unUsedLabel;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *allStartButton;
@property (nonatomic,strong) UIProgressBar *progressView;

@end

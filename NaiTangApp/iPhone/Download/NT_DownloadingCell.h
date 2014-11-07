//
//  NT_DownloadingCell.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-9.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  下载中列

#import <UIKit/UIKit.h>
#import "UIProgressBar.h"
#import "NT_DownloadModel.h"
#import "NT_BaseDownloadCell.h"
#import "NT_CustomButtonStyle.h"

#define KDownloadButtonTag  12113

@protocol NT_DownloadLackOfSpaceDelegate;

@interface NT_DownloadingCell : NT_BaseDownloadCell

@property (nonatomic,strong) UIProgressBar *progressView;
//下载状态，大小，速度
@property (nonatomic,strong) UILabel *statusLabel,*sizeLabel,*speedLabel,*showLabel;
@property (nonatomic,strong) NT_DownloadModel *model;
@property (nonatomic,strong) UIButton *downloadStautsButton;
@property (nonatomic,strong) NT_CustomButtonStyle *customButtonStyle;
@property (nonatomic,weak) id <NT_DownloadLackOfSpaceDelegate> spaceDelegate;

@property (nonatomic,assign) uint64_t modelID;

- (void)refreshDataWith:(NT_DownloadModel *)model;

@end

//空间不足提示 委托
@protocol NT_DownloadLackOfSpaceDelegate <NSObject>

- (void)refreshLackOfSpaceDelegate;

@end


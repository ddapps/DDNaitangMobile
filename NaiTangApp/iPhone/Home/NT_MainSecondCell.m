//
//  NT_MainSecondCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_MainSecondCell.h"

#define KNormalDisplayHeight 45
#define KNolimitGoldDisplayHeight 68

@implementation NT_MainSecondCell
{
    UIImageView *_backImage;
}

@synthesize delegates = _delegates;
@synthesize appsInfoDetail = _appsInfoDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.alpha = 1.0;
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNormalDisplayHeight)];
        _backImage.image = [UIImage imageNamed:@"rectangle.png"];
        _backImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_backImage];
    }
    return self;
}

//Cell弹出框的高度
+ (float)heightForAppsInfoDetail:(NT_AppDetailInfo *)info
{
    for (NT_DownloadAddInfo *downloadInfo in info.downloadArray)
    {
        NSLog(@"download type:%d",downloadInfo.downloadType);
        
        if (downloadInfo.downloadType == ([[UIDevice currentDevice] isJailbroken]?DownloadTypeNolimitGold:NOBreakDownloadTypeNolimitGold)) {
            return KNolimitGoldDisplayHeight;
        }
    }
    return KNormalDisplayHeight;
}

//加载无限金币版
- (void)loadViewForUnlimitGold
{
    [_backImage removeAllSubViews];
    _backImage.height = KNormalDisplayHeight;
    /*很重要的 点击按钮背景，收起无限金币框
    UIButton *btn = [[UIButton alloc] initWithFrame:_backImage.bounds];
    [btn addTarget:self action:@selector(gotoAppDownLoad:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 10;
    [_backImage addSubview:btn];
    */
    NSArray *downloadArray = self.appsInfoDetail.downloadArray;
    int count = downloadArray.count;
    if (count < 2) {
        return;
    }
    count = MIN(2, count);
    
    float startX = 5;
    float eachWidth = (_backImage.width - startX * 2) / count;
    for (int i = 0; i < count; i++) {
        NT_DownloadAddInfo *info = [downloadArray objectAtIndex:i];
        NSString *bgImageName = @"";
        NSString *bgImageName_hl = @"";
        switch (info.downloadType) {
            case DownloadTypeAppStore:
                bgImageName = @"btn-green.png";
                bgImageName_hl = @"btn-green-hover.png";
                break;
            case DownloadTypeNormalIpa:
                bgImageName = @"btn-green.png";
                bgImageName_hl = @"btn-green-hover.png";
                break;
            case DownloadTypeNolimitGold:
                bgImageName = @"btn-orange.png";
                bgImageName_hl = @"btn-orange-hover.png";
                break;
            case NOBreakDownloadTypeNolimitGold:
                bgImageName = @"btn-orange.png";
                bgImageName_hl = @"btn-orange-hover.png";
                break;
            default:
                break;
        }
        UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 13, 140, 25) title:info.version_name bgImage:[UIImage imageNamed:bgImageName] titleColor:[UIColor whiteColor] target:self action:@selector(gotoAppDownLoad:)];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        button.tag = i;
        [button setBackgroundImage:[UIImage imageNamed:bgImageName_hl] forState:UIControlStateHighlighted];
        [_backImage addSubview:button];
        button.right = _backImage.width - (eachWidth/2 - button.width/2) - eachWidth * i - startX;
    
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 140, 38)];
        control.right = _backImage.width - (eachWidth/2 - button.width/2) - eachWidth * i - startX;
        control.tag = i;
        [control addTarget:self action:@selector(gotoAppDownLoad:) forControlEvents:UIControlEventTouchUpInside];
        [_backImage addSubview:control];
        
        if (info.downloadType == ([[UIDevice currentDevice] isJailbroken]?DownloadTypeNolimitGold:NOBreakDownloadTypeNolimitGold)) {
            UIImageView *explanation = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44, _backImage.width - 20, 20)];
            explanation.backgroundColor = [UIColor blackColor];
            [_backImage addSubview:explanation];
            
            UIImageView *arrowImageView = [UIImageView imageViewWithFrame:CGRectMake(button.center.x - 5,  explanation.top - 5, 10, 5) andImage:[UIImage imageNamed:@"arrow.png"]];
           

            [_backImage addSubview:arrowImageView];
            
            UILabel *text = [[UILabel alloc] initWithFrame:CGRectInset(explanation.bounds, 5, 2)];
            text.backgroundColor = [UIColor clearColor];
            text.text = [info.archives_name length] ? info.archives_name : @"全通关存档，顶级武器至尊剑......";
            text.textColor = [UIColor whiteColor];
            text.font = [UIFont systemFontOfSize:10];
            text.adjustsFontSizeToFitWidth = YES;
            text.minimumFontSize = 10;
            [explanation addSubview:text];
            _backImage.height = KNolimitGoldDisplayHeight;
        }
    }
}

- (void)formatWithAppsInfoDetail:(NT_AppDetailInfo *)info
{
    self.appsInfoDetail = info;
    [self loadViewForUnlimitGold];
}

//游戏下载
- (void)gotoAppDownLoad:(UIButton *)sender
{
    if (self.delegates && [self.delegates respondsToSelector:@selector(installSecondCell:installIndex:)]) {
        [self.delegates installSecondCell:self installIndex:sender.tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.delegates = nil;
    self.appsInfoDetail = nil;
}

@end

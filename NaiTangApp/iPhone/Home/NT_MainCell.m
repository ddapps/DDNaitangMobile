//
//  NT_MainCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_MainCell.h"
#import "NT_BaseView.h"
#import "NT_AppDetailInfo.h"
#import "UIButton+WebCache.h"
#import "NT_WifiBrowseImage.h"

@implementation NT_MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.alpha = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        //列表样式
        NT_BaseView *backView = [[NT_BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 71)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconPressed:)];
        [backView.appIcon addGestureRecognizer:tap];
        //[backView.appIcon addTarget:self action:@selector(iconPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backView.button addTarget:self action:@selector(installBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        backView.appIcon.tag = 10;
        backView.tag = 1;
        backView.button.tag = 1;
        backView.hidden = YES;
        [self.contentView addSubview:backView];

        /*
        //加大按钮点击区域
        UIControl *contol = [[UIControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(66), 6, 80, 60)];
        contol.tag = 1;
        [contol addTarget:self action:@selector(installBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:contol];
        */
        
        //分割线，若滑动时显示分割线，需要cell高度-1，不然往上滑动时，无分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, backView.bottom-0.5, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
        [self.contentView addSubview:view];
        
        /*
        //_line = [[UIImageView alloc] initWithFrame:CGRectMake(270, 73, 10, 6)];
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 16)];
        _line.hidden = YES;
        [self.contentView addSubview:_line];
         */
    }
    return self;
}

- (void)formatWithDataArray:(NSArray *)dataArray indexPath:(NSIndexPath *)indexPath selectedIndex:(int)index
{
    self.indexParh = indexPath;
    
    int section = indexPath.section;

    /*
    if (index >=0&&index==section)
    {
        _line.hidden = NO;
        _line.image = [UIImage imageNamed:@"arrowRight.png"];
    }
    else
    {
        _line.hidden = YES;
    }
    */
    NT_BaseView *backImage = (NT_BaseView *)[self.contentView viewWithTag:1];
    
    //正确的状态显示
    [backImage.button setTitle:@"免费下载" forState:UIControlStateNormal];
    NT_AppDetailInfo *detailInfo = nil;
    if (self.tag == KSearchCellTag)
    {
        section = indexPath.section-1;
    }
    detailInfo = [dataArray objectAtIndex:section];
    
    backImage.hidden = NO;
    //    NSURL *url = [NSURL URLWithString:detailInfo.round_pic];
    
    //  设置-打开或关闭wifi下浏览图片通用方法
    NT_WifiBrowseImage *wifiImage = [[NT_WifiBrowseImage alloc] init];
    [wifiImage wifiBrowseImage:backImage.appIcon urlString:detailInfo.round_pic];
    /*
    // 检测当前是否WIFI网络环境
    BOOL isConnectedProperly =[[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==ReachableViaWiFi;
    //是否是2G/3G网络
    BOOL isWWAN = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==ReachableViaWWAN;
    //无网络
    BOOL notReach = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable;
    NSString * netStatus;
    //    NSString * placeHoldImgSrc;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //若关闭"只在wifi下加载图片"，则3G、wifi都可以加载图片
    if ([[userDefaults objectForKey:@"BigPicLoad"] isEqualToString:@"close"])
    {
        //3g或wifif连接
        if (!notReach)
        {
            netStatus = @"true";
            //            placeHoldImgSrc = detailInfo.round_pic;
            [backImage.appIcon setImageURL:[NSURL URLWithString:detailInfo.round_pic]];
        }
    }
    else
    {
        //打开只在wifi下加载图片
        //若使用的是3G，就不加载图片
        if (isWWAN)
        {
            netStatus = @"false";
            //            placeHoldImgSrc = detailInfo.round_pic;
            [backImage.appIcon imageUrl:[NSURL URLWithString:detailInfo.round_pic] tempSTR:netStatus];
        }
        else if (isConnectedProperly)
        {
            //若使用的是wifi，则加载图片
            netStatus = @"true";
            //            placeHoldImgSrc = detailInfo.round_pic;
            [backImage.appIcon setImageURL:[NSURL URLWithString:detailInfo.round_pic]];
        }

    }
    */
   
    backImage.appName.text = detailInfo.game_name;
    backImage.appType.text = [NSString stringWithFormat:@"%@  |  %@",detailInfo.categoryName,detailInfo.size];
    backImage.scoreLabel.text = [NSString stringWithFormat:@"评分 %@",detailInfo.score];
    //backImage.appSize.text = [NSString stringWithFormat:@"%@",detailInfo.size];
    if ([detailInfo.is_much_money intValue] == 0) {
        backImage.goldSign.hidden= YES;
    }
    else
    {
        backImage.goldSign.hidden = NO;
    }
     
}

//点击整个图标
- (void)iconPressed:(UIButton *)sender
{
    if (self.delegates && [self.delegates respondsToSelector:@selector(tableViewCell:didSelectSecondModel:)]) {
        [self.delegates tableViewCell:self didSelectSecondModel:sender.tag];
    }
}
//点击安装按钮
- (void)installBtnPressed:(UIButton *)sender
{
    NT_BaseView *imageView = (NT_BaseView *)[self.contentView viewWithTag:1];
    if([imageView.button.titleLabel.text isEqualToString:@"下载中"]){
        return;
    }
    sender.tag = 1;
    int tag = sender.tag;
    if (self.delegates && [self.delegates respondsToSelector:@selector(tableViewCell:shouldOpenSecondModel:)])
    {
        [self.delegates tableViewCell:self shouldOpenSecondModel:tag];
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
   self.indexParh = nil;
}

@end

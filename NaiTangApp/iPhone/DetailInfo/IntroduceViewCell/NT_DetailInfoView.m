//
//  NT_DetailInfoView.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-7.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_DetailInfoView.h"
#import "NT_DetailImageView.h"
#import "NT_DetailIntroView.h"
#import "NT_DetailNewsView.h"
#import "NT_DetailOtherGamesView.h"

@interface NT_DetailInfoView()
{
    CGFloat heightOfDetail;
}

@end

@implementation NT_DetailInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//加载所有详情,游戏介绍高度，是否展开
- (void)loadAllView:(CGFloat)height isExpansion:(BOOL)flag
{
    //[_detailScrollView removeAllSubviews];
    
    //移除所有子类，否则将会重复添加
    [self removeAllSubViews];
    
    //图片展示
    _detailImageView = [[NT_DetailImageView alloc] initWithFrame:CGRectMake(10, 14, SCREEN_WIDTH-20, KImageCellHeight)];
    [self addSubview:_detailImageView];
    
   
    //游戏信息
    _introView = [[NT_DetailIntroView alloc] initWithFrame:CGRectMake(0,  _detailImageView.bottom, SCREEN_WIDTH,KIntroCellHeight)];
    _introView.delegate = self;
    [self addSubview:_introView];
  
    if (self.newsInfoArray.count > 0 && self.otherGameArray.count > 0)
    {
        //游戏资讯
        _newsView = [[NT_DetailNewsView alloc] initWithFrame:CGRectMake(0, _introView.bottom, SCREEN_WIDTH, 40+self.newsInfoArray.count*40)];
        [self addSubview:_newsView];
        
        //相关游戏
        _otherGamesView = [[NT_DetailOtherGamesView alloc] initWithFrame:CGRectMake(0, _newsView.bottom, SCREEN_WIDTH, KOtherGameCellHeight)];
        _otherGamesView.otherGamesViewDelegate = self;
        [self addSubview:_otherGamesView];
        
    }
    else if (self.newsInfoArray.count > 0 && self.otherGameArray.count == 0)
    {
        //游戏资讯
        _newsView = [[NT_DetailNewsView alloc] initWithFrame:CGRectMake(0, _introView.bottom, SCREEN_WIDTH, 40+self.newsInfoArray.count*40)];
        [self addSubview:_newsView];

    }
    else if (self.newsInfoArray.count == 0 && self.otherGameArray.count > 0)
    {
        //相关游戏
        _otherGamesView = [[NT_DetailOtherGamesView alloc] initWithFrame:CGRectMake(0, _introView.bottom, SCREEN_WIDTH, KOtherGameCellHeight)];
        _otherGamesView.otherGamesViewDelegate = self;
        [self addSubview:_otherGamesView];
        
    }
    
    if (flag && height)
    {
        //获取展开后信息高度
        self.introView.height = self.introView.height + height;
        //有资讯 有大家还喜欢
        if (self.newsInfoArray.count > 0 && self.otherGameArray.count > 0)
        {
            self.newsView.top = self.introView.bottom;
            self.otherGamesView.top = self.newsView.bottom;
        }
        else if (self.newsInfoArray.count > 0 && self.otherGameArray.count ==0)
        {
            self.newsView.top = self.introView.bottom;
        }
        else if (self.newsInfoArray.count == 0 && self.otherGameArray.count > 0)
        {
            self.otherGamesView.top = self.introView.bottom;
        }
    }
}

//图片展示
- (void)loadDetailImage:(NT_BaseAppDetailInfo *)info
{
    self.detailInfo = info;
    [self.detailImageView refreshWithAppInfo:self.detailInfo];
}

//游戏介绍信息
- (void)loadDetailInfo:(NT_BaseAppDetailInfo *)info isExpansion:(BOOL)flag
{
    self.detailInfo = info;
    [self.introView refreshIntroData:info isExpansion:flag];
}


//相关游戏展示
- (void)loadOtherGames:(NSArray *)otherGamesArray
{
    [self.otherGamesView refreshWithAppInfo:self.otherGameArray];
}



//资讯信息
- (void)loadNewsInfo:(NSArray *)newsArray
{
    self.newsView.newsArray = newsArray;
    [self.newsView refreshNewsInfo:newsArray];
}

//根据游戏id，获取详情信息
- (void)getOtherGamesInfo:(NSInteger)appID isOtherGames:(BOOL)flag;
{
    if (self.detailInfoViewDelegate&&[self.detailInfoViewDelegate respondsToSelector:@selector(getOtherGamesInfo:isOtherGames:)])
    {
        [self.detailInfoViewDelegate getOtherGamesInfo:appID isOtherGames:YES];
    }
}

//展开、收起介绍高度
- (void)expansionDetailInfoViewDelegate:(CGFloat)height expansion:(BOOL)flag
{
    CGFloat expansionHeight = 0;
    if (flag)
    {
        //展开高度
        expansionHeight = self.allHeight - 60 + height;
         //_detailScrollView.contentSize = CGSizeMake(0, expansionHeight);
    }
    else
    {
        expansionHeight = self.allHeight;
        //_detailScrollView.contentSize = CGSizeMake(0, self.allHeight);
    }
    
    if (self.detailInfoViewDelegate&&[self.detailInfoViewDelegate respondsToSelector:@selector(expansionDetailInfoViewDelegate:expansion:)])
    {
        [self.detailInfoViewDelegate expansionDetailInfoViewDelegate:expansionHeight expansion:flag];
    }
}

- (CGFloat)calcuHeightForSecondCell
{
    CGFloat contentHeight = 0.0f;
    /*
     //计算资讯 大家还喜欢 是否有数据时显示高度
     if (self.detailInfoViewDelegate && [self.detailInfoViewDelegate respondsToSelector:@selector(loadDefaultDetailHeight:)])
     {
     [self.detailInfoViewDelegate loadDefaultDetailHeight:height+self.detailScrollView.height];
     }
     */
    contentHeight += self.detailImageView.frame.size.height;
    contentHeight += self.introView.frame.size.height;
//    contentHeight += heightOfDetail;
    
    NSLog(@"introl size total %f",heightOfDetail);
    self.introView.height = heightOfDetail;
    
    if (self.newsInfoArray.count > 0 && self.otherGameArray.count > 0)
    {
        contentHeight += self.newsView.frame.size.height;
        contentHeight += self.otherGamesView.frame.size.height;
        self.newsView.top = self.introView.bottom;
    }
    else if (self.newsInfoArray.count > 0 && self.otherGameArray.count == 0)
    {
        contentHeight += self.newsView.frame.size.height;
    }
    else if (self.newsInfoArray.count == 0 && self.otherGameArray.count > 0)
    {
        contentHeight += self.otherGamesView.size.height;
    }
    else
    {
        //            self.detailScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+self.detailScrollView.height);
        
        //self.detailScrollView.frame = CGRectMake(0, 0, 320, height+self.height);
        
        
    }

    return contentHeight;
}

@end

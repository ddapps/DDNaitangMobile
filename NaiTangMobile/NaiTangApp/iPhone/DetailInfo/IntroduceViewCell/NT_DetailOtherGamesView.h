//
//  NT_DetailOtherGamesView.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-7.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  详情-相关游戏

#import <UIKit/UIKit.h>

#define KOtherGameCellHeight 130

@class NT_CustomPageControl;
@protocol NT_DetailOtherGamesViewDelegate;

@interface NT_DetailOtherGamesView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NT_CustomPageControl *pageControl;
@property (nonatomic,weak) id<NT_DetailOtherGamesViewDelegate> otherGamesViewDelegate;
@property (nonatomic,strong) NSArray *otherGameArray;

//相关游戏信息
- (void)refreshWithAppInfo:(NSArray *)otherGames;

@end

//获取相关游戏详情信息
@protocol NT_DetailOtherGamesViewDelegate <NSObject>

- (void)getOtherGamesInfo:(NSInteger)appID isOtherGames:(BOOL)flag;

@end

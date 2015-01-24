//
//  NT_DetailNewsView.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-7.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  详情-游戏资讯

#import <UIKit/UIKit.h>

#define KNewsCellHeight 140

@interface NT_DetailNewsView : UIView 

@property (nonatomic,strong) NSArray *newsArray;
//@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *newsView;
@property (nonatomic,assign) BOOL newsFlag;
@property (nonatomic,assign) int newsHeight;
//@property (nonatomic,strong) UILabel *newsLabel;
//资讯信息
- (void)refreshNewsInfo:(NSArray *)newsArray;

@end

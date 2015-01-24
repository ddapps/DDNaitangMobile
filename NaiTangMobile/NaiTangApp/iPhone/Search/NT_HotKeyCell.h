//
//  NT_HotKeyCell.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-6.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  搜索-搜索热词

#import <UIKit/UIKit.h>

@protocol NTHotKeyCellDelegate;

@interface NT_HotKeyCell : UITableViewCell

@property (nonatomic,strong) NSArray *hotKeysArray;
@property (nonatomic,assign) CGFloat hotKeyX;
@property (nonatomic,assign) CGFloat hotKeyY;
//未换行的坐标x
@property (nonatomic,assign) CGFloat positonX;
@property (nonatomic,assign) NSInteger rowCount;
@property (nonatomic,assign) NSInteger hotKeyCount;
@property (nonatomic,strong) NSArray *nextHotKeyArray;
@property (nonatomic,assign) NSInteger changeClickCount;

//图片
@property (nonatomic,strong) NSArray *imageArray;
//一行有多少个按钮
@property (nonatomic,assign) NSInteger rowCountWithImage;
//图片下标
@property (nonatomic,assign) NSInteger imageIndex;

@property (nonatomic,weak) id<NTHotKeyCellDelegate> delegate;

//获取热词
- (void)getHotKeyArray:(NSArray *)keywordArray;
//换一组按钮点击次数
- (void)changeHotKey:(int)changeButtonClickCount;

@end

@protocol NTHotKeyCellDelegate <NSObject>

- (void)searchWithHotKey:(NSString *)hotKey;

@end
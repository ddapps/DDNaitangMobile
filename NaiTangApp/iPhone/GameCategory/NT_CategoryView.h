//
//  NT_CategoryView.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NT_HttpEngine.h"
#import "NT_MainView.h"

@interface NT_CategoryView : NT_MainView

@property (nonatomic) int categoryId;
@property (nonatomic) SortType sortType;
@property (nonatomic,assign)id target;
@property (nonatomic,strong) NSString *categoryType;
@property (nonatomic,weak) id <NTMainViewDelegate> delegate;

@property (nonatomic,assign) int linkType;
@property (nonatomic,assign) int linkId;

//底部红色框高度
@property (nonatomic,assign) CGFloat bottomRedHeight;

- (id)initWithFrame:(CGRect)frame linkId:(int)linkId linkType:(int)linkType isOnline:(BOOL)isOnline sortType:(SortType)sortType;

- (id)initWithFrame:(CGRect)frame categoryType:(NSString *)categoryType  categoryId:(int)categoryId isOnlineGame:(BOOL)isOnline;
- (id)initWithFrame:(CGRect)frame categoryType:(NSString *)categoryType categoryId:(int)categoryId sortType:(SortType)sortType isOnlineGame:(BOOL)isOnline;

@end

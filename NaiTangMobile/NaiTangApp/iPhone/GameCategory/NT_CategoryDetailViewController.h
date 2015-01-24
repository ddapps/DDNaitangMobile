//
//  NT_CategoryDetailViewController.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NT_BaseViewController.h"

@interface NT_CategoryDetailViewController : NT_BaseViewController <UIScrollViewDelegate,NTMainViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,assign) int categoryID;
@property (nonatomic,strong) NSString *categoryType;

@property (nonatomic,assign) BOOL isOnlineGame;
@property (nonatomic,assign) int sortType;
@property (nonatomic,assign) NSInteger linkType;
@property (nonatomic,assign) NSInteger linkID;

@end

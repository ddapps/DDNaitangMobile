//
//  NT_MainCell.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  主页-自定义列表的列显示

#import <UIKit/UIKit.h>

#define  KSearchCellTag  131445

@protocol NT_MainCellDelegate;
typedef enum
{
    secondModelLeft = 1,
    secondModelMiddle,
    secondModelRight,
    
}secondModel;

@interface NT_MainCell : UITableViewCell
{
    //UIImageView *_line;
    UIView *_line;
}

@property (weak,nonatomic) id<NT_MainCellDelegate> delegates;
@property (strong,nonatomic)  NSIndexPath *indexParh;

- (void)formatWithDataArray:(NSArray *)dataArray indexPath:(NSIndexPath *)indexPath selectedIndex:(int)index;

@end


//协议
@protocol NT_MainCellDelegate <NSObject>

//打开无限金币弹出框
- (BOOL)tableViewCell:(NT_MainCell *)tableViewCell shouldOpenSecondModel:(secondModel)model;
- (void)tableViewCell:(NT_MainCell *)tableViewCell didSelectSecondModel:(secondModel)model;
@end
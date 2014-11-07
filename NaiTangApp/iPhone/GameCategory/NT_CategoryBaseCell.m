//
//  NT_CategoryBaseCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-28.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_CategoryBaseCell.h"
#import "UIImageView+WebCache.h"
#import "NT_CategoryBaseView.h"

@implementation NT_CategoryBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        for (int i = 0; i < 2; i++)
        {
            float width = 152;
            NT_CategoryBaseView *categoryBaseView = [[NT_CategoryBaseView alloc] initWithFrame:CGRectMake(5 + (width + 5) * i,5, width, 70)];
            
            //categoryBaseView.iconButton.tag = 1 + i;
            [categoryBaseView.iconButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            //分类视图tag
            categoryBaseView.tag = i + 1;
            [self.contentView addSubview:categoryBaseView];
        }
    }
    return self;
}

- (void)formatWithDataArray:(NSArray *)dataArray indexPath:(NSIndexPath *)indexPath selectedIndex:(int)index
{
    int row = indexPath.row;
    for (int i = row * 2; i < row * 2 + 2; i++)
    {
        NT_CategoryBaseView *baseView = (NT_CategoryBaseView *)[self.contentView viewWithTag:1+i%2];
        baseView.iconButton.tag = i+1;
        if (i < [dataArray count])
        {
            NT_CategoryInfo *categoryInfo = [dataArray objectAtIndex:i];
            baseView.categoryNameLabel.text = categoryInfo.title;
            baseView.categoryCountLabel.text = categoryInfo.gameCount;
            baseView.categoryTypeLabel.text = categoryInfo.subtitle;
            [baseView.categoryImageView setImageWithURL:[NSURL URLWithString:categoryInfo.pic] placeholderImage:[UIImage imageNamed:@"default-icon.png"]];
        }
        
    }

}

- (void)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag -1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryCellSelectedIndex:)])
    {
        [self.delegate categoryCellSelectedIndex:tag];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

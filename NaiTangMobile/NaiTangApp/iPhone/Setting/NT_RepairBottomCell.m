//
//  NT_RepairBottomCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-4-14.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_RepairBottomCell.h"

@implementation NT_RepairBottomCell

@synthesize repairedButton;
@synthesize unrepairedButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        repairedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        repairedButton.frame = CGRectMake(42, 15, 240, 35);
        repairedButton.tag = 456;
        [repairedButton setBackgroundImage:[UIImage imageNamed:@"border-blue@2x.png"] forState:UIControlStateNormal];
        [repairedButton setBackgroundImage:[UIImage imageNamed:@"border-blue-hover@2x.png"] forState:UIControlStateHighlighted];
        [repairedButton setTitle:@"太有用了，搞定了闪退" forState:UIControlStateNormal];
        [repairedButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        repairedButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:repairedButton];
        
        unrepairedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        unrepairedButton.frame = CGRectMake(42, repairedButton.bottom+10, 240, 35);
        unrepairedButton.tag = 457;
        [unrepairedButton setBackgroundImage:[UIImage imageNamed:@"border-gray@2x.png"] forState:UIControlStateNormal];
        [unrepairedButton setBackgroundImage:[UIImage imageNamed:@"border-gray-hover@2x.png"] forState:UIControlStateHighlighted];
        [unrepairedButton setTitle:@"不行啊，教程不给力啊" forState:UIControlStateNormal];
        [unrepairedButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        unrepairedButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:unrepairedButton];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

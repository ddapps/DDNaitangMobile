//
//  NT_RepairFirstCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-4-14.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_RepairFirstCell.h"
#import "NT_MacroDefine.h"

@implementation NT_RepairFirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 100, 20)];
        lab1.text = @"如您打开游戏";
        lab1.font = [UIFont systemFontOfSize:16];
        lab1.textColor = Text_Color_Setting_Gray;
        [self.contentView addSubview:lab1];
        
        UILabel *lab1Red = [[UILabel alloc] initWithFrame:CGRectMake(lab1.right-5, 16, 100, 20)];
        lab1Red.textColor = [UIColor colorWithHex:@"#ff4f4f"];
        lab1Red.font = [UIFont systemFontOfSize:16];
        lab1Red.text = @"出现闪退";
        [self.contentView addSubview:lab1Red];
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(lab1.left, lab1.bottom+5, 80, 20)];
        lab2.text = @"或打开游戏";
        lab2.textColor = Text_Color_Setting_Gray;
        lab2.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lab2];
        
        UILabel *lab2Red = [[UILabel alloc] initWithFrame:CGRectMake(lab2.right, lab2.top, 260, 20)];
        lab2Red.textColor = [UIColor colorWithHex:@"#ff4f4f"];
        lab2Red.text = @"出现弹出需要输入账号密码，";
        lab2Red.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lab2Red];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(lab2.left, lab2.bottom+5, 40, 20)];
        lab3.text = @"如图:";
        lab3.textColor = Text_Color_Setting_Gray;
        lab3.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lab3];
        
        //修复图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(lab3.right, lab3.bottom+5, 209, 127)];
        imageView.image = [UIImage imageNamed:@"repair@2x.png"];
        [self.contentView addSubview:imageView];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(lab3.left, imageView.bottom+5, 300, 20)];
        lab4.textColor = Text_Color_Setting_Gray;
        lab4.text = @"请您按照以下方法即可解决:";
        lab4.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lab4];
        
        //虚线
        UIImageView *dashedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lab4.left, lab4.bottom+5, 280, 3)];
        dashedImageView.image = [UIImage imageNamed:@"setting-dashed@2x.png"];
        [self.contentView addSubview:dashedImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

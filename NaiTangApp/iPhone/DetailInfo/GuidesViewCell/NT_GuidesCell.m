//
//  NT_GuidesCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-6.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_GuidesCell.h"

@implementation NT_GuidesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _guidesImageView = [[EGOImageView alloc] init];
        _guidesTitleLabel = [[UILabel alloc] init];
        _countLabel = [[UILabel alloc] init];
        
        if (self.isTemp == YES) {
            _guidesImageView.frame = CGRectMake(10, 5, 60, 50);
            _guidesTitleLabel.frame = CGRectMake(80, 5, SCREEN_WIDTH-50, 20);
            _countLabel.frame = CGRectMake(80, _guidesTitleLabel.bottom, 200, 20);
            
        }else{
            _guidesTitleLabel.frame = CGRectMake(10, 5, self.frame.size.width - 20, 30);
            _countLabel.frame = CGRectMake(10, _guidesTitleLabel.bottom - 5, self.frame.size.width - 20, 20);
        }
        
        //图片
        //        _guidesImageView.image = [UIImage imageNamed:@"icon.png"];
        [self.contentView addSubview:_guidesImageView];
        
        //标题
        _guidesTitleLabel.text = @"怪物大全";
        _guidesTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.contentView addSubview:_guidesTitleLabel];
        
        //攻略数量
        _countLabel.text = @"共12篇";
        _countLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_countLabel];
        
        //分割线
        UIView * lineImg = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + 59, self.frame.size.width, 1)];
        lineImg.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self addSubview:lineImg];
        
    }
    return self;
}

- (void)refreshGuidesInfo:(NSDictionary *)dic
{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [_guidesImageView cancelImageLoad];
    }
}
- (void)setImageURL:(NSString *)imageURL
{
    _guidesImageView.imageURL = [NSURL URLWithString:imageURL];
}
//无网络请求调用
- (void)setImageURL:(NSString *)imageURL strTemp:(NSString *)temp
{
    NSURL * url = [NSURL URLWithString:imageURL];
    [_guidesImageView imageUrl:url tempSTR:temp];
}

@end

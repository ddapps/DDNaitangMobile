//
//  NT_BaseView.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_BaseView.h"

@implementation NT_BaseView

@synthesize verticalLine = _verticalLine,scoreImageView = _scoreImageView;
@synthesize appIcon = _appIcon;
@synthesize appName = _appName;
@synthesize appType = _appType;
@synthesize appSize = _appSize;
@synthesize commentLabel = _commentLabel;
@synthesize goldSign = _goldSign;
@synthesize button = _button;
@synthesize scoreLabel = _scoreLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = 1.0f;
        self.alpha = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        //游戏图标
        _appIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default-icon.png"]];
        _appIcon.frame = CGRectMake(12, 7, 57, 57);
        /*
         //优化tableview，不能使用imageView设置圆角，会引起tableview滚卡顿
         _appIcon.layer.cornerRadius = 15;
         _appIcon.clipsToBounds = YES;
         */
        //_appIcon.backgroundColor = [UIColor clearColor];
        [self addSubview:_appIcon];
        
        //优化tableview，使用图片遮罩，圆角底图
        _roundCornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 57, 57)];
        _roundCornerImageView.image = [UIImage imageNamed:@"round-corner.png"];
        [self addSubview:_roundCornerImageView];
        
        //游戏名称
        _appName = [[UILabel alloc] initWithFrame:CGRectMake(_appIcon.right+10, 5, 150, 30)];
        //_appName.numberOfLines = 2;
        //_appName.backgroundColor = [UIColor clearColor];
        _appName.font = [UIFont boldSystemFontOfSize:16];
        _appName.textColor = Text_Color_Title;
        _appName.textAlignment = TEXT_ALIGN_LEFT;
        [self addSubview:_appName];
        
        //评分图片
        _scoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_appName.left, 33, 10, 10)];
        _scoreImageView.image = [UIImage imageNamed:@"list-score.png"];
        //_scoreImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scoreImageView];
        
        //分数
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(_appName.left+15, 29, 60, 20)];
        _scoreLabel.textColor = [UIColor colorWithHex:@"#34bcf8"];
        //_scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_scoreLabel];
        
        /*
         //分割线图片
         _verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(_scoreLabel.right-5, 43, 1, 16)];
         _verticalLine.image = [UIImage imageNamed:@"split-line.png"];
         _verticalLine.backgroundColor = [UIColor clearColor];
         [self addSubview:_verticalLine];
         
         
         //评论图片
         UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_verticalLine.right+5, 43, 10, 10)];
         commentImageView.backgroundColor = [UIColor clearColor];
         commentImageView.image = [UIImage imageNamed:@"list-common.png"];
         [self addSubview:commentImageView];
         
         //评论数
         _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_verticalLine.right+14, 40, 60, 16)];
         _commentLabel.textColor = Text_Color;
         _commentLabel.text = @"评论36条";
         _commentLabel.backgroundColor = [UIColor clearColor];
         _commentLabel.font = [UIFont systemFontOfSize:12];
         [self addSubview:_commentLabel];
         */
        
        /*
         //无限金币图片
         _goldSign = [[UILabel alloc] initWithFrame:CGRectMake(_scoreLabel.right-5, 38, 60, 16)];
         _goldSign.text = @"无限金币版";
         _goldSign.textAlignment = TEXT_ALIGN_CENTER;
         _goldSign.textColor = [UIColor whiteColor];
         _goldSign.backgroundColor = [UIColor colorWithHex:@"#ff3e50"];
         _goldSign.font = [UIFont systemFontOfSize:10];
         _goldSign.layer.cornerRadius = 3;
         [self addSubview:_goldSign];
         */
        
        _goldSign = [UIButton buttonWithType:UIButtonTypeCustom];
        _goldSign.frame = CGRectMake(_scoreLabel.right-5, 32, 60, 16);
        [_goldSign setTitle:@"无限金币版" forState:UIControlStateNormal];
        [_goldSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goldSign setBackgroundImage:[UIImage imageNamed:@"red-gold.png"] forState:UIControlStateNormal];
        [_goldSign setBackgroundImage:[UIImage imageNamed:@"red-gold.png"] forState:UIControlStateHighlighted];
        [_goldSign.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_goldSign];
        
        //游戏类型
        //_appType = [[UILabel alloc] initWithFrame:CGRectMake(_appName.left, 52, 100, 20)];
        _appType = [[UILabel alloc] initWithFrame:CGRectMake(_appName.left, 45, 200, 20)];
        //_appType.backgroundColor = [UIColor clearColor];
        _appType.textColor = Text_Color;
        _appType.font = [UIFont systemFontOfSize:10];
        _appType.text =@"动作格斗";
        [self addSubview:_appType];
        
        //游戏大小
        /*
         _appSize = [[UILabel alloc] initWithFrame:CGRectMake(160, 52, 100, 20)];
         _appSize.backgroundColor = [UIColor clearColor];
         _appSize.textColor = Text_Color;
         _appSize.font = [UIFont systemFontOfSize:10];
         [self addSubview:_appSize];
         */
        
        
        
        //下载按钮
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(SCREEN_WIDTH-80, 0, 80, 70);
        [_button setTitle:@"免费下载" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithHex:@"#888888"] forState:UIControlStateNormal];
        //_button.selected = NO;
        //_button.titleLabel.textAlignment = TEXT_ALIGN_CENTER;
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
        _button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn-green-download.png"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"btn-green-download-hover.png"] forState:UIControlStateHighlighted];

        /*
        //拉伸图片
        UIImage *originalImage = [UIImage imageNamed:@"btn-green-download.png"];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 20);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        [_button setBackgroundImage:stretchableImage forState:UIControlStateNormal];
        
        //拉伸按下图片
        UIImage *hoverImage = [UIImage imageNamed:@"btn-green-download-hover.png"];
        UIImage *stretchImage = [hoverImage resizableImageWithCapInsets:insets];
        [_button setBackgroundImage:stretchImage forState:UIControlStateHighlighted];
        */
        //[_button setBackgroundImage:[UIImage imageNamed:@"btn-download.png"] forState:UIControlStateNormal];
        //[_button setBackgroundImage:[UIImage imageNamed:@"btn-download-hover.png"] forState:UIControlStateHighlighted];
        [self addSubview:_button];
        
    }
    return self;
}

//设置详情头部样式
- (void)setDetailBaseView
{
    _appIcon.frame = CGRectMake(12, 13, 65, 65);
    _roundCornerImageView.frame = CGRectMake(12, 13, 65, 65);
    _appName.frame = CGRectMake(_appIcon.right+10, _appIcon.top + 2, 150, 30);
    _scoreImageView.frame = CGRectMake(_appName.left, 45, 10, 10);
    _scoreLabel.frame = CGRectMake(_appName.left+14, 42, 60, 16);
    _goldSign.frame = CGRectMake(_scoreLabel.right-5, 42, 60, 16);
    _appType.frame = CGRectMake(_appName.left, 56, 200, 20);
    [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_button setTitleEdgeInsets:UIEdgeInsetsZero];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"detail-btn.png"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"detail-btn-hover.png"] forState:UIControlStateHighlighted];
    _button.frame = CGRectMake(SCREEN_WIDTH-(12+78), 28, 78, 32);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [_appIcon cancelImageLoad];
    }
}
- (void)setImageURL:(NSString *)imageURL
{
    _appIcon.imageURL = [NSURL URLWithString:imageURL];
}
//无网络请求调用
- (void)setImageURL:(NSString *)imageURL strTemp:(NSString *)temp
{
    NSURL * url = [NSURL URLWithString:imageURL];
    [_appIcon imageUrl:url tempSTR:temp];
}

@end

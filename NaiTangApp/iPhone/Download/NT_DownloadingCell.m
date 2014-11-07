//
//  NT_DownloadingCell.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-9.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_DownloadingCell.h"
#import "UIImageView+WebCache.h"
#import "NT_SpeedShowWindow.h"
#import "NT_DownloadViewController.h"
#import "NT_WifiBrowseImage.h"

@implementation NT_DownloadingCell

@synthesize progressView = _progressView;
@synthesize statusLabel = _statusLabel;
@synthesize sizeLabel = _sizeLabel;
@synthesize speedLabel = _speedLabel;
@synthesize showLabel = _showLabel;
@synthesize model = _model;
@synthesize downloadStautsButton = _downloadStautsButton;
@synthesize customButtonStyle = _customButtonStyle;
@synthesize spaceDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _customButtonStyle = [[NT_CustomButtonStyle alloc] init];
        
        //下载状态按钮
        _downloadStautsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadStautsButton.frame = CGRectMake(SCREEN_WIDTH-(54+10), 22, 54, 29);
        /*
         [_downloadStautsButton setBackgroundImage:[UIImage imageNamed:@"btn-white.png"] forState:UIControlStateNormal];
         [_downloadStautsButton setBackgroundImage:[UIImage imageNamed:@"btn-white-hover.png"] forState:UIControlStateHighlighted];
         [_downloadStautsButton setTitle:@"设置" forState:UIControlStateNormal];
         [_downloadStautsButton setTitleColor:Text_Color forState:UIControlStateNormal];
         [_downloadStautsButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
         */
        [_downloadStautsButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _downloadStautsButton.tag = KDownloadButtonTag;
        [self.contentView addSubview:_downloadStautsButton];
        
        //自定义progressView
        _progressView = [[UIProgressBar alloc] initWithFrame:CGRectMake(self.iconView.right+8, 33, 160, 10)];
        _progressView.currentValue = 0;
        _progressView.lineColor = [UIColor whiteColor];
        _progressView.progressColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green-line.png"]];
        _progressView.minValue = 0;
        _progressView.progressRemainingColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray-line.png"]];
        [self.contentView addSubview:_progressView];
        
        
        //下载状态
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, 45, 50, 20)];
        _statusLabel.font = [UIFont systemFontOfSize:10];
        _statusLabel.text = @"已下载";
        _statusLabel.textColor = Text_Color;
        _statusLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_statusLabel];
        
        //游戏大小
        //_sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.right-10, _statusLabel.top, 120, 20)];
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.right, _statusLabel.top, 240, 20)];
        //_sizeLabel.text = @"66M/120M";
        _sizeLabel.textColor = Text_Color;
        _sizeLabel.font = [UIFont systemFontOfSize:10];
        _sizeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_sizeLabel];
        
        /*
         //下载速度
         _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sizeLabel.right-14, _statusLabel.top, 100, 20)];
         //_speedLabel.text = @"(20k/s)";
         _speedLabel.textColor = Text_Color;
         _speedLabel.font = [UIFont systemFontOfSize:10];
         _speedLabel.backgroundColor = [UIColor clearColor];
         [self.contentView addSubview:_speedLabel];
         */
        
        //非下载信息
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.left, 45, 280, 20)];
        _showLabel.numberOfLines = 2;
        _showLabel.font = [UIFont systemFontOfSize:10];
        _showLabel.backgroundColor = [UIColor clearColor];
        _showLabel.textColor = Text_Color;
        _showLabel.text = @"";
        [self.contentView addSubview:_showLabel];
        
        /*
        //分割线，若滑动时显示分割线，需要cell高度-1，不然往上滑动时，无分割线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70.5, SCREEN_WIDTH, 0.5)];
        view.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
        [self.contentView addSubview:view];
         */
    }
    return self;
}

//下载信息
- (void)refreshDataWith:(NT_DownloadModel *)model
{
    /*
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:KIsFirstDownloadImage];
    if (!isFirst)
    {
        //若是第一次显示下载中，则加载图片
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KIsFirstDownloadImage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //by 张正超 使用图片缓存方式显示
        [self.iconView setImageURL:[NSURL URLWithString:model.iconName]];
    }
    else
    {
        //第二次使用缓存图片
        [self.iconView imageUrl:[NSURL URLWithString:model.iconName] tempSTR:@"false"];
    }
    */
    //  设置-打开或关闭wifi下浏览图片通用方法
    NT_WifiBrowseImage *wifiImage = [[NT_WifiBrowseImage alloc] init];
    [wifiImage wifiBrowseImage:self.iconView urlString:model.iconName];
    
    self.modelID = model.modelID;
    
    self.nameLabel.text = model.gameName;
    
    //by thilong，初始化所有展示信息
    _statusLabel.text = @"";
    _sizeLabel.text= @"";
    _showLabel.text = @"";
    _progressView.currentValue = 0.0f;
    
    //by thilong, 2014-04-10
    self.statusLabel.hidden = NO;
    //self.speedLabel.hidden = YES;
    self.sizeLabel.hidden = NO;
    self.progressView.hidden = NO;
    //by 张正超 隐藏错误信息
    self.showLabel.hidden = YES;
    
    
    /*
     //按钮状态
     NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:KDownloadingStauts];
     if (status)
     {
     if ([status isEqualToString:@"删除"])
     {
     self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"删除" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"] ];
     }
     else if ([status isEqualToString:@"初始化"])
     {
     //点击下载按钮，状态改变时
     if (model.loadType == LOADING)
     {
     self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     }
     else if (model.loadType == PAUSE)
     {
     self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
     }
     else if (model.loadType == WAITEDOWNLOAD)
     {
     self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"] ];
     }
     else if (model.loadType == DOWNFAILED)
     {
     self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"重下" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
     }
     else if (model.loadType == ISUNLITMTGOLD)
     {
     //只有正版的类型为ISUNLITMTGOLD
     
     }
     }
     }
     */
    //by thilong. !IMPORTANT 请注意这里的改动。buttonStatus仅用于删除显示。其他状态根据下载状态来定
    if(1);
    else if (model.buttonStatus == loadOn)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
        /*
         self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
         */
    }
    else if (model.buttonStatus == pauseOn)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
        /*
         self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
         */
    }
    else if (model.buttonStatus == waiteOn)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"] ];
        /*
         self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"] ];
         */
    }
    else if (model.buttonStatus == reloadOn)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"重下" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        /*
         self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"重下" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
         */
    }
    
    if (model.buttonStatus == deleteOn)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
        /*
         self.downloadStautsButton = [_customButtonStyle customButton:self.downloadStautsButton title:@"删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
         */
    }
    else if(model.loadType == LOADING)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
    }
    else if(model.loadType == PAUSE)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
    }
    else if (model.loadType == DOWNFAILED)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
        
    }
    else if(model.loadType == WAITEDOWNLOAD)
    {
        [_customButtonStyle customButton:self.downloadStautsButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
    }
    else if(model.loadType == DOWNFAILEDWITHUNCONNECT){
        [_customButtonStyle customButton:self.downloadStautsButton title:@"重下" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
    }
    
    
    
    //获取本地剩余空间大小
    NSNumber *freeSpace = [[NSUserDefaults standardUserDefaults] objectForKey:KFreeSpace];
    //long long spaceSize = [freeSpace longLongValue]/1024.0/1024.0/1024.0;
    long long spaceSize = [freeSpace longLongValue];
    if (spaceSize>0)
    {
        if (model.fileSize > spaceSize)
        {
            //若还有空间，会在底部提示文字，还是继续下载的
            if (self.spaceDelegate && [self.spaceDelegate respondsToSelector:@selector(refreshLackOfSpaceDelegate)])
            {
                [self.spaceDelegate refreshLackOfSpaceDelegate];
            }
        }
        
        if (model.loadType == LOADING || model.loadType == PAUSE || model.loadType == DOWNFAILEDWITHUNCONNECT || model.loadType == DOWNFAILED ||model.loadType == WAITEDOWNLOAD)
        {
            self.statusLabel.hidden = NO;
            //self.speedLabel.hidden = YES;
            self.sizeLabel.hidden = NO;
            self.progressView.hidden = NO;
            
            if (model.loadType == LOADING)
            {
                //by 张正超 显示下载信息
                //self.speedLabel.hidden = NO;
                self.showLabel.hidden = YES;
                
                //self.statusLabel.text = [NSString stringWithFormat:@"已下载:%d%%",(int)(model.progress*100.0)];
                //self.speedLabel.text = [NSString stringWithFormat:@"(%@)",NSStringFromSize(model.downSpeed)];
                //下载大小与下载速度整合到一起
                self.statusLabel.text = @"已下载";
                self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@(%@)",NSStringFromSize(model.fileSize*model.progress),NSStringFromSize(model.fileSize),NSStringFromSize(model.downSpeed)];
            }
            
            else if (model.loadType == DOWNFAILED || model.loadType == DOWNFAILEDWITHUNCONNECT)
            {
                self.statusLabel.hidden = YES;
                //self.speedLabel.hidden = YES;
                self.sizeLabel.hidden = YES;
                
                self.showLabel.hidden = NO;
                self.showLabel.textColor = [UIColor redColor];
                self.showLabel.backgroundColor = [UIColor whiteColor];
                
                //by 张正超 存储错误值并显示错误信息
                if (model.errorCode == 0)
                {
                    //若无错误信息
                    self.showLabel.hidden = YES;
                    
                    self.statusLabel.hidden = NO;
                    //self.speedLabel.hidden = NO;
                    self.sizeLabel.hidden = NO;
                    
                    self.statusLabel.text = [NSString stringWithFormat:@"已下载:%d%%",(int)(model.progress*100.0)];
                    self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@(%@)",NSStringFromSize(model.fileSize*model.progress),NSStringFromSize(model.fileSize),NSStringFromSize(model.downSpeed)];
                    //self.speedLabel.text = [NSString stringWithFormat:@"(%@)",NSStringFromSize(model.downSpeed)];
                }
                else if(model.errorCode == SPACE_NOT_ENOUGH_ERROR)
                {
                    self.showLabel.text = @"下载失败，空间不足";
                }
                else if(model.errorCode == -1001)
                {
                    self.showLabel.text = @"下载失败，连接超时";
                }
                else if(model.errorCode ==  -404)
                {
                    self.showLabel.text = @"下载失败，找不到文件";
                }
                else if(model.errorCode == -500)
                {
                    self.showLabel.text = @"下载失败，服务器错误";
                }
                else if (model.errorCode == -1009)
                {
                    //self.showLabel.text = @"下载失败，网络连接失败";
                    //下载失败，网络连接失败
                    self.showLabel.hidden = YES;
                    
                    self.statusLabel.hidden = NO;
                    //self.speedLabel.hidden = NO;
                    self.sizeLabel.hidden = NO;
                    
                    self.statusLabel.text = @"已下载";
                    self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@(%@)",NSStringFromSize(model.fileSize*model.progress),NSStringFromSize(model.fileSize),NSStringFromSize(model.downSpeed)];
                }
                else
                {
                    self.showLabel.text = [NSString stringWithFormat:@"下载失败，错误%d",model.errorCode];
                }
                
            }
            else if (model.loadType == PAUSE)
            {
                /*
                 if(model.pausedByNetworkChange)
                 self.statusLabel.text = @"下载错误";
                 else*/
                
                self.statusLabel.text = @"暂停中";
                self.sizeLabel.text = [NSString stringWithFormat:@"%@/%@",NSStringFromSize(model.fileSize*model.progress),NSStringFromSize(model.fileSize)];
                
            }
            else if (model.loadType == WAITEDOWNLOAD)
            {
                self.statusLabel.text = @"等待下载";
            }
            self.progressView.currentValue = model.progress;
        }
        /*
         else if(model.loadType == INSTALLING)
         {
         self.progressView.hidden = YES;
         self.statusLabel.hidden = YES;
         self.speedLabel.hidden = YES;
         self.sizeLabel.hidden = YES;
         
         self.showLabel.text = @"正在安装..";
         }
         else if (model.loadType == ISUNLITMTGOLD)
         {
         //只有正版的类型为ISUNLITMTGOLD
         self.progressView.hidden = NO;
         self.statusLabel.hidden = YES;
         self.speedLabel.hidden = YES;
         self.sizeLabel.hidden = YES;
         
         self.showLabel.backgroundColor = [UIColor whiteColor];
         self.showLabel.text = @"抱歉，无限金币版必须连接PC端进行下载！";
         self.showLabel.textColor = [UIColor redColor];
         
         }
         else if(model.loadType == WAITEINSTALL)
         {
         self.progressView.hidden = YES;
         self.statusLabel.hidden = YES;
         self.speedLabel.hidden = YES;
         self.sizeLabel.hidden = YES;
         
         self.showLabel.backgroundColor = [UIColor whiteColor];
         self.showLabel.text = @"等待安装..";
         self.showLabel.textColor = [UIColor colorWithHex:@"#6666666"];
         
         }else if (model.loadType == INSTALLFAILED)
         {
         self.progressView.hidden = YES;
         self.statusLabel.hidden = YES;
         self.sizeLabel.hidden = YES;
         self.speedLabel.hidden = YES;
         self.showLabel.backgroundColor = [UIColor whiteColor];
         self.showLabel.textColor = [UIColor redColor];
         self.showLabel.text = @"安装失败，请点击重新下载";
         }
         else if(model.loadType == FINISHED)
         {
         self.progressView.hidden = YES;
         self.statusLabel.hidden = YES;
         self.sizeLabel.hidden = YES;
         self.speedLabel.hidden = YES;
         self.showLabel.width += 50;
         self.showLabel.backgroundColor = [UIColor whiteColor];
         self.showLabel.text = @"下载完成，可点击安装";
         self.showLabel.textColor = [UIColor colorWithHex:@"#6666666"];
         }
         */
    }
    /*
     else
     {
     self.statusLabel.hidden = YES;
     self.speedLabel.hidden = YES;
     self.sizeLabel.hidden = YES;
     self.progressView.hidden = NO;
     
     self.showLabel.hidden = NO;
     //如果空间为0时，会在下载栏里提示
     self.showLabel.text = @"存储空间不足";
     self.showLabel.textColor = [UIColor redColor];
     
     }
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

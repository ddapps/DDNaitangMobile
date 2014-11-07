//
//  NT_DetailImageView.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-7.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_DetailImageView.h"
#import "NT_CustomPageControl.h"
#import "UIView_MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NT_BaseAppDetailInfo.h"
#import "UIImage+CustomImageScale.h"
#import "NT_WifiBrowseImage.h"

@implementation NT_DetailImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KImageCellHeight-40)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.width*3, _scrollView.height);
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        //分页
        _pageControl = [[NT_CustomPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.height + 10, _scrollView.width, 18)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<7)
        {
            //小于iOS7的处理，因为iOS7默认会调用两次，但《7的版本却不会，目前没找到问题。
            _pageControl.currentPage = 0;
        }
        _pageControl.backgroundColor  = [UIColor clearColor];
        _pageControl.numberOfPages = 3;
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
        
        /*
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _pageControl.bottom + 5, SCREEN_WIDTH, 1)];
        lineImageView.image = [UIImage imageNamed:@"line.png"];
        [self addSubview:lineImageView];
         */
    }
    return self;
}


#pragma mark UIScrollViewDelagete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//根据坐标算页数
    _pageControl.currentPage = page;//页数赋值给pageControl的当前页
}

//加载图片
- (void)refreshWithAppInfo:(NT_BaseAppDetailInfo *)info
{
    NT_GameInfo *gameInfo = info.gameInfo;
    [self.scrollView removeAllSubViews];
    UIScrollView *scrollView = self.scrollView;
    NSArray *urlStringArray = [gameInfo screenShotUrlArray];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView showLoadingMeg:@"加载中..."];
    [self.scrollView setLoadingUserInterfaceEnable:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLoading:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    
    //设置批量图片间距
    [urlStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.scrollView hideLoading];
        __weak  UIImageView *pageImage = [UIImageView imageViewWithFrame:CGRectMake(idx * (200+10), scrollView.origin.y, 200, 300) andImage:[UIImage imageNamed:@"vertical-default.png"]];
        
        //设置图片尺寸适应
        pageImage.contentMode = UIViewContentModeScaleAspectFit;
        
        
        NSString * netStatus;
        NSString * placeHoldImgSrc;
        
        //开启或关闭wifi加载图片
        NT_WifiBrowseImage *wifiImage = [[NT_WifiBrowseImage alloc] init];
        NSDictionary *dic = [wifiImage getWifiStatusAndUrlString:obj placeholderString:@"vertical-default.png"];
        if ([dic count])
        {
            placeHoldImgSrc = [dic objectForKey:KPlaceHoldImgSrc];
            //netStatus = [dic objectForKey:KNetStatus];
        }
        
        /*
        // 检测当前是否WIFI网络环境
        BOOL isConnectedProperly =[[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==ReachableViaWiFi;
        //是否是2G/3G网络
        BOOL isWWAN = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==ReachableViaWWAN;
        //无网络
        BOOL notReach = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable;
        NSString * netStatus;
        NSString * placeHoldImgSrc;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //若关闭"只在wifi下加载图片"，则3G、wifi都可以加载图片
        if ([[userDefaults objectForKey:@"BigPicLoad"] isEqualToString:@"close"])
        {
            //3g或wifif连接
            if (!notReach)
            {
                netStatus = @"true";
                placeHoldImgSrc = obj;
            }
        }
        else
        {
            //打开只在wifi下加载图片
            //若使用的是3G，就不加载图片
            if (isWWAN)
            {
                netStatus = @"false";
                placeHoldImgSrc = @"vertical-default.png";
            }
            else if (isConnectedProperly)
            {
                //若使用的是wifi，则加载图片
                netStatus = @"true";
                placeHoldImgSrc = obj;
            }
            
        }
         */
        
        //你可以等图片加载完成后判断图片高度来确定是否是横图 然后旋转
        [pageImage setImageWithURL:[NSURL URLWithString:placeHoldImgSrc]  placeholderImage:[UIImage imageNamed:@"vertical-default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             
             if (tapGesture) {
                 [self.scrollView removeGestureRecognizer:tapGesture];
             }
             [self.scrollView hideLoading];
             
             //图片旋转为竖向图片
             pageImage.autoresizingMask = UIImageOrientationLeft|UIImageOrientationRight;
             if (image.size.width>image.size.height)
             {
                 pageImage.transform=CGAffineTransformMakeRotation(M_PI_2);
             }
             
             //根据高度300，进行缩放
             image = [pageImage.image scaleWithImageHeight:300];
             
             pageImage.frame = CGRectMake(idx*(image.size.width+10), scrollView.origin.y, image.size.width, image.size.height);
            
             scrollView.contentSize = CGSizeMake((image.size.width+10) * urlStringArray.count, scrollView.height);
         }];
        [scrollView addSubview:pageImage];
    }];
    
    _pageControl.numberOfPages = (urlStringArray.count+2-1)/2;

    NSLog(@"image x:%f y:%f width:%f height:%f",scrollView.origin.x,scrollView.origin.y,scrollView.width,scrollView.height);
    /*
    NT_GameInfo *gameInfo = info.gameInfo;
    [self.scrollView removeAllSubViews];
    UIScrollView *scrollView = self.scrollView;
    NSArray *urlStringArray = [gameInfo screenShotUrlArray];
    
    [self.scrollView showLoadingMeg:@"加载中..."];
    [self.scrollView setLoadingUserInterfaceEnable:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLoading:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    
    //设置批量图片间距
    [urlStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        __weak  UIImageView *pageImage = [UIImageView imageViewWithFrame:CGRectMake(0, scrollView.origin.y, 200, 300) andImage:[UIImage imageNamed:@"vertical-default.png"]];
        
        //设置图片尺寸适应
        pageImage.contentMode = UIViewContentModeScaleAspectFit;
        
        
        //你可以等图片加载完成后判断图片高度来确定是否是横图 然后旋转
        [pageImage setImageWithURL:[NSURL URLWithString:obj]  placeholderImage:[UIImage imageNamed:@"vertical-default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             
             if (tapGesture) {
                 [self.scrollView removeGestureRecognizer:tapGesture];
             }
             [self.scrollView hideLoading];
             
             //图片旋转为竖向图片
             pageImage.autoresizingMask = UIImageOrientationLeft|UIImageOrientationRight;
             if (image.size.width>image.size.height)
             {
                 pageImage.transform=CGAffineTransformMakeRotation(M_PI_2);
             }
             
             //根据高度300，进行缩放
             image = [pageImage.image scaleWithImageHeight:300];
             
             pageImage.frame = CGRectMake(idx*(image.size.width+10), scrollView.origin.y, image.size.width, image.size.height);
             
             scrollView.contentSize = CGSizeMake((image.size.width+10) * urlStringArray.count, scrollView.height);
             
         }];
        [scrollView addSubview:pageImage];
    }];
    
    _pageControl.numberOfPages = (urlStringArray.count+2-1)/2;
    */
}

- (void)hiddenLoading:(UITapGestureRecognizer *)tap
{
    if (tap) {
        [self.scrollView removeGestureRecognizer:tap];
    }
    [self.scrollView hideLoading];
}

@end

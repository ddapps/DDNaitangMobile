//
//  NT_TopAdView.m
//  NaiTangApp
//
//  Created by 张正超 on 14-4-10.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_TopAdView.h"
#import "AdModel.h"
#import "DataService.h"
#import "ContentViewController.h"
#import "NT_WifiBrowseImage.h"

@implementation NT_TopAdView

@synthesize switchTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.dataArray = [NSMutableArray array];
                
        switchTableView = [SwitchTableView shareSwitchTableViewData];
        
        //加载图片滚动视图
        [self loadScrollView];
        [self structAdData];
        
        if([switchTableView isConnectionAvailable] == YES) {
            [self performSelector:@selector(requestAdData) withObject:nil afterDelay:1.0];
        }
    }
    return self;
}

//加载图片滚动视图
- (void)loadScrollView
{
    //循环广告视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 ,0, SCREEN_WIDTH, 100)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    //默认图片
    _imgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"top-default.png"]];
    _imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.height);
    [_scrollView addSubview:_imgView];
}

//加载轮播图片
- (void)structAdData
{
    //加载轮播图片
    NSData * slideImageURLSData = [[NSUserDefaults standardUserDefaults] objectForKey:@"slideImageURLS"];
    if (slideImageURLSData) {
        self.dataArray = [NSMutableArray array];
        NSArray * events = [NSKeyedUnarchiver unarchiveObjectWithData:slideImageURLSData];
        for (NSDictionary * dic in events){
            [self.dataArray addObject:[[AdModel alloc] initWithDictionary:dic]];
        }
    }
}

//请求头图数据
- (void)requestAdData
{
    if ([self.dataArray count] > 0)
    {
        //加载数据
        [self loadContent];
    }
    else
    {
        [DataService requestWithURL:@"http://www.7k7k.com/m-json/appad/3_1.html" finishBlock:^(id result) {
            NSArray * events = [[result objectForKey:@"data"] objectForKey:@"list"];
            self.dataArray = [NSMutableArray array];
            for (NSDictionary * dic in events){
                [self.dataArray addObject:[[AdModel alloc] initWithDictionary:dic]];
                
            }
            if (self.dataArray.count == 3) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:events] forKey:@"slideImageURLS"];
            }
            [self loadContent];
        }];

    }
}

//加载数据
- (void)loadContent
{
    [self.scrollView removeAllSubViews];
    for (int i = 0; i< [self.dataArray count]; i++)
    {
        AdModel *model = (AdModel *)[self.dataArray objectAtIndex:i];
        _imgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"top-default.png"]];
        _imgView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.height);
        _imgView.userInteractionEnabled = YES;

        NT_WifiBrowseImage *wifiImage = [[NT_WifiBrowseImage alloc] init];
        [wifiImage wifiBrowseImage:_imgView urlString:model.img];
         
        _imgView.tag = i + 1;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adImagePressed:)];
        [_imgView addGestureRecognizer:tapGesture];
        
        [self.scrollView addSubview:_imgView];
    }
    self.scrollView.contentSize = CGSizeMake(self.dataArray.count*SCREEN_WIDTH, self.scrollView.height);
}

//广告图片点击事件
- (void)adImagePressed:(UITapGestureRecognizer *)tap
{
    int tag = tap.view.tag-1;
    AdModel *model =  [self.dataArray objectAtIndex:tag];
    if ([model.type isEqualToString:@"1"])
    {
        ContentViewController * contentVC = [[ContentViewController alloc] init];
        contentVC.webUrl = model.url;
        contentVC.titleText = model.title;
        [self.viewController.navigationController pushViewController:contentVC animated:YES];
    }else if ([model.type isEqualToString:@"2"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
            [self openAppWithIdentifier:model.url];
        }else
        {
            [self outerOpenAppWithIdentifier:model.url];
        }
    }

}

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController * storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self.viewController.navigationController presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
}

//
// app外打开appstore（适用于<ios6.0）
//
- (void)outerOpenAppWithIdentifier:(NSString *)appId {
    NSString * urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
    NSURL * url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --
#pragma mark -- EGOImageView Delegate methods
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        [_imgView cancelImageLoad];
    }
}
- (void)setImageURL:(NSString *)imageURL
{
    _imgView.imageURL = [NSURL URLWithString:imageURL];
}
//无网络请求调用
- (void)setImageURL:(NSString *)imageURL strTemp:(NSString *)temp
{
    NSURL * url = [NSURL URLWithString:imageURL];
    [_imgView imageUrl:url tempSTR:temp];
}



- (void)dealloc
{
    self.scrollView = nil;
    self.dataArray = nil;
    self.imageArray = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

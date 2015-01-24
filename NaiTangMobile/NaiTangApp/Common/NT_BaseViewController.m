//
//  NT_BaseViewController.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_BaseViewController.h"
#import "liBaoViewController.h"
#import "RightViewController.h"
#import "NT_RepairViewController.h"

@interface NT_BaseViewController ()

@end

@implementation NT_BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    if (isIOS6)
    {
        UIImage *imgNav = [UIImage imageNamed:@"top-bk.png"];
        [self.navigationController.navigationBar setBackgroundImage:imgNav forBarMetrics:
         UIBarMetricsDefault];
    }
     */
    
    //更多设置
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, 44, 44);
    [settingButton setImage:[UIImage imageNamed:@"ico-topleft.png"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"ico-topleft-hover.png"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(settingBarPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingBar = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    if (isIOS7)
    {
        //设置ios7导航栏两边间距，和ios6以下两边间距一致
        UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        spaceBar.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceBar,settingBar, nil];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = settingBar;
    }
    
    
    //礼包
    UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    giftButton.bounds = CGRectMake(0, 0, 44, 44);
    [giftButton setImage:[UIImage imageNamed:@"ico-topright.png"] forState:UIControlStateNormal];
    [giftButton setImage:[UIImage imageNamed:@"ico-topright-hover.png"] forState:UIControlStateHighlighted];
    [giftButton addTarget:self action:@selector(giftBarPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *giftBar = [[UIBarButtonItem alloc] initWithCustomView:giftButton];
    
    if (isIOS7)
    {
        //设置ios7导航栏两边间距，和ios6以下两边间距一致
        UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        spaceBar.width = -10;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceBar,giftBar, nil];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = giftBar;
    }
}

#pragma mark -- 
#pragma mark -- UIBarButtonItem Pressed Event Methods
//更多设置按钮事件
- (void)settingBarPressed
{
    RightViewController *settingController = [[RightViewController alloc] init];
    settingController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingController animated:NO];
}

//礼包按钮事件
- (void)giftBarPressed
{
    /*
    liBaoViewController *rankingController = [[liBaoViewController alloc] init];
    [self.navigationController pushViewController:rankingController animated:YES];
     */
    NT_RepairViewController *repairController = [[NT_RepairViewController alloc] init];
    repairController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:repairController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

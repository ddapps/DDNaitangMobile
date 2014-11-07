//
//  RightViewController.m
//  PartnerProject7kShare
//
//  Created by 王明远 on 13-12-16.
//  Copyright (c) 2013年 王明远. All rights reserved.
//

#import "RightViewController.h"
#import "Utile.h"
#import "RightCell.h"
//#import "UMFeedback.h"
#import "EGOCache.h"
#import "NTAppDelegate.h"
#import "AppDelegate_Def.h"

// shareSDK
//#import <ShareSDK/ShareSDK.h>

// 友盟反馈
//#import "UMFeedback.h"
//SDWebImage
#import "SDImageCache.h"

#import "NT_SettingManager.h"
#import "NT_AboutViewController.h"
#import "NT_RepairViewController.h"
#import "NT_NaiTangUpdateInfo.h"
#import "NT_UpdateAppInfo.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*
         self.cellArray = [NSMutableArray arrayWithObjects:@"",@"只在WIFI下加载图片",
         @"清理缓存",@"",@"为7k7k游戏评分",@"分享给好友",@"关于我们",@"意见反馈", nil];
         self.tagImgArr = [NSMutableArray arrayWithObjects:@"",@"btn-set-wifi@2x.png", @"btn-set-cache@2x.png",@"",@"btn-set-pingfen@2x.png",@"btn-set-share@2x.png", @"btn-set-about@2x.png",@"btn-set-feedback@2x.png",nil];
         self.listArr = [NSMutableArray array];
         */
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //计算缓存的大小
    [self _countCacheSize];
    [self.rightTable reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    if (iPad || iPad4) {
    //        superWidth = 768;
    //    } else
    //    {
    superWidth = 320;
    //    }
    /*
     if (IOS7) {
     superHeight = self.view.frame.size.height;
     
     UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
     [customLab setTextColor:[UIColor whiteColor]];
     customLab.textAlignment = NSTextAlignmentCenter;
     [customLab setText:@"更多"];
     [customLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
     self.navigationItem.titleView = customLab;
     [[UINavigationBar appearance]setBarTintColor:NAV_UICOLOR];
     
     } else
     {
     superHeight = self.view.frame.size.height + 20;
     
     self.title = @"更多";
     UINavigationBar *navBar = self.navigationController.navigationBar;
     [navBar setTintColor:NAV_UICOLOR];
     }
     */
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"更多";
    titleLable.textAlignment = TEXT_ALIGN_CENTER;
    [titleLable sizeToFit];
    self.navigationItem.titleView = titleLable;
    
    
    //返回按钮
    UIButton *leftBt = [UIButton buttonWithFrame:CGRectMake(0, 0, 44, 44) image:[UIImage imageNamed:@"top-back.png"] target:self action:@selector(gotoBack)];
    [leftBt setImage:[UIImage imageNamed:@"top-back-hover.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftBt];
    
    if (isIOS7)
    {
        //设置ios7导航栏两边间距，和ios6以下两边间距一致
        UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        spaceBar.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:spaceBar,backItem, nil];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    //    self.navigationController.navigationBarHidden = YES;
    //    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha: 1.0f];
    //    self.view.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:47/255.0 alpha: 1.0f];
    
    //CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    self.rightTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //    _rightTable.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha: 1.0f];
    _rightTable.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha: 1.0f];
    _rightTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    //    _rightTable.bounces = NO;
    _rightTable.separatorColor = [UIColor colorWithRed:47 green:79 blue:79 alpha: 0.1f];
    [self.view addSubview:_rightTable];
    [Utile setExtraCellLineHidden:_rightTable];
    
    self.cellArray = [NSMutableArray arrayWithObjects:@"",@"只在WIFI下加载图片",@"只在WIFI下下载游戏",
                      @"清理缓存",@"",@"版本更新",@"关于奶糖",@"闪退修复帮助", nil];
    self.tagImgArr = [NSMutableArray arrayWithObjects:@"",@"btn-set-wifi.png", @"btn-set-2g3g.png",@"btn-set-cache.png",@"",@"btn-set-share.png", @"btn-set-about.png",@"btn-set-feedback.png",@"btn-set-repair.png",nil];
    self.listArr = [NSMutableArray array];
    
    
}

#pragma UITabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cellArray count];
}

/**
 * @brief 设定cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row == 3 || indexPath.row == 0)
    if (indexPath.row == 4 || indexPath.row == 0)
    {
        return 5;
    }else{
        return 45;
    }
}

/**
 * @brief 设定cell的背景色
 * 专门用这个方法来设定cell的背景色
 * 是因为在IOS6里面，cell的背景色是无法被直接设定的
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:47/255.0 alpha:1];
    //if (indexPath.row == 3 || indexPath.row == 0)
    if (indexPath.row == 4 || indexPath.row == 0)
    {
        cell.backgroundColor = [UIColor clearColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * cellTag = @"rightCellID";
    RightCell * cell = [tableView dequeueReusableCellWithIdentifier:cellTag];
    if (!cell) {
        cell = [[RightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTag];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row == 3) {
        
        //设置缓存显示文本
        _label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60 - 5, 3, 60, self.rightTable.rowHeight-5)];
        _label.font = [UIFont fontWithName:@"Helvetica" size:15];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor whiteColor];
        _label.textColor = [UIColor blackColor];
        [cell addSubview:_label];
        
        float m = sum /(1024.0 * 1024.0);
        NSLog(@"%f",m);
        _label.text = [NSString stringWithFormat:@"%.1fM",m];
        
    }
    /* else if (indexPath.row == 1) {
     //        _defaultSwitch = [[RESwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 8, 75, 28)];
     //        [_defaultSwitch setTitle:@"打开" forLabel:RESwitchLabelOn];
     //        [_defaultSwitch setTitle:@"关闭" forLabel:RESwitchLabelOff];
     //        _defaultSwitch.on = NO;
     
     switchWiFi = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 8, 90, 28)];
     switchWiFi.backgroundColor = [UIColor clearColor];
     //        [switchWiFi addTarget:self action:@selector(picLoad) forControlEvents:UIControlEventValueChanged];
     
     //        [switchWiFi addTarget:self action:@selector(picLoad) forControlEvents:UIControlEventValueChanged];
     
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     if (![userDefaults objectForKey:@"BigPicLoad"]) {
     [userDefaults setObject:@"close" forKey:@"BigPicLoad"];
     } else
     {
     if ([[userDefaults objectForKey:@"BigPicLoad"] isEqualToString:@"open"]) {
     //                _defaultSwitch.on = YES;
     [switchWiFi setOn:YES];
     } else{
     //                _defaultSwitch.on = NO;
     [switchWiFi setOn:NO];
     }
     }
     [userDefaults synchronize];
     //        [cell addSubview:_defaultSwitch];
     [cell addSubview:switchWiFi];
     }*/
    else if (indexPath.row == 1)
    {
        //只在wifi下加载图片
        if (!switchNoWiFi) {
            switchNoWiFi = [[NT_SwitchButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 47, 23)];
            switchNoWiFi.isChecked = YES;
            [switchNoWiFi addTarget:self action:@selector(picLoad) forControlEvents:UIControlEventTouchUpInside];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (![userDefaults objectForKey:@"BigPicLoad"]) {
                [userDefaults setObject:@"open" forKey:@"BigPicLoad"];
            } else
            {
                if ([[userDefaults objectForKey:@"BigPicLoad"] isEqualToString:@"open"]) {
                    switchNoWiFi.isChecked = YES;
                } else{
                    switchNoWiFi.isChecked = NO;
                }
            }
            [userDefaults synchronize];
            [cell addSubview:switchNoWiFi];
        }
        
    }
    else if (indexPath.row == 2)
    {
        //只在wifi下载游戏
        if (!switchWifiDownload) {
            switchWifiDownload = [[NT_SwitchButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 10, 47, 23)];
            switchWifiDownload.isChecked = YES;
            //默认开启
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([NT_SettingManager onlyDownloadUseWifi]) {
                switchWifiDownload.isChecked = YES;
            } else{
                switchWifiDownload.isChecked = NO;
            }
            [userDefaults synchronize];
            //switchWifiDownload.isChecked = [NT_SettingManager onlyDownloadUseWifi];
            [switchWifiDownload addTarget:self action:@selector(switchWifiDownloadChange:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:switchWifiDownload];
        }
        
        
    }
    //else if(indexPath.row == 0 || indexPath.row == 3)
    else if(indexPath.row == 0 || indexPath.row == 4)
    {
        cell.tagImgView.hidden = YES;
        cell.borderBottom.hidden = YES;
    }
    cell.tagImgView.image = [UIImage imageNamed:self.tagImgArr[indexPath.row]];
    cell.rightLabelTitle.text = [_cellArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:{
            
            //            // 新建UIWindow，在UIWindow中加载收藏列表页
            //            _collectionViewController = [[CollectionViewController alloc]init];
            //            _collectionViewController.view.frame = CGRectMake(0, 0, superWidth, superHeight);
            //            [_collectionViewController loadCollectionView];
            
        }break;
        case 1:{
            
        }break;
        case 3:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清理缓存"
                                                           message:@"确定要清理吗？"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
            [alert show];
        }break;
        case 4:{
            
        }break;
        case 5:{
            //奶糖版本更新
            [self updateNaitangVersion];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppUrl]];
        }break;
        case 6:{
            //关于奶糖
            NT_AboutViewController *aboutController = [[NT_AboutViewController alloc] init];
            aboutController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutController animated:YES];
            /*
             // 分享给好友
             id forActionSheet;
             
             if(iPad || iPad4){
             //创建弹出菜单容器
             id<ISSContainer> container = [ShareSDK container];
             [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
             
             forActionSheet = container;
             
             }else{
             forActionSheet = nil;
             }
             
             id<ISSContent> publishContent = [ShareSDK content:@"自从装了7K7K游戏，好玩的游戏再也不用到处找，你们也快来试试看吧。https://itunes.apple.com/cn/app/id838133287?mt=8"
             defaultContent:@"好应用，东花园出品"
             image:[ShareSDK pngImageWithImage:[UIImage imageNamed:@"icon.png"]]
             title:@"7K7K游戏"
             url:@"http://www.7kapp.cn/"
             description:@"7K7K游戏"
             mediaType:SSPublishContentMediaTypeNews];
             
             [ShareSDK showShareActionSheet:forActionSheet
             shareList:nil
             content:publishContent
             statusBarTips:YES
             authOptions:nil
             shareOptions:nil
             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
             if (state == SSResponseStateSuccess)
             {
             NSLog(@"分享成功");
             }
             else if (state == SSResponseStateFail)
             {
             NSString * errorMsg = [NSString stringWithFormat:@"错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]];
             
             UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
             
             [alert show];
             }
             }
             
             ];
             */
        }break;
        case 7:
        {
            NT_RepairViewController *repairController = [[NT_RepairViewController alloc] init];
            [self.navigationController pushViewController:repairController animated:YES];
        }
            break;
            /*
             case 7:{
             _windowView.hidden = NO;
             if (!_coverView) {
             _coverView = [[DetailActorsView alloc]initWithFrame:CGRectMake(superWidth, 0, superWidth,superHeight)];
             //                _coverView.backgroundColor = [UIColor blackColor];
             _coverView.tag = 2013;
             _windowView = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, superWidth, superHeight)];
             _windowView.windowLevel = UIWindowLevelNormal;
             _windowView.backgroundColor = [UIColor clearColor];
             [_windowView addSubview:_coverView];
             [_windowView makeKeyAndVisible];
             UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
             [_coverView addGestureRecognizer:pan];
             }
             [UIView animateWithDuration:.35 animations:^{
             _coverView.frame = CGRectMake(0, 0, superWidth, superHeight);
             } completion:^(BOOL finished) {
             
             }];
             }break;
             */
        case 8:{
            //[UMFeedback showFeedback:(UIViewController *)self withAppkey:(NSString *)UMENG_STATISTICAL_APPKEY];
        }
            
            break;
        default:
            break;
    }
}

- (void)_countCacheSize
{
    sum = 0;
    //拿到缓存文件的目录
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    //计算大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //图片名字的集合
    NSArray *filePaths = [fileManager subpathsOfDirectoryAtPath:path error:nil];
    for (NSString *subPath in filePaths) {
        //文件的路径
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        //获取文件的属性
        NSDictionary *dic = [fileManager attributesOfItemAtPath:filePath error:nil];
        long long size = [dic fileSize];
        NSLog(@"%lld",size);
        sum += size;
    }
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        //计算大小
        //清理小图缓存
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
        NSLog(@"%@",path);
        BOOL success = [fileManager removeItemAtPath:path error:nil];
        if (success) {
            NSLog(@"清理缓存");
        }
        //清理网页缓存
        NTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        [appDelegate.myCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"slideImageURLS"];
        
        [[EGOCache currentCache]clearCache];
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [self.view showLoadingMeg:@"清除完成！" time:1];
        
        //        [self _countCacheSize];
        sum = 0.0;
        //刷新tableView
        [self.rightTable reloadData];
        
    }
}


- (void)panAction:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGFloat translation = [pan translationInView:_coverView].x;
        
        if (translation > 0)
        {
            [UIView animateWithDuration:.35 animations:^{
                _coverView.frame = CGRectMake(superWidth, 0, superWidth, superHeight);
            }];
            [self performSelector:@selector(customWindowHidden) withObject:nil afterDelay:.35];
        }
    }
    
}

- (void)customWindowHidden
{
    _windowView.hidden = YES;
    
}

- (void)picLoad
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"BigPicLoad"] isEqualToString:@"open"]) {
        switchNoWiFi.isChecked = NO;
        [userDefaults setObject:@"close" forKey:@"BigPicLoad"];
    } else
    {
        switchNoWiFi.isChecked = YES;
        [userDefaults setObject:@"open" forKey:@"BigPicLoad"];
    }
    [userDefaults synchronize];
}

//只在wifi下下载
- (void)switchWifiDownloadChange:(NT_SwitchButton *)s
{
    s.isChecked = !s.isChecked;
    [NT_SettingManager setOnlyDownloadUseWifi:s.isChecked];
}

//奶糖版本更新提示
- (void)updateNaitangVersion
{
    [[NT_HttpEngine sharedNT_HttpEngine] checkIsNeedUpdateVersionCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSData *data = [completedOperation responseData];
         NSError *error;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         if (dic.count>0) {
             NSLog(@"奶糖版本更新dic:%@",dic);
             
             if ([[dic objectForKey:@"status"] boolValue])
             {
                 NSArray *dataArray = [dic objectForKey:@"data"];
                 NSDictionary *dataDictionary = [dataArray objectAtIndex:0];
                 NT_NaiTangUpdateInfo *updateInfo = [[NT_NaiTangUpdateInfo alloc] init];
                 updateInfo = [updateInfo updateInfoWithDic:dataDictionary];
                 
                 //越狱和非越狱的调用都调用正版app
                 if ([[UIDevice currentDevice] isJailbroken] || ![[UIDevice currentDevice] isJailbroken])
                 {
                     //需要更新
                     if ([NT_UpdateAppInfo versionCompare:updateInfo.version_name  and:currentVersionString])
                         
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:updateInfo.desc delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                         [alert showWithCompletionHandler:^(NSInteger buttonIndex)
                          {
                              if (buttonIndex == 1)
                              {
                                  NSLog(@"plist2:%@",updateInfo.plist2);
                                  if (isIOS7)
                                  {
                                      NSString *url = [[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",updateInfo.plist2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                      
                                      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                                      {
                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                      }
                                  }
                                  else
                                  {
                                      NSLog(@"plist1:%@",updateInfo.plist1);
                                      //使用http安装
                                      NSString *url = [[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",updateInfo.plist1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                      
                                      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
                                      {
                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                      }
                                  }
                              }
                              return ;
                          }];
                         
                     }
                     else
                     {
                         //若无更新信息，需要弹框提示无更新
                         if (!self.isNoShowUpdate)
                         {
                             showAlert(@"当前版本已经是最新版本，不需要更新");
                         }
                     }
                     
                 }
             }
         }
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
         [self.view showLoadingMeg:@"更新出错" time:1.5];
     }];
    
    /*
     [[NT_HttpEngine sharedNT_HttpEngine] checkIsNeedUpdateVersionCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
     // NSDictionary *dic = [completedOperation responseJSON];
     NSData *data = [completedOperation responseData];
     NSError *error;
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
     if (dic.count>0) {
     NSLog(@"奶糖版本更新dic:%@",dic);
     
     /\*
     //根据设备类型，获取不同版本
     NSDictionary *typeDictionary = nil;
     
     if (isIphone)
     {
     if ([[UIDevice currentDevice] isJailbroken])
     {
     typeDictionary = [dic objectForKey:@"iphone_jailbroken"];
     }
     else
     {
     typeDictionary = [dic objectForKey:@"iphone"];
     }
     
     }
     
     NSString *updateVesrion = typeDictionary[@"vNum"];
     //if ([YSUpdateTableView versionCompare:updateVesrion  and:currentVersionString])
     if ([updateVesrion floatValue]>=[currentVersionString floatValue])
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:typeDictionary[@"desc"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
     if (buttonIndex == 1)
     {
     if (isIOS7)
     {
     NSString *url = [@"itms-services://?action=download-manifest&url=https://ssl.naitang.com/nt_iphone_fy.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
     {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
     }
     }
     else
     {
     NSString *url = [@"itms-services://?action=download-manifest&url=http://dl.naitang.com/yingyong/ios/nt_iphone_fy/nt_iphone_fy.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
     {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
     }
     
     }
     
     //正版与越狱均可需要使用items-services协议，打开web，直接安装。但是越狱发布前，需要做其他一些配置，将release改为install等。
     //file为plist
     /\*
     if ([[UIDevice currentDevice] isJailbroken])
     {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-services://?action=download-manifest&url=http://dl.naitang.com/yingyong/ios/nt_iphone_yy/nt_iphone_yy.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
     }
     else
     {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-services://?action=download-manifest&url=http://dl.naitang.com/yingyong/ios/nt_iphone_fy/nt_iphone_fy.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
     }*/
    //NSString *newVersionUrl = typeDictionary[@"file"];
    
    
    //NSString *newVersionUrl = dic[@"data"][@"file"];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",newVersionUrl]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]]];
    /*
     DownLoadModel *model = [[DownLoadModel alloc] initWithAddress:newVersionUrl andGameName:typeDictionary[@"title"] andRoundPic:typeDictionary[@"pic"] andVersion:typeDictionary[@"vNum"] andAppID:nil];
     model.package = [[NSBundle mainBundle] bundleIdentifier];
     model.isUpdateModel = YES;
     [[DownLoadManager sharedDownLoadManager] downLoadWithModel:model];
     *\/
     }
     
     }];
     
     }
     else
     {
     //若无更新信息，需要弹框提示无更新
     if (!self.isNoShowUpdate)
     {
     showAlert(@"当前版本已经是最新版本，不需要更新");
     }
     }
     }
     */
    /*
     NSLog(@"version %@",dic);
     if ([dic[@"status"] intValue] == 1) {
     [YSShowUpdateView hide];
     if(dic[@"data"][@"vNum"] != [NSNull null]&&dic[@"data"][@"file"] != [NSNull null]&&![dic[@"data"][@"vNum"] isEqualToString:currentVersionString]){
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"发现最新版本%@，请尽快更新~！",dic[@"data"][@"vNum"]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
     if (buttonIndex == 1) {
     //                                    NSLog(@"更新");
     NSString *newVersionUrl = dic[@"data"][@"file"];
     //                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionUrl]];
     
     //DownLoadModel *model = [[DownLoadModel alloc] initWithAddress:newVersionUrl andGameName:@"奶糖新版" andRoundPic:nil an];
     DownLoadModel *model = [[DownLoadModel alloc] initWithAddress:newVersionUrl andGameName:@"奶糖新版" andRoundPic:nil andAppID:nil];
     model.package = [[NSBundle mainBundle] bundleIdentifier];
     [[DownLoadManager sharedDownLoadManager] downLoadWithModel:model];
     }
     }];
     }
     else
     {
     showAlert(@"当前版本已经是最新版本，不需要更新");
     }
     
     }
     
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
     
     [self.view showLoadingMeg:@"更新出错" time:1.5];
     }];
     */
}

- (void)gotoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

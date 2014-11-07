//
//  NT_DownloadViewController.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-9.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_DownloadViewController.h"
#import "NT_HeaderView.h"
#import "NT_DownloadingCell.h"
#import "NT_SpeedShowWindow.h"
#import "NT_CustomButtonStyle.h"
#import "NT_FinishedHeaderCell.h"
#import "NT_FinishedCell.h"
#import "MobileInstallationInstallManager.h"
#import "NT_InstallAppInfo.h"
#import "NT_UpdateAppInfo.h"
#import "NT_SettingManager.h"
#import "NT_UpdateCell.h"
#import "NT_DownloadingTableView.h"
#import "NT_HeaderCell.h"
#import "NT_UpdateTableView.h"
#import "NT_UpdateCell.h"
#import "NT_FinishedHeaderCell.h"
#import "NT_DownloadFinishedTableView.h"
#import "Utile.h"

@interface NT_DownloadViewController ()
{
    int _currnetPage;
    UIButton *_seletBt;
    BOOL _isScrolling;
    BOOL _isNeedRefresh;
    //by thilong.
    BOOL _canActionDownloadingToggle;
}

//@property (nonatomic,strong) UIImageView *slide;
@property (nonatomic,strong) UIView *slide;
@property (nonatomic,strong) UITableView *downloadingTableView;
@property (nonatomic,strong) UITableView *finishedTableView;
@property (nonatomic,strong) UITableView *updateTableView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NT_HeaderView *headerView;
@property (nonatomic,strong) NT_CustomButtonStyle *customButtonStyle;
//更新
//@property (nonatomic,strong) NSMutableArray *updateMutArray;
@property (nonatomic,assign) BOOL isOpenUpdate;
@property (nonatomic,assign) NSInteger currentRow;
@property (nonatomic,assign) BOOL isAllIgnore;

@property (nonatomic,assign) UIButton *updateBadgeValueView;

@end

@implementation NT_DownloadViewController
{
    BOOL _downloadingEidting ;
    BOOL _finishedEditing;
    BOOL _updateEditing;
    
    UIImageView *_noDownloadingImg;
    UIImageView *_noDownloadedImg;
    UIImageView *_noUpdateImg;
    
    //保存更新点击数量
    int  clickUpdateCount;
}

@synthesize slide = _slide;
@synthesize downloadingTableView = _downloadingTableView;
@synthesize finishedTableView = _finishedTableView;
@synthesize updateTableView = _updateTableView;
@synthesize scrollView = _scrollView;
@synthesize dataArray = _dataArray;
@synthesize headerView = _headerView;
@synthesize customButtonStyle = _customButtonStyle;
@synthesize isOpenUpdate = _isOpenUpdate;
@synthesize currentRow = _currentRow;
@synthesize isAllIgnore = _isAllIgnore;

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
    _downloadingEidting = _finishedEditing = _updateEditing = NO;
    //by thilong
    _canActionDownloadingToggle = YES;
	// Do any additional setup after loading the view.
    //self.navigationItem.title = @"奶糖游戏";
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLable.font = [UIFont boldSystemFontOfSize:20];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"奶糖游戏";
    titleLable.textAlignment = TEXT_ALIGN_CENTER;
    [titleLable sizeToFit];
    self.navigationItem.titleView = titleLable;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isNeedRefresh = NO;
    _isScrolling = NO;
    self.currentRow = -1;
    
    [NT_DownloadManager sharedNT_DownLoadManager].delegate = self;
    [NT_DownloadManager sharedNT_DownLoadManager].finishedDelegate = self;
    [NT_DownloadManager sharedNT_DownLoadManager].updateDelegate = self;
    [NT_DownloadManager sharedNT_DownLoadManager].usedSpaceDelegate = self;
    //self.updateMutArray = [NSMutableArray arrayWithCapacity:10];
    
    _customButtonStyle = [[NT_CustomButtonStyle alloc] init];
    
    
    //初始化时设置按钮状态，按钮状态和下载状态一致
    [[NSUserDefaults standardUserDefaults] setObject:@"改变" forKey:KDownloadingStauts];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.dataArray = [NSArray arrayWithObjects:@"下载中",@"已下载",@"可更新", nil];
    
    
    //滑动条
    if (isIOS7)
    {
        _slide = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    }
    else
    {
        _slide = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
    _slide.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    _slide.userInteractionEnabled = YES;
    [self.view addSubview:_slide];
    
    
    //选项按钮
    for (int i = 0;  i< [self.dataArray count]; i++) {
        //UIButton *textBt = [[UIButton alloc] initWithFrame:CGRectMake(107*i, 6, 107, 26)];
        UIButton *textBt = [[UIButton alloc] initWithFrame:CGRectMake(107*i, 0, 107, 40)];
        textBt.backgroundColor = [UIColor clearColor];
        [textBt setTitle:[self.dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [textBt addTarget:self action:@selector(gotoChange:) forControlEvents:UIControlEventTouchUpInside];
        [_slide addSubview:textBt];
        textBt.tag = 10 + i;
        
        textBt.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        //[textBt setTitleColor:[UIColor colorWithHex:@"#8c9599"] forState:UIControlStateNormal];
        [textBt setTitleColor:Text_Color_Title forState:UIControlStateNormal];
        
        
        if (i==0) {
            [textBt setTitleColor:[UIColor colorWithHex:@"#1eb5f7"] forState:UIControlStateNormal];
            _currnetPage = 0;
            _seletBt = textBt;
        }
        else if (i == 2)
        {
            //by 张正超 重启App时，显示更新数量问题处理
            //显示游戏可更新数量
            NSInteger updateCount = [[NSUserDefaults standardUserDefaults] integerForKey:KUpdateCount];
            //点击更新按钮数量
            NSInteger updateClickCount = [[NSUserDefaults standardUserDefaults] integerForKey:kClickUpdateCount];
            //点击忽略按钮数量
            NSInteger ignoreClickCount = [[NT_DownloadManager sharedNT_DownLoadManager].updateIgnoreArray count];
            
            if (updateCount > 0)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(textBt.titleLabel.right, 2, 18, 18);
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                btn.titleLabel.textAlignment = TEXT_ALIGN_CENTER;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"warn.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"warn.png"] forState:UIControlStateHighlighted];
                [textBt addSubview:btn];
                _updateBadgeValueView = btn;
                
                _updateBadgeValueView.hidden = NO;
                
                //若有可更新数量，且无更新按钮点击，无忽略按钮点击
                if (updateClickCount == 0 && ignoreClickCount == 0)
                {
                    [btn setTitle:[NSString stringWithFormat:@"%d",updateCount] forState:UIControlStateNormal];
                }
                else if (updateClickCount > 0 && ignoreClickCount == 0)
                {
                    //若所有的更新按钮点击时，就无忽略按钮点击，则显示所有点击的更新按钮的可更新数量
                    [btn setTitle:[NSString stringWithFormat:@"%d",updateClickCount] forState:UIControlStateNormal];
                }
                else if (updateClickCount == 0 && ignoreClickCount > 0)
                {
                    if (ignoreClickCount < updateCount)
                    {
                        //若无更新点击按钮，有忽略按钮点击时，且不是所有的都忽略时，显示更新数量
                        int count = updateCount - ignoreClickCount;
                        [btn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
                    }
                    else
                    {
                        //若所有忽略按钮点击，则隐藏红色更新提示
                        _updateBadgeValueView.hidden = YES;
                    }
                }
                else if (updateClickCount > 0 && ignoreClickCount > 0)
                {
                    //若有更新按钮点击，也有忽略按钮点击，则更新数量为总更新数量-忽略更新数量
                    int count = updateCount - ignoreClickCount;
                    [btn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
    [_slide addSubview:lineView];
    
    //滑动线
    UIView *lineShow = [[UIView alloc] initWithFrame:CGRectMake(0, 37, 107, 3)];
    lineShow.backgroundColor = [UIColor colorWithHex:@"#1eb5f7"];
    lineShow.tag = 100;
    [_slide addSubview:lineShow];
    //by thilong
    [self loadScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //by thilong
    //[self loadScrollView];
    
    //判断网络问题，若无网络，则底部红色提示
    NSString *networkStatus = [[NSUserDefaults standardUserDefaults] objectForKey:KNetworkTipStatus];
    NSLog(@"network status:%@",networkStatus);
    if (networkStatus&&[networkStatus isEqualToString:NETNOTWORKING])
    {
        //无网络提示
        [self bottomInfoLabel:@"网络连接异常，无法开始任务"];
    }
    else
    {
        //移除无网络提示
        [self dismissBottomRedInfo:@"网络连接异常，无法开始任务"];
    }
    
    //无剩余空间提示
    [self noSpaceTip];
}

//无剩余空间提示
- (void)noSpaceTip
{
    //刷新头部空间剩余
    [_headerView refreshHeaderData];
    
    //判断存储空间是否足够
    NSNumber *freeSpace = [[NT_DownloadManager sharedNT_DownLoadManager] getSpaceSize];
    
    NSLog(@"剩余freeSpace:%@",freeSpace);
    if ([freeSpace floatValue] <= 1024)
    {
        //底部红色空间不足提示
        [self bottomInfoLabel:@"抱歉内存不足，无法下载/安装任务"];
    }
    else
    {
        //去掉底部红色空间不足提示
        [self dismissBottomRedInfo:@"抱歉内存不足，无法下载/安装任务"];
    }
}

- (void)loadScrollView
{
    //顶部-剩余空间
    //_headerView = [[NT_HeaderView alloc] initWithFrame:CGRectMake(0, _slide.bottom, SCREEN_WIDTH, 74)];
    _headerView = [[NT_HeaderView alloc] initWithFrame:CGRectMake(0, _slide.bottom, SCREEN_WIDTH, 48)];
    //刷新剩余空间数据
    [_headerView refreshHeaderData];
    //按钮点击后松开事件
    [_headerView.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.allStartButton addTarget:self action:@selector(allStartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headerView];
    
    //滚动条
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-(44+36+49+20+48))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.autoresizesSubviews = NO;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*[self.dataArray count], _scrollView.frame.size.height);
    
    //无下载中任务默认图片
    _noDownloadingImg = [UIImageView imageViewWithName:@"no-downloading.png"];
    _noDownloadedImg = [UIImageView imageViewWithName:@"no-finished.png"];
    _noUpdateImg = [UIImageView imageViewWithName:@"no-update.png"];
    CGRect imgFrame = _noDownloadingImg.frame;
    imgFrame.origin.y = (_scrollView.height - _noDownloadingImg.frame.size.height) / 2;
    imgFrame.origin.x = (_scrollView.width - _noDownloadingImg.frame.size.width) / 2;
    NSLog(@"downloading x:%f",imgFrame.origin.x);
    [_scrollView addSubview:_noDownloadingImg];
    
    _noDownloadingImg.frame = imgFrame;
    _noDownloadingImg.hidden = YES;
    
    //无下载完成任务默认图片
    imgFrame = _noDownloadedImg.frame;
    imgFrame.origin.y = (_scrollView.height - _noDownloadedImg.frame.size.height) / 2;
    imgFrame.origin.x = (_scrollView.width - _noDownloadedImg.frame.size.width) / 2 + _scrollView.width;
    NSLog(@"finished x:%f",imgFrame.origin.x);
    [_scrollView addSubview:_noDownloadedImg];
    
    _noDownloadedImg.frame = imgFrame;
    _noDownloadedImg.hidden = YES;
    
    //无可更新任务默认图片
    imgFrame = _noUpdateImg.frame;
    imgFrame.origin.y = (_scrollView.height - _noUpdateImg.frame.size.height) / 2;
    imgFrame.origin.x = (_scrollView.width - _noUpdateImg.frame.size.width) / 2 + _scrollView.width * 2;
    [_scrollView addSubview:_noUpdateImg];
    _noUpdateImg.frame = imgFrame;
    _noUpdateImg.hidden = YES;
    
    NSLog(@"update x:%f",imgFrame.origin.x);
    
    //下载中
    _downloadingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height)];
    _downloadingTableView.backgroundColor = [UIColor whiteColor];
    _downloadingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _downloadingTableView.tag = 200;
    _downloadingTableView.opaque = YES;
    _downloadingTableView.alpha = 1.0;
    _downloadingTableView.delegate = self;
    _downloadingTableView.dataSource = self;
    _downloadingTableView.separatorColor = [UIColor colorWithHex:@"#f0f0f0"];
    //ios7表格线会变短，将表格线变长
    if ([_downloadingTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_downloadingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [_scrollView addSubview:_downloadingTableView];
    
    [Utile setExtraCellLineHidden:_downloadingTableView];
}

//底部弹出红色信息
- (UILabel *)bottomInfoLabel:(NSString *)info
{
    //底部弹出红色信息
    UILabel *_bottomInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scrollView.height-23, SCREEN_WIDTH, 21)];
    _bottomInfoLabel.backgroundColor = [UIColor redColor];
    _bottomInfoLabel.textColor = [UIColor whiteColor];
    _bottomInfoLabel.textAlignment = TEXT_ALIGN_CENTER;
    _bottomInfoLabel.text = info;
    _bottomInfoLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.scrollView addSubview:_bottomInfoLabel];
    return _bottomInfoLabel;
}

#pragma mark --
#pragma mark -- NT_DownLoadManagerDelegate Delegate Method
- (void)shouldTipMemoryNotEnough
{
    //无内存时提示
    [self noSpaceTip];
    /*
     UILabel *infoLabel = [self bottomInfoLabel:@"抱歉内存不足，无法下载/安装"];
     [self.view perform:^{
     [infoLabel removeFromSuperview];
     } afterDelay:3];
     */
}

//设置里开启“只在Wifi下载”，将暂停所有正在下载的任务
- (void)checkNetConnection:(NT_DownloadManager *)downLoadManager
{
    NSString *netConnection = [[NT_HttpEngine sharedNT_HttpEngine] getCurrentNet];
    
    //存储下载网络状态
    [[NSUserDefaults standardUserDefaults] setObject:netConnection forKey:KNetworkTipStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([NT_SettingManager onlyDownloadUseWifi] && ![netConnection isEqualToString:NETWORKVIAWIFI] && ![netConnection isEqualToString:NETNOTWORKING]) {
        
        [self dismissBottomRedInfo:@"网络连接异常，无法开始任务"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //by thilong
            //全部暂停
            //[self pauseAll];
            [self pauseAllByNetWorkChange];
        });
        
        
    }
    
    if ([netConnection isEqualToString:NETNOTWORKING])
    {
        //无网络时，底部红色提示，且只在下载中显示
        [self bottomInfoLabel:@"网络连接异常，无法开始任务"];
        /*
         UILabel *infoLabel = [self bottomInfoLabel:@"网络连接异常，无法开始任务"];
         
         [self.view perform:^{
         [infoLabel removeFromSuperview];
         } afterDelay:3];
         */
        
        //断网时，所有正在下载的任务将暂停在“正在下载”任务栏里
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //by thilong
            //全部暂停
            //[self pauseAll];
            [self pauseAllByNetWorkChange];
            
        });
    }
    else
    {
        [self dismissBottomRedInfo:@"网络连接异常，无法开始任务"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //by thilong
            //开启网络，将所有暂停的任务开启
            //[self startAll];
            [self startAllByNetWorkChange];
        });
    }
}


//移除底部提示信息
- (void)dismissBottomRedInfo:(NSString *)info
{
    //因为“网络连接异常"，加载了两次，所以需要循环删除，底部红色提示消失
    for (int i = 0;i < [self.scrollView.subviews count];i++)
    {
        if ([[self.scrollView.subviews objectAtIndex:i] isKindOfClass:[UILabel class]])
        {
            UILabel *infoLabel = (UILabel *)[self.scrollView.subviews objectAtIndex:i];
            NSRange range = [infoLabel.text rangeOfString:info];
            if (range.location != NSNotFound)
            {
                [infoLabel removeFromSuperview];
            }
        }
    }
    
}

//全部暂停
- (void)pauseAll
{
    //by thilong.正确的多线程同步
    @synchronized(self)
    {
        NSArray *dataArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
        for (int i = 0; i<dataArray.count; i++)
        {
            //全部暂停
            NT_DownloadModel *model = [dataArray objectAtIndex:i];
            if (model.loadType == LOADING || model.loadType == WAITEDOWNLOAD  || model.loadType == DOWNFAILEDWITHUNCONNECT)
            {
                //by thilong ,只是变更了状态，但没有真正停止
                if (model.operation != nil) {
                    [model.operation cancel];
                    model.operation = nil;
                }
                model.loadType = PAUSE;
                [[NT_DownloadManager sharedNT_DownLoadManager] pauseAllDownLoadWithModel:model];
            }
        }
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
    }
}

//by thilong
- (void)pauseAllByNetWorkChange{
    NSArray *dataArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
    for (int i = 0; i<dataArray.count; i++)
    {
        //全部暂停
        NT_DownloadModel *model = [dataArray objectAtIndex:i];
        if (model.loadType == LOADING || model.loadType == WAITEDOWNLOAD  || model.loadType == DOWNFAILEDWITHUNCONNECT)
        {
            
            model.loadType = PAUSE;
            model.pausedByNetworkChange = true;
            [[NT_DownloadManager sharedNT_DownLoadManager] pauseAllDownLoadWithModel:model];
        }
    }
    [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
}

//全部开始
- (void)startAll
{
    //by thilong.多线程同步
    @synchronized(self){
        NSArray *dataArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
        for (int i = 0; i<dataArray.count; i++)
        {
            NT_DownloadModel *model = [dataArray objectAtIndex:i];
            if (model.loadType == PAUSE)
            {
                model.loadType = LOADING;
                [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:nil];
            }
        }
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
    }
}

//by thilong
- (void)startAllByNetWorkChange{
    NSArray *dataArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
    for (int i = 0; i<dataArray.count; i++)
    {
        NT_DownloadModel *model = [dataArray objectAtIndex:i];
        if (model.loadType == PAUSE && model.pausedByNetworkChange)
        {
            model.loadType = LOADING;
            model.pausedByNetworkChange = false;
            [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:nil];
        }
    }
    [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
    [self startAll];
}

//按钮按下后松开事件
#pragma mark - NT_HearderViewDelegate Delegate Methods

- (void)editButtonPressed:(UIButton *)btn
{
    //编辑按钮
    btn.selected = !btn.selected;
    if(_scrollView.contentOffset.x == 0)
    {
        _downloadingEidting = btn.selected;
        [self RefreshDownloadingStatus];
    }
    else if(_scrollView.contentOffset.x == SCREEN_WIDTH)
    {
        _finishedEditing = btn.selected;
        [self RefreshFinishedStatus];
    }
    else if(_scrollView.contentOffset.x == SCREEN_WIDTH*2)
    {
        _updateEditing = btn.selected;
        [self RefreshUpdateStatus];
    }
    
    return;
    if (btn.selected)
    {
        //设置按钮状态为删除
        [[NSUserDefaults standardUserDefaults] setObject:@"删除" forKey:KDownloadingStauts];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //取消按钮
        [_customButtonStyle customButton:btn title:@"取消" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"]  highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        
        if (_scrollView.contentOffset.x == 0 || _scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //全部删除按钮
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
        }
        else
        {
            //更新时-全部忽略按钮
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部忽略" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
            
        }
        
        //列表删除
        if (_scrollView.contentOffset.x == 0)
        {
            /*
             不能循环表的可见列的数据，因为不会全部加载所有数据，且会表格的信息会重叠。 for (NSIndexPath *cellIndex in [self.shoppingTableView indexPathsForVisibleRows] ){}。所以，需要循环表的所有行。
             */
            //循环1个分区内的所有列数据，
            if (_scrollView.contentOffset.x == 0)
            {
                /* by thilong
                 //下载中-删除按钮
                 for (int i = 0; i<[self.downloadingTableView numberOfRowsInSection:0]; i++)
                 {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                 NT_DownloadingCell *cell = (NT_DownloadingCell *)[self.downloadingTableView cellForRowAtIndexPath:indexPath];
                 
                 UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
                 
                 [_customButtonStyle customButton:downloadButton title:@"删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
                 
                 NT_DownloadModel *model = (NT_DownloadModel *)[[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray objectAtIndex:i];
                 model.buttonStatus = deleteOn;
                 [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
                 }
                 */
                
                NSMutableArray *downloadingArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
                for(NT_DownloadModel *model in downloadingArray){
                    model.buttonStatus = deleteOn;
                }
                [self.downloadingTableView reloadData];
            }
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //by thilong. 2014-04-10
            NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
            for(NT_DownloadModel *model in array){
                model.buttonStatus = deleteOn;
            }
            array = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
            for(NT_DownloadModel *model in array){
                model.buttonStatus = deleteOn;
            }
            [self.finishedTableView reloadData];
            
            //by thilong. 2014-04-10
            /*
             for (int i = 0; i < [self.finishedTableView numberOfSections]; i++)
             {
             for (int j = 0; j<[self.finishedTableView numberOfRowsInSection:i]; j++)
             {
             //下载完成- 删除按钮
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
             NT_FinishedCell *cell = (NT_FinishedCell *)[self.finishedTableView cellForRowAtIndexPath:indexPath];
             
             if ([cell isKindOfClass:[NT_FinishedCell class]])
             {
             NT_DownloadModel *model = (NT_DownloadModel *)cell.model;
             model.buttonStatus = deleteOn;
             [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
             
             UIButton *finishedButton = (UIButton *)[cell.contentView viewWithTag:KFinishedInstallButtonTag];
             finishedButton.hidden = NO;
             
             [_customButtonStyle customButton:finishedButton title:@"删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
             }
             
             
             }
             
             }*/
        }
        else
        {
            //可更新-忽略按钮
            for (int i = 0; i < [self.updateTableView numberOfRowsInSection:0]; i++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NT_UpdateCell *cell = (NT_UpdateCell *)[self.updateTableView cellForRowAtIndexPath:indexPath];
                UIButton *updateButton = (UIButton *)[cell.contentView viewWithTag:KFinishedInstallButtonTag];
                
                [_customButtonStyle customButton:updateButton title:@"忽略" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
            }
            //全部忽略
            self.isAllIgnore = YES;
        }
        
    }
    else
    {
        
        //设置按钮状态为不删除
        [[NSUserDefaults standardUserDefaults] setObject:@"改变" forKey:KDownloadingStauts];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (_scrollView.contentOffset.x == 0)
        {
            //下载中
            //编辑按钮
            [_customButtonStyle customButton:btn title:@"编辑" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            if([[NT_DownloadManager sharedNT_DownLoadManager] anyDownloading]){
                //暂停按钮
                [_customButtonStyle customButton:_headerView.allStartButton title:@"全部暂停" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            }
            else{
                //全部开始按钮
                [_customButtonStyle customButton:_headerView.allStartButton title:@"全部开始" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            }
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //下载完成
            //编辑按钮
            [_customButtonStyle customButton:btn title:@"编辑" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            
            //全部删除按钮
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-light-read.png"] highlightedImage:[UIImage imageNamed:@"btn-light-read.png"]];
            
            /*
             _headerView.allStartButton = [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
             */
            //_headerView.allStartButton.userInteractionEnabled = NO;
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2)
        {
            self.isAllIgnore = NO;
            //更新时
            //忽略按钮
            [_customButtonStyle customButton:btn title:@"忽略" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            
            //全部更新按钮
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部更新" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            
        }
        
        //循环所有列表，改变按钮状态
        //列表取消
        /*
         不能循环表的可见列的数据，因为不会全部加载所有数据，且会表格的信息会重叠。 for (NSIndexPath *cellIndex in [self.shoppingTableView indexPathsForVisibleRows] ){}。所以，需要循环表的所有行。
         */
        //循环1个分区内的所有列数据，
        if (_scrollView.contentOffset.x == 0)
        {
            
            NSMutableArray *downloadingArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
            for(NT_DownloadModel *model in downloadingArray){
                
                if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
                {
                    model.buttonStatus = pauseOn;
                }
                else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
                {
                    model.buttonStatus = loadOn;
                }
                else if (model.loadType == WAITEDOWNLOAD)
                {
                    model.loadType = WAITEDOWNLOAD;
                    model.buttonStatus = waiteOn;
                }
                else if (model.loadType == DOWNFAILED || model.loadType == ISMUCHMONEYFIELD)
                {
                    model.buttonStatus = loadOn;
                }
                else if (model.loadType == ISUNLITMTGOLD)
                {
                    model.buttonStatus = waiteOn;
                }
                [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            }
            [self.downloadingTableView reloadData];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            /*
             
             for (int i = 0; i<[self.downloadingTableView numberOfRowsInSection:0]; i++)
             {
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
             NT_DownloadingCell *cell = (NT_DownloadingCell *)[self.downloadingTableView cellForRowAtIndexPath:indexPath];
             
             UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
             
             NT_DownloadModel *model = cell.model;
             if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
             {
             //若任务是下载时，暂停下载任务
             
             model.buttonStatus = pauseOn;
             [_customButtonStyle customButton:downloadButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
             
             }
             else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
             {
             //若任务时暂停的，则开始下载任务
             
             [_customButtonStyle customButton:downloadButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             model.buttonStatus = loadOn;
             }
             else if (model.loadType == WAITEDOWNLOAD)
             {
             //等待下载，不做处理
             model.loadType = WAITEDOWNLOAD;
             
             [_customButtonStyle customButton:downloadButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
             model.buttonStatus = waiteOn;
             }
             else if (model.loadType == DOWNFAILED || model.loadType == ISMUCHMONEYFIELD)
             {
             //若任务是失败的，则重新下载
             
             [_customButtonStyle customButton:downloadButton title:@"重下" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             model.buttonStatus = loadOn;
             }
             else if (model.loadType == ISUNLITMTGOLD)
             {
             //无限金币
             [_customButtonStyle customButton:downloadButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
             model.buttonStatus = waiteOn;
             }
             [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
             }*/
            
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //by thilong. 2014-04-10
            NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
            for(NT_DownloadModel *model in array){
                model.buttonStatus = waiteOn;
            }
            array = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
            for(NT_DownloadModel *model in array){
                model.buttonStatus = reInstallOn;
            }
            [self.finishedTableView reloadData];
            /*
             for (int i = 0; i < [self.finishedTableView numberOfSections]; i++)
             {
             for (int j = 0; j<[self.finishedTableView numberOfRowsInSection:i]; j++)
             {
             //下载完成-未安装 改变按钮
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
             
             UITableViewCell *cell = [self.finishedTableView cellForRowAtIndexPath:indexPath];
             if ([cell isKindOfClass:[NT_FinishedCell class]])
             {
             NT_FinishedCell *finishedCell = (NT_FinishedCell *)cell;
             UIButton *finishedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
             
             NT_DownloadModel *model = finishedCell.model;
             if (model.loadType == FINISHED || model.loadType == WAITEINSTALL)
             {
             
             [_customButtonStyle customButton:finishedButton title:@"安装" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             }
             else if (model.loadType == INSTALLFINISHED)
             {
             finishedButton.hidden = YES;
             }
             else if (model.loadType == INSTALLFAILED)
             {
             model.buttonStatus = reInstallOn;
             [_customButtonStyle customButton:finishedButton title:@"重装" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             }
             }
             
             }
             }*/
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2)
        {
            for (int i = 0; i<[self.updateTableView numberOfRowsInSection:0]; i++)
            {
                //可更新-改变所有按钮状态
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NT_UpdateCell *cell = (NT_UpdateCell *)[self.updateTableView cellForRowAtIndexPath:indexPath];
                UIButton *updateButton = (UIButton *)[cell.contentView viewWithTag:KFinishedInstallButtonTag];
                
                
                [_customButtonStyle customButton:updateButton title:@"更新" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            }
        }
    }
}

//全部开始-全部删除
- (void)allStartButtonPressed:(UIButton *)btn
{
    if ([_headerView.editButton.titleLabel.text isEqualToString:@"取消"])
    {
        if (_scrollView.contentOffset.x == 0)
        {
            //下载中-全部删除
            [_customButtonStyle customButton:btn title:@"全部删除" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"]  highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"] ];
            
            if ([[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray count]>0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除任务" message:@"您确定要删除全部任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //下载完成-全部删除
            [_customButtonStyle customButton:btn title:@"全部删除" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"]  highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"] ];
            
            if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]>0 || [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]>0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除任务" message:@"您确定要删除全部任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2)
        {
            //更新-全部忽略
            [_customButtonStyle customButton:btn title:@"全部忽略" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"]  highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
            
            
            if ([[NT_DownloadManager sharedNT_DownLoadManager].updateListArray count] > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除任务" message:@"您确定要忽略全部任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }
    else
    {
        if (_scrollView.contentOffset.x == 0)
        {
            //by thilong.添加同步锁，以防止切换时的崩溃
            //@synchronized(self){
            //by thilong.IMPORTANT 同步锁移动到正确的地方。
            //by thilong. 2014-04-10,状态没有切换成功时禁止下一次切换
            if(!_canActionDownloadingToggle)
                return;
            {
                //下载中
                //开始全部下载
                if ([btn.titleLabel.text isEqualToString:@"全部开始"])
                {
                    [btn setTitle:@"全部暂停" forState:UIControlStateNormal];
                    if (_scrollView.contentOffset.x == 0)
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            //by thilong. 2014-04-10
                            _canActionDownloadingToggle = NO;
                            //全部开始
                            [self startAll];
                            _canActionDownloadingToggle = YES;
                            /*  by thilong. 每一行的样式都会不断更新，不需要每一行去做变化。
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                             
                             for (int i = 0; i<[self.downloadingTableView numberOfRowsInSection:0]; i++)
                             {
                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                             NT_DownloadingCell *cell = (NT_DownloadingCell *)[self.downloadingTableView cellForRowAtIndexPath:indexPath];
                             
                             UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
                             
                             [_customButtonStyle customButton:downloadButton title:@"暂停" titleColor:Text_Color  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
                             
                             }
                             });
                             */
                        });
                        
                    }
                }
                else if([btn.titleLabel.text isEqualToString:@"全部暂停"])
                {
                    [btn setTitle:@"全部开始" forState:UIControlStateNormal];
                    if (_scrollView.contentOffset.x == 0)
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            //by thilong. 2014-04-10
                            _canActionDownloadingToggle = NO;
                            //全部暂停
                            [self pauseAll];
                            _canActionDownloadingToggle = YES;
                            /*by thilong.原因同上
                             dispatch_async(dispatch_get_main_queue(), ^{
                             
                             for (int i = 0; i<[self.downloadingTableView numberOfRowsInSection:0]; i++)
                             {
                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                             NT_DownloadingCell *cell = (NT_DownloadingCell *)[self.downloadingTableView cellForRowAtIndexPath:indexPath];
                             
                             UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
                             
                             [_customButtonStyle customButton:downloadButton title:@"继续" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
                             
                             }
                             }); */
                        });
                        
                    }
                    
                }
            }
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            [_customButtonStyle customButton:btn title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-light-read.png"] highlightedImage:[UIImage imageNamed:@"btn-light-read.png"]];
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH * 2)
        {
            //全部更新
            for (NT_UpdateAppInfo *updateInfo in [NT_DownloadManager sharedNT_DownLoadManager].updateListArray)
            {
                if (updateInfo.updateState == 0)
                {
                    NT_DownloadModel *model = [[NT_DownloadModel alloc] initWithAddress:updateInfo.download_addr andGameName:updateInfo.game_name andRoundPic:updateInfo.iconName andVersion:updateInfo.version_name andAppID:updateInfo.appId];
                    model.package = updateInfo.package;
                    model.isUpdateModel = YES;
                    //更新
                    [[NT_DownloadManager sharedNT_DownLoadManager] downLoadWithModel:model];
                }
            }
            [self refreshUpdateView:nil];
        }
    }
}


#pragma mark - UIAlertView  Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //全部编辑
        [_customButtonStyle customButton: _headerView.editButton  title:@"编辑" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
        _headerView.editButton.selected = NO;
        
        
        if (_scrollView.contentOffset.x == 0)
        {
            //全部开始按钮
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部开始" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-light-read.png"] highlightedImage:[UIImage imageNamed:@"btn-light-read.png"]];
            
        }
        else
        {
            //可更新
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部更新" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
            
        }
        
        if (_scrollView.contentOffset.x == 0)
        {
            NSMutableArray *arr = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
            //下载中-全部删除
            for (int i = 0; i < arr.count; i++)
            {
                NT_DownloadModel *model = (NT_DownloadModel *)[arr objectAtIndex:i];
                //by thilong,需要停止
                [[NT_DownloadManager sharedNT_DownLoadManager] cancelDownloading:model];
                if (model.savePlistPath)
                {
                    //删除plist文件
                    [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
                }
                //删除ipa文件
                [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
            }
            [[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray removeAllObjects];
            [[NT_DownloadManager sharedNT_DownLoadManager] somethingRemoved];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            
            _downloadingEidting = NO;
            [self RefreshDownloadingStatus];
            //[self.downloadingTableView reloadData];
            
        }
        else if (_scrollView.contentOffset.x == SCREEN_WIDTH)
        {
            //下载完成-全部删除
            NSMutableArray *arr = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
            NSMutableArray *installedArr = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
            for (int i = 0; i<arr.count; i++)
            {
                NT_DownloadModel *model = (NT_DownloadModel *)[arr objectAtIndex:i];
                if (model.savePlistPath)
                {
                    //删除plist文件
                    [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
                }
                //删除ipa文件
                [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
            }
            for (int i= 0; i<installedArr.count; i++)
            {
                NT_DownloadModel *model = (NT_DownloadModel *)[installedArr objectAtIndex:i];
                if (model.savePlistPath)
                {
                    //删除plist文件
                    [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
                }
                //删除ipa文件
                [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
            }
            [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray removeAllObjects];
            [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray removeAllObjects];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            [self.finishedTableView reloadData];
        }
        else
        {
            //可更新-全部忽略
            //将所有忽略存入忽略归档里
            [NT_DownloadManager sharedNT_DownLoadManager].updateIgnoreArray = [NT_DownloadManager sharedNT_DownLoadManager].updateListArray ;
            [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray removeAllObjects];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            [self.updateTableView reloadData];
            [self refreshApplicationIconBadgeNumber];
            
        }
    }
    else
    {
        return;
    }
}

#pragma mark - UITableView Data Source Methods And Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == self.downloadingTableView.tag)
    {
        return 1;
    }
    else if (tableView.tag == self.finishedTableView.tag)
    {
        return 1;
        /*
         _noDownloadedImg.hidden = YES;
         _finishedTableView.hidden = NO;
         
         
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count] >0 && [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count] > 0)
         {
         return 2;
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count] >0)
         {
         return 1;
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count] > 0)
         {
         return 1;
         }
         else
         {
         //无下载完成任务时，显示图片
         _noDownloadedImg.hidden = NO;
         _finishedTableView.hidden = YES;
         }
         */
    }
    else if (tableView.tag == self.updateTableView.tag)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == self.downloadingTableView.tag)
    {
        int co = [[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray count];
        if(co>0)
        {
            _noDownloadingImg.hidden = YES;
            _downloadingTableView.hidden = NO;
        }
        else{
            _noDownloadingImg.hidden = NO;
            _downloadingTableView.hidden = YES;
        }
        return co;
    }
    else if (tableView.tag == self.finishedTableView.tag)
    {
        int co =  [[NT_DownloadManager sharedNT_DownLoadManager]. downFinishedArray count];
        if (co > 0)
        {
            _noDownloadedImg.hidden = YES;
            _finishedTableView.hidden = NO;
            
        }
        else
        {
            _noDownloadedImg.hidden = NO;
            _finishedTableView.hidden = YES;
            
        }
        return co;
        /*
         _noDownloadedImg.hidden = YES;
         _finishedTableView.hidden = NO;
         
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]>0&&[[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]>0)
         {
         if (section == 0)
         {
         //未安装的游戏
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count])
         {
         return [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count] + 1;
         }
         }
         else if (section == 1)
         {
         //已安装游戏
         if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count])
         {
         return [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count] + 1;
         }
         }
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]>0)
         {
         //未安装的游戏
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count])
         {
         return [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count] + 1;
         }
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]>0)
         {
         //已安装游戏
         if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count])
         {
         return [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count] + 1;
         }
         }
         else
         {
         _noDownloadedImg.hidden = NO;
         _finishedTableView.hidden = YES;
         }
         */
    }
    else if (tableView.tag == self.updateTableView.tag)
    {
        //更新
        //return [self.updateMutArray count];
        int co= [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray count];
        if(co>0)
        {
            _noUpdateImg.hidden = YES;
            _updateTableView.hidden = NO;
        }
        else
        {
            _noUpdateImg.hidden = NO;
            _updateTableView.hidden = YES;
        }
        return co;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == self.downloadingTableView.tag)
    {
        static NSString *cellID = @"downloadingCell";
        NT_DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[NT_DownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.spaceDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.downloadStautsButton addTarget:self action:@selector(downloadStautsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        //刷新游戏下载中信息
        NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray objectAtIndex:indexPath.row];
        cell.model = model;
        [cell refreshDataWith:model];
        return cell;
    }
    else if (tableView.tag == self.finishedTableView.tag)
    {
        if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count] > 0)
        {
            static NSString *cellName = @"finishedCell1";
            NT_FinishedCell *finishedCell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!finishedCell)
            {
                finishedCell = [[NT_FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                finishedCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
                [installedButton addTarget:self action:@selector(installedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray objectAtIndex:indexPath.row];
            finishedCell.model = model;
            model.isFinishedModel = YES;
            [finishedCell refreshFinishedData:model];
            return finishedCell;
            
        }
        /*
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]>0&&[[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]>0)
         {
         if (indexPath.section == 0)
         {
         if (indexPath.row == 0)
         {
         //未安装
         static NSString *cellName = @"headCell1";
         NT_FinishedHeaderCell *headerCell  = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!headerCell) {
         headerCell = [[NT_FinishedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count])
         {
         UILabel *headerLabel = (UILabel *)[headerCell.contentView viewWithTag:KFinishedHeadCellTag];
         headerLabel.text = [NSString stringWithFormat:@"未安装(%d)",[[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]];
         }
         return headerCell;
         }
         else
         {
         NSInteger currentRow = indexPath.row-1;
         if (currentRow<0) {
         currentRow=0;
         }
         static NSString *cellName = @"finishedCell1";
         NT_FinishedCell *finishedCell = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!finishedCell)
         {
         finishedCell = [[NT_FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         finishedCell.selectionStyle = UITableViewCellSelectionStyleNone;
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [installedButton addTarget:self action:@selector(installedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
         }
         NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray objectAtIndex:currentRow];
         finishedCell.model = model;
         model.isFinishedModel = YES;
         [finishedCell refreshFinishedData:model];
         return finishedCell;
         }
         }
         else
         {
         if (indexPath.row == 0)
         {
         //未安装
         static NSString *cellName = @"headCell2";
         NT_FinishedHeaderCell *headerCell  = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!headerCell) {
         headerCell = [[NT_FinishedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count])
         {
         UILabel *headerLabel = (UILabel *)[headerCell.contentView viewWithTag:KFinishedHeadCellTag];
         headerLabel.text = [NSString stringWithFormat:@"已安装(%d)",[[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]];
         }
         return headerCell;
         }
         else
         {
         NSInteger currentRow = indexPath.row-1;
         if (currentRow<0) {
         currentRow=0;
         }
         static NSString *cellName = @"finishedCell2";
         NT_FinishedCell *finishedCell = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!finishedCell)
         {
         finishedCell = [[NT_FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         finishedCell.selectionStyle = UITableViewCellSelectionStyleNone;
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [installedButton addTarget:self action:@selector(installedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
         }
         NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray objectAtIndex:currentRow];
         finishedCell.model = model;
         model.isFinishedModel = YES;
         [finishedCell refreshFinishedData:model];
         return finishedCell;
         }
         
         }
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]>0)
         {
         if (indexPath.row == 0)
         {
         //未安装
         static NSString *cellName = @"headCell3";
         NT_FinishedHeaderCell *headerCell  = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!headerCell) {
         headerCell = [[NT_FinishedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         if ([[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count])
         {
         UILabel *headerLabel = (UILabel *)[headerCell.contentView viewWithTag:KFinishedHeadCellTag];
         headerLabel.text = [NSString stringWithFormat:@"未安装(%d)",[[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray count]];
         }
         return headerCell;
         }
         else
         {
         NSInteger currentRow = indexPath.row-1;
         if (currentRow<0) {
         currentRow=0;
         }
         static NSString *cellName = @"finishedCell3";
         NT_FinishedCell *finishedCell = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!finishedCell)
         {
         finishedCell = [[NT_FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         finishedCell.selectionStyle = UITableViewCellSelectionStyleNone;
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [installedButton addTarget:self action:@selector(installedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
         
         }
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [_customButtonStyle customButton:installedButton title:@"重装" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
         
         NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray objectAtIndex:currentRow];
         finishedCell.model = model;
         model.isFinishedModel = YES;
         [finishedCell refreshFinishedData:model];
         return finishedCell;
         }
         
         }
         else if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]>0)
         {
         if (indexPath.row == 0)
         {
         //未安装
         static NSString *cellName = @"headCell4";
         NT_FinishedHeaderCell *headerCell  = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!headerCell) {
         headerCell = [[NT_FinishedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
         if ([[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count])
         {
         UILabel *headerLabel = (UILabel *)[headerCell.contentView viewWithTag:KFinishedHeadCellTag];
         headerLabel.text = [NSString stringWithFormat:@"已安装(%d)",[[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray count]];
         }
         return headerCell;
         }
         else
         {
         NSInteger currentRow = indexPath.row-1;
         if (currentRow<0) {
         currentRow=0;
         }
         static NSString *cellName = @"finishedCell4";
         NT_FinishedCell *finishedCell = [tableView dequeueReusableCellWithIdentifier:cellName];
         if (!finishedCell)
         {
         finishedCell = [[NT_FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
         finishedCell.selectionStyle = UITableViewCellSelectionStyleNone;
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [installedButton addTarget:self action:@selector(installedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
         }
         
         UIButton *installedButton = (UIButton *)[finishedCell.contentView viewWithTag:KFinishedInstallButtonTag];
         [_customButtonStyle customButton:installedButton title:@"重装" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
         
         NT_DownloadModel *model = [[NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray objectAtIndex:currentRow];
         finishedCell.model = model;
         model.isFinishedModel = YES;
         [finishedCell refreshFinishedData:model];
         return finishedCell;
         }
         }
         */
    }
    else
    {
        static NSString *cellName = @"updateTableCell";
        NT_UpdateCell *updateCell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!updateCell)
        {
            updateCell = [[NT_UpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            updateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //更新按钮
            UIButton *updateButton = (UIButton *)[updateCell.contentView viewWithTag:KFinishedInstallButtonTag];
            [updateButton addTarget:self action:@selector(updateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
        [updateCell refreshUpdateData:updateInfo isOpenUpdate:self.isOpenUpdate isAllIgnore:self.isAllIgnore];
        
        
        //If this is the selected index then calculate the height of the cell based on the amount of text we have
        if (self.currentRow == indexPath.row)
        {
            CGFloat updateInfoHeight = [self getUpdateInfoHeightForIndex:indexPath.row updateInfo:updateInfo];
            
            UILabel *updateLabel = (UILabel *)[updateCell.contentView viewWithTag:KUpdateInfoTag];
            updateLabel.frame = CGRectMake(10, 71, SCREEN_WIDTH - 20, updateInfoHeight);
            updateLabel.text = updateInfo.news_version;
        }
        else
        {
            //Otherwise just return the minimum height for the label.
            UILabel *updateLabel = (UILabel *)[updateCell.contentView viewWithTag:KUpdateInfoTag];
            updateLabel.frame = CGRectZero;
        }
        return updateCell;
    }
    return nil;
    
}

//获取展开更新信息高度
- (CGFloat)getUpdateInfoHeightForIndex:(NSInteger)index updateInfo:(NT_UpdateAppInfo *)updateInfo
{
    NSString *info = updateInfo.news_version;
    CGSize size = CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT);
    CGSize maxSize = [info sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:size lineBreakMode:LINE_BREAK_WORD_WRAP];
    return maxSize.height;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == self.updateTableView.tag)
    {
        //We only don't want to allow selection on any cells which cannot be expanded
        NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
        if ([self getUpdateInfoHeightForIndex:indexPath.row updateInfo:updateInfo])
        {
            return indexPath;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == self.updateTableView.tag)
    {
        //The user is selecting the cell which is currently expanded
        //we want to minimize it back
        if (self.currentRow == indexPath.row)
        {
            self.currentRow = -1;
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            return;
        }
        
        //First we check if a cell is already expanded.
        //If it is we want to minimize make sure it is reloaded to minimize it back
        if (self.currentRow >= 0)
        {
            NSIndexPath *previousPath = [NSIndexPath indexPathForRow:self.currentRow inSection:0];
            
            self.currentRow = indexPath.row;
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
        
        //Finally set the selected index to the new selection and reload it to expand
        self.currentRow = indexPath.row;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        /*
         //展开更新信息
         self.isOpenUpdate = YES;
         //记录当前需要展开更新信息的行数，heightForRowAtIndexPath改变行高
         self.currentRow = indexPath.row;
         [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         */
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == self.downloadingTableView.tag)
    {
        return 71;
    }
    else if (tableView.tag == self.finishedTableView.tag)
    {
        return 71;
        /*
         if (indexPath.row == 0)
         {
         return 30;
         }
         else
         {
         return 80;
         }
         */
    }
    else if (tableView.tag == self.updateTableView.tag)
    {
        if (self.currentRow == indexPath.row)
        {
            NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
            return [self getUpdateInfoHeightForIndex:indexPath.row updateInfo:updateInfo] + 80;
            //return self.isOpenUpdate ? [NT_UpdateCell openUpdateDetailInfo:updateInfo] : 80;
        }
        else
        {
            return 71;
        }
        
    }
    return 0;
}

#pragma mark --
#pragma mark NT_DownloadingCell Delegate Methods
//获取下载中-按钮的状态值
- (void)downloadStautsButtonPressed:(UIButton *)btn
{
    
    NT_DownloadingCell *cell = nil;
    NT_DownloadingTableView *tableView = nil;
    if (isIOS7)
    {
        cell = (NT_DownloadingCell *)btn.superview.superview.superview;
        tableView = (NT_DownloadingTableView *)cell.superview.superview;
    }
    else
    {
        cell = (NT_DownloadingCell *)btn.superview.superview;
        tableView = (NT_DownloadingTableView *)cell.superview;
    }
    
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    
    NT_DownloadModel *model = cell.model;
    
    if ([btn.titleLabel.text isEqualToString:@"删除"]) //删除一个下载
    {
        //已点击删除，停止任务
        if (model.operation != nil) {
            [model.operation cancel];
            model.operation = nil;
        }
        if (model.savePlistPath)
        {
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            //删除plist文件
            [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
        }
        //删除ipa文件
        [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
        [[NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray removeObjectAtIndex:indexPath.row];
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];

        
        [self.downloadingTableView beginUpdates];
        [self.downloadingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.downloadingTableView endUpdates];
        
        [[NT_DownloadManager sharedNT_DownLoadManager]  somethingRemoved];
        
    }
    else
    {
        // 耗时的操作
        if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
        {
            [_customButtonStyle customButton:btn title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            //by thilong
            if(model.loadType==LOADING)
            {
                if (model.operation != nil) {
                    [model.operation cancel];
                    model.operation = nil;
                }
            }
            //若任务是下载时，暂停下载任务
            model.loadType = PAUSE;
            model.buttonStatus = loadOn;
            [self reloadDownloadStatusWithRow:indexPath];
            [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            
        }
        else if (model.loadType == PAUSE)
        {
            [_customButtonStyle customButton:btn title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
            //若任务时暂停的，则开始下载任务
            model.loadType = LOADING;
            model.buttonStatus = pauseOn;
            [self reloadDownloadStatusWithRow:indexPath];
            [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        }
        //by thilong ,这里的状态不匹配
        else if (model.loadType == WAITEDOWNLOAD)
        {
            [_customButtonStyle customButton:btn title:@"继续" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            //等待下载，暂停状态
            if(model.loadType==WAITEDOWNLOAD)
            {
                if (model.operation != nil) {
                    [model.operation cancel];
                    model.operation = nil;
                }
            }
            model.loadType = PAUSE;
            model.buttonStatus = reloadOn;
            [self reloadDownloadStatusWithRow:indexPath];
        }
        else if (model.loadType == DOWNFAILED)
        {
            [_customButtonStyle customButton:btn title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];            //若任务是失败的，则重新下载
            model.loadType = LOADING;
            model.buttonStatus = pauseOn;
            [self reloadDownloadStatusWithRow:indexPath];
            [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        }
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
    }
        /*
        // 耗时的操作
        if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
        {
            [_customButtonStyle customButton:btn title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            //by thilong
            if(model.loadType==LOADING)
            {
                if (model.operation != nil) {
                    [model.operation cancel];
                    model.operation = nil;
                }
            }
            //若任务是下载时，暂停下载任务
            model.loadType = PAUSE;
            model.buttonStatus = loadOn;
            [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            
        }
        else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
        {
            [_customButtonStyle customButton:btn title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"] ];
            //若任务时暂停的，则开始下载任务
            //by thilong
            if(model.loadType==WAITEDOWNLOAD)
            {
                if (model.operation != nil) {
                    [model.operation cancel];
                    model.operation = nil;
                }
            }
            model.loadType = LOADING;
            model.buttonStatus = pauseOn;
            [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        }
        //by thilong ,这里的状态不匹配
        else if (model.loadType == WAITEDOWNLOAD)
        {
            [_customButtonStyle customButton:btn title:@"继续" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
            //等待下载，不做处理
            model.loadType = PAUSE;
            model.loadType = waiteOn;
        }
        else if (model.loadType == DOWNFAILED)
        {
            [_customButtonStyle customButton:btn title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];            //若任务是失败的，则重新下载
            model.loadType = LOADING;
            model.buttonStatus = pauseOn;
            [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
            //[[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        }
        if(indexPath)
            [self.downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        });
    }
         */
    /*
     //改变下载状态
     UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
     
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"设置" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     
     
     if (model.loadType == INSTALLFAILED)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] reStartInstallOrDelModel:model indexPath:indexPath];
     return;
     }else if (model.loadType == DOWNFAILED||model.loadType == WAITEDOWNLOAD||model.loadType == PAUSE)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] reStartDownLoadORDelModel:model indexPath:indexPath];
     return;
     }else if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] delOrPauseDownLoadWithModel:model indexPath:indexPath];
     return;
     }
     else if(model.loadType == FINISHED)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] installOrDelSoftWithModel:model indexPath:indexPath];
     return;
     }
     [[NT_DownloadManager sharedNT_DownLoadManager] delDownLoadWithModel:model indexPath:nil];
     
     }
     */
    /*
     //改变下载状态
     UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
     
     if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
     {
     //若任务是下载时，暂停下载任务
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     
     }
     else if (model.loadType == PAUSE)
     {
     //若任务时暂停的，则开始下载任务
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
     }
     else if (model.loadType == WAITEDOWNLOAD)
     {
     //等待下载，不做处理
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     }
     else if (model.loadType == DOWNFAILED)
     {
     //若任务是失败的，则重新下载
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"重下" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
     }
     
     //存储按钮
     model.changeButtonStauts = downloadButton;
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     [self.downloadingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // 耗时的操作
     if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
     {
     //若任务是下载时，暂停下载任务
     model.loadType = PAUSE;
     [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     
     }
     else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
     {
     //若任务时暂停的，则开始下载任务
     model.loadType = LOADING;
     [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     else if (model.loadType == WAITEDOWNLOAD)
     {
     //等待下载，不做处理
     model.loadType = WAITEDOWNLOAD;;
     }
     else if (model.loadType == DOWNFAILED)
     {
     //若任务是失败的，则重新下载
     model.loadType = LOADING;
     [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     });
     
     }
     
     */
    
    /*
     //改变下载状态
     UIButton *downloadButton = (UIButton *)[cell.contentView viewWithTag:KDownloadButtonTag];
     
     if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
     {
     //若任务是下载时，暂停下载任务
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"暂停" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     
     }
     else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
     {
     //若任务时暂停的，则开始下载任务
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"继续" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
     }
     else if (model.loadType == WAITEDOWNLOAD)
     {
     //等待下载，不做处理
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"等待" titleColor:Text_Color font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
     }
     else if (model.loadType == DOWNFAILED)
     {
     //若任务是失败的，则重新下载
     downloadButton = [_customButtonStyle customButton:downloadButton title:@"重下" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
     }
     */
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // 耗时的操作
     if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
     {
     //若任务是下载时，暂停下载任务
     model.loadType = PAUSE;
     [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     
     }
     else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
     {
     //若任务时暂停的，则开始下载任务
     model.loadType = LOADING;
     [[NT_DownloadManager sharedNT_DownLoadManager] startDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     else if (model.loadType == WAITEDOWNLOAD)
     {
     //等待下载，不做处理
     model.loadType = WAITEDOWNLOAD;;
     }
     else if (model.loadType == DOWNFAILED)
     {
     //若任务是失败的，则重新下载
     model.loadType = LOADING;
     [[NT_DownloadManager sharedNT_DownLoadManager] pauseDownLoadWithModel:model indexPath:indexPath];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     });
     }
     
     }
     */
}

//刷新下载状态
- (void)reloadDownloadStatusWithRow:(NSIndexPath *)indexPath
{
    if(indexPath)
    {
        [self.downloadingTableView beginUpdates];
        [self.downloadingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.downloadingTableView endUpdates];
    }
}

//下载完成-未安装、已安装 按钮
- (void)installedButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NT_FinishedCell *cell = nil;
    NT_DownloadFinishedTableView *finishedTableView = nil;
    if (isIOS7)
    {
        cell = (NT_FinishedCell *)btn.superview.superview.superview;
        finishedTableView = (NT_DownloadFinishedTableView *)cell.superview.superview;
    }
    else
    {
        cell = (NT_FinishedCell *)btn.superview.superview;
        finishedTableView = (NT_DownloadFinishedTableView *)cell.superview;
    }
    NSIndexPath *indexPath = [finishedTableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    
    NSMutableArray *downFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
    
    if ([btn.titleLabel.text isEqualToString:@"删除"])
    {
        if ([downFinishedArr count] > 0)
        {
            //删除plist ipa文件
            NT_DownloadModel *model = (NT_DownloadModel *)[downFinishedArr objectAtIndex:row];
            if (model.savePlistPath)
            {
                [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
            }
            [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
            
            [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray removeObjectAtIndex:row];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            
            [self.finishedTableView beginUpdates];
            [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.finishedTableView endUpdates];
            
            /*
            if ([downFinishedArr count]==1)
            {
                //未安装
                [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray removeObjectAtIndex:row];
                [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
                
                [self.finishedTableView beginUpdates];
                //删除最后1行数据deleteSections，但是有默认图，所以不能deleteSections
                [self.finishedTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
                [self.finishedTableView endUpdates];
            }
            else
            {
                //未安装
                [[NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray removeObjectAtIndex:row];
                [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];

                [self.finishedTableView beginUpdates];
                [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self.finishedTableView endUpdates];
            }
             */
            
        }
    }
    else if ([btn.titleLabel.text isEqualToString:@"安装"])
    {
        if ([downFinishedArr count] > 0)
        {
            NT_DownloadModel *model = (NT_DownloadModel *)[downFinishedArr objectAtIndex:row];
            [[NT_DownloadManager sharedNT_DownLoadManager] saveAsPlist:model];
        }
    }
    /*
     if ([btn.titleLabel.text isEqualToString:@"删除"])
     {
     NSInteger row = indexPath.row - 1;
     
     NSMutableArray *downFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
     NSMutableArray *installFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
     
     if ([downFinishedArr count]>0&&[installFinishedArr count]>0)
     {
     if (indexPath.section == 0)
     {
     
     NT_DownloadModel *model = (NT_DownloadModel *)[downFinishedArr objectAtIndex:row];
     if (model.savePlistPath)
     {
     //删除plist文件
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
     }
     //删除ipa文件
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
     
     //如果是分组，你会发现很怪的现象：当一个分组中，有多条数据时，你删除其中一条，正确；当一个分组中，你要删除唯一的一条时，仍然会报出如上的错误！
     //(Assertion failure in -[UITableView_endCellAnimationsWithContext)
     /\*
     重点：删除某个分组中的最后一条数据时，分组数，和行数都要变。这时候，只调用了deleteRowsAtIndexPaths方法。也就是说，只对行数进行了操作，但是没有对变动的分组进行操作！
     需要：deleteSections：方法！
     最重要：改变numberofsection值
     *\/
     if ([downFinishedArr count]==1)
     {
     //未安装
     [downFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     else
     {
     //未安装
     [downFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     }
     else if (indexPath.section == 1)
     {
     //已安装
     NT_DownloadModel *model = (NT_DownloadModel *)[installFinishedArr objectAtIndex:row];
     if (model.savePlistPath)
     {
     //删除plist文件
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
     }
     //删除ipa文件
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
     
     //如果是分组，你会发现很怪的现象：当一个分组中，有多条数据时，你删除其中一条，正确；当一个分组中，你要删除唯一的一条时，仍然会报出如上的错误！
     //(Assertion failure in -[UITableView_endCellAnimationsWithContext)
     /\*
     重点：删除某个分组中的最后一条数据时，分组数，和行数都要变。这时候，只调用了deleteRowsAtIndexPaths方法。也就是说，只对行数进行了操作，但是没有对变动的分组进行操作！需要：deleteSections：方法！
     *\/
     
     if ([installFinishedArr count]==1)
     {
     [installFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
     
     [self.finishedTableView endUpdates];
     }
     else
     {
     [installFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     
     }
     }
     else if ([downFinishedArr count])
     {
     //删除plist ipa文件
     NT_DownloadModel *model = (NT_DownloadModel *)[downFinishedArr objectAtIndex:row];
     if (model.savePlistPath)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
     }
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
     
     if ([downFinishedArr count]==1)
     {
     //未安装
     [downFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     else
     {
     //未安装
     [downFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     }
     else if ([installFinishedArr count]>0)
     {
     //删除plist ipa文件
     NT_DownloadModel *model = (NT_DownloadModel *)[installFinishedArr objectAtIndex:row];
     if (model.savePlistPath)
     {
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePlistPath];
     }
     [[NT_DownloadManager sharedNT_DownLoadManager] delFileWithPath:model.savePath];
     if ([installFinishedArr count]==1)
     {
     [installFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     else
     {
     [installFinishedArr removeObjectAtIndex:row];
     
     [self.finishedTableView beginUpdates];
     [self.finishedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
     [self.finishedTableView endUpdates];
     }
     }
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     else if ([btn.titleLabel.text isEqualToString:@"安装"])
     {
     //安装：下载完成，未安装时
     NSMutableArray *downFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
     
     if (indexPath.section == 0) //[downFinishedArr count])
     {
     NSInteger row = indexPath.row - 1;
     
     NT_DownloadModel *model = (NT_DownloadModel *)[downFinishedArr objectAtIndex:row];
     if (model.loadType == FINISHED)
     {
     model.buttonStatus = installOn;
     //未越狱安装
     [[NT_DownloadManager sharedNT_DownLoadManager] saveAsPlist:model];
     /\*
     if (![[UIDevice currentDevice] isJailbroken])
     {
     //未越狱安装
     [[NT_DownloadManager sharedNT_DownLoadManager] saveAsPlist:model];
     }
     else
     {
     //越狱安装
     [[NT_DownloadManager sharedNT_DownLoadManager] installSoftwareWithModel:model indexPath:nil];
     }
     *\/
     }
     
     }
     
     //重装：是已安装过或安装失败时才重装
     NSMutableArray *installFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
     
     if (indexPath.section == 1 ) //[installFinishedArr count]>0)
     {
     NSInteger row = indexPath.row - 1;
     //已安装
     NT_DownloadModel *model = (NT_DownloadModel *)[installFinishedArr objectAtIndex:row];
     if (model.loadType == INSTALLFAILED)
     {
     model.buttonStatus = reInstallOn;
     [[NT_DownloadManager sharedNT_DownLoadManager] goInstallOrWaitInStall:model indexPath:nil];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     //by 张正超 已安装，也可重装
     else if (model.loadType == INSTALLFINISHED)
     {
     model.buttonStatus = reInstallOn;
     //未越狱安装
     [[NT_DownloadManager sharedNT_DownLoadManager] saveAsPlist:model];
     }
     else if (model.loadType == FINISHED)
     {
     //若没有设备没有安装，但是已经检测到安装
     model.buttonStatus = reInstallOn;
     //未越狱安装
     [[NT_DownloadManager sharedNT_DownLoadManager] saveAsPlist:model];
     }
     }
     
     }
     else if ([btn.titleLabel.text isEqualToString:@"重装"])
     {
     //重装：是已安装过或安装失败时才重装
     NSMutableArray *installFinishedArr = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
     
     NSInteger row = indexPath.row - 1;
     
     if ([installFinishedArr count]>0)
     {
     //已安装
     NT_DownloadModel *model = (NT_DownloadModel *)[installFinishedArr objectAtIndex:row];
     if (model.loadType == INSTALLFAILED)
     {
     model.buttonStatus = reInstallOn;
     [[NT_DownloadManager sharedNT_DownLoadManager] goInstallOrWaitInStall:model indexPath:nil];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     //by 张正超 已安装，也可重装
     else if (model.loadType == INSTALLFINISHED)
     {
     model.buttonStatus = reInstallOn;
     [[NT_DownloadManager sharedNT_DownLoadManager] goInstallOrWaitInStall:model indexPath:nil];
     [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
     }
     }
     
     }
     */
}

//更新按钮
- (void)updateButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NT_UpdateCell *cell = nil;
    NT_UpdateTableView *updateTable = nil;
    if (isIOS7)
    {
        cell = (NT_UpdateCell *)btn.superview.superview.superview;
        updateTable = (NT_UpdateTableView *)cell.superview.superview;
    }
    else
    {
        cell = (NT_UpdateCell *)btn.superview.superview;
        updateTable = (NT_UpdateTableView *)cell.superview;
    }
    NSIndexPath *indexPath = [updateTable indexPathForCell:cell];
    
    if ([btn.titleLabel.text isEqualToString:@"忽略"])
    {
        NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
        //添加到忽略存档里
        [[NT_DownloadManager sharedNT_DownLoadManager].updateIgnoreArray addObject:updateInfo];
        
        [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray removeObject:updateInfo];
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        
        [self.updateTableView reloadData];
        [self refreshApplicationIconBadgeNumber];
        
    }
    else if([btn.titleLabel.text isEqualToString:@"更新"])
    {
        //保存更新点击数量
        clickUpdateCount++;
        //保存更新按钮点击数量，下次可获取更新数量
        [[NSUserDefaults standardUserDefaults] setInteger:clickUpdateCount forKey:kClickUpdateCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
        NT_DownloadModel *model = [[NT_DownloadModel alloc] initWithAddress:updateInfo.download_addr andGameName:updateInfo.game_name andRoundPic:updateInfo.iconName andVersion:updateInfo.version_name andAppID:updateInfo.appId];
        model.package = updateInfo.package;
        model.isUpdateModel = YES;
        //下载并更新
        //[[NT_DownloadManager sharedNT_DownLoadManager] downLoadWithModel:model];
        
        //[[NT_DownloadManager sharedNT_DownLoadManager] downLoadWithModel:model];
        [[NT_DownloadManager sharedNT_DownLoadManager] installOrDownloadUpdate:model];
        [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray removeObjectAtIndex:indexPath.row];
        [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
        
        [self.updateTableView reloadData];
        
        //by 张正超 若更新数为0，则不显示红色更新数量
        if ([[NT_DownloadManager sharedNT_DownLoadManager].updateListArray count] > 0)
        {
            _updateBadgeValueView.hidden = NO;
            [_updateBadgeValueView setTitle:[NSString stringWithFormat:@"%d",[NT_DownloadManager sharedNT_DownLoadManager].updateListArray.count] forState:UIControlStateNormal];
        }
        else
        {
            _updateBadgeValueView.hidden = YES;
        }
        
        //[_updateBadgeValueView setTitle:[NSString stringWithFormat:@"%d",[NT_DownloadManager sharedNT_DownLoadManager].updateListArray.count] forState:UIControlStateNormal];
        /*
         //by 张正超
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         //下载并更新
         [[NT_DownloadManager sharedNT_DownLoadManager] downLoadWithModel:model];
         });
         dispatch_async(dispatch_get_main_queue(), ^{
         //点击“更新”按钮，就删除该列表的更新行
         [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray removeObjectAtIndex:indexPath.row];
         [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
         
         //删除该行
         [self.updateTableView beginUpdates];
         [self.updateTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
         [self.updateTableView endUpdates];
         
         
         });*/
        
    }
    else  if([btn.titleLabel.text isEqualToString:@"安装"]){
        NT_UpdateAppInfo *updateInfo = [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray objectAtIndex:indexPath.row];
        NT_DownloadModel *model = [[NT_DownloadModel alloc] initWithAddress:updateInfo.download_addr andGameName:updateInfo.game_name andRoundPic:updateInfo.iconName andVersion:updateInfo.version_name andAppID:updateInfo.appId];
        model.package = updateInfo.package;
        model.isUpdateModel = YES;
        [[NT_DownloadManager sharedNT_DownLoadManager] installOrDownloadUpdate:model];
    }
    
}

#pragma mark --
#pragma mark NT_DownLoadManagerDelegate Delegate Methods

//刷新当前下载进度条显示
- (void)refreshViewInDownLoadManager:(NT_DownloadManager *)downLoadManager shouldReloadData:(bool )should
{
    double totalSpeed = 0;
    int downCount = 0;
    for (NT_DownloadModel *model in [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray)
    {
        if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
        {
            totalSpeed += model.downSpeed;
            downCount ++;
        }
    }
    [NT_SpeedShowWindow  showSpeed:totalSpeed];
    
    
    
    if (downCount == 0)
    {
        [NT_SpeedShowWindow hideSpeedView];
    }
    
    if(should){
        [self.downloadingTableView reloadData];
        return;
    }
    
    if (!_isScrolling)
    {
        /*
         if (indexPath)
         {
         [self.downloadingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         }
         else
         {
         [self.downloadingTableView reloadData];
         }*/
        NSArray *cells = self.downloadingTableView.visibleCells;
        NSArray *data = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
        for(NT_DownloadingCell *dcell in cells){
            for(NT_DownloadModel * model in data){
                if(dcell.modelID == model.modelID)
                    [dcell refreshDataWith:model];
            }
        }
    }
    else
    {
        _isNeedRefresh = YES;
    }
    
}

//下载完成
- (void)refreshFinishedManager:(NT_DownloadManager *)downLoadManager
{
    [self.finishedTableView reloadData];
    
    
}

#pragma mark --
#pragma mark UIScrollView Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//根据坐标算页数
        NSLog(@"dddd=====%i",page);
        [self _sliperIndex:page];
    }
}

#pragma mark - 滑动条

- (void)_sliperIndex:(int)page
{
    if (_currnetPage != page) {
        UIImageView *line = (UIImageView *)[_slide viewWithTag:100];
        
        [UIView animateWithDuration:0.2 animations:^{
            line.center = CGPointMake(107*page + 107/2, 39);
        } completion:^(BOOL finished) {
            for (int i = 0; i < [self.dataArray count]; i++) {
                UIButton *textBt = (UIButton *)[_slide viewWithTag:10 + i];
                //[textBt setTitleColor:[UIColor colorWithHex:@"#8c9599"] forState:UIControlStateNormal];
                [textBt setTitleColor:Text_Color_Title forState:UIControlStateNormal];
            }
            UIButton *textBt = (UIButton *)[_slide viewWithTag:10+page];
            _seletBt = textBt;
            [textBt setTitleColor:[UIColor colorWithHex:@"#1eb5f7"] forState:UIControlStateNormal];
        }];
        
    }
    _currnetPage = page;
    
    switch (page)
    {
        case 0:
        {
            /*
             [_customButtonStyle customButton:_headerView.editButton title:@"编辑" titleColor:[UIColor colorWithHex:@"#a3aaad"]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
             [_customButtonStyle customButton:_headerView.allStartButton title:@"全部开始" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             
             [_customButtonStyle customButton:_headerView.editButton title:@"编辑" titleColor:Text_Color  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
             [_customButtonStyle customButton:_headerView.allStartButton title:@"全部开始" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
             */
            if (!_downloadingTableView)
            {
                //下载中
                _downloadingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height)];
                _downloadingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                _downloadingTableView.tag = 200;
                _downloadingTableView.opaque = YES;
                _downloadingTableView.alpha = 1.0;
                _downloadingTableView.delegate = self;
                _downloadingTableView.dataSource = self;
                _downloadingTableView.backgroundColor = [UIColor whiteColor];
                _downloadingTableView.separatorColor = [UIColor colorWithHex:@"#f0f0f0"];
                //ios7表格线会变短，将表格线变长
                if ([_downloadingTableView respondsToSelector:@selector(setSeparatorInset:)])
                {
                    [_downloadingTableView setSeparatorInset:UIEdgeInsetsZero];
                }
                [_scrollView addSubview:_downloadingTableView];
                
                [Utile setExtraCellLineHidden:_downloadingTableView];
            }
            
            _scrollView.contentOffset = CGPointMake(0, 0);
            //[_finishedTableView removeFromSuperview];
            //[_updateTableView removeFromSuperview];
            _headerView.editButton.selected = _downloadingEidting;
            [self RefreshDownloadingStatus];
        }
            break;
        case 1:
        {
            
            
            if (!_finishedTableView)
            {
                
                _finishedTableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
                _finishedTableView.tag = 200 + page;
                _finishedTableView.delegate = self;
                _finishedTableView.dataSource = self;
                _finishedTableView.opaque = YES;
                _finishedTableView.alpha = 1.0;
                _finishedTableView.backgroundColor = [UIColor whiteColor];
               
                
                _finishedTableView.separatorColor = [UIColor colorWithHex:@"#f0f0f0"];
                //ios7表格线会变短，将表格线变长
                if ([_finishedTableView respondsToSelector:@selector(setSeparatorInset:)])
                {
                    [_finishedTableView setSeparatorInset:UIEdgeInsetsZero];
                }

                [_scrollView addSubview:_finishedTableView];
                [Utile setExtraCellLineHidden:_finishedTableView];
            }
            
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            //[_downloadingTableView removeFromSuperview];
            //[_updateTableView removeFromSuperview];
            _headerView.editButton.selected = _finishedEditing;
            [self RefreshFinishedStatus];
            
        }
            break;
        case 2:
        {
            if (!_updateTableView) {
                
                _updateTableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
                _updateTableView.tag = 200 + page;
                _updateTableView.delegate = self;
                _updateTableView.dataSource = self;
                _updateTableView.opaque = YES;
                _updateTableView.alpha = 1.0;
                _updateTableView.backgroundColor = [UIColor whiteColor];
               
                _updateTableView.separatorColor = [UIColor colorWithHex:@"#f0f0f0"];
                //ios7表格线会变短，将表格线变长
                if ([_updateTableView respondsToSelector:@selector(setSeparatorInset:)])
                {
                    [_updateTableView setSeparatorInset:UIEdgeInsetsZero];
                }

                //仅第一次加载
                [self loadUpdateData];
                [_scrollView addSubview:_updateTableView];
                [Utile setExtraCellLineHidden:_updateTableView];
            }
            
            //更新
            
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
            //[_downloadingTableView removeFromSuperview];
            //[_finishedTableView removeFromSuperview];
            _headerView.editButton.selected = _updateEditing;
            [self RefreshUpdateStatus];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Update Data

- (void)loadUpdateData
{
    NSMutableArray *installedArray = [NSMutableArray array];
    NSMutableString *identiferStr = [NSMutableString stringWithString:@""];
    [self.view showLoadingMeg:@"数据加载中"];
    [self.view setLoadingUserInterfaceEnable:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLoading:)];
    [self.view addGestureRecognizer:tapGesture];
    [self perform:^{
        NSArray *arr = [MobileInstallationInstallManager IPAInstalled:nil];
        
        if (!arr) {
            arr = [MobileInstallationInstallManager browse];
        }
        
        for (int i = 0; i < arr.count; i++) {
            NT_InstallAppInfo *info = [NT_InstallAppInfo infoFromDic:arr[i]];
            if (identiferStr.length == 0) {
                [identiferStr appendString:info.appIdentifier];
            }else
            {
                [identiferStr appendString:[NSString stringWithFormat:@",%@",info.appIdentifier]];
            }
            [installedArray addObject:info];
        }
    } withCompletionHandler:^{
        [[NT_HttpEngine sharedNT_HttpEngine] getEnableUpdateListByIdentifer:identiferStr onCompletionHandler:^(MKNetworkOperation *completedOperation) {
            if (tapGesture) {
                [self.view removeGestureRecognizer:tapGesture];
            }
            [self.view hideLoading];
            
            
            
            NSDictionary *dic = [completedOperation responseJSON];
            //NSLog(@"update info:%@",dic);
            if ([dic[@"status"] boolValue]) {
                NSArray *itemArray = dic[@"data"][@"list"];
                //先移除原有的
                [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray removeAllObjects];
                
                for (NSDictionary *subDic in itemArray) {
                    NT_UpdateAppInfo *updateInfo = [NT_UpdateAppInfo dictToInfo:subDic];
                    for (NT_InstallAppInfo *installInfo in installedArray) {
                        //NSLog(@"updatePackage:%@",updateInfo.package);
                        //NSLog(@"appID:%@",installInfo.appIdentifier);
                        if ([updateInfo.package isEqualToString:installInfo.appIdentifier]) {
                            //                        NSLog(@"11111112:%@,%@",updateInfo.version_name,installInfo.appVersion);
                            if ([NT_UpdateAppInfo versionCompare:updateInfo.version_name and:installInfo.appVersion])
                            {
                                //是否有忽略更新
                                int sign = 0;
                                
                                //若有更新，则判断该游戏是否已经被忽略了
                                NSMutableArray *ignoreArray = [NT_DownloadManager sharedNT_DownLoadManager].updateIgnoreArray;
                                if (ignoreArray.count > 0)
                                {
                                    for (NT_UpdateAppInfo *info in ignoreArray)
                                    {
                                        if ([info.package isEqualToString:updateInfo.package])
                                        {
                                            //有忽略更新
                                            sign = 1;
                                            break;
                                        }
                                        
                                    }
                                    if (sign == 0)
                                    {
                                        [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray addObject:updateInfo];
                                    }
                                }
                                else
                                {
                                    [[NT_DownloadManager sharedNT_DownLoadManager].updateListArray addObject:updateInfo];
                                }
                            }
                            break;
                        }
                    }
                }
                [self refreshApplicationIconBadgeNumber];
            }
            
            [self refreshUpdateView:nil];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            if (tapGesture) {
                [self.view removeGestureRecognizer:tapGesture];
            }
            [self.view hideLoading];
            [self.view showLoadingMeg:@"数据加载出现错误" time:1];
        }];
    }];
    
}

//刷新更新数量
- (void)refreshApplicationIconBadgeNumber
{
    if ([NT_SettingManager showUpdateTips]) {
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.updateMutArray.count];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[NT_DownloadManager sharedNT_DownLoadManager].updateListArray count]];
        
        //by thilong, 控制更新数量的正确显示
        int count=[[NT_DownloadManager sharedNT_DownLoadManager].updateListArray count];
        if(count > 0){
            [_updateBadgeValueView setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
            _updateBadgeValueView.hidden = NO;
            
            
            //保存可更新数量
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:KUpdateCount];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            _updateBadgeValueView.hidden = YES;
            
            
            //保存可更新数量为0
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:KUpdateCount];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
}

#pragma mark --
#pragma mark -- NT_UpdateTableView Delegate Method
- (void)refreshUpdateView:(NT_DownloadManager *)manager
{
    NSArray *downloadingArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
    NSArray *downloadFinishedArray = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
    NSArray *installFinishedArray = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
    
    NSMutableArray *updateMutArray = [NT_DownloadManager sharedNT_DownLoadManager].updateListArray;
    
    //NT_UpdateAppInfo *downloadingInfo = nil;
    //NT_UpdateAppInfo *finishedInfo = nil;
    NT_UpdateAppInfo *installFinishedInfo = nil;
    //下载中
    for (NT_DownloadModel *model in downloadingArray)
    {
        if (model.isUpdateModel)
        {
            for (NT_UpdateAppInfo *info in updateMutArray)
            {
                if ([info.download_addr isEqualToString:model.addressName])
                {
                    info.updateState = model.loadType;
                    [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
                    //downloadingInfo = info;
                    break;
                }
            }
        }
    }
    //未安装
    for (NT_DownloadModel *model in downloadFinishedArray)
    {
        if (model.isUpdateModel)
        {
            for (NT_UpdateAppInfo *info in updateMutArray)
            {
                if ([info.download_addr isEqualToString:model.addressName])
                {
                    info.updateState = model.loadType;
                    [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
                    //finishedInfo = info;
                    break;
                }
            }
        }
    }
    //已安装
    for (NT_DownloadModel *model in installFinishedArray)
    {
        if (model.isUpdateModel)
        {
            for (NT_UpdateAppInfo *info in updateMutArray)
            {
                if ([info.download_addr isEqualToString:model.addressName])
                {
                    info.updateState = model.loadType;
                    installFinishedInfo = info;
                    [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
                    break;
                }
            }
        }
    }
    
    if (installFinishedInfo != nil)
    {
        //删除已更新并且已经安装后，下载更新列表显示的数据
        [updateMutArray removeObject:installFinishedInfo];
    }
    [NT_DownloadManager sharedNT_DownLoadManager].updateListArray = updateMutArray;
    NSLog(@"array count %d",updateMutArray.count);
    [self refreshApplicationIconBadgeNumber];
    [self.updateTableView reloadData];
}

#pragma mark --
#pragma mark -- NT_DownLoadUsedSpaceManager Delegate Method
//已用空间 空闲空间 顶部
- (void)refreshUsedSpaceViewManager:(NT_DownloadManager *)downLoadManager
{
    //刷新剩余空间，若无空间则提示
    [self noSpaceTip];
    /*
     //刷新头部空间剩余
     [_headerView refreshHeaderData];
     
     
     //去掉底部红色空间不足提示
     [self dismissBottomRedInfo:@"抱歉内存不足，无法下载/安装任务"];
     */
    
}

#pragma mark --
#pragma mark -- NT_DownloadLackOfSpaceDelegate Delegate Method
//空间不足 底部提示
- (void)refreshLackOfSpaceDelegate
{
    /*
     UILabel *infoLabel = [self bottomInfoLabel:@"抱歉内存不足，无法下载/安装任务"];
     [self perform:^{
     [infoLabel removeFromSuperview];
     } afterDelay:3];
     
     
     //by thilong.2014-04-10,空间不足，停止所有下载
     [_headerView.allStartButton setTitle:@"全部开始" forState:UIControlStateNormal];
     */
    
    [self noSpaceTip];
    
    //by thilong.2014-04-10,空间不足，停止所有下载
    //全部暂停
    [self pauseAll];
}

#pragma mark --
#pragma mark -- NT_DownloadManagerBottomInfoDelegate Method
- (void)refreshBottomInfoManager:(NT_DownloadManager *)downLoadManager info:(NSString *)info
{
    UILabel *infoLabel = [self bottomInfoLabel:@"测试"];
    [self perform:^{
        [infoLabel removeFromSuperview];
    } afterDelay:3];
}

- (void)hiddenLoading:(UITapGestureRecognizer *)tap
{
    if (tap) {
        [self.view removeGestureRecognizer:tap];
    }
    [self.view hideLoading];
}

- (void)gotoChange:(UIButton *)sender
{
    if (sender != _seletBt) {
        [self _sliperIndex:(sender.tag - 10)];
        _seletBt = sender;
        CGRect newFrame = _scrollView.frame;
        newFrame.origin.x = _scrollView.frame.size.width*(sender.tag -10);
        [_scrollView scrollRectToVisible:newFrame animated:YES];
    }
}

- (void)clear
{
    self.slide = nil;
    self.downloadingTableView = nil;
    self.finishedTableView = nil;
    self.updateTableView = nil;
    self.scrollView = nil;
    self.dataArray = nil;
    self.headerView = nil;
    self.customButtonStyle = nil;
    self.isOpenUpdate = NO;
    self.currentRow = 0;
    self.isAllIgnore = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (isIOS6)
    {
        if ([self isViewLoaded] && self.view.window == nil) {
            self.view = nil;
        }
    }
    [self clear];
}


#pragma mark - status adjust

-(void)RefreshDownloadingStatus
{
    
    //by thilong 判断编辑状态
    NSMutableArray *downloadingArray = [NT_DownloadManager sharedNT_DownLoadManager].downLoadingArray;
    if(_downloadingEidting)
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"取消" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"]  highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        
        [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
        
        if ([downloadingArray count] > 0)
        {
            for(NT_DownloadModel *model in downloadingArray)
            {
                model.buttonStatus = deleteOn;
            }
            [self.downloadingTableView reloadData];
        }
        
    }
    else
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"编辑" titleColor:Text_Color  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
        if([[NT_DownloadManager sharedNT_DownLoadManager] anyDownloading])
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部暂停" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        else
            [_customButtonStyle customButton:_headerView.allStartButton title:@"全部开始" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        
        if ([downloadingArray count] > 0)
        {
            for(NT_DownloadModel *model in downloadingArray){
                
                if (model.loadType == LOADING || model.loadType == DOWNFAILEDWITHUNCONNECT)
                {
                    model.buttonStatus = pauseOn;
                }
                else if (model.loadType == PAUSE || model.loadType == WAITEDOWNLOAD)
                {
                    model.buttonStatus = loadOn;
                }
                else if (model.loadType == WAITEDOWNLOAD)
                {
                    model.loadType = WAITEDOWNLOAD;
                    model.buttonStatus = waiteOn;
                }
                else if (model.loadType == DOWNFAILED || model.loadType == ISMUCHMONEYFIELD)
                {
                    model.buttonStatus = loadOn;
                }
                else if (model.loadType == ISUNLITMTGOLD)
                {
                    model.buttonStatus = waiteOn;
                }
                [[NT_DownloadManager sharedNT_DownLoadManager] saveArchiver];
            }
            [self.downloadingTableView reloadData];
        }
       
    }

}

- (void)RefreshFinishedStatus{
    if(_finishedEditing)
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"取消" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"]  highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-light-read.png"] highlightedImage:[UIImage imageNamed:@"btn-light-read.png"]];
        
        NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
        if ([array count] > 0)
        {
            for(NT_DownloadModel *model in array){
                model.buttonStatus = deleteOn;
            }
            [self.finishedTableView reloadData];
        }
        
        /*
        NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;

        for(NT_DownloadModel *model in array){
            model.buttonStatus = deleteOn;
        }
        array = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
        for(NT_DownloadModel *model in array){
            model.buttonStatus = deleteOn;
        }
        [self.finishedTableView reloadData];
         */
    }
    else
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"编辑" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
        [_customButtonStyle customButton:_headerView.allStartButton title:@"全部删除" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-light-read.png"] highlightedImage:[UIImage imageNamed:@"btn-light-read.png"]];
        
        
        NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
        if ([array count] > 0)
        {
            for(NT_DownloadModel *model in array){
                model.buttonStatus = waiteOn;
            }
            [self.finishedTableView reloadData];
        }
        /*
        NSMutableArray *array = [NT_DownloadManager sharedNT_DownLoadManager].downFinishedArray;
        for(NT_DownloadModel *model in array){
            model.buttonStatus = waiteOn;
        }
        array = [NT_DownloadManager sharedNT_DownLoadManager].installFinishedArray;
        for(NT_DownloadModel *model in array){
            model.buttonStatus = reInstallOn;
        }
        [self.finishedTableView reloadData];
         */
    }
    
}

- (void)RefreshUpdateStatus{
    if(_updateEditing)
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"取消" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"]  highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        [_customButtonStyle customButton:_headerView.allStartButton title:@"全部忽略" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-read.png"] highlightedImage:[UIImage imageNamed:@"btn-read-hover.png"]];
        
        self.isAllIgnore = YES;
        [self.updateTableView reloadData];
        
    }
    else
    {
        [_customButtonStyle customButton:_headerView.editButton title:@"忽略" titleColor:Text_Color font:[UIFont systemFontOfSize:14]  bgImage:[UIImage imageNamed:@"btn-white.png"] highlightedImage:[UIImage imageNamed:@"btn-white-hover.png"]];
        
        //全部更新按钮
        [_customButtonStyle customButton:_headerView.allStartButton title:@"全部更新" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:14] bgImage:[UIImage imageNamed:@"btn-blue.png"] highlightedImage:[UIImage imageNamed:@"btn-blue-hover.png"]];
        
        self.isAllIgnore = NO;
        [self.updateTableView reloadData];
        
    }
}

@end

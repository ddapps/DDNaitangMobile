//
//  NT_DownloadManager.h
//  NaiTangApp
//
//  Created by 张正超 on 14-3-3.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NT_DownloadManager.h"
#import "NT_DownloadModel.h"

#define kNotificationDownloadNumChanged @"kNotificationDownloadNumChanged"
#define KMAXLOADNUM 2

#define InstalledAppList  @"installed"

@protocol NT_DownLoadManagerDelegate;
@protocol NT_DownLoadManagerUpdateDelegate;
@protocol NT_DownLoadManagerInstallDelegate ;
@protocol NT_DownLoadFinishedManagerDelegate;
@protocol NT_DownloadManagerUsedSpaceDelegate;

@interface NT_DownloadManager : NSObject

+ (NT_DownloadManager *)sharedNT_DownLoadManager;

@property (nonatomic,assign) id<NT_DownLoadManagerDelegate> delegate;
@property (nonatomic,assign) BOOL isFirstDownLoad;
@property (nonatomic,assign) BOOL isFirstUnlimitGold;
@property (nonatomic,weak) id <NT_DownLoadFinishedManagerDelegate> finishedDelegate;
@property (nonatomic,weak) id<NT_DownLoadManagerUpdateDelegate> updateDelegate;
@property (nonatomic,weak) id<NT_DownLoadManagerInstallDelegate> installDelegate;
@property (nonatomic,weak) id<NT_DownloadManagerUsedSpaceDelegate> usedSpaceDelegate;
@property (nonatomic,strong) NSMutableArray *installedListArray;

// 保存正在下载的项目数据
@property (strong, nonatomic) NSMutableArray *downLoadingArray;

// 保存下载完成待安装的项目数据
@property (strong,nonatomic) NSMutableArray *downFinishedArray;

// 保存已安装完成的游戏数据
@property (strong,nonatomic) NSMutableArray *installFinishedArray;

//保存网络连接失败前所下载的数据
@property (strong,nonatomic) NSMutableArray *networkFiledArray;

@property (strong,nonatomic)NT_DownloadModel *installedModel;

//存档更新信息  存储忽略更新数据
@property (strong,nonatomic) NSMutableArray *updateListArray;
@property (strong,nonatomic) NSMutableArray *updateIgnoreArray;

- (void)saveArchiver;
- (void)loadArchiver;
- (void)goInstallOrWaitInStall:(NT_DownloadModel *)model  indexPath:(NSIndexPath *)indexPath;
- (BOOL)downLoadWithModel:(NT_DownloadModel *)model;
- (BOOL)startDownLoadWithModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
- (BOOL)pauseDownLoadWithModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)delDownLoadWithModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
// 删除安装记录
- (void)delInstalleFinishedCellWithModel:(NT_DownloadModel *)model;
- (void)reStartInstallOrDelModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)reStartDownLoadORDelModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)delOrPauseDownLoadWithModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)installOrDelSoftWithModel:(NT_DownloadModel *)model  indexPath:(NSIndexPath *)indexPath;
//越狱版安装成功
- (void)installSoftwareWithModel:(NT_DownloadModel *)model indexPath:(NSIndexPath *)indexPath;
//删除文件路径
- (void)delFileWithPath:(NSString *)filePath;
- (void)saveAsPlist:(NT_DownloadModel *)model;


//断网时，直接暂停所有下载任务
- (BOOL)pauseAllDownLoadWithModel:(NT_DownloadModel *)model;
//获取本地剩余空间大小
- (NSNumber *)getSpaceSize;
//获取剩余空间大小
- (NSString *)getFreeSpace;

//有东西移除了，判断空间大小，设置正在下载数目显示
- (void)somethingRemoved;

//判断是否还有下载
- (bool)anyDownloading;
//通知外界下载状况,每隔1秒通知一次
- (void)postDownloadStatus;

- (void)shouldRescanInstallApps;

- (void)cancelDownloading:(NT_DownloadModel *)model;
- (BOOL)isDownloadingModel:(NT_DownloadModel*)model;

- (void)installOrDownloadUpdate:(NT_DownloadModel *)model;

- (void)repeateInstalled:(NT_DownloadModel *)model;
@end

//已用空间 空闲空间 委托
@protocol NT_DownloadManagerUsedSpaceDelegate <NSObject>

- (void)refreshUsedSpaceViewManager:(NT_DownloadManager *)downLoadManager;

@end

//下载协议
@protocol NT_DownLoadManagerDelegate <NSObject>

- (void)refreshViewInDownLoadManager:(NT_DownloadManager *)downLoadManager shouldReloadData:(bool )should;
- (void)checkNetConnection:(NT_DownloadManager *)downLoadManager;

- (void)shouldTipMemoryNotEnough;

//网络连接状态
//- (void)networkConnectionStatus:(NT_DownloadManager *)downLoadManager;

@end

//下载完成协议
@protocol NT_DownLoadFinishedManagerDelegate <NSObject>

- (void)refreshFinishedManager:(NT_DownloadManager *)downLoadManager;

@end

//更新协议
@protocol NT_DownLoadManagerUpdateDelegate <NSObject>

- (void)refreshUpdateView:(NT_DownloadManager *)manager;

@end

//安装协议
@protocol NT_DownLoadManagerInstallDelegate <NSObject>

- (void)refreshInstallView:(NT_DownloadManager *)manager;

@end


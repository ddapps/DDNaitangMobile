//
//  NT_WifiBrowseImage.h
//  NaiTangApp
//
//  Created by 张正超 on 14-4-12.
//  Copyright (c) 2014年 张正超. All rights reserved.
//
//  设置-打开或关闭wifi下浏览图片通用方法

#import <Foundation/Foundation.h>

@interface NT_WifiBrowseImage : NSObject

//  设置-打开或关闭wifi下浏览图片的处理方法
- (void)wifiBrowseImage:(EGOImageView *)appImageView urlString:(NSString *)url;

//获取wifi的状态，显示缓存图片（详情大图、大家还喜欢）
- (NSDictionary *)getWifiStatusAndUrlString:(NSString *)urlString placeholderString:(NSString *)placeholder;

//获取wifi的状态显示的占位图片（文章页）
- (NSDictionary *)getWifiStatusAndUrlString;

@end

//
//  UIImage+CustomImageScale.m
//  NaiTangApp
//
//  Created by 张正超 on 14-3-6.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "UIImage+CustomImageScale.h"

@implementation UIImage (CustomImageScale)

//根据图片高度来缩放图片
- (UIImage *)scaleWithImageHeight:(CGFloat)imageHeight
{
    //原图高宽
    CGFloat sourceWidth = CGImageGetWidth(self.CGImage);
    CGFloat sourceHeight = CGImageGetHeight(self.CGImage);
    
    //NSLog(@"source width:%f height:%f",sourceWidth,sourceHeight);
    
    //横图时，将高宽调换
    CGFloat temp=0;
    if (sourceWidth > sourceHeight) {
        temp = sourceWidth;
        sourceWidth = sourceHeight;
        sourceHeight = temp;
    }
    
    //根据固定高度值，获取高度的缩放比例值0.6
    CGFloat heightRadio = sourceHeight>imageHeight?imageHeight/sourceHeight:sourceHeight/imageHeight;
    
    //根据高度缩放比例0.6，宽度也缩放0.6
    CGFloat toWidth = sourceWidth*heightRadio;
    
    //获取缩放后的宽度，和固定高度值。
    CGSize size = CGSizeMake(toWidth, imageHeight);
    //NSLog(@"size:width%f height:%f",size.width,size.height);
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
}


@end

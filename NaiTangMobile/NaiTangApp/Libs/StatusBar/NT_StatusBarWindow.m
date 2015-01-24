//
//  NT_StatusBarWindow.m
//  NaiTangApp
//
//  Created by 张正超 on 14-2-26.
//  Copyright (c) 2014年 张正超. All rights reserved.
//

#import "NT_StatusBarWindow.h"
#import "NT_Singleton.h"

@implementation NT_StatusBarWindow
SYNTHESIZE_SINGLETON_FOR_CLASS(NT_StatusBarWindow);

- (id)init
{
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 90, 320, 20);
    if (isIpad) {
        frame = CGRectMake(0, SCREEN_WIDTH - 90, SCREEN_HEIGHT, 20);
    }
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *text = [[UILabel alloc] initWithFrame:self.bounds];
        text.layer.cornerRadius = 3;
        text.clipsToBounds = YES;
        text.backgroundColor = [UIColor blackColor];
        text.textColor = [UIColor whiteColor];
        text.font = [UIFont systemFontOfSize:13];
        text.textAlignment = TEXT_ALIGN_CENTER;
        self.textLabel = text;
        [self addSubview:text];
    }
    return self;
}

- (void)checkArray
{
    if (self.array.count) {
        [self showMessage:[self.array objectAtIndex:0]];
        [self.array removeObjectAtIndex:0];
    }
}
- (void)showMessage:(NSString *)meg
{
    if (!meg || ![meg isKindOfClass:[NSString class]]) {
        return;
    }
    if (self.isShowing) {
        if (!self.array) {
            self.array = [NSMutableArray array];
        }
        [self.array addObject:meg];
        return;
    }
    self.textLabel.text = meg;
    if ([meg rangeOfString:@"失败"].length > 0) {
        self.textLabel.textColor = COLOR_WITH_ARGB(200, 0, 0, 1);
    }
    else
    {
        self.textLabel.textColor = [UIColor whiteColor];
    }
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font];
    size.width = MIN(isIpad?SCREEN_HEIGHT:SCREEN_WIDTH - 20, size.width + 20);
    [self.textLabel setFrame:CGRectMake(self.width/2 - size.width/2, 0, size.width, self.height)];
    self.hidden = NO;
    self.isShowing = YES;
    self.textLabel.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.textLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
            self.textLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.isShowing = NO;
            [self checkArray];
        }];
        
    }];
}
+ (void)showMessage:(NSString *)meg
{
    [[self sharedNT_StatusBarWindow] showMessage:meg];
}

- (void)dealloc
{
    self.array = nil;
    self.textLabel = nil;
}


@end

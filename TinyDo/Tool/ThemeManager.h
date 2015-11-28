//
//  I try to switch between daylight and night mode but failed
//  viewRecursion and appearance canot satisified me
//
//  ThemeManager.h
//  TinyDo
//
//  Created by pi on 15/11/3.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol Theme
-(UIColor*)backgroundColor;
-(UIColor*)textColor;
//
-(UIColor*)buttonTitleColorNormal;
-(UIColor*)buttonTitleColorSelected;
@end

@interface ThemeManager : NSObject
+(id<Theme>)sharedTheme;
+(void)setSharedTheme:(id<Theme>)newTheme;
+(void)customizeView:(UIView*)view;
@end

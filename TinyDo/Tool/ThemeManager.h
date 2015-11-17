//
//  ThemeManager.h
//  TinyDo
//
//  Created by pi on 15/11/3.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Theme

@end

@interface ThemeManager : NSObject
+(instancetype)sharedTheme;
+(void)applyTheme;
+(void)setSharedTheme:(id<Theme>)newTheme;
@end

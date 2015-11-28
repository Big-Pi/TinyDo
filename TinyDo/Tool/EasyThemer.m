//
//  EasyThemer.m
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "EasyThemer.h"
#import "Colours.h"

NSString *const kThemeColor=@"kThemeColor";

@implementation EasyThemer

+(void)initialize{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{kThemeColor:[[UIColor orangeColor]hexString]}];
}

+(void)applyTheme:(UIColor *)color{
    [self saveThemeColor:color];
    [self applyTheme];
}

+(void)applyTheme{
    UIColor *color=[self themeColor];
    UIWindow *window= [[UIApplication sharedApplication].delegate window];
    window.tintColor=color;
    [UIView appearance].tintColor=color;
}

+(UIColor*)themeColor{
    return [self getValueFromUserDefault:kThemeColor];
}

+(void)saveThemeColor:(UIColor *)color{
    [[NSUserDefaults standardUserDefaults]setObject:[color hexString] forKey:kThemeColor];
}

+(UIColor*)getValueFromUserDefault:(NSString *)key{
    NSString *colorHexStr= [[NSUserDefaults standardUserDefaults]stringForKey:key];
    return [UIColor colorFromHexString:colorHexStr];
}
@end

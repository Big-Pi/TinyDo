//
//  ThemeManager.m
//  TinyDo
//
//  Created by pi on 15/11/3.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "ThemeManager.h"
#import "DefaultWhiteTheme.h"
#import "NightTheme.h"

@interface ThemeManager ()
@end

@implementation ThemeManager
static id<Theme> _theme=nil;

+(void)setSharedTheme:(id<Theme>)newTheme{
    _theme=newTheme;
}

+(id<Theme>)sharedTheme{
    if(!_theme){
        _theme=[[NightTheme alloc]init];
    }
    return _theme;
}

+(void)customizeView:(UIView *)view{
//    UISwitch *switchOriginalAppearance=[UISwitch appearance];
    
//    [UIView appearance].backgroundColor=[theme backgroundColor];
//    [UILabel appearance].textColor=[theme textColor];
//    [UILabel appearance].backgroundColor=[UIColor clearColor];
//    NSString *placeholderStr=@"我想。。。";
//    NSMutableAttributedString *placeHolderAttr=[[NSMutableAttributedString alloc]initWithString:placeholderStr];
//    [placeHolderAttr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, placeholderStr.length)];
//    [UITextField appearance].attributedPlaceholder=placeHolderAttr;
//    [UISwitch appearance];
    
    [self subViewRecursion:view];
    NSString *placeholderStr=@"我想。。。";
    NSMutableAttributedString *placeHolderAttr=[[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [placeHolderAttr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, placeholderStr.length)];
    [UITextField appearance].attributedPlaceholder=placeHolderAttr;
}

+(void)subViewRecursion:(UIView *)view{
    id<Theme> theme=[self sharedTheme];
    for (UIView *v in view.subviews) {
        if([v isKindOfClass:[UILabel class]]){
            UILabel *label=(UILabel *)v;
            label.textColor=[theme textColor];
            continue;
        }
        if([v isKindOfClass:[UISwitch class]] || [v isKindOfClass:[UITextField class]]){
            continue;
        }
        if([v isKindOfClass:[UIButton class]]){
            [self customizeButton:(UIButton *)v];
            continue;
        }
        if([v isKindOfClass:[UIDatePicker class]]){
            [UIDatePicker appearance].backgroundColor=[UIColor whiteColor];
            continue;
        }
        if([v isKindOfClass:[UITableViewCell class]]){
            [self customizeTableViewCell:(UITableViewCell*)v];
            continue;
        }
        if([v isKindOfClass:[UITableView class]]){
            [self customizeTableView:(UITableView*)v];
            continue;
        }
        
        v.backgroundColor=[theme backgroundColor];
        [self subViewRecursion:v];
    }
}
+(void)customizeButton:(UIButton *)btn{
    id<Theme> theme=[self sharedTheme];
    [btn setTitleColor:[theme buttonTitleColorNormal] forState:UIControlStateNormal];
    [btn setTitleColor:[theme buttonTitleColorSelected] forState:UIControlStateSelected];
}

+ (void)customizeTableViewCell:(UITableViewCell*)tableViewCell {
    id <Theme> theme = [self sharedTheme];
    tableViewCell.backgroundColor=[theme backgroundColor];
    [self customizeView:tableViewCell.contentView];
}
+(void)customizeTableView:(UITableView*)tableview{
    [self customizeView:tableview];
}
@end

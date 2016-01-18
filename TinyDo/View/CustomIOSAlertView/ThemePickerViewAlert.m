//
//  ThemePickerViewAlert.m
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "ThemePickerViewAlert.h"
#import "CustomIOSAlertView.h"
#import "ThemePickerView.h"

@interface ThemePickerViewAlert ()<CustomIOSAlertViewDelegate>
@property (strong,nonatomic) ThemePickerView *picker;
@end

@implementation ThemePickerViewAlert

+(id)alert{
    ThemePickerViewAlert *themeAlert=[[ThemePickerViewAlert alloc]init];
    
    [themeAlert setButtonTitles:@[NSLocalizedString(@"确定", @"确定")]];
    themeAlert.picker=[[ThemePickerView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    [themeAlert setContainerView:themeAlert.picker];
    return themeAlert;
}
-(UIColor *)selectedColor{
    return [self.picker selectedColor];
}
@end

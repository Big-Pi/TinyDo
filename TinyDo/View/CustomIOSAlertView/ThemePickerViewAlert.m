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

@implementation ThemePickerViewAlert
+(instancetype)sharedAlert{
    CustomIOSAlertView *alert=[[CustomIOSAlertView alloc]init];
    [alert setButtonTitles:@[@"确定"]];
    ThemePickerView *picker=[[ThemePickerView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    [alert setContainerView:picker];
    [alert show];
    return (ThemePickerViewAlert*)alert;
}
@end

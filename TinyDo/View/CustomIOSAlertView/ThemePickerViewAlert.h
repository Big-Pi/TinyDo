//
//  ThemePickerViewAlert.h
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "CustomIOSAlertView.h"


@interface ThemePickerViewAlert : CustomIOSAlertView
#warning 用delegate 和父类重复怎办？
//@property(nonatomic,weak) id<ThemePickerViewAlertDelegate> alertDelegate; //用delegate 和父类重复怎办？
+(instancetype)alert;
-(UIColor*)selectedColor;
@end

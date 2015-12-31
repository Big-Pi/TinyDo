//
//  ThemePickerViewAlert.h
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "CustomIOSAlertView.h"


@interface ThemePickerViewAlert : CustomIOSAlertView
+(instancetype)alert;
-(UIColor*)selectedColor;
@end

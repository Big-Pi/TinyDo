//
//  NightTheme.m
//  TinyDo
//
//  Created by pi on 15/11/27.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "NightTheme.h"
#import "Colours.h"
@import UIKit;

@implementation NightTheme
-(UIColor *)backgroundColor{
    return [UIColor indigoColor];
}
-(UIColor *)textColor{
    return [UIColor whiteColor];
}
#pragma mark - Button
-(UIColor *)buttonTitleColorNormal{
    return [UIColor whiteColor];
}
-(UIColor *)buttonTitleColorSelected{
    return [UIColor yellowColor];
}
@end

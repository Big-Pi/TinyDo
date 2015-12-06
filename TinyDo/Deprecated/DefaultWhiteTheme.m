//
//  DefaultWhiteTheme.m
//  TinyDo
//
//  Created by pi on 15/11/27.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "DefaultWhiteTheme.h"
@import UIKit;

@implementation DefaultWhiteTheme
-(UIColor *)backgroundColor{
    return [UIColor whiteColor];
}
-(UIColor *)textColor{
    return [UIColor blackColor];
}
#pragma mark - Button
-(UIColor *)buttonTitleColorNormal{
    return [UIColor blackColor];
}
-(UIColor *)buttonTitleColorSelected{
    return [UIColor whiteColor];
}
@end

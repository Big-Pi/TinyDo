//
//  UIColor+PiRandomColor.m
//  TimeLineTableView
//
//  Created by pi on 15/11/18.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "UIColor+PiRandomColor.h"
#import "Colours.h"

@implementation UIColor (PiRandomColor)
+(UIColor *)randomColor{
    NSArray *colors=[self themeColors];
    return colors[arc4random()%(colors.count-1)];
}
+(NSArray*)themeColors{
    return @[[UIColor pinkLipstickColor], [UIColor infoBlueColor],[UIColor successColor],[UIColor grapeColor],[UIColor skyBlueColor],[UIColor pastelPurpleColor],[UIColor pastelOrangeColor]];
}
@end

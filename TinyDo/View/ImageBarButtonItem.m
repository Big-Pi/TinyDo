//
//  ImageBarButtonItem.m
//  TinyDo
//
//  Created by pi on 15/11/14.
//  Copyright (c) 2015年 pi. All rights reserved.
//
//
//#import "ImageBarButtonItem.h"
//static NSInteger imgIndex=0;
//@implementation ImageBarButtonItem
//
//-(void)awakeFromNib{
//    self.tag=imgIndex;
//    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    //让image使用tintcolor渲染
//    UIImage *img=[[UIImage imageNamed:[self imags]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [button setImage:img forState:UIControlStateNormal];
//    self.customView=button;
//}
//
//-(NSString *)imags{
//    return @[@"Pin",@"Like",@"Settings",@"About"][imgIndex++];
//}
//@end

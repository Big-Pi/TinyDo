//
//  UmengInit.m
//  TinyDo
//
//  Created by pi on 15/11/28.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "UmengInit.h"
#import "UMSocial.h"

@implementation UmengInit
+(void)load{
    [UMSocialData setAppKey:@"5656c533e0f55a07d8000330"];
    NSLog(@"UmengInit");
}
@end

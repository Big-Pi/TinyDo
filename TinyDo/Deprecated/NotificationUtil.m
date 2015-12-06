//
//  NotificationUtil.m
//  TinyDo
//
//  Created by pi on 15/11/27.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "NotificationUtil.h"

NSString * const kDismissKeyboard=@"kDismissKeyboard";

@implementation NotificationUtil
+(void)sendDismissKeyBoardNotify{
    NSLog(@"kDismissKeyboard");
    [[NSNotificationCenter defaultCenter]postNotificationName:kDismissKeyboard object:nil];
}
@end

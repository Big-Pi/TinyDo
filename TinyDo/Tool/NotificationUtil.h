//
//  NotificationUtil.h
//  TinyDo
//
//  Created by pi on 15/11/27.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

UIKIT_EXTERN NSString *const kDismissKeyboard;

@interface NotificationUtil : NSObject
+(void)sendDismissKeyBoardNotify;
@end

//
//  NotifyUtil.h
//  TinyDo
//
//  Created by pi on 15/11/24.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Note;

@interface NotifyUtil : NSObject
+(void)scheduleAlarm:(Note*)note;
+(void)cancelAlarm:(Note *)note;
//debug
+(NSString*)scheduleWeekRepeatAlarmWithDate:(NSDate*)date alertBody:(NSString*)bodyStr;
@end

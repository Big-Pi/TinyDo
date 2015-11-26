//
//  NotifyUtil.m
//  TinyDo
//
//  Created by pi on 15/11/24.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "NotifyUtil.h"
#import "Note.h"
@import UIKit;

@implementation NotifyUtil

+(void)scheduleAlarm:(Note*)note{
    
    NSMutableArray *oneWeek=[NSMutableArray arrayWithCapacity:7];
    NSCalendar *calendar=[NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *aday=[[NSDateComponents alloc]init];
    //
    NSArray *repeatWeek= note.remindRepeat;
    NSString *alertBody=note.content;
    
    NSString *alarmId;
    if(repeatWeek!=nil&&repeatWeek.count>1){
        //如果需要重复闹钟 生成一周的date
        for(int i=0;i<7;i++){
            aday.day=1*i;
            NSDate *weekDay= [calendar dateByAddingComponents:aday toDate:note.remindDate options:0];
            [oneWeek addObject:weekDay];
        }
        for(NSDate *date in oneWeek){
            //判断周几需要重复闹钟
            NSInteger week= [calendar component:NSCalendarUnitWeekday fromDate:date];
            if([repeatWeek containsObject:@(week)]){
                alarmId=[self scheduleWeekRepeatAlarmWithDate:date alertBody:alertBody];
            }
        }
    }else{
        //一次性闹钟
        alarmId=[self scheduleOnceAlarmWithDate:note.remindDate alertBody:alertBody];
    }
    note.alarmID=alarmId;
    
}

+(NSString*)scheduleOnceAlarmWithDate:(NSDate*)date alertBody:(NSString*)bodyStr{
    //0 不重复
    return [self scheduleAlarmWithDate:date repeat:0 alertBody:bodyStr];
}

+(NSString*)scheduleWeekRepeatAlarmWithDate:(NSDate*)date alertBody:(NSString*)bodyStr{
    //http://stackoverflow.com/questions/29754384/how-to-set-up-weekly-repeating-uilocalnotifications-with-ios-8-deprecations
    return [self scheduleAlarmWithDate:date repeat:NSCalendarUnitWeekOfYear alertBody:bodyStr];
}

+(NSString *)scheduleAlarmWithDate:(NSDate *)date repeat:(NSCalendarUnit)repeat alertBody:(NSString *)bodyStr{
    UILocalNotification *alarm=[[UILocalNotification alloc]init];
    alarm.fireDate=date;
    alarm.timeZone=[NSTimeZone defaultTimeZone];
    alarm.alertBody=bodyStr;
    alarm.repeatInterval=repeat;
    alarm.alertTitle=@"TinyDo";
    alarm.soundName=UILocalNotificationDefaultSoundName;
    NSString *uuid=[self uuid];
    alarm.userInfo=@{@"alarmID":uuid};
    [[UIApplication sharedApplication]scheduleLocalNotification:alarm];
    NSLog(@"scheduleAlarm :%@ ",alarm);
    return uuid;
}

+(void)cancelAlarm:(Note *)note{
    NSArray *localAlarms= [UIApplication sharedApplication].scheduledLocalNotifications;

    for (UILocalNotification *localAlarm in localAlarms) {
        if([note.alarmID isEqualToString:localAlarm.userInfo[@"alarmID"]]) {
            [[UIApplication sharedApplication]cancelLocalNotification:localAlarm];
            break;
        }
    }
}

+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end

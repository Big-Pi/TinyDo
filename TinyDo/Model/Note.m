//
//  Note.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Note.h"
#import "NotifyUtil.h"

@implementation Note

-(void)setDeleted:(NSNumber *)deleted{
    
    [self willChangeValueForKey:@"deleted"];
    [self setPrimitiveValue:deleted forKey:@"deleted"];
    [self didChangeValueForKey:@"deleted"];
    [self willChangeValueForKey:@"deperacted"];
    [self setPrimitiveValue:@(![deleted boolValue]) forKey:@"deperacted"];
    [self didChangeValueForKey:@"deperacted"];
}

-(void)setDeperacted:(NSNumber *)deperacted{
    [self willChangeValueForKey:@"deperacted"];
    [self setPrimitiveValue:deperacted forKey:@"deperacted"];
    [self didChangeValueForKey:@"deperacted"];
    [self willChangeValueForKey:@"deleted"];
    [self setPrimitiveValue:@(![deperacted boolValue]) forKey:@"deleted"];
    [self didChangeValueForKey:@"deleted"];
    
}

-(void)setNeedRemind:(NSNumber *)needRemind{
    [self willChangeValueForKey:@"needRemind"];
    [self setPrimitiveValue:needRemind forKey:@"needRemind"];
    [self didChangeValueForKey:@"needRemind"];
    if([needRemind boolValue]){
        [NotifyUtil scheduleAlarm:self];
    }else{
        [NotifyUtil cancelAlarm:self];
    }
}
@end

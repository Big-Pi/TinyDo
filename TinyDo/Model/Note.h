//
//  Note.h
//  TinyDo
//
//  Created by pi on 15/10/25.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * pirority;
@property (nonatomic, retain) NSDate * remindDate;
@property (nonatomic, retain) NSNumber * remindRepeat;

@end

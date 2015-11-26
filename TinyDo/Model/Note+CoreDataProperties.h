//
//  Note+CoreDataProperties.h
//  TinyDo
//
//  Created by pi on 15/11/25.
//  Copyright © 2015年 pi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSNumber *deperacted;
@property (nullable, nonatomic, retain) NSNumber *needRemind;
@property (nullable, nonatomic, retain) NSNumber *pirority;
@property (nullable, nonatomic, retain) NSDate *remindDate;
@property (nullable, nonatomic, retain) id remindRepeat;
@property (nullable, nonatomic, retain) NSString *alarmID;

@end

NS_ASSUME_NONNULL_END

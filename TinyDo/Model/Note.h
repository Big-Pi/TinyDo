//
//  Note.h
//  TinyDo
//
//  Created by pi on 15/11/28.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, NoteState) {
    NoteStateNormal,
    NoteStateDeprecated,
    NoteStateDeleted
};
@interface Note : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)setNoteState:(NoteState)noteState;
@end

NS_ASSUME_NONNULL_END

#import "Note+CoreDataProperties.h"

//
//  CoreDataStack.h
//  TinyDo
//
//  Created by pi on 15/10/25.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@import CoreData;

@interface CoreDataStack : NSObject
@property(nonatomic,strong,readonly)NSManagedObjectContext *context;
@property(nonatomic,strong,readonly)NSPersistentStoreCoordinator *psc;
@property(nonatomic,strong,readonly)NSManagedObjectModel *model;
@property(nonatomic,strong,readonly)NSPersistentStore *store;

-(NSArray*)fetchAllNotes;
-(void)deleteNote:(Note *)note;
-(Note*)insertNote;
+(instancetype)sharedStack;
-(void)saveContext;
@end

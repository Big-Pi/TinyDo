//
//  CoreDataStack.m
//  TinyDo
//
//  Created by pi on 15/10/25.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "CoreDataStack.h"
@import CoreText;

@interface CoreDataStack ()
@property(nonatomic,strong)NSManagedObjectContext *context;
@property(nonatomic,strong)NSPersistentStoreCoordinator *psc;
@property(nonatomic,strong)NSManagedObjectModel *model;
@property(nonatomic,strong)NSPersistentStore *store;
@end

@implementation CoreDataStack

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url= [[NSBundle mainBundle]URLForResource:@"TinyDo" withExtension:@"momd"];
        //
        self.model=[[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        self.psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
        self.context =[[NSManagedObjectContext alloc]init];
        self.context.persistentStoreCoordinator=self.psc;
        //
        NSURL *documentUrl=[self applicationDocumentsDirectory];
        NSURL *storeUrl=[documentUrl URLByAppendingPathComponent:@"TinyDo"];
        NSDictionary *options= @{NSMigratePersistentStoresAutomaticallyOption:@YES};
        
        NSError *error;
        self.store=[self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
        
        if(self.store==nil){
            NSLog(@"Error add persistent store %@",[error localizedDescription]);
        }
    }
    return self;
}

+(instancetype)sharedStack{
    static id stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack=[[CoreDataStack alloc]init];
    });
    return stack;
}

-(Note*)fetchNoteWithNoteID:(NSString*)noteID{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteID=%@",noteID];
    request.predicate=predicate;
    NSError *error;
    NSArray *result=[self.context executeFetchRequest:request error:&error];
    if(!result){
        NSLog(@"%@",[error localizedDescription]);
    }
    return [result lastObject];
}

-(NSArray *)fetchAllNotes{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deleted = %@",@NO];
    request.predicate=predicate;
    NSError *error;
    NSArray *result= [self.context executeFetchRequest:request error:&error];
    if(!result){
        NSLog(@"%@",[error localizedDescription]);
    }
    return result;
}

-(NSArray*)fetchAllDeletedNotes{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"deleted = %@",@YES];
    request.predicate=predicate;
    NSError *error;
    NSArray *result= [self.context executeFetchRequest:request error:&error];
    if(!result){
        NSLog(@"%@",[error localizedDescription]);
    }
    return result;
}

-(Note *)insertNote{
    NSEntityDescription *noteDescription= [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.context];
    Note *note= [[Note alloc]initWithEntity:noteDescription insertIntoManagedObjectContext:self.context];
    note.noteID=[self uuid];
    return note;
}

-(void)deleteNote:(Note *)note{
    note.deleted=@YES;
    note.deletedDate=[NSDate date];
    [self saveContext];
}

-(void)destoryNote:(Note *)note{
    [self.context deleteObject:note];
    [self saveContext];
}

-(NSURL*)applicationDocumentsDirectory{
    return (NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];;
}

-(void)saveContext{
    NSLog(@"%@",@"saving all the note changes~~!!");
    NSError *error;
    if([self.context hasChanges] && ![self.context save:&error]){
        NSLog(@"Could not save %@",[error localizedDescription]);
    }
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end

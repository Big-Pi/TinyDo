//
//  CoreDataStack.m
//  TinyDo
//
//  Created by pi on 15/10/25.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "CoreDataStack.h"

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

-(NSArray *)fetchAllNotes{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Note"];
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
    return note;
}
-(void)deleteNote:(Note *)note{
    [self.context deleteObject:note];
}

-(NSURL*)applicationDocumentsDirectory{
    return (NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];;
}

-(void)saveContext{
    NSError *error;
    if([self.context hasChanges] && ![self.context save:&error]){
        NSLog(@"Could not save %@",[error localizedDescription]);
    }
}
@end

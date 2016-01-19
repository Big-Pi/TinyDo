//
//  Note.m
//  TinyDo
//
//  Created by pi on 15/11/28.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Note.h"
#import "CoreDataStack.h"

@interface Note ()

@end

@implementation Note

+(CoreDataStack *)db{
    static id db;
    if(!db){
        db=[CoreDataStack sharedStack];
    }
    return db;
}

+(NSArray*)fetchAllNotes{
    return [[Note db]fetchAllNotes];
}

+(NSArray*)fetchAllDeletedNotes{
    return [[Note db]fetchAllDeletedNotes];
}

+(Note*)fetchNoteWithNoteID:(NSString*)noteID{
    return [[Note db]fetchNoteWithNoteID:noteID];
}

-(void)deleteNote{
    return [[CoreDataStack sharedStack]deleteNote:self];
}

-(void)destoryNote{
    return [[CoreDataStack sharedStack]destoryNote:self];
}

+(Note*)insertNote{
    Note *note=[[self db]insertNote];
    note.createDate=[NSDate date];
    return note;
}

+(void)syncNotes{
    [[self db]saveContext];
}

-(void)setNoteState:(NoteState)noteState{
    switch (noteState) {
        case NoteStateNormal:
            self.deleted=@NO;
            self.deperacted=@NO;
            break;
        case NoteStateDeleted:
            self.deleted=@YES;
            self.deperacted=@NO;
            break;
        case NoteStateDeprecated:
            self.deleted=@NO;
            self.deperacted=@YES;
            break;
    }
}

-(NSComparisonResult)sortByCreateDate:(Note*)otherNote{
    return [otherNote.createDate compare:self.createDate];
}

@end

//
//  Note.m
//  TinyDo
//
//  Created by pi on 15/11/28.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Note.h"

@implementation Note

// Insert code here to add functionality to your managed object subclass
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
@end

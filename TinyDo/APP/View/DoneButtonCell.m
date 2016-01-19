//
//  DoneButtonCell.m
//  TinyDo
//
//  Created by pi on 15/12/31.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "DoneButtonCell.h"
typedef void(^DoneBlock)();

@interface DoneButtonCell ()
@property (copy,nonatomic) DoneBlock doneBlock;
@end

@implementation DoneButtonCell
- (IBAction)done:(id)sender {
    self.doneBlock();
}
-(void)onDone:(void (^)())done{
    _doneBlock=done;
}
@end

//
//  TimePickerCell.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "TimePickerCell.h"
#import "NotificationUtil.h"
#import "Note.h"

@implementation TimePickerCell

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (IBAction)timeChanged:(UIDatePicker *)sender {
    if(self.delegate){
        [self.delegate timePickerCell:self didTimeChanged:sender.date];
    }
}
-(id)configWithEditableNote:(Note *)note{
    if(note.remindDate){
        self.timePicker.date=note.remindDate;
    }else{
        self.timePicker.date=[NSDate date];
    }
    self.contentView.alpha=0.0;
    return self;
}
+(NSInteger)cellHeight{
    return 264;
}
@end

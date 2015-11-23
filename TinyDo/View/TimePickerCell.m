//
//  TimePickerCell.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "TimePickerCell.h"

@implementation TimePickerCell

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (IBAction)timeChanged:(UIDatePicker *)sender {
    if(self.delegate){
        [self.delegate timePickerCell:self didTimeChanged:sender.date];
    }
}

@end

//
//  TimePickerCell.h
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimePickerCell;

@protocol TimePickerCellDelegate <NSObject>

-(void)timePickerCell:(TimePickerCell *)cell didTimeChanged:(NSDate*)date;

@end
@interface TimePickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property(nonatomic,weak) id<TimePickerCellDelegate> delegate;
@end

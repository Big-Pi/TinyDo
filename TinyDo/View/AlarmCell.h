//
//  AlarmCell.h
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlarmCell;

@protocol AlarmCellDelegate <NSObject>
-(void)alarmCell:(AlarmCell*)cell didSelectedBtnChanged:(NSSet*)selectedIndex msgString:(NSString*)msg;
@end

@interface AlarmCell : UITableViewCell
@property(nonatomic,weak) id<AlarmCellDelegate> delegate;
-(void)setTimeMsg:(NSString*)timeMsg;
-(void)setRepeatMsg:(NSString*)repeatMsg;
@end

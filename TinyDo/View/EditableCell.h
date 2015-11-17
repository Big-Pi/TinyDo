//
//  EditableCell.h
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditableCell;

@protocol EditableCellDelegate <NSObject>
@required
-(void)editableCellDidAlarmClick:(EditableCell *)cell;
-(void)editableCellDidPriorityClick:(EditableCell *)cell;
-(void)editableCellDidEndEditNote:(EditableCell *)cell;

@end

@interface EditableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic) BOOL setInsertOrEdit;
@property(nonatomic,weak)id<EditableCellDelegate> delegate;
-(void)setInsertOrEdit:(BOOL)insertOrEdit anim:(BOOL)anim;
@end

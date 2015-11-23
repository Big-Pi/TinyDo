//
//  EditableContent.h
//  TinyDo
//
//  Created by pi on 15/11/24.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditableContent;

@protocol EditableContentDelegate <NSObject>
-(void)editableContentDidAlarmClick:(EditableContent*)content selected:(BOOL)isSelected;

-(void)editableContentDidPriorityClick:(EditableContent*)content selected:(BOOL)isSelected;
-(void)editableContentDidEndEditNote:(EditableContent *)content;
@end

@interface EditableContent : UIView
@property(nonatomic,weak) id<EditableContentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
@property (weak, nonatomic) IBOutlet UITextField *textField;
//
@property(nonatomic) BOOL setInsertOrEdit;
-(void)setInsertOrEdit:(BOOL)insertOrEdit anim:(BOOL)anim;
-(void)setInsertOrEdit:(BOOL)insertOrEdit anim:(BOOL)anim completion:(void (^)())completion;
@end

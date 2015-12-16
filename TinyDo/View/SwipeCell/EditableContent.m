//
//  EditableContent.m
//  TinyDo
//
//  Created by pi on 15/11/24.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "EditableContent.h"
#import "Note.h"


@interface EditableContent ()<UITextFieldDelegate>


@end

@implementation EditableContent


-(void)awakeFromNib{
    [super awakeFromNib];
    
    //    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.textField.delegate=self;
    self.alarm.alpha=0.0;
    self.priority.alpha=0.0;
    self.textField.enabled=NO;
    //
    //make left padding for textField
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20*[UIScreen mainScreen].scale, 0)];
    self.textField.leftView=leftView;
    self.textField.leftViewMode=UITextFieldViewModeAlways;
    //
    [self.priority setImage:[[UIImage imageNamed:@"Priority"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.alarm setImage:[[UIImage imageNamed:@"Alarm"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
}
- (IBAction)alarmClick:(UIButton *)sender {
    self.alarm.selected=!self.alarm.selected;
    [self.delegate editableContentDidAlarmClick:self selected:self.alarm.selected];
}

- (IBAction)priorityClick:(UIButton *)sender {
    self.priority.selected=!self.priority.selected;
    [self.delegate editableContentDidPriorityClick:self selected:self.priority.selected];
}

-(void)setInsertOrEdit:(BOOL)insertOrEdit anim:(BOOL)anim{
    [self setInsertOrEdit:insertOrEdit anim:anim completion:nil];
}

-(void)setInsertOrEdit:(BOOL)insertOrEdit anim:(BOOL)anim completion:(void (^)())completion{
    if(anim){
        [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alarm.alpha= insertOrEdit ? 1.0 : 0.0;
            self.priority.alpha= insertOrEdit ? 1.0 :0.0;
            
            //scale 为0.0无动画？
            self.alarm.transform=insertOrEdit ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformMakeScale(0.1, 0.1);
            self.priority.transform =insertOrEdit ? CGAffineTransformMakeScale(1.2, 1.2) :CGAffineTransformMakeScale(0.1, 0.1);
            self.seprateLine.alpha=insertOrEdit ? 0.3 :0.0;
        } completion:^(BOOL finished) {
            if(insertOrEdit){
                self.priority.transform=CGAffineTransformIdentity;
                self.alarm.transform=CGAffineTransformIdentity;
            }
            if(completion){
                completion();
            }
        }];
    }else{
        self.alarm.alpha= insertOrEdit ? 1.0 : 0.0;
        self.priority.alpha= insertOrEdit ? 1.0 :0.0;
        self.alarm.transform=insertOrEdit ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.0, 0.0);
        self.priority.transform =insertOrEdit ? CGAffineTransformIdentity :CGAffineTransformMakeScale(0.0, 0.0);
        self.seprateLine.alpha=insertOrEdit ? 0.3 :0.0;
        if(completion){
            completion();
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.text.length ==0 && string.length>0){
        //begin editing
        [self setInsertOrEdit:YES anim:YES];
    }
    
    if(textField.text.length==1&&string.length==0){
        //end editing
        [self setInsertOrEdit:NO anim:YES];
    }
    //    NSLog(@"%ld----%ld",textField.text.length,string.length);
    
    NSString *newStr= [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self.delegate editableContentDidChangeNoteContent:newStr];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.delegate editableContentDidEndEditNote:self];
    return YES;
}

@end

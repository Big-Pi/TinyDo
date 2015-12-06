//
//  EditableCell.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//
#import "CoreDataStack.h"
#import "EditableCell.h"

@interface EditableCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *alarm;
@property (weak, nonatomic) IBOutlet UIButton *priority;
@end

@implementation EditableCell

- (IBAction)alarmClick:(UIButton *)sender {
    [self.alarm setSelected:!self.alarm.selected];
    [self.delegate editableCellDidAlarmClick:self selected:self.alarm.selected];
}

- (IBAction)priorityClick:(UIButton *)sender {
    [self.priority setSelected:!self.priority.selected];
    [self.delegate editableCellDidPriorityClick:self selected:self.priority.selected];
}


-(void)awakeFromNib
{
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

//-(void)setInsertOrEdit:(BOOL)insertOrEdit
//{
//    if(insertOrEdit){
//        //show alarm priority button
//        [UIView animateWithDuration:0.4 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.alarm.alpha=1.0;
//            self.priority.alpha=1.0;
//            self.alarm.transform=CGAffineTransformScale(self.alarm.transform, 1.2, 1.2);
//            self.priority.transform=CGAffineTransformScale(self.alarm.transform, 1.2, 1.2);
//            self.seprateLine.alpha=0.3;
//        } completion:^(BOOL finished) {
//            //
//            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.alarm.transform=CGAffineTransformIdentity;
//                self.priority.transform=CGAffineTransformIdentity;
//            } completion:nil];
//        }];
//    }else{
//        //hide them
//        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.alarm.alpha=0.0;
//            self.priority.alpha=0.0;
//            self.seprateLine.alpha=0.0;
//            self.alarm.transform=CGAffineTransformMakeScale(0.1, 0.1);
//            self.priority.transform=CGAffineTransformMakeScale(0.1, 0.1);
//        } completion:^(BOOL finished) {
//            self.alarm.transform=CGAffineTransformIdentity;
//            self.alarm.transform=CGAffineTransformIdentity;
//        }];
//    }
//    
//}

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
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text length]>0){
        Note *note= [[CoreDataStack sharedStack]insertNote];
        note.content=textField.text;
    }
    [self.delegate editableCellDidEndEditNote:self];
    return YES;
}
@end

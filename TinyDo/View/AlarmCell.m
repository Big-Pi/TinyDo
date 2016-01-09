//
//  AlarmCell.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "AlarmCell.h"
#import "DateBtn.h"
#import "Note.h"
#import "Helper.h"


@interface AlarmCell ()<DateBtnDelegate>

@property (strong,nonatomic) NSMutableSet *dateBtnSet;
@property (weak, nonatomic) IBOutlet UIButton *repeatLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (strong, nonatomic) Note *note;
@end

@implementation AlarmCell

- (void)awakeFromNib {
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
+(NSInteger)cellHeight{
    return 204;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *v in self.contentView.subviews) {
        if([v isMemberOfClass:[DateBtn class]]){
            DateBtn *btn=(DateBtn*)v;
            btn.delegate=self;
            [self.dateBtnSet addObject:btn];
            if(btn.tag){
                NSNumber *key=@(btn.tag);
                [btn setText:[Helper dataDict][key]];
            }
        }
    }
    NSArray *remindRepeat= self.note.remindRepeat;
    for (DateBtn *btn in self.dateBtnSet) {
        if([remindRepeat containsObject:@(btn.tag)]){
            [btn setDateBtnSelected:YES];
        }
    }
}
-(NSMutableSet *)dateBtnSet{
    if(!_dateBtnSet){
        _dateBtnSet=[NSMutableSet set];
    }
    return _dateBtnSet;
}

-(void)setTimeMsg:(NSString *)timeMsg{
    [self.timeLabel setTitle:timeMsg forState:UIControlStateNormal];
}

-(void)setRepeatMsg:(NSString*)repeatMsg{
    [self.repeatLabel setTitle:repeatMsg forState:UIControlStateNormal];
}

-(id)configWithEidtableNote:(Note *)note{
    
    if(note.remindDate!=nil){
        [self setTimeMsg:[Helper shortTimeStringFromDate:note.remindDate]];
    }
    if(note.remindRepeat!=nil){
        [self setRepeatMsg:[Helper repeatMsgFromRaw:note.remindRepeat]];
    }
    
    self.note=note;
    self.contentView.alpha=0.0;
    return self;
}

-(NSMutableSet *)selectedRepeatedWeek{
    _selectedRepeatedWeek=[NSMutableSet set];
    for(DateBtn *btn in self.dateBtnSet){
        if(btn.isDateBtnSelected){
            [_selectedRepeatedWeek addObject:@(btn.tag)];
        }
    }
    return _selectedRepeatedWeek;
}

#pragma mark - DateBtnDelegate
-(void)dateBtn:(UIButton *)btn didSelectionChanged:(BOOL)selected{
    NSMutableString *msg=[NSMutableString string];
    NSMutableSet *selectedRepeatedWeek=[self selectedRepeatedWeek];
    if(selectedRepeatedWeek.count==0){
        
        [msg appendString:NSLocalizedString(@"仅一次", @"仅一次")];
    }else if(selectedRepeatedWeek.count==[Helper dataDict].count){
        [msg appendString:NSLocalizedString(@"每天", @"每天")];
    }else{
        NSArray *sortedBtns=[self.dateBtnSet sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
        
        for (DateBtn *btn in sortedBtns) {
            if(btn.isDateBtnSelected){
                NSNumber *key=@(btn.tag);
                [msg appendString:[Helper dataDict][key]];
                [msg appendString:@", "];
            }
        }
        //删掉最后一个逗号和空格
        if(msg.length>0){
            [msg deleteCharactersInRange:NSMakeRange(msg.length-2, 2)];
        }
    }
    [self.repeatLabel setTitle:msg forState:UIControlStateNormal];
    [self.delegate alarmCell:self didSelectedBtnChanged:selectedRepeatedWeek msgString:msg];
}

@end

//
//  EditNoteViewController.m
//  TinyDo
//
//  Created by pi on 15/10/28.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "EditNoteViewController.h"
#import "SwipeableCell.h"
#import "CoreDataStack.h"
#import "AlarmCell.h"
#import "TimePickerCell.h"
#import "Note.h"
#import "Helper.h"
#import "NotifyUtil.h"


@interface EditNoteViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmCellDelegate,TimePickerCellDelegate,EditableContentDelegate>
@property(nonatomic)EditMode mode;
@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwipeableCell" bundle:nil] forCellReuseIdentifier:@"SwipeableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AlarmCell" bundle:nil] forCellReuseIdentifier:@"AlarmCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimePickerCell" bundle:nil] forCellReuseIdentifier:@"TimePickerCell"];
    
    
    
    //如果note!=nil 是编辑 否则是插入
    if(self.note!=nil){
        self.editCell.editableContent.textField.text=self.note.content;
        self.mode=Edit;
    }else{
        self.note=[[CoreDataStack sharedStack]insertNote];
        self.note.remindDate=[NSDate date];
    }
}
#pragma mark - Getter Setter

-(EditMode)mode{
    if (!_mode) {
        _mode=Insert;
    }
    return _mode;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //
    [self.editCell.editableContent.textField becomeFirstResponder];
    //如果是修改note内容,则直接显示button动画
    if(self.note.content&&self.note.content.length>0){
        [self.editCell.editableContent setInsertOrEdit:YES anim:YES];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        SwipeableCell *swipeCell=[tableView dequeueReusableCellWithIdentifier:@"SwipeableCell"];
        
        swipeCell.editableContent.delegate=self;
        [swipeCell setSwipeable:NO];
        //
        swipeCell.editableContent.textField.text=@"";
        swipeCell.editableContent.textField.enabled=YES;
        swipeCell.editableContent.textField.placeholder=@"我想。。。。";
        swipeCell.editableContent.alarm.selected=[self.note.needRemind boolValue];
        swipeCell.editableContent.priority.selected=[self.note.pirority boolValue];
        //
        return swipeCell;
    }
    if(indexPath.row==1){
        AlarmCell *alarmCell= [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
        alarmCell.delegate=self;
        if(self.note.remindDate!=nil){
            [alarmCell setTimeMsg:[Helper shortTimeStringFromDate:self.note.remindDate]];
        }
        if(self.note.remindRepeat!=nil){
            [alarmCell setRepeatMsg:[Helper repeatMsgFromRaw:self.note.remindRepeat]];
        }
        return alarmCell;
    }else if(indexPath.row==2){
        TimePickerCell *timePickerCell= [tableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
        timePickerCell.delegate=self;
        if(self.note.remindDate){
            timePickerCell.timePicker.date=self.note.remindDate;
        }else{
            timePickerCell.timePicker.date=[NSDate date];
        }
        return timePickerCell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].contentView.frame.size.height;
}

//-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
//    NSLog(@"segueForUnwindingToViewController");
//    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
//}

#pragma mark - hack method
-(SwipeableCell *)editCell{
    return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
-(AlarmCell*)alarmCell{
    return [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

#pragma mark - AlarmCellDelegate
-(void)alarmCell:(AlarmCell *)cell didSelectedBtnChanged:(NSSet *)selectedIndex msgString:(NSString *)msg{
    NSLog(@"%@",msg);
    self.note.remindRepeat=[selectedIndex allObjects];
}

#pragma mark - TimePickerCellDelegate
-(void)timePickerCell:(TimePickerCell *)cell didTimeChanged:(NSDate *)date{
    NSLog(@"%@",date);
    AlarmCell *alarmCell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [alarmCell setTimeMsg:[Helper shortTimeStringFromDate:date]];
        self.note.remindDate=date;
}

#pragma mark - EditableContentDelegate
-(void)editableContentDidPriorityClick:(EditableContent *)content selected:(BOOL)isSelected{
    self.note.pirority=@(isSelected);
}

-(void)editableContentDidEndEditNote:(EditableContent *)content{
    [self.view endEditing:YES];
    self.note.content=self.editCell.editableContent.textField.text;
    [[CoreDataStack sharedStack]saveContext];
    [self.delegate editNoteViewControllerDidEndEdit:self withNote:self.note editMode:self.mode];
}

-(void)editableContentDidAlarmClick:(EditableContent *)content selected:(BOOL)isSelected{
    self.note.needRemind=@(isSelected);
    if(isSelected){
        self.note.remindRepeat = [self alarmCell].selectedRepeatedWeek;
        [NotifyUtil scheduleAlarm:self.note];
    }else{
        self.note.remindRepeat=nil;
        [NotifyUtil cancelAlarm:self.note];
    }
    [[CoreDataStack sharedStack]saveContext];
}

-(void)dealloc{
    [[CoreDataStack sharedStack]saveContext];
    NSLog(@"EditNoteViewController___dealloc");
}
@end

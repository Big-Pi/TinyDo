//
//  EditNoteViewController.m
//  TinyDo
//
//  Created by pi on 15/10/28.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "EditNoteViewController.h"
#import "SwipeableCell.h"
#import "AlarmCell.h"
#import "TimePickerCell.h"
#import "Note.h"
#import "Helper.h"
#import "NotifyUtil.h"
#import "DoneButtonCell.h"


@interface EditNoteViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmCellDelegate,TimePickerCellDelegate,EditableContentDelegate>
@property(nonatomic)EditMode mode;
@property (weak, nonatomic) AlarmCell *alarmCell;
@property (weak, nonatomic,readwrite) SwipeableCell *editCell;
@property (weak, nonatomic) TimePickerCell *timePickerCell;
@end

@implementation EditNoteViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    self.restorationIdentifier=NSStringFromClass([EditNoteViewController class]);
    self.restorationClass=[EditNoteViewController class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwipeableCell" bundle:nil] forCellReuseIdentifier:@"SwipeableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AlarmCell" bundle:nil] forCellReuseIdentifier:@"AlarmCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimePickerCell" bundle:nil] forCellReuseIdentifier:@"TimePickerCell"];
    
    //如果note!=nil 是编辑 否则是插入
    if(self.note!=nil){
        self.mode=Edit;
    }else{
        self.note=[Note insertNote];
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
    
    [self fadeInView:self.alarmCell.contentView];
    [self fadeInView:self.timePickerCell.contentView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.note.remindDate = self.timePickerCell.timePicker.date;
    [NotifyUtil cancelAlarm:self.note];
    if([self.note.needRemind boolValue]){
        [NotifyUtil scheduleAlarm:self.note];
    }
    [Note syncNotes];
}


#pragma mark - UITableViewDelegate UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        SwipeableCell *swipeCell=[tableView dequeueReusableCellWithIdentifier:@"SwipeableCell"];
        [swipeCell setSwipeable:NO];
        //
        swipeCell.editableContent.textField.text=self.note.content;
        swipeCell.editableContent.textField.enabled=YES;
        swipeCell.editableContent.textField.placeholder=@"我想。。。。";
        swipeCell.editableContent.alarm.selected=[self.note.needRemind boolValue];
        swipeCell.editableContent.priority.selected=[self.note.pirority boolValue];
        swipeCell.editableContent.delegate=self;
        //
        self.editCell=swipeCell;
        return swipeCell;
    }
    if(indexPath.row==1){
        AlarmCell *alarmCell= [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
        alarmCell.delegate=self;
        [alarmCell configWithEidtableNote:self.note];
        self.alarmCell=alarmCell;
        return alarmCell;
    }else if(indexPath.row==2){
        TimePickerCell *timePickerCell= [tableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
        [timePickerCell configWithEditableNote: self.note];
        timePickerCell.delegate=self;
        self.timePickerCell=timePickerCell;
        return timePickerCell;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DoneButtonCell *cell= [tableView dequeueReusableCellWithIdentifier:@"DoneButtonCell"];
    [cell onDone:^{
        [self editableContentDidEndEditNote:self.editCell.editableContent];
    }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat H= CGRectGetHeight(self.tableView.bounds);
    H=H-[SwipeableCell cellHeight]-[AlarmCell cellHeight]-[TimePickerCell cellHeight];
    if(H<44){
        return 44;
    }
    return H;
}

#warning temp way to calclate cell height for different kind of cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger h=0;
    switch (indexPath.row) {
        case 0:
            h=[SwipeableCell cellHeight];
            break;
        case 1:
            h=[AlarmCell cellHeight];
            break;
        case 2:
            h=[TimePickerCell cellHeight];
            break;
    }
    return h;
}

#pragma mark - private
-(void)fadeInView:(UIView*)v{
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        v.alpha=1.0;
    } completion:^(BOOL finished) {
    }];
}

-(void)fadeOutSelf{
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alarmCell.contentView.alpha=0.0;
        self.timePickerCell.contentView.alpha=0.0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - State Restoration
+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if(sb){
        EditNoteViewController *vc= [sb instantiateViewControllerWithIdentifier:NSStringFromClass([EditNoteViewController class])];
        vc.restorationClass=[EditNoteViewController class];
        vc.restorationIdentifier=[identifierComponents lastObject];
        return vc;
    }
    return nil;
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
    
    NSString *noteID=self.note.noteID;
    NSLog(@"%@",noteID);
    [coder encodeObject:noteID forKey:@"noteID"];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"%@",[coder decodeObjectForKey:@"noteID"]);
    self.note=[Note fetchNoteWithNoteID:[coder decodeObjectForKey:@"noteID"]];
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
    self.note.needRemind=@YES;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditableContentDelegate
-(void)editableContentDidPriorityClick:(EditableContent *)content selected:(BOOL)isSelected{
    self.note.pirority=@(isSelected);
}

-(void)editableContentDidEndEditNote:(EditableContent *)content{
    [self.view endEditing:YES];
    self.note.content=self.editCell.editableContent.textField.text;
    [self.delegate editNoteViewControllerDidEndEdit:self withNote:self.note editMode:self.mode];
}

-(void)editableContentDidChangeNoteContent:(NSString *)noteContent{
    self.note.content=noteContent;
}

-(void)editableContentDidAlarmClick:(EditableContent *)content selected:(BOOL)isSelected{
    self.note.needRemind=@(isSelected);
    if(isSelected){
        self.note.remindRepeat = [self alarmCell].selectedRepeatedWeek;
    }else{
        self.note.remindRepeat=nil;
    }
}

-(void)dealloc{
    NSLog(@"EditNoteViewController___dealloc");
}
@end

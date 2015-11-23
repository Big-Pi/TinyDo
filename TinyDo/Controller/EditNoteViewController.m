//
//  EditNoteViewController.m
//  TinyDo
//
//  Created by pi on 15/10/28.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "EditNoteViewController.h"
#import "EditableCell.h"
#import "CoreDataStack.h"
#import "AlarmCell.h"
#import "TimePickerCell.h"
#import "Note.h"

@interface EditNoteViewController ()<UITableViewDelegate,UITableViewDataSource,EditableCellDelegate,AlarmCellDelegate,TimePickerCellDelegate>

@property(strong,nonatomic)EditableCell *editCell;
@property(nonatomic)EditMode mode;
@property (strong, nonatomic) AlarmCell *alarmCell;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditableCell" bundle:nil] forCellReuseIdentifier:@"EditableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AlarmCell" bundle:nil] forCellReuseIdentifier:@"AlarmCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TimePickerCell" bundle:nil] forCellReuseIdentifier:@"TimePickerCell"];
    
    //如果note!=nil 是编辑 否则是插入
    if(self.note!=nil){
        self.editCell.textField.text=self.note.content;
        self.mode=Edit;
    }else{
        self.note=[[CoreDataStack sharedStack]insertNote];
    }
    self.editCell.delegate=self;
}

-(EditMode)mode{
    if (!_mode) {
        _mode=Insert;
    }
    return _mode;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.editCell.textField becomeFirstResponder];
    //如果是修改note内容,则直接显示button动画
    if(self.note.content&&self.note.content.length>0){
        [self.editCell setInsertOrEdit:YES anim:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        self.editCell=[tableView dequeueReusableCellWithIdentifier:@"EditableCell"];
        self.editCell.textField.text=@"";
        self.editCell.textField.enabled=YES;
        self.editCell.textField.placeholder=@"我想。。。。";
        return self.editCell;
    }
    if(indexPath.row==1){
        AlarmCell *alarmCell= [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
        alarmCell.delegate=self;
        self.alarmCell=alarmCell;
        return alarmCell;
    }else if(indexPath.row==2){
        TimePickerCell *timePickerCell= [tableView dequeueReusableCellWithIdentifier:@"TimePickerCell"];
        timePickerCell.delegate=self;
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

#pragma mark - EditableCellDelegate
-(void)editableCellDidAlarmClick:(EditableCell *)cell selected:(BOOL)selected{
    self.note.needRemind=@(selected);
}

-(void)editableCellDidPriorityClick:(EditableCell *)cell selected:(BOOL)selected{
    self.note.pirority=@(selected);
}

-(void)editableCellDidEndEditNote:(EditableCell *)cell{
    [self.view endEditing:YES];
    self.note.content=self.editCell.textField.text;
    [self.delegate editNoteViewControllerDidEndEdit:self withNote:self.note editMode:self.mode];
}

-(void)dealloc{
    NSLog(@"EditNoteViewController___dealloc");
}

//-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
//    NSLog(@"segueForUnwindingToViewController");
//    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
//}

#pragma mark - AlarmCellDelegate
-(void)alarmCell:(AlarmCell *)cell didSelectedBtnChanged:(NSSet *)selectedIndex msgString:(NSString *)msg{
    NSLog(@"%@",msg);
    self.note.remindRepeat=[selectedIndex allObjects];
}

#pragma mark - TimePickerCellDelegate
-(void)timePickerCell:(TimePickerCell *)cell didTimeChanged:(NSDate *)date{
    NSLog(@"%@",date);
    AlarmCell *alarmCell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [alarmCell setTimeMsg:[date description]];
    self.note.remindDate=date;
}

@end

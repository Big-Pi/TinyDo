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

@interface EditNoteViewController ()<UITableViewDelegate,UITableViewDataSource,EditableCellDelegate>


@property(strong,nonatomic)EditableCell *editCell;
@property(nonatomic)EditMode mode;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight=66;
    if(self.note!=nil){
        self.editCell.textField.text=self.note.content;
        self.mode=Edit;
    }else{
        self.note=[[CoreDataStack sharedStack]insertNote];
    }
    self.editCell.delegate=self;
}

-(EditableCell *)editCell{
    if(!_editCell){
        _editCell=[[[NSBundle mainBundle]loadNibNamed:@"EditableCell" owner:nil options:nil]lastObject];
        _editCell.textField.text=@"";
        _editCell.textField.enabled=YES;
        _editCell.textField.placeholder=@"我想。。。。";
    }
    return _editCell;
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
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.editCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


#pragma mark - EditableCellDelegate

-(void)editableCellDidAlarmClick:(EditableCell *)cell{
    [UIView animateWithDuration:0.0 animations:nil completion:nil];
}

-(void)editableCellDidPriorityClick:(EditableCell *)cell{
    
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
@end

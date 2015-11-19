//
//  ToDoListViewController.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "ToDoListViewController.h"
#import "EditableCell.h"
#import "Note.h"
#import "CoreDataStack.h"
#import "EditNoteViewController.h"
#import "NoNotePlaceHolderCell.h"
#import "MagicTransitionAnimator.h"
#import "DrawerToolbar.h"

@import CoreData;

@interface ToDoListViewController ()<UITableViewDataSource,UITableViewDelegate,EditNoteViewControllerDelegate,UIViewControllerTransitioningDelegate,DrawerToolbarDelegate>

@property(nonatomic,strong)NSMutableArray *notes;
@property (weak, nonatomic) IBOutlet DrawerToolbar *drawerToolbar;
@property(nonatomic,strong)MagicTransitionAnimator *animator;
@end

@implementation ToDoListViewController


#pragma mark - getter setter
-(MagicTransitionAnimator *)animator{
    if(!_animator){
        _animator=[[MagicTransitionAnimator alloc]init];
    }
    return _animator;
}

#pragma mark - ViewController LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NSArray *results= [[CoreDataStack sharedStack]fetchAllNotes];
    if([results count]>0){
        self.notes= [results mutableCopy];
    }else{
        self.notes=[[NSMutableArray alloc]initWithCapacity:10];
    }
    
//    //drawerToolbar constraints bugFix 在storyboard设置的约束在自定义view不生效？
//    self.drawerToolbar.delegate=self;
//    self.drawerToolbar.translatesAutoresizingMaskIntoConstraints=NO;
//    NSDictionary *dic=@{@"drawerToolbar":self.drawerToolbar};
//    NSArray *constaintH=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[drawerToolbar]|" options:0 metrics:nil views:dic];
//    NSArray *constaintV=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[drawerToolbar(==44)]-0-|" options:0 metrics:nil views:dic];
//    
//    //ios 8+ 用active 不用加到父view中
//    [NSLayoutConstraint activateConstraints:constaintV];
//    [NSLayoutConstraint activateConstraints:constaintH];
////    [self.view addConstraints:constaintH];
////    [self.view addConstraints:constaintV];
    //
    EditableCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"EditableCell" owner:nil options:nil]lastObject];
            cell.textField.text=@"";
            cell.textField.enabled=YES;
            cell.textField.placeholder=@"我想。。。。";
            cell.seprateLine.hidden=YES;
    self.tableView.tableHeaderView=cell.contentView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EditableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.contentInset=UIEdgeInsetsMake(-66+20, 0, 0, 0);
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.destinationViewController isKindOfClass:[EditNoteViewController class]]){
//        EditNoteViewController *vc= segue.destinationViewController;
//        vc.delegate=self;
//        if([sender isKindOfClass:[Note class]]){
//            vc.note=(Note *)sender;
//        }
//    }
//}


//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //淡入tableviewCell分割线
//    CABasicAnimation *alphaAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnim.fromValue=@0.0;
//    alphaAnim.toValue=@0.4;
//    alphaAnim.duration=0.6;
//    for(EditableCell *cell in self.tableView.visibleCells){
//        [cell.seprateLine.layer addAnimation:alphaAnim forKey:nil];
//    }
//}



#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.notes.count==0){
        return 1;
    }
    return [self.notes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.notes.count==0){
        NoNotePlaceHolderCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"NoNotePlaceHolderCell" owner:nil options:nil]lastObject];
        return cell;
    }
    Note *note=self.notes[indexPath.row];
    EditableCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textField.placeholder=@"";
    cell.seprateLine.alpha=0.3;
    cell.textField.text=[NSString stringWithFormat:@"%@",note.content];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.notes.count==0) return;
    EditNoteViewController *editNoteVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditNoteViewController"];
    editNoteVC.transitioningDelegate=self;
    editNoteVC.delegate=self;
    
    editNoteVC.note=self.notes[indexPath.row];
    self.animator.isInsert=NO;
    self.animator.selectedCellIndex=indexPath;
    
    //**************************************************************************//
    //odd bug sometimes presentViewController not animate immediately
    //but after touch it start animate ?
    //事件队列问题?
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:editNoteVC animated:YES completion:nil];
    });
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y<-66*1.3){
        EditNoteViewController *editNoteVC= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditNoteViewController"];
        editNoteVC.transitioningDelegate=self;
        editNoteVC.delegate=self;
        self.animator.isInsert=YES;
        [self presentViewController:editNoteVC animated:YES completion:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.notes.count >0;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //如果将要删除最后一个note,则notes为空 显示占位cell 提醒用户下拉创建新note
        if(self.notes.count==1){
            [[CoreDataStack sharedStack]deleteNote:[self.notes lastObject]];
            [self.notes removeAllObjects];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            Note *note2Remove=[self.notes objectAtIndex:indexPath.row];
            [[CoreDataStack sharedStack]deleteNote:note2Remove];
            [self.notes removeObjectIdenticalTo:note2Remove];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.notes.count>0){
        return 66;
    }else{
        return self.view.bounds.size.height;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}

#pragma mark - EditNoteViewControllerDelegate
-(void)editNoteViewControllerDidEndEdit:(EditNoteViewController *)controller withNote:(Note *)note editMode:(EditMode)mode{
        [controller dismissViewControllerAnimated:YES completion:nil];
    if (mode==Edit) {
        NSUInteger row=[self.notes indexOfObjectIdenticalTo:note];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }else if(mode==Insert){
        //如果将要添加第一个note,则添加之前notes为空 reloadRowAtIndex隐藏占位cell
        if(self.notes.count==0) {
            [self.notes insertObject:note atIndex:0];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }else{
            [self.notes insertObject:note atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.animator.isShowUp=NO;
    return self.animator;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.animator.isShowUp=YES;
    return self.animator;
}

#pragma mark - DrawerToolbarDelegate
-(void)onDrawerToolbar:(DrawerToolbar *)toolbar barButtonItemClick:(ImageBarButtonItemType)type{
    NSLog(@"%ld",type);
}


-(void)dealloc{
    NSLog(@"%@ ___dealloc",[self class] );
}

@end

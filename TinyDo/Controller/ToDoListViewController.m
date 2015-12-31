//
//  ToDoListViewController.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "ToDoListViewController.h"
#import "Note.h"
#import "EditNoteViewController.h"
#import "NoNotePlaceHolderCell.h"
#import "MagicTransitionAnimator.h"
#import "DrawerToolbar.h"
#import "Helper.h"
#import "HelpViewController.h"
#import "SwipeableCell.h"
#import "NotifyUtil.h"

@import CoreData;

@interface ToDoListViewController ()<UITableViewDataSource,UITableViewDelegate,EditNoteViewControllerDelegate,UIViewControllerTransitioningDelegate,DrawerToolbarDelegate,SwipeableCellDelegate>

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
    NSArray *results= [Note fetchAllNotes];
    if([results count]>0){
        self.notes= [results mutableCopy];
    }else{
        self.notes=[[NSMutableArray alloc]initWithCapacity:10];
    }
    
    //
    SwipeableCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"SwipeableCell" owner:nil options:nil]lastObject];
    [cell configPlaceHolderCell];
    cell.delegate=self;
    self.tableView.tableHeaderView=cell.contentView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwipeableCell" bundle:nil] forCellReuseIdentifier:@"SwipeableCell"];
    self.tableView.contentInset=UIEdgeInsetsMake(-66+20, 0, 0, 0);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //启动时检查一次是否第一次进入app
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [Helper checkFirstLaunch:self presentSplashVC:@"HelpViewController"];
    });
    [self.notes sortUsingSelector:@selector(sortByCreateDate:)];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

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

    //当没有note时显示占为cell
    if(self.notes.count==0){
        NoNotePlaceHolderCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"NoNotePlaceHolderCell" owner:nil options:nil]lastObject];
        return cell;
    }
    Note *note=self.notes[indexPath.row];
    SwipeableCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"SwipeableCell"];
    [cell configWithEidtableNote:note];
    cell.delegate=self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.notes.count==0) return;
    
    EditNoteViewController *editNoteVC= [self configEditNoteViewController];
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
        EditNoteViewController *editNoteVC=[self configEditNoteViewController];
        self.animator.isInsert=YES;
        [self presentViewController:editNoteVC animated:YES completion:nil];
    }
}

-(EditNoteViewController*)configEditNoteViewController{
    EditNoteViewController *editNoteVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"EditNoteViewController"];
    editNoteVC.transitioningDelegate=self;
    editNoteVC.delegate=self;
    return editNoteVC;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.notes.count >0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.notes.count>0){
        return 66;
    }else{
        return self.view.bounds.size.height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

#pragma mark - EditNoteViewControllerDelegate
-(void)editNoteViewControllerDidEndEdit:(EditNoteViewController *)controller withNote:(Note *)note editMode:(EditMode)mode{
        [controller dismissViewControllerAnimated:YES completion:nil];
    if (mode==Edit) {
        NSUInteger row=[self.notes indexOfObjectIdenticalTo:note];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    switch (type) {
        case ImageBarButtonItemTypePin: {
            
            break;
        }
        case ImageBarButtonItemTypeLike: {
            
            break;
        }
        case ImageBarButtonItemTypeSetting: {
            UIViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SettingViewController"];
            [self presentViewController:controller animated:YES completion:nil];
            break;
        }
        case ImageBarButtonItemTypeAbout: {
            UIViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AboutViewController"];
            [self presentViewController:controller animated:YES completion:nil];
            break;
        }
    }
}

#pragma mark - SwipeableCellDelegate
-(void)swipeableCell:(SwipeableCell *)cell didStateChanged:(DeleteLineContainerViewState)state{
    NSIndexPath *indexPath=  [self.tableView indexPathForCell:cell];
    Note *note=self.notes[indexPath.row];
    
    switch (state) {
        case DeleteLineContainerViewStateNormal: {
            [note setNoteState:NoteStateNormal];
            break;
        }
            
        case DeleteLineContainerViewStateDeprecated: {
            [note setNoteState:NoteStateDeprecated];
            break;
        }
            
        case DeleteLineContainerViewStateDeleted: {
            [self.notes removeObject:note];
            if(self.notes.count==0){
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [note setNoteState:NoteStateDeleted];
            [note deleteNote];
            break;
        }
    }
}
-(void)dealloc{
    NSLog(@"%@ ___dealloc",[self class]);
}

@end

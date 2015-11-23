
//
//  MagicTransitionAnimator.m
//  TinyDo
//
//  Created by pi on 15/11/5.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "MagicTransitionAnimator.h"
#import "ToDoListViewController.h"
#import "EditNoteViewController.h"
#import "EditableCell.h"
#import "Note.h"



@interface MagicTransitionAnimator ()
@end

@implementation MagicTransitionAnimator

-(CGFloat)duration{
    if(_duration==0.0){
        _duration=0.35;
    }
    return _duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    ToDoListViewController *toDoVC=(ToDoListViewController*)[transitionContext viewControllerForKey:self.isShowUp? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey];
    
    EditNoteViewController *editVC=(EditNoteViewController*)[transitionContext viewControllerForKey:self.isShowUp? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if(self.isShowUp) {
        if(self.isInsert){
            
//            [containerView addSubview:editVC.view];
//            editVC.view.alpha=0.0;
//            
//            [editVC.view layoutIfNeeded];
//            
//            UIView *fromView= toDoVC.tableView.tableHeaderView;
//            EditableCell *toCell=(EditableCell*)[editVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            UIView *snapShot=[fromView snapshotViewAfterScreenUpdates:NO];
//            
//            CGRect fromFrame=[containerView convertRect:fromView.frame fromView:fromView.superview];
//            snapShot.frame=fromFrame;
//            [containerView addSubview:snapShot];
//            
//            toDoVC.tableView.tableHeaderView.hidden=YES;
//            UIView *tableViewSnapShot=[toDoVC.tableView snapshotViewAfterScreenUpdates:YES];
//            toDoVC.tableView.tableHeaderView.hidden=NO;
//            
//            tableViewSnapShot.frame=toDoVC.tableView.frame;
//            [containerView insertSubview:tableViewSnapShot belowSubview:snapShot];
//            
//            toDoVC.tableView.hidden=YES;
//            toCell.hidden=YES;
//            [UIView animateWithDuration:self.duration delay:0.0 options:0 animations:^{
//                NSLog(@"insertAnim start");
//                editVC.view.alpha=1.0;
//                CGRect toFrame= CGRectOffset(toCell.contentView.frame, 0, 20);
//                tableViewSnapShot.transform=CGAffineTransformMakeTranslation(0, 400);
//                tableViewSnapShot.alpha=0.0;
//                snapShot.frame=toFrame;
//            } completion:^(BOOL finished) {
//                toCell.hidden=NO;
//                toDoVC.tableView.hidden=NO;
//                [snapShot removeFromSuperview];
//                [tableViewSnapShot removeFromSuperview];
//                [transitionContext completeTransition:YES];
//                [toCell setInsertOrEdit:NO];
//                NSLog(@"insertAnim complete");
//            }];
            
//
            
            
            [containerView addSubview:editVC.view];
            [editVC.view layoutIfNeeded];
            
            for (UITableViewCell *cell in toDoVC.tableView.visibleCells) {
                //snapshotViewAfterScreenUpdates:NO
                //Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
                //
                UIView *snapShot= [cell snapshotViewAfterScreenUpdates:NO];
                //偏移tableView中scrollView的y轴偏移量
                snapShot.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y-toDoVC.tableView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
                [containerView addSubview:snapShot];
                [UIView animateWithDuration:self.duration animations:^{
                    snapShot.transform=CGAffineTransformMakeTranslation(0, 150);
                    snapShot.alpha=0.0;
                } completion:^(BOOL finished) {
                    [snapShot removeFromSuperview];
                }];
            }
            
            
            CGRect fromFrame=[containerView convertRect:toDoVC.tableView.tableHeaderView.frame fromView:toDoVC.tableView.tableHeaderView.superview];
            
            UIView *cell2Anim= [editVC.tableView cellForRowAtIndexPath:[self indexPathForEditCell]];
            
            CGRect toFrame=cell2Anim.frame;
            
            cell2Anim.frame=fromFrame;
            
            [UIView animateWithDuration:self.duration animations:^{
                cell2Anim.frame=toFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            
        }else{
//            [containerView addSubview:editVC.view];
//            [editVC.view layoutIfNeeded];
//            
//            
//            EditableCell *fromCell=(EditableCell*)[toDoVC.tableView cellForRowAtIndexPath:toDoVC.tableView.indexPathForSelectedRow];
//            
//            EditableCell *toCell=(EditableCell*)[editVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            
//            fromCell.seprateLine.alpha=0.0;
//            UIView *snapShot=[fromCell.contentView snapshotViewAfterScreenUpdates:YES];
//            fromCell.seprateLine.alpha=0.3;
//            fromCell.textField.alpha=0.0;
//            
//            CGRect fromFrame=[containerView convertRect:fromCell.contentView.frame fromView:fromCell.contentView.superview];
//    //        NSLog(@" from:__%@",NSStringFromCGRect(fromFrame));
//            fromFrame=CGRectOffset(fromFrame, 0, -46);
//            snapShot.frame=fromFrame;
//            [toDoVC.view removeFromSuperview];
//            [containerView addSubview:snapShot];
//            toCell.hidden=YES;
//            [UIView animateWithDuration:self.duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//    //            NSLog(@"start");
//                CGRect toFrame=CGRectOffset(toCell.contentView.frame, 0, 20);
//                snapShot.frame=toFrame;
//                //            NSLog(@"to:___%@",NSStringFromCGRect(toView.frame));
//            } completion:^(BOOL finished) {
//                toCell.hidden=NO;
//                
//                [toCell setInsertOrEdit:YES];
//                toCell.textField.text=editVC.note.content;
//                [snapShot removeFromSuperview];
//                [transitionContext completeTransition:YES];
//    //            NSLog(@"finished");
//            }];
            
            [containerView addSubview:editVC.view];
            [editVC.view layoutIfNeeded];
            
            for (UITableViewCell *cell in toDoVC.tableView.visibleCells) {
                //snapshotViewAfterScreenUpdates:NO
                //Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
                //
                UIView *snapShot= [cell snapshotViewAfterScreenUpdates:NO];
                snapShot.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y-toDoVC.tableView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
                [containerView addSubview:snapShot];
                [UIView animateWithDuration:self.duration animations:^{
                    snapShot.alpha=0.0;
                } completion:^(BOOL finished) {
                    [snapShot removeFromSuperview];
                }];
            }
            
            EditableCell *cell2Anim=(EditableCell*)[editVC.tableView cellForRowAtIndexPath:[self indexPathForEditCell]];
            cell2Anim.textField.text=editVC.note.content;
            
            UITableViewCell *selectedCell= [toDoVC.tableView cellForRowAtIndexPath:[toDoVC.tableView indexPathForSelectedRow]];
            CGRect fromFrame=[containerView convertRect:selectedCell.contentView.frame fromView:selectedCell.contentView.superview];
            
            CGRect toFrame=cell2Anim.frame;
            
            cell2Anim.frame=fromFrame;
            
            [UIView animateWithDuration:self.duration animations:^{
                cell2Anim.frame=toFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            
        }
        
    }else{
        if(self.isInsert){
//            [UIView animateWithDuration:self.duration animations:^{
//                toDoVC.view.alpha=0.0;
//            } completion:^(BOOL finished) {
//                [transitionContext completeTransition:YES];
//            }];
            [transitionContext completeTransition:YES];
            
        }else{
            
            EditableCell *fromCell= (EditableCell*)[editVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            __weak EditableCell *weakFromCell=fromCell;
            [fromCell setInsertOrEdit:NO anim:YES completion:^{
                [containerView addSubview:toDoVC.view];
                UITableViewCell *cell2Anim= [toDoVC.tableView cellForRowAtIndexPath:self.selectedCellIndex];
                [cell2Anim.superview bringSubviewToFront:cell2Anim];
                CGRect oldFrame=cell2Anim.frame;
                cell2Anim.frame=weakFromCell.frame;
                [UIView animateWithDuration:self.duration animations:^{
                    cell2Anim.frame=oldFrame;
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
            }];
            
//
//            [UIView animateWithDuration:0.4 animations:^{
//                fromCell.textField.alpha=0.0;
//            } completion:^(BOOL finished) {
//            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                fromCell.textField.alpha=1.0;
//                UIView *snapShot= [fromCell.contentView snapshotViewAfterScreenUpdates:YES];
//                fromCell.textField.alpha=0.0;
//                CGRect fromFrame=[containerView convertRect:fromCell.contentView.frame fromView:fromCell.contentView.superview];
//                snapShot.frame=fromFrame;
//                toDoVC.view.alpha=0.0;
//                [containerView addSubview:toDoVC.view];
//                [containerView addSubview: snapShot];
//                
//                UITableViewCell *selectedCell=[toDoVC.tableView cellForRowAtIndexPath:self.selectedCellIndex];
//                selectedCell.hidden=YES;
//                [UIView animateWithDuration:self.duration delay:0.0 options:0 animations:^{
//                    toDoVC.view.alpha=1.0;
//                    CGRect toFrame=[containerView convertRect:selectedCell.contentView.frame fromView:selectedCell.contentView.superview];
//                    snapShot.frame=toFrame;
//                } completion:^(BOOL finished) {
//                    selectedCell.hidden=NO;
//                    fromCell.textField.alpha=1.0;
//                    [snapShot removeFromSuperview];
//                    [transitionContext completeTransition:YES];
//                }];
//            });
        }
    }
}

-(NSIndexPath *)indexPathForEditCell{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}
@end

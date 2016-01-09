//
//  SwipeableCell.m
//  SlideCell
//
//  Created by pi on 15/11/11.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "SwipeableCell.h"
#import "Note.h"


static CGFloat const kanimDurationFactor = 450.0;

@interface SwipeableCell ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property(nonatomic)CGPoint panStartPoint;

@end

@implementation SwipeableCell

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setSwipeable:YES];
}

+(NSInteger)cellHeight{
    return 66;
}

-(void)configWithEidtableNote:(Note *)note{
    
    self.editableContent.textField.placeholder=@"";
    self.editableContent.seprateLine.alpha=0.3;
    self.editableContent.textField.text=[NSString stringWithFormat:@"%@",note.content];
    if(note.deperacted){
        self.myContainerView.isDeprecated=YES;
        [self.myContainerView toggleDeleteImage];
    }
    if([note.pirority boolValue]){
        self.editableContent.textField.textColor=self.tintColor ;
    }
}

-(void)configPlaceHolderCell{
    self.editableContent.textField.text=@"";
    self.editableContent.textField.enabled=YES;
    self.editableContent.textField.placeholder=NSLocalizedString(@"我想。。。。", @"我想。。。。");
    self.editableContent.seprateLine.hidden=YES;
}

-(void)setSwipeable:(BOOL)canSwipe{
    if(canSwipe){
        self.pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panThisCell:)];
        self.pan.delegate=self;
        [self.myContainerView addGestureRecognizer:self.pan];
    }else{
        [self.myContainerView removeGestureRecognizer:self.pan];
        self.pan=nil;
    }
}

-(void)panThisCell:(UIPanGestureRecognizer*)pan{
    CGPoint currentPoint=[pan translationInView:self.myContainerView];
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan: {
            self.panStartPoint=currentPoint;
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGFloat deltaX=currentPoint.x-self.panStartPoint.x;
            //            NSLog(@"deltaX : %f",deltaX);
            self.myContainerView.transform=CGAffineTransformMakeTranslation(deltaX, 0);
            break;
        }

        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled :{
            
            NSTimeInterval duration = fabsl(self.myContainerView.transform.tx / kanimDurationFactor);
//            NSLog(@"pan end or cancelled");
            [self.myContainerView updateState];
            BOOL toLeft= currentPoint.x-self.panStartPoint.x<0;
            [self animCellWithState:self.myContainerView.currentState duration:duration toLeft:toLeft completion:^{
                [self.myContainerView toggleDeleteImage];
            }];
            break;
        }
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.editableContent.textField.textColor=nil;
    self.myContainerView.isDeprecated=NO;
    self.transform=CGAffineTransformIdentity;
    self.myContainerView.transform=CGAffineTransformIdentity;
    self.contentView.alpha=1.0;
}

-(void)animCellWithState:(DeleteLineContainerViewState)state duration:(NSTimeInterval)duration toLeft:(BOOL)toLeft completion:(void (^)())completion{
    
    void(^completionBlock)() = ^() {
        completion();
        [self.delegate swipeableCell:self didStateChanged:state];
    };
    
    switch (state) {
        case DeleteLineContainerViewStateNormal: {
            [self animResetCellPosition:duration completion:completionBlock];
            break;
        }
        case DeleteLineContainerViewStateDeprecated: {
            [self animResetCellPosition:duration completion:completionBlock];
            break;
        }
        case DeleteLineContainerViewStateDeleted: {
            [self animDeleteCell:toLeft duration:duration completion:completionBlock];
            break;
        }
    }
}

-(void)animResetCellPosition:(NSTimeInterval)duration completion:(void (^)())completion{
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.myContainerView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        completion();
    }];
}

-(void)animDeleteCell:(BOOL)toLeft duration:(NSTimeInterval)duration completion:(void (^)())completion{
    CGFloat width= CGRectGetWidth(self.bounds);
    CGFloat delta;
    if(toLeft){
        delta=width+self.myContainerView.transform.tx;
        delta*=-1;
        delta-=80;
    }else{
        delta=width-self.myContainerView.transform.tx;
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform=CGAffineTransformMakeTranslation(delta, 0);
    } completion:^(BOOL finished) {
        self.contentView.alpha=0.0;
        completion();
    }];
}

#pragma mark - UIGestureRecognizerDelegate
//tableview的下拉和cell横向滑动可以同时触发 如果不加不能下拉
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

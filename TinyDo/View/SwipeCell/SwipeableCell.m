//
//  SwipeableCell.m
//  SlideCell
//
//  Created by pi on 15/11/11.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "SwipeableCell.h"
#import "Note.h"


static CGFloat const kanimDurationFactor = 600.0;

@interface SwipeableCell ()<UIGestureRecognizerDelegate>
//
@property(nonatomic,strong)UIPanGestureRecognizer *pan;
@property(nonatomic)CGPoint panStartPoint;
//


@end

@implementation SwipeableCell

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setSwipeable:YES];
//    self.myContainerView.delegate=self;
}

+(NSInteger)cellHeight{
    return 66;
}

-(id)configWithEidtableNote:(Note *)note{
    
    [self setSwipeable:NO];
    //
    self.editableContent.textField.text=note.content;
    self.editableContent.textField.enabled=YES;
    self.editableContent.textField.placeholder=@"我想。。。。";
    self.editableContent.alarm.selected=[note.needRemind boolValue];
    self.editableContent.priority.selected=[note.pirority boolValue];
    //
    return self;

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
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan: {
            self.panStartPoint=[pan translationInView:self.myContainerView];
            //            NSLog(@"pan begin : %@",NSStringFromCGPoint(self.panStartPoint));
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint=[pan translationInView:self.myContainerView];
            CGFloat deltaX=currentPoint.x-self.panStartPoint.x;
            //            NSLog(@"deltaX : %f",deltaX);
            self.myContainerView.transform=CGAffineTransformMakeTranslation(deltaX, 0);
            
            break;
            
            //用attributeText设置删除线不行。。只能在文字上设置。。
            //                NSMutableAttributedString *attrs=[[NSMutableAttributedString alloc]initWithString:self.myTextLabel.text];
            //                [attrs addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(2, self.myTextLabel.text.length-2)];
            //                [attrs addAttribute:NSStrikethroughColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, self.myTextLabel.text.length-2)];
            //                self.myTextLabel.attributedText=attrs;
            //            }
        }

        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled :{
            NSTimeInterval duration = self.myContainerView.transform.tx / kanimDurationFactor;
            [self.myContainerView animateToResetTransformWithDuration:duration];
//            NSLog(@"pan end or cancelled");
            break;
        }
            
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.editableContent.textField.textColor=nil;
}


//在这里画删除线会画在cell.contentview上 被挡住

//-(void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    CGFloat lineY= rect.origin.y + rect.size.height/2;
//    CGFloat lineX=20;
//    CGPoint lineStartPoint= CGPointMake(lineX, lineY);
////    CGPoint lineEndPoint=CGPointApplyAffineTransform(lineStartPoint, self.myContentView.transform);
//    CGPoint lineEndPoint=CGPointMake(lineStartPoint.x+100, lineStartPoint.y);
//    
////    UIBezierPath *path=[UIBezierPath bezierPath];
////    [path moveToPoint:lineStartPoint];
////    [path addLineToPoint:lineEndPoint];
////    [[UIColor blackColor]setStroke];
////    path.lineWidth=2;
////    [path stroke];
//
////    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:rect];
////    [[UIColor blackColor]setFill];
////    [path fill];
//}

#pragma mark - UIGestureRecognizerDelegate

#warning tableview的下拉和cell横向滑动可以同时触发
//tableview的下拉和cell横向滑动可以同时触发 如果不加不能下拉
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end

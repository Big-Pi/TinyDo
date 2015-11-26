//
//  DeleteLineContainerView.m
//  SlideCell
//
//  Created by pi on 15/11/13.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "DeleteLineContainerView.h"
#import "EditableContent.h"


static CGFloat const kDeleteLineFactor=1.35;


@interface DeleteLineContainerView ()
@property(nonatomic,strong)UIBezierPath *path;
@property(weak,nonatomic)IBOutlet UIImageView *leftDeleteImage;
@property(weak,nonatomic)IBOutlet UIImageView *rightDeleteImage;
@property(nonatomic)DeleteLineContainerViewState currentState;
@end

@implementation DeleteLineContainerView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        self.currentState=DeleteLineContainerViewStateNormal;
    }
    return self;
}

-(CGFloat)deleteLineStartOffsetX{
    return 20.0;
}

-(UIBezierPath *)path{
    if(!_path){
        _path=[UIBezierPath bezierPath];
    }
    return _path;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat deltaX=0.0;
    if(self.transform.tx>0){//手指向右滑动
        if(self.isDeprecated){
            //从头到尾画删除线
            deltaX=[self maxDeleteLineLengthInRect:rect];
        }else{
            //据手指滑动的距离画删除线
            deltaX=fabs(self.transform.tx);
        }
    }else if(self.transform.tx<0){//手指向左滑动
        if(self.isDeprecated){
            //根据手指滑动距离减少删除线的长度
            CGFloat maxDeleteLineLength=[self maxDeleteLineLengthInRect:rect];
            deltaX = (maxDeleteLineLength + self.transform.tx)/kDeleteLineFactor;
        }else{
            //没动画吖..
        }
    }else{
        //transform为0
        if(self.isDeprecated){
            deltaX=[self maxDeleteLineLengthInRect:rect];
        }
    }
    
    if(deltaX!=0){
        [[self deleteLinePathInRect:rect withStartX:[self deleteLineStartOffsetX] deltaX:deltaX]stroke];
    }
}

-(CGFloat)maxDeleteLineLengthInRect:(CGRect)rect{
    return rect.size.width-2 * [self deleteLineStartOffsetX];
}

/**
 *  @author pi, 15-11-13 22:11:05
 *
 *  根据起点和偏移量生成删除线
 *
 *
 *  @param startX 删除线起点
 *  @param deltaX 与起点的偏移量
 *
 *  @return UIBezierPath
 */
-(UIBezierPath*)deleteLinePathInRect:(CGRect)rect withStartX:(CGFloat)startX deltaX:(CGFloat)deltaX{
    [self.path removeAllPoints];
    CGFloat lineStartY=rect.origin.y + rect.size.height/2;
    CGFloat lineStartX=startX;
    CGPoint lineStartPoint=CGPointMake(lineStartX, lineStartY);
    
    deltaX=deltaX*kDeleteLineFactor;
    CGPoint lineEndPoint=CGPointMake(lineStartPoint.x + deltaX, lineStartPoint.y);
    
    [self.path moveToPoint:lineStartPoint];
    [self.path addLineToPoint:lineEndPoint];
//    NSLog(@"startPoint : %@",NSStringFromCGPoint(lineStartPoint));
//    NSLog(@"endPoint : %@",NSStringFromCGPoint(lineEndPoint));
    return self.path;
}

/**
 *  @author pi, 15-11-13 22:11:24
 *
 *  重置contentview的transform为identity
 *
 *  @param duration 动画持续时间
 */
-(void)animateToResetTransformWithDuration:(NSTimeInterval)duration{
    //根据pan手势结束时此view的transform决定当前的状态
    
    if(self.transform.tx>[self screenWidth_2]){
        //右滑到一定距离
        if(self.isDeprecated){
            self.currentState=DeleteLineContainerViewStateDeleted;
        }else{
            self.isDeprecated=YES;
            self.currentState=DeleteLineContainerViewStateDeprecated;
        }
    }else if(self.transform.tx<-[self screenWidth_2]){
        //左滑到一定距离
        if(self.isDeprecated){
            self.isDeprecated=NO;
            self.currentState=DeleteLineContainerViewStateNormal;
        }else{
            self.currentState=DeleteLineContainerViewStateDeleted;
        }
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform=CGAffineTransformIdentity;
        self.userInteractionEnabled=NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled=YES;
        [self toggleDeleteImage];
        [self.delegate deleteLineContainerView:self onStateChanged:self.currentState];
    }];
}

/**
 *  @author pi, 15-11-13 22:11:16
 *
 *  显示隐藏左右的垃圾桶图标
 */
-(void)toggleDeleteImage{
    self.leftDeleteImage.hidden=!self.isDeprecated;
    self.rightDeleteImage.hidden=self.isDeprecated;
}

-(CGFloat)screenWidth_2{
    return [UIScreen mainScreen].bounds.size.width/2.5;
}

-(void)setTransform:(CGAffineTransform)transform{
    [super setTransform:transform];
    [self setNeedsDisplay];
}

-(void)setIsDeprecated:(BOOL)isDeprecated{
    _isDeprecated=isDeprecated;
    [self setNeedsDisplay];
}
@end

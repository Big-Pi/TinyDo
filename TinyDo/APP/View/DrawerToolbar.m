//
//  DrawerToolbar.m
//  TinyDo
//
//  Created by pi on 15/11/14.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "DrawerToolbar.h"


@interface DrawerToolbar ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *content;
@property (strong,nonatomic) UITapGestureRecognizer *tap;
@property (strong,nonatomic) NSLayoutConstraint *bottomSpaceConstraint;
@end

@implementation DrawerToolbar

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self addNibView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addNibView];
}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self toogleDrawer];
}

#pragma mark - UIGestureRecognizerDelegate

-(void)addNibView{
     self.content= [[[NSBundle mainBundle]loadNibNamed:@"DrawerToolbar" owner:self options:nil]firstObject];
    [self addSubview:self.content];
}

- (IBAction)barButtonClick:(UIButton *)sender {
    [self.delegate onDrawerToolbar:self barButtonItemClick:sender.tag];
}
-(void)layoutSubviews{
    self.content.frame=self.bounds;
}

//-(void)didMoveToSuperview{
//    [super didMoveToSuperview];
//
//    
//    //drawerToolbar constraints bugFix 在storyboard设置的约束在自定义view不生效?
//    self.translatesAutoresizingMaskIntoConstraints=NO;
//    
//    NSDictionary *dic=@{@"drawerToolbar":self};
//    NSArray *constaintH=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[drawerToolbar]|" options:0 metrics:nil views:dic];
//    
//    NSArray *constaintV=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[drawerToolbar(==64)]-(-44)-|" options:0 metrics:nil views:dic];
//
//    NSArray *constraints= self.constraints;
//    for(int i=0;i<constraints.count;i++){
//        NSLayoutConstraint *constraint= constraints[i];
//        if([constraint.firstItem isMemberOfClass:[UIView class] ] &&[constraint.secondItem isMemberOfClass:[DrawerToolbar class]]){
//            self.bottomSpaceConstraint=constraint;
////            NSLog(@"%@",constraint);
//        }
//        
//    }
//
//    //ios 8+ 用active 不用加到父view中
//    [NSLayoutConstraint activateConstraints:constaintV];
//    [NSLayoutConstraint activateConstraints:constaintH];
//    //    [self.view addConstraints:constaintH];
//    //    [self.view addConstraints:constaintV];
//}

-(void)updateDrawerToolBarConstraints:(CGFloat)deltaY{
    [UIView animateWithDuration:0.225 animations:^{
        self.bottomSpaceConstraint.constant=deltaY;
        [self layoutIfNeeded];
    }];
}


-(NSLayoutConstraint *)bottomSpaceConstraint{
    if(!_bottomSpaceConstraint){
        NSArray *constraints= self.superview.constraints;
        for(int i=0;i<constraints.count;i++){
            NSLayoutConstraint *constraint= constraints[i];
            if(  [constraint.secondItem isMemberOfClass:[DrawerToolbar class]] && [constraint.firstItem conformsToProtocol:@protocol(UILayoutSupport)]){
                self.bottomSpaceConstraint=constraint;
            }
        }
    }
    return _bottomSpaceConstraint;
}
-(void)toogleDrawer{
    //0是开 －44是关 总高66
    CGFloat newConstant=self.bottomSpaceConstraint.constant == 0 ? -44 : 0;
    [self updateDrawerToolBarConstraints:newConstant];
}
@end

//
//  DrawerToolbar.m
//  TinyDo
//
//  Created by pi on 15/11/14.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "DrawerToolbar.h"


@interface DrawerToolbar ()
@property(nonatomic,strong)UIView *view;
@end

@implementation DrawerToolbar

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self addNibView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addNibView];
}

-(void)addNibView{
     self.view= [[[NSBundle mainBundle]loadNibNamed:@"DrawerToolbar" owner:self options:nil]firstObject];
//    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y,[UIScreen mainScreen].bounds.size.width , view.frame.size.height);
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
//    self.view.frame=self.frame;
    [self addSubview:self.view];
    
}

- (IBAction)barButtonClick:(UIButton *)sender {
    [self.delegate onDrawerToolbar:self barButtonItemClick:sender.tag];
}
-(void)layoutSubviews{
    self.view.frame=self.bounds;
}

@end

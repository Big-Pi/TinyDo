//
//  DateBtn.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "DateBtn.h"

@interface DateBtn ()
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (strong,nonatomic) UIView *v;
@end

@implementation DateBtn

-(void)awakeFromNib{
    self.v= [[NSBundle mainBundle]loadNibNamed:@"DateBtn" owner:self options:nil].firstObject ;
    [self addSubview:self.v];
}

-(void)setText:(NSString *)text{
    [self.dateBtn setTitle:text forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.v.frame=self.bounds;
}

-(BOOL)isDateBtnSelected{
    return self.dateBtn.selected;
}

- (IBAction)click:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.indicator.backgroundColor= sender.selected ? self.tintColor : [UIColor clearColor];
    [self.delegate dateBtn:self didSelectionChanged:sender.selected];
}
@end

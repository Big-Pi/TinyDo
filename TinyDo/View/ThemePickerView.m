//
//  ThemePickerView.m
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "ThemePickerView.h"
#import "UIColor+AllFlatColors.h"


@interface ThemePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *themePicker;
@property (copy,nonatomic) NSArray *colors;
@property (strong,nonatomic) UIView *v;

@end

@implementation ThemePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviewPrivate];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubviewPrivate];
}

-(void)addSubviewPrivate{
    self.v= [[[NSBundle mainBundle]loadNibNamed:@"ThemePickerView" owner:self options:nil] firstObject];
    [self addSubview:self.v];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.v.frame=self.bounds;
}

-(NSArray *)colors{
    if(!_colors){
        _colors=[UIColor allFlatColors];
    }
    return _colors;
}

-(UIColor *)selectedColor{
    return self.colors[[self.themePicker selectedRowInComponent:0]];
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.colors.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *v=view;
    if(!v){
        v= [[UIView alloc]init];
    }
    v.backgroundColor=self.colors[row];
    return v;
}
@end

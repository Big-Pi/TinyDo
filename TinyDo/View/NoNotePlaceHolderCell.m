//
//  NoNotePlaceHolderCell.m
//  TinyDo
//
//  Created by pi on 15/10/29.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "NoNotePlaceHolderCell.h"

@implementation NoNotePlaceHolderCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
@end

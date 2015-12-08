//
//  SwipeableCell.h
//  SlideCell
//
//  Created by pi on 15/11/11.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableContent.h"
#import "DeleteLineContainerView.h"
@class Note;

@interface SwipeableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DeleteLineContainerView *myContainerView;
@property (weak, nonatomic) IBOutlet EditableContent *editableContent;
-(void)setSwipeable:(BOOL)canSwipe;
-(id)configWithEidtableNote:(Note*)note;
+(NSInteger)cellHeight;
@end

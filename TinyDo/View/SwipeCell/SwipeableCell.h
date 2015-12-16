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
@class SwipeableCell;


@protocol SwipeableCellDelegate <NSObject>

-(void)swipeableCell:(SwipeableCell*)cell didStateChanged:(DeleteLineContainerViewState)state;

@end

@interface SwipeableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet DeleteLineContainerView *myContainerView;
@property (weak, nonatomic) IBOutlet EditableContent *editableContent;
@property(nonatomic,weak) id<SwipeableCellDelegate> delegate;
-(void)setSwipeable:(BOOL)canSwipe;
-(id)configWithEidtableNote:(Note*)note;
+(NSInteger)cellHeight;
@end

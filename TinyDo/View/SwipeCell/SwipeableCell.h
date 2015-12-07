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

//@protocol SwipeableCellDelegate <NSObject>
//
//@end

@interface SwipeableCell : UITableViewCell
//@property(nonatomic,weak) id<SwipeableCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet DeleteLineContainerView *myContainerView;
@property (weak, nonatomic) IBOutlet EditableContent *editableContent;
-(void)setSwipeable:(BOOL)canSwipe;
+(NSInteger)cellHeight;
@end

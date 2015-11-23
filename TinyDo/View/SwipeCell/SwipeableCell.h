//
//  SwipeableCell.h
//  SlideCell
//
//  Created by pi on 15/11/11.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>

@end

@interface SwipeableCell : UITableViewCell
@property(nonatomic,weak) id<SwipeableCellDelegate> delegate;
-(void)setSwipeable:(BOOL)canSwipe;
@end

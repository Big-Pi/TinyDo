//
//  MagicTransitionAnimator.h
//  TinyDo
//
//  Created by pi on 15/11/5.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MagicTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property(nonatomic)BOOL isShowUp;
@property(nonatomic,weak)UITableViewCell *fromCell;
@property(nonatomic,weak)UITableViewCell *toCell;
@property(nonatomic)CGFloat duration;
@property(nonatomic)BOOL isInsert;
@property(nonatomic)NSIndexPath *selectedCellIndex;

@end

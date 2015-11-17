//
//  DrawerToolbar.h
//  TinyDo
//
//  Created by pi on 15/11/14.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageBarButtonItem.h"


typedef NS_ENUM(NSInteger, ImageBarButtonItemType) {
    ImageBarButtonItemTypePin=100,
    ImageBarButtonItemTypeLike,
    ImageBarButtonItemTypeSetting,
    ImageBarButtonItemTypeAbout
};

@class DrawerToolbar;
@protocol DrawerToolbarDelegate <UIToolbarDelegate>
-(void)onDrawerToolbar:(DrawerToolbar*)toolbar barButtonItemClick:(ImageBarButtonItemType)type;
@end

@interface DrawerToolbar : UIView
@property(nonatomic,weak) id<DrawerToolbarDelegate> delegate;
@end

//
//  DeleteLineContainerView.h
//  SlideCell
//
//  Created by pi on 15/11/13.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeleteLineContainerView;

typedef NS_ENUM(NSInteger, DeleteLineContainerViewState) {
    DeleteLineContainerViewStateNormal,
    DeleteLineContainerViewStateDeprecated,
    DeleteLineContainerViewStateDeleted
};

//@protocol DeleteLineContainerViewDelegate <NSObject>
//-(void)deleteLineContainerView:(DeleteLineContainerView*)contentView onStateChanged:(DeleteLineContainerViewState)state toLeft:(BOOL)toLeft;
//@end

@interface DeleteLineContainerView : UIView
@property(nonatomic)BOOL isDeprecated;
@property(nonatomic,readonly)DeleteLineContainerViewState currentState;
//@property(nonatomic,weak) id<DeleteLineContainerViewDelegate> delegate;
-(void)toggleDeleteImage;
-(void)updateState;

@end

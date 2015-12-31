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


@interface DeleteLineContainerView : UIView
@property(nonatomic)BOOL isDeprecated;
@property(nonatomic)DeleteLineContainerViewState currentState;
-(void)toggleDeleteImage;
-(void)updateState;
//-(void)setInitialState:(DeleteLineContainerViewState)initialState;
@end

//
//  EditNoteViewController.h
//  TinyDo
//
//  Created by pi on 15/10/28.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Note;
@class TimePickerCell;
@class AlarmCell;
@class SwipeableCell;

typedef NS_ENUM(NSInteger, EditMode){
    Insert,
    Edit
};

@class EditNoteViewController;

@protocol EditNoteViewControllerDelegate <NSObject>

-(void)editNoteViewControllerDidEndEdit:(EditNoteViewController *)controller withNote:(Note*)note editMode:(EditMode)mode;

@end

@interface EditNoteViewController : UIViewController<UIViewControllerRestoration>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic,readonly) SwipeableCell *editCell;
@property(strong,nonatomic)Note *note; //segue时传note代表编辑note 否则 插入note
@property(weak,nonatomic) id<EditNoteViewControllerDelegate> delegate;
//
-(void)fadeOutSelf;
@end

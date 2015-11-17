//
//  EditNoteViewController.h
//  TinyDo
//
//  Created by pi on 15/10/28.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

typedef NS_ENUM(NSInteger, EditMode){
    Insert,
    Edit
};

@class EditNoteViewController;

@protocol EditNoteViewControllerDelegate <NSObject>

-(void)editNoteViewControllerDidEndEdit:(EditNoteViewController *)controller withNote:(Note*)note editMode:(EditMode)mode;

@end

@interface EditNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)Note *note; //segue时传note代表编辑note 否则 插入note
@property(weak,nonatomic) id<EditNoteViewControllerDelegate> delegate;
@end

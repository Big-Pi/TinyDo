//
//  ToDoListViewController.h
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditableCell;
@interface ToDoListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak)EditableCell *headCell;
@end

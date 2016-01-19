//
//  DoneButtonCell.h
//  TinyDo
//
//  Created by pi on 15/12/31.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoneButtonCell : UITableViewCell
-(void)onDone:(void (^)())done;
@end

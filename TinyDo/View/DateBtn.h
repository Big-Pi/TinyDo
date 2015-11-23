//
//  DateBtn.h
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DateBtn;

@protocol DateBtnDelegate <NSObject>

-(void)dateBtn:(DateBtn*)btn didSelectionChanged:(BOOL)selected;

@end

@interface DateBtn : UIView
@property(nonatomic,weak) id<DateBtnDelegate> delegate;
-(void)setText:(NSString*)text;
-(BOOL)isDateBtnSelected;
@end

//
//  SettingViewController.m
//  TinyDo
//
//  Created by pi on 15/11/25.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "SettingViewController.h"
#import "ThemePickerViewAlert.h"

@interface SettingViewController ()<CustomIOSAlertViewDelegate>
@property (strong,nonatomic) CustomIOSAlertView *alert;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)dismissSelf:(UIBarButtonItem *)sender {
    if(self.presentingViewController){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        self.alert = [ThemePickerViewAlert sharedAlert];
        self.alert.delegate=self;
    }
}

#pragma mark - CustomIOSAlertViewDelegate
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.alert close];
    self.alert=nil;
//    NSLog(@"%ld",buttonIndex);
}
@end

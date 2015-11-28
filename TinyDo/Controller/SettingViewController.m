//
//  SettingViewController.m
//  TinyDo
//
//  Created by pi on 15/11/25.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "SettingViewController.h"
#import "ThemePickerViewAlert.h"
#import "EasyThemer.h"
#import "Colours.h"


@interface SettingViewController ()<CustomIOSAlertViewDelegate>
@property (strong,nonatomic) ThemePickerViewAlert *alert;
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
        self.alert = [ThemePickerViewAlert alert];
        self.alert.delegate=self;
        [self.alert show];
    }
}

//- (IBAction)toggleNightTheme:(UISwitch *)sender {
//    if(sender.on){
//        [ThemeManager setSharedTheme:[[NightTheme alloc]init]];
//    }else{
//        [ThemeManager setSharedTheme:[[DefaultWhiteTheme alloc]init]];
//    }
//    [ThemeManager customizeView:self.view];
//}

#pragma mark - CustomIOSAlertViewDelegate
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView close];
    
//http://stackoverflow.com/questions/19641476/how-can-i-change-the-global-tint-color-programmatically
// stackoverflow recommand answer but not work for me
//    UIWindow *window= [[UIApplication sharedApplication] keyWindow];
//    [window setTintColor:[UIColor redColor]];
    UIColor *c= [self.alert selectedColor];
    [EasyThemer applyTheme:c];
    self.navigationController.navigationBar.tintColor=c;
    self.alert=nil;
}
@end

//
//  Helper.m
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "Helper.h"


NSString *const kIsFristLaunch=@"kIsFristLaunch";
@implementation Helper
+(void)load{
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{kIsFristLaunch :@YES}];
}

+(BOOL)isFirstLaunch{
   return [[NSUserDefaults standardUserDefaults] boolForKey:kIsFristLaunch];
}

+(void)setIsFirstLaunch:(BOOL)isFirstLaunch{
    [[NSUserDefaults standardUserDefaults]setBool:isFirstLaunch forKey:kIsFristLaunch];
}

+(void)checkFirstLaunch:(UIViewController *)controller presentSplashVC:(NSString *)storyBoardIdentifier{
    [self checkFirstLaunch:controller storyboardName:@"Main" presentSplashVC:storyBoardIdentifier];
}
//如果第一次进入app 就加载教程界面
+(void)checkFirstLaunch:(UIViewController *)controller storyboardName:(NSString *)storyboardName presentSplashVC:(NSString *)storyBoardIdentifier{
    if([self isFirstLaunch]){
//        [self setIsFirstLaunch:NO];
        UIViewController *splashVC= [[UIStoryboard storyboardWithName:storyboardName bundle:nil]instantiateViewControllerWithIdentifier:storyBoardIdentifier];
        
        //Warning: Attempt to present <HelpViewController: 0x7fc63ae3de60> on <ToDoListViewController: 0x7fc63ac936f0> whose view is not in the window hierarchy!
        //http://stackoverflow.com/questions/11862883/whose-view-is-not-in-the-window-hierarchy
        //        [controller presentViewController:splashVC animated:NO completion:nil];
        
        [controller.view addSubview:splashVC.view];
        [controller addChildViewController:splashVC];
        [splashVC didMoveToParentViewController:controller];
    }
}
//

+(CGFloat)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
@end

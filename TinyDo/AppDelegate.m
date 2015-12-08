//
//  AppDelegate.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "AppDelegate.h"
#import "ToDoListViewController.h"
#import "CoreDataStack.h"
#import "UMSocial.h"
#import "EasyThemer.h"
#import "DissmissKeyBoardWindow.h"


@interface AppDelegate ()
@property(nonatomic,strong,readonly)CoreDataStack *stack;
@end

@implementation AppDelegate

-(CoreDataStack *)stack{
    return [CoreDataStack sharedStack];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registNotifySetting];
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"didFinishLaunchingWithOptions : %@",localNotif);
    }
    [EasyThemer applyTheme];
    return YES;
}

-(void)registNotifySetting{
    UIUserNotificationType types=UIUserNotificationTypeAlert|UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    通过或被拒绝本地通知
//    NSLog(@"%@",notificationSettings);
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    NSLog(@"alarm : %@",notification);
}

//http://stackoverflow.com/questions/11274119/dismiss-keyboard-on-touch-anywhere-outside-uitextfield
//当点击除textField和textView以外的view时 dismisskeyboard
- (UIWindow *)window{
    static DissmissKeyBoardWindow *customWindow = nil;
    if (!customWindow)
        customWindow = [[DissmissKeyBoardWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return customWindow;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}
-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return  YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.stack saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.stack saveContext];
}
@end

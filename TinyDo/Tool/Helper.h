//
//  Helper.h
//  TinyDo
//
//  Created by pi on 15/11/23.
//  Copyright © 2015年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kIsFristLaunch;

@interface Helper : NSObject
+(CGFloat)screenWidth;
//
+(void)checkFirstLaunch:(UIViewController *)controller presentSplashVC:(NSString *)storyBoardIdentifier;
+(void)checkFirstLaunch:(UIViewController *)controller storyboardName:(NSString *)storyboardName presentSplashVC:(NSString *)storyBoardIdentifier;
@end

//
//  UIViewController+Theme.m
//  TinyDo
//
//  Created by pi on 15/11/28.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "UIViewController+Theme.h"
#import "ThemeManager.h"
#import <objc/runtime.h>

@implementation UIViewController (Theme)
//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class=[self class];
//        
//        SEL originalSel=@selector(viewWillAppear:);
//        SEL swizzledSel=@selector(BigPi_viewWillAppear:);
//        
//        Method originalMethod=class_getInstanceMethod(class, originalSel);
//        Method swizzledMethod=class_getInstanceMethod(class, swizzledSel);
//        
//        BOOL didAddMethod=class_addMethod(class, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if(didAddMethod){
//            class_replaceMethod(class, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        }else{
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//        
//    });
//}

#pragma mark - Method Swizzling
-(void)BigPi_viewWillAppear:(BOOL)animated{
    [self BigPi_viewWillAppear:animated];
    NSLog(@"customizeTheme %@",self);
    if([self isKindOfClass:[UIInputViewController class]]){
        return;
    }
    [ThemeManager customizeView:self.view];
}
@end

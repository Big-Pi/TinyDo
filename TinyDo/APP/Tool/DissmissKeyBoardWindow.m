//
//  DissmissKeyBoardWindow.m
//  TinyDo
//
//  Created by pi on 15/11/27.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "DissmissKeyBoardWindow.h"

@interface DissmissKeyBoardWindow ()
@property (weak, nonatomic) UIView *currentFirstResponder;
@end

@implementation DissmissKeyBoardWindow

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self startObservingFirstResponder];
}

- (void)dealloc {
    [self stopObservingFirstResponder];
}

- (void)startObservingFirstResponder {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(observeBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [center addObserver:self selector:@selector(observeEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)stopObservingFirstResponder {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)observeBeginEditing:(NSNotification *)note {
    self.currentFirstResponder = note.object;
}

- (void)observeEndEditing:(NSNotification *)note {
    if (self.currentFirstResponder == note.object) {
        self.currentFirstResponder = nil;
    }
}

- (void)sendEvent:(UIEvent *)event {
    [self adjustFirstResponderForEvent:event];
    [super sendEvent:event];
}

- (void)adjustFirstResponderForEvent:(UIEvent *)event {
    if (self.currentFirstResponder
        && ![self eventContainsTouchInFirstResponder:event]
        && [self eventContainsNewTouchInNonresponder:event]) {
        [self.currentFirstResponder resignFirstResponder];
    }
}

- (BOOL)eventContainsTouchInFirstResponder:(UIEvent *)event {
    for (UITouch *touch in [event touchesForWindow:self]) {
        if (touch.view == self.currentFirstResponder)
            return YES;
    }
    return NO;
}

- (BOOL)eventContainsNewTouchInNonresponder:(UIEvent *)event {
    for (UITouch *touch in [event touchesForWindow:self]) {
        if (touch.phase == UITouchPhaseBegan && ![touch.view canBecomeFirstResponder])
            return YES;
    }
    return NO;
}
@end

//
//  AboutViewController.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>
#import "UMSocial.h"

@interface AboutViewController ()<MFMailComposeViewControllerDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@end

@implementation AboutViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self animBtnAppear];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.shareBtn.hidden=YES;
    self.emailBtn.hidden=YES;
    self.helpBtn.hidden=YES;
}

//也可以用layer animation fromValue toValue
-(void)animBtnAppear{
    self.emailBtn.hidden=NO;
    [self animateViewSlideLeftIn:self.emailBtn left:YES completion:^{
        self.shareBtn.hidden=NO;
        [self animateViewSlideLeftIn:self.shareBtn left:NO completion:^{
            self.helpBtn.hidden=NO;
            [self animateViewSlideLeftIn:self.helpBtn left:YES completion:nil];
        }];
    }];
}

-(void)animateViewSlideLeftIn:(UIView *)view left:(BOOL)animLeftToRight completion:(void (^)())completion{
    CGFloat screenWidth_2=[UIScreen mainScreen].bounds.size.width/2;
    CGAffineTransform transform=CGAffineTransformMakeTranslation(animLeftToRight ? -screenWidth_2 : screenWidth_2, 0);
    view.transform=transform;
    [UIView animateWithDuration:0.225 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if(completion){
            completion();
        }
    }];
}
- (IBAction)dismissSelf:(UIBarButtonItem *)sender {
    if(self.presentingViewController){
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//not work on simulator
- (IBAction)email:(id)sender {
    // Email Subject
    NSString *emailTitle = @"TinyDo 反馈";
    // Email Content
    NSString *messageBody = @"TinyDo 协助您更有效的搞定日常事务～";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"wangdapishuai@163.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)share:(id)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5656c533e0f55a07d8000330"
                                      shareText:@"TinyDo 协助您更有效的搞定日常事务～"
                                     shareImage:[UIImage imageNamed:@"ApplicationIcon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:self];
}

- (IBAction)help:(id)sender {
    UIViewController *controller= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled: {
            
            break;
        }
        case MFMailComposeResultSaved: {
            
            break;
        }
        case MFMailComposeResultSent: {
            
            break;
        }
        case MFMailComposeResultFailed: {
            
            break;
        }
            
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

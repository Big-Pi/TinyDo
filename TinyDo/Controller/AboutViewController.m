//
//  AboutViewController.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
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

- (IBAction)email:(id)sender {
    
}

- (IBAction)share:(id)sender {
    
}

- (IBAction)help:(id)sender {
    UIViewController *controller= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end

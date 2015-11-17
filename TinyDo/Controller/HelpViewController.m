//
//  HelpViewController.m
//  TinyDo
//
//  Created by pi on 15/10/25.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *imageNames;
@property (strong,nonatomic) NSArray *imageMessage;
@end

@implementation HelpViewController


-(NSArray *)imageNames{
    if(!_imageNames){
        _imageNames=@[@"HelpCreate",@"HelpDone",@"HelpMove"];
    }
    return _imageNames;
}

-(NSArray *)imageMessage{
    if(!_imageMessage){
        _imageMessage=@[@"下拉创建新事项",@"右滑完成事项",@"长按以重新排序"];
    }
    return _imageMessage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize= [UIScreen mainScreen].bounds.size;
    CGFloat scale= [UIScreen mainScreen].scale;
    
    for (int i=0; i<[self.imageNames count]; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(screenSize.width*i, 0, screenSize.width, screenSize.height)];
        UIImage *img=[UIImage imageNamed:self.imageNames[i]];
        imageView.image=img;
        
        //
        UILabel *msgLabel=[[UILabel alloc]init];
        msgLabel.text=self.imageMessage[i];
        [msgLabel sizeToFit];
        msgLabel.center=CGPointMake(screenSize.width/2, screenSize.height-50*scale);
        [imageView addSubview:msgLabel];
        //
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize=CGSizeMake(screenSize.width*self.imageNames.count, 0);
    self.scrollView.bounces=false;
    self.scrollView.showsHorizontalScrollIndicator=false;
    self.scrollView.pagingEnabled=true;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat dismissOffset= [UIScreen mainScreen].bounds.size.width *(self.imageNames.count-1);
//    NSLog(@"%@------%f",NSStringFromCGPoint(scrollView.contentOffset),dismissOffset );
    if(scrollView.contentOffset.x>=dismissOffset){
        
    }
}

@end

//
//  RubbishBinViewController.m
//  TinyDo
//
//  Created by pi on 15/11/26.
//  Copyright © 2015年 pi. All rights reserved.
//

#import "RubbishBinViewController.h"
#import "Note.h"

@interface RubbishBinViewController ()
@property (strong,nonatomic) NSMutableArray *deletedNotes;
@end

@implementation RubbishBinViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *deleteAllItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllNote)];
    self.navigationItem.rightBarButtonItem=deleteAllItem;
    
    self.deletedNotes = [[Note fetchAllDeletedNotes]mutableCopy];
//    NSLog(@"%@",self.deletedNotes);

}
#pragma mark - Private

-(void)deleteAllNote{
    for (Note *note in self.deletedNotes) {
        [note destoryNote];
    }
    [self.deletedNotes removeAllObjects];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSString*)dateStringFromDate:(NSDate*)date{
    static NSDateFormatter *formatter;
    if(!formatter){
        formatter=[[NSDateFormatter alloc]init];
        formatter.locale=[NSLocale currentLocale];
        formatter.timeStyle=NSDateFormatterMediumStyle;
        formatter.dateStyle=NSDateFormatterMediumStyle;
    }
    return [formatter stringFromDate:date];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.deletedNotes.count==0 ? 0 :1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deletedNotes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Note *note=self.deletedNotes[indexPath.row];
    cell.textLabel.text=note.content;
    cell.detailTextLabel.text=[self dateStringFromDate:note.deletedDate];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note= self.deletedNotes[indexPath.row];
        [note deleteNote];
        [self.deletedNotes removeObject:note];
        if(self.deletedNotes.count==0){
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end

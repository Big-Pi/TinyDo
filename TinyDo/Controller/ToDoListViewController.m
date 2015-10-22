//
//  ToDoListViewController.m
//  TinyDo
//
//  Created by pi on 15/10/23.
//  Copyright (c) 2015年 pi. All rights reserved.
//

#import "ToDoListViewController.h"
#import "EditableCell.h"

@interface ToDoListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditableCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textField.placeholder=[NSString stringWithFormat:@"%ld",indexPath.row];
    cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.tableView.frame.size.width, 66);
    return cell;
}




@end

//
//  SetTagViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "SetTagViewController.h"
#import "NewTagViewController.h"

@interface SetTagViewController ()
@property (weak, nonatomic) IBOutlet UITableView *TableViewOfTag;

@end

@implementation SetTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tagList = @[@"朋友",@"亲人",@"同学"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tag"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Tag"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[self.tagList objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
    return cell;

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tagList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewTagViewController *newTagViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTagView"];
    [self.navigationController pushViewController:newTagViewController animated:YES];

    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

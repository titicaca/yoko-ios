//
//  NewFriendViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "NewFriendViewController.h"

@interface NewFriendViewController ()
@property (weak, nonatomic) IBOutlet UITableView *TableOfNewFriend;

@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendList=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Friend"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"Friend"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=[self.friendList objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
    cell.imageView.image=[UIImage imageNamed:@"1.png"];
    cell.detailTextLabel.text = @"验证信息：xxxxx";
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(300,0,50,50)];
    [addButton setBackgroundColor:[UIColor blueColor]];
    [addButton setTitle:@"点击" forState:UIControlStateNormal];
    addButton.titleLabel.textColor = [UIColor blackColor];
    addButton.showsTouchWhenHighlighted = true;
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTag:[[self.friendList objectAtIndex:indexPath.row] integerValue]];
    [cell addSubview:addButton];
    return cell;
    
}

-(void)addButtonClick:(UIButton*)sender{
    NSLog(@"%ld",[sender tag]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return 5;
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

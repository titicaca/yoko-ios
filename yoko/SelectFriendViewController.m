//
//  SelectFriendViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/25.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "TableFriendInfo.h"
#import "FriendTableViewCell.h"

@interface SelectFriendViewController ()
- (IBAction)actionOfFinish:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableViewOfFriendList;
@property(nonatomic, retain) NSMutableArray *friendIdList;
@end

@implementation SelectFriendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择好友";
    self.friendList = [TableFriendInfo getFriendInfoRecords];
    self.friendIdList = [[NSMutableArray alloc]init];
    for(FriendInfoRecord *friendInfoRecord in self.friendList){
        [self.friendIdList addObject:[NSNumber numberWithLong:friendInfoRecord.fuid]];
    }
    [self.tableViewOfFriendList reloadData];
    [self setCheckmarkWithTableFriendInfo:self.oldFriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Friend"];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Friend"];
    }
    FriendInfoRecord *friendInfoRecord = [self.friendList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=friendInfoRecord.nickname;
    cell.friendInfoRecord = friendInfoRecord;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
    cell.imageView.image=[UIImage imageNamed:@"1.png"];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendList count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
        cell.accessoryType = UITableViewCellAccessoryNone;
    else
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)setCheckmarkWithTableFriendInfo:(NSArray *)tableFriendInfo{
    for(FriendInfoRecord *friendInfoRecord in tableFriendInfo){
        NSInteger index = [self.friendIdList indexOfObject:[NSNumber numberWithLong:friendInfoRecord.fuid]];
        if(index != NSNotFound){
            UITableViewCell *cell = [self.tableViewOfFriendList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionOfFinish:(id)sender {
    NSMutableArray *returnFriendList = [[NSMutableArray alloc] init];
    NSInteger count = [self.friendList count];
    for(int i =0;i<count;i++){
        if([self.tableViewOfFriendList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType == UITableViewCellAccessoryCheckmark)
            [returnFriendList addObject:[self.friendList objectAtIndex:i]];
    }
    
    [self.delegate selectFriendData:returnFriendList];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

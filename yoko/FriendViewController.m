//
//  FriendView.m
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "FriendViewController.h"
#import "RootFriendDetailViewController.h"
#import "SetTagViewController.h"
#import "NewFriendViewController.h"
#import "RestAPI.h"
#import "SqliteManager.h"
#import "DatabaseCenter.h"
#import "TableFriendInfo.h"
#import "TableFriendTag.h"
#import "FriendTableViewCell.h"

@interface FriendViewController ()
{
    NSIndexPath *currentIndexPath;
    NSInteger currentFriendId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewOfFriendList;

- (IBAction)ButtonOfTest:(id)sender;

- (IBAction)ButtonOfTest2:(id)sender;

@end

@implementation FriendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友";
    self.friendList = [TableFriendInfo getFriendInfoRecords];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    RootFriendDetailViewController *rootFriendDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootFriendDetailView"];
    rootFriendDetailViewController.allPageIndex=[self.friendList count];
    rootFriendDetailViewController.currentPageIndex=([indexPath row]+1);
    rootFriendDetailViewController.friendId = cell.friendInfoRecord.fuid;
    [self.navigationController pushViewController:rootFriendDetailViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = (FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.friendList count]) {
            currentIndexPath = indexPath;
            currentFriendId = cell.friendInfoRecord.fuid;
            RestAPI *r =[[RestAPI alloc] initNormalRequestWithURI:[NSString stringWithFormat:@"/user/myfriend/%ld",cell.friendInfoRecord.fuid] andHTTPMethod:@"DELETE" andHTTPValues:nil andDelegate:self andIdentifier:@"deleteFriend"];
            [r startConnection];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (IBAction)ButtonOfTest:(id)sender {
    
    RestAPI *r =[[RestAPI alloc] initNormalRequestWithURI:@"/user/userinfo" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:nil];
    
    [r startConnection];
   
}

- (IBAction)ButtonOfTest2:(id)sender {
    [TableFriendTag getTagArray];
//    [TableFriendInfo createTable];
//    [TableFriendInfo createUniqueIndex];
//    FriendInfoRecord *f = [[FriendInfoRecord alloc]initWithUid:2l andFuid:5l andEmail:@"f" andLocation:@"f" andMobile:@"f" andNickname:@"f" andPicturelink:@"f" andQq:@"f" andSex:10 andWechat:@"f" andWeibo:@"f" andCollectnumber:1 andEnrollnumber:2 andFriendnumber:3 andLogintime:10l];
//    [TableFriendInfo insertRecord:f];
    

}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode / 100 == 2){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        
        if([identifier isEqualToString:@"deleteFriend"]){
            if([[rcvDictionary objectForKey:@"result"] boolValue] == true){
                [TableFriendInfo deleteFriendInfoRecordsByFriendId:currentFriendId];
                if (currentIndexPath.row<[self.friendList count]) {
                    [self.friendList removeObjectAtIndex:currentIndexPath.row];//移除数据源的数据
                    [self.tableViewOfFriendList deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
                }
            }
        }
    }
    
    
}

@end

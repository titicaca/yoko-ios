//
//  FriendView.m
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "FriendView.h"
#import "RootFriendDetailViewController.h"
#import "SetTagViewController.h"
#import "NewFriendViewController.h"
#import "RestAPI.h"
#import "SqliteManager.h"
#import "DatabaseCenter.h"
#import "TableFriendInfo.h"
#import "FriendInfoRecord.h"

@interface FriendView ()
@property (weak, nonatomic) IBOutlet UITableView *TableViewOfFriendFunciton;
@property (weak, nonatomic) IBOutlet UITableView *TableViewOfFriendList;
- (IBAction)ButtonOfTest:(id)sender;

- (IBAction)ButtonOfTest2:(id)sender;

@end

@implementation FriendView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendAndTag = @[@"新朋友",@"标签"];
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
    if(tableView == self.TableViewOfFriendFunciton){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Friend"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"Friend"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[self.friendAndTag objectAtIndex:indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        return cell;
    }
    if(tableView == self.TableViewOfFriendList){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Friend"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"Friend"];
        }
        FriendInfoRecord *friendInfoRecord = [self.friendList objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=friendInfoRecord.nickname;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        cell.imageView.image=[UIImage imageNamed:@"1.png"];
        return cell;
    }

    return NULL;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.TableViewOfFriendFunciton){
        return [self.friendAndTag count];
    }
    if(tableView == self.TableViewOfFriendList){
        return [self.friendList count];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.TableViewOfFriendList){
        NSInteger rowNumber=[indexPath row];
        NSLog(@"%ld",rowNumber);
        RootFriendDetailViewController *rootFriendDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootFriendDetailView"];
        rootFriendDetailViewController.allPageIndex=[self.friendList count];
        rootFriendDetailViewController.friendId=(rowNumber+1);
        [self.navigationController pushViewController:rootFriendDetailViewController animated:YES];

    }
    if(tableView == self.TableViewOfFriendFunciton){
        NSInteger rowNumber=[indexPath row];
        NSLog(@"%ld",rowNumber);
        if(rowNumber == 0){
            NewFriendViewController *newFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFriendView"];
            [self.navigationController pushViewController:newFriendViewController animated:YES];
        }
        if(rowNumber == 1){
            SetTagViewController *setTagViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SetTagView"];
            [self.navigationController pushViewController:setTagViewController animated:YES];
        }
        
        
    }
    
}

- (IBAction)ButtonOfTest:(id)sender {
    
    RestAPI *r =[[RestAPI alloc] initNormalRequestWithURI:@"/user/userinfo" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:nil];
    
    [r startConnection];
   
}

- (IBAction)ButtonOfTest2:(id)sender {
    [TableFriendInfo getFriendInfoRecords];
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
}

@end

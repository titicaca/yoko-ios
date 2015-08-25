//
//  SetTagViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "SetTagViewController.h"
#import "NewTagViewController.h"
#import "TableFriendTag.h"

@interface SetTagViewController ()
{
    NSIndexPath *currentIndexPath;
    NSInteger currentTagId;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOfTag;

@end

@implementation SetTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"标签";
}

-(void)viewWillAppear:(BOOL)animated{
    self.tagList = [TableFriendTag getTagArray];
    [self.tableViewOfTag reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tag"];
    FriendTagRecord *friendTagRecord = [self.tagList objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Tag"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=friendTagRecord.tagName;
    cell.tag=friendTagRecord.tagId;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
    return cell;

    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tagList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTagRecord *friendTagRecord = [self.tagList objectAtIndex:indexPath.row];
    NewTagViewController *newTagViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewTagView"];
    newTagViewController.selectedTagId = friendTagRecord.tagId;
    newTagViewController.selectedTagname = friendTagRecord.tagName;
    newTagViewController.title = @"修改标签";
    [self.navigationController pushViewController:newTagViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.tagList count]) {
            currentIndexPath = indexPath;
            currentTagId = cell.tag;
            RestAPI *r =[[RestAPI alloc] initNormalRequestWithURI:[NSString stringWithFormat:@"/user/mytag/%ld",cell.tag] andHTTPMethod:@"DELETE" andHTTPValues:nil andDelegate:self andIdentifier:@"deleteTag"];
            [r startConnection];
        }
    }
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode / 100 !=2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([identifier isEqualToString:@"deleteTag"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if([[rcvDictionary objectForKey:@"result"] boolValue] == true){
            [TableFriendTag deleteFriendTagRecordsByTagId:currentTagId];
            if (currentIndexPath.row<[self.tagList count]) {
                [self.tagList removeObjectAtIndex:currentIndexPath.row];//移除数据源的数据
                [self.tableViewOfTag deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentIndexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
            }

            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
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

@end

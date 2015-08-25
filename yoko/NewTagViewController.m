//
//  NewTagViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "NewTagViewController.h"
#import "NewTagCollectionViewCell.h"
#import "TableFriendTag.h"
#import "TableFriendInfo.h"


@interface NewTagViewController ()

- (IBAction)actionOfFinish:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfTag;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonOfFinish;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfTagName;
@end

@implementation NewTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.textFieldOfTagName.text = self.selectedTagname;
    
    self.friendList = [TableFriendTag getFriendArrayByTagId:self.selectedTagId];
    
    
    [self.collectionViewOfTag registerClass:[NewTagCollectionViewCell class] forCellWithReuseIdentifier:@"NewTagCollectionViewCell"];
    self.deleteFlag = 0;
    [self.collectionViewOfTag setPagingEnabled:NO];
    if([self.textFieldOfTagName.text length] == 0)
    self.buttonOfFinish.enabled = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    

//    [self.collectionViewOfTag setContentOffset:CGPointMake(0, 200000)];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [self.friendList count]){
        NewTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:indexPath];
        FriendTagRecord *friendTagRecord = [self.friendList objectAtIndex:indexPath.row];
        FriendInfoRecord *friendInfoRecord = [TableFriendInfo getFriendInfoByFriendId:friendTagRecord.fuid];
        cell.layer.cornerRadius = 0.8;
        cell.layer.masksToBounds = true;
        cell.backgroundColor=[UIColor orangeColor];
        cell.LabelOfName.text = friendInfoRecord.nickname;
        cell.ImageViewOfPhoto.image=[UIImage imageNamed:@"1.png"];
        cell.ButtonOfDelete.tag = indexPath.row;
        [cell.ButtonOfDelete addTarget:self action:@selector(ButtonOfDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.row == [self.friendList count]){
        NewTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 0.8;
        cell.layer.masksToBounds = true;
        cell.backgroundColor=[UIColor orangeColor];
        cell.LabelOfName.text = @"添加";
        cell.ImageViewOfPhoto.image=[UIImage imageNamed:@"1.png"];
        cell.ButtonOfDelete = nil;
        return cell;
    }
    else{
        NewTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 0.8;
        cell.layer.masksToBounds = true;
        cell.backgroundColor=[UIColor orangeColor];
        cell.LabelOfName.text = @"删除";
        cell.ImageViewOfPhoto.image=[UIImage imageNamed:@"1.png"];
        cell.ButtonOfDelete = nil;
        return cell;
    }

    
}

- (void)ButtonOfDeleteClick:(UIButton *)sender{
  //  NewTagCollectionViewCell *cell = [self.CollectionViewOfTag dequeueReusableCellWithReuseIdentifier:@"NewTagCollectionViewCell" forIndexPath:self.CollectionViewOfTag .indexPathsForVisibleItems[sender.tag]];
    if (sender.tag<[self.friendList count]) {
        [self.friendList removeObjectAtIndex:sender.tag];//移除数据源的数据
        [self.collectionViewOfTag deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]]];
    }
    [self.collectionViewOfTag reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.friendList count]+2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == [self.friendList count] + 1){
        if([[collectionView visibleCells] count] == 2) return;
        if(self.deleteFlag == 0)
            [self showDeleteSign];
        else
            [self hiddenDeleteSign];
    }
    else if(indexPath.row == [self.friendList count]){
         if(self.deleteFlag!=0)
             [self hiddenDeleteSign];
         else{
             SelectFriendViewController *selectFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectFriendView"];
             selectFriendViewController.oldFriendList = self.friendList;
             selectFriendViewController.delegate = self;
             [self.navigationController pushViewController:selectFriendViewController animated:YES];
         }
    }
    else{
        if(self.deleteFlag!=0)
            [self hiddenDeleteSign];
        else{
            
        }
    }
}


- (void)showDeleteSign{
    for(NSIndexPath *indexPath in self.collectionViewOfTag .indexPathsForVisibleItems){
        NewTagCollectionViewCell *cell = (NewTagCollectionViewCell *)[self.collectionViewOfTag  cellForItemAtIndexPath:indexPath];
        cell.ButtonOfDelete.hidden = NO;
        [cell reloadInputViews];
    }
    self.deleteFlag = 1;
    

    
}

- (void)hiddenDeleteSign{
    for(NSIndexPath *indexPath in self.collectionViewOfTag .indexPathsForVisibleItems){
        NewTagCollectionViewCell *cell = (NewTagCollectionViewCell *)[self.collectionViewOfTag  cellForItemAtIndexPath:indexPath];
        cell.ButtonOfDelete.hidden = YES;
        [cell reloadInputViews];
    }
    self.deleteFlag = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)selectFriendData:(NSArray *)friendList{
    self.friendList = [NSMutableArray arrayWithArray:friendList];
    [self.collectionViewOfTag reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(range.location == 25) return NO;
    
    return YES;
    
}

- (void)textFieldChanged{
    if([self.textFieldOfTagName.text length]== 0)
        self.buttonOfFinish.enabled = NO;
    else
        self.buttonOfFinish.enabled = YES;

}


- (IBAction)actionOfFinish:(id)sender {
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *sendArray = [[NSMutableArray alloc] init];
    for(FriendTagRecord *friendTagRecord in self.friendList){
         NSDictionary *sendFriendId = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:friendTagRecord.fuid],@"id", nil];
        [sendArray addObject:sendFriendId];
    }
    [sendDictionary setObject:self.textFieldOfTagName.text forKey:@"tagname"];
    [sendDictionary setObject:sendArray forKey:@"friendlist"];
    
    if(self.selectedTagId == 0){
        RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/mytag/friendlist" andHTTPMethod:@"POST" andHTTPValues:sendDictionary andDelegate:self andIdentifier:@"postfriendlist"];
        [r startConnection];
    }
    else{
        RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:[NSString stringWithFormat:@"/user/mytag/%ld/friendlist",self.selectedTagId] andHTTPMethod:@"PUT" andHTTPValues:sendDictionary andDelegate:self andIdentifier:@"putfriendlist"];
        [r startConnection];
    }
    
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode / 100 !=2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败" message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([identifier isEqualToString:@"postfriendlist"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if([[rcvDictionary objectForKey:@"result"] boolValue] == true){
            NSString *tagIdString = [rcvDictionary objectForKey:@"msg"];
            NSInteger tagId = [tagIdString integerValue];
            NSMutableArray *insertFriendIdArray = [[NSMutableArray alloc] init];
            for(FriendTagRecord *friendTagRecord in self.friendList){
                FriendTagRecord *newFriendTagRecord = [[FriendTagRecord alloc] initWithUid:[UserServer getUserID] andFuid:friendTagRecord.fuid andTagId:tagId andTagName:self.textFieldOfTagName.text];
                [insertFriendIdArray addObject:newFriendTagRecord];
            }
            FriendTagRecord *newFriendTagRecord = [[FriendTagRecord alloc] initWithUid:[UserServer getUserID] andFuid:0l andTagId:tagId andTagName:self.textFieldOfTagName.text];
            [insertFriendIdArray addObject:newFriendTagRecord];
            
            [TableFriendTag insertFriendTagRecords:insertFriendIdArray];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建失败" message:@"新建失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    if([identifier isEqualToString:@"putfriendlist"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if([[rcvDictionary objectForKey:@"result"] boolValue] == true){
            NSInteger tagId = self.selectedTagId;
            NSMutableArray *updateFriendIdArray = [[NSMutableArray alloc] init];
            for(FriendTagRecord *friendTagRecord in self.friendList){
                FriendTagRecord *newFriendTagRecord = [[FriendTagRecord alloc] initWithUid:[UserServer getUserID] andFuid:friendTagRecord.fuid andTagId:tagId andTagName:self.textFieldOfTagName.text];
                [updateFriendIdArray addObject:newFriendTagRecord];
            }
            FriendTagRecord *newFriendTagRecord = [[FriendTagRecord alloc] initWithUid:[UserServer getUserID] andFuid:0l andTagId:tagId andTagName:self.textFieldOfTagName.text];
            [updateFriendIdArray addObject:newFriendTagRecord];
            
            [TableFriendTag updateFriendTagRecordsWithTagId:tagId andFriendTagArray:updateFriendIdArray];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改失败" message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }

    }
    
}

@end

//
//  AddFriendViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/24.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
{
    NSInteger currentFriendId;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOfFriend;
@property (weak, nonatomic) IBOutlet UIView *viewOfUserInfo;
@property (weak, nonatomic) IBOutlet UIView *viewOfRequest;
@property (weak, nonatomic) IBOutlet UILabel *labelOfNickname;
@property (weak, nonatomic) IBOutlet UITextView *textViewOfMsg;
- (IBAction)actionOfRequest:(id)sender;
- (IBAction)actionOfSend:(id)sender;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加好友";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.viewOfRequest.hidden = YES;
    self.viewOfUserInfo.hidden = YES;
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.searchBarOfFriend.text,@"mobile",nil];
    
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myfriend/search" andHTTPMethod:@"POST" andHTTPValues:sendDictionary andDelegate:self andIdentifier:@"searchfriend"];
    [r startConnection];
}

-(void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    
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
    if([identifier isEqualToString:@"searchfriend"]){
        
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查找失败" message:@"无此用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        currentFriendId = [[rcvDictionary objectForKey:@"id"] longValue];
        self.labelOfNickname.text = [rcvDictionary objectForKey:@"nickname"];
        self.viewOfUserInfo.hidden = NO;
    }
    if([identifier isEqualToString:@"sendrequest"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([[rcvDictionary objectForKey:@"result"] boolValue] == true){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已发送" message:@"已发送" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self moveView:-200];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self moveView:200];
}

-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
    }
    if(range.location == 20) return NO;
    return YES;
}


- (IBAction)actionOfRequest:(id)sender {
    self.viewOfRequest.hidden = NO;
}

- (IBAction)actionOfSend:(id)sender {
    [self.textViewOfMsg resignFirstResponder];
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.textViewOfMsg.text,@"msg" ,nil];
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:[NSString stringWithFormat:@"/user/myfriend/request/%ld",currentFriendId] andHTTPMethod:@"POST" andHTTPValues:sendDictionary andDelegate:self andIdentifier:@"sendrequest"];
    [r startConnection];
    
}
@end

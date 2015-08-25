//
//  LoginInViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/4.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "LoginInViewController.h"
#import "MainTabViewController.h"
#import "TableFriendInfo.h"
#import "UserServer.h"
#import "TableFriendTag.h"

@interface LoginInViewController ()
- (IBAction)ActionOfLoginIn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfMobile;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfPassword;


@end

@implementation LoginInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([UserServer getUserID] != 0l){
        MainTabViewController *mainTabViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabView"];
        [self presentViewController:mainTabViewController animated:YES completion:^{
            NSLog(@"ok");}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",[UserServer getMobileRole]);
    if([[[UserServer getMobileRole] substringToIndex:1] isEqualToString:@"0"]){
        self.textFieldOfMobile.text = [[UserServer getMobileRole] substringFromIndex:2];
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

- (IBAction)ActionOfLoginIn:(id)sender {
    NSMutableDictionary *HTTPValues= [[NSMutableDictionary alloc] init];
    [HTTPValues setObject:[NSString stringWithFormat:@"0_%@",self.textFieldOfMobile.text] forKey:@"username"];
    [HTTPValues setObject:self.textFieldOfPassword.text forKey:@"password"];
    [HTTPValues setObject:@"password" forKey:@"grant_type"];
    
    RestAPI *r = [[RestAPI alloc] initTokenRequestWithURI:@"/oauth/token" andHTTPMethod:@"POST" andHTTPValues:HTTPValues andDelegate:self andIdentifier:@"login"];
    [r startConnection];
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);

    
    if([identifier isEqualToString:@"login"]){
        if(statusCode / 100 !=2){
            NSLog(@"%ld",statusCode);
            UIAlertView *alert;
            if(statusCode == 400){
                alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        }
            else{
                alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            }
            [alert show];
            return;

        }
        
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSString *accessToken = [rcvDictionary objectForKey:@"access_token"];
        if(accessToken == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString *refreshToken = [rcvDictionary objectForKey:@"refresh_token"];
        
        [UserServer saveLogInInfoWithAccessToken:accessToken andRefreshToken:refreshToken andUserMobile:self.textFieldOfMobile.text andPassword:self.textFieldOfPassword.text];
        
        [TableFriendInfo createTable];
        [TableFriendTag createTable];

        
        MainTabViewController *mainTabViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabView"];
        [self presentViewController:mainTabViewController animated:YES completion:nil];
        
    }
    
    
}

@end

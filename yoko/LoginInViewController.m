//
//  LoginInViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/4.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "LoginInViewController.h"
#import "MainTabViewController.h"

@interface LoginInViewController ()
- (IBAction)ActionOfLoginIn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldOfMobile;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldOfPassword;


@end

@implementation LoginInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)ActionOfLoginIn:(id)sender {
    NSMutableDictionary *HTTPValues= [[NSMutableDictionary alloc] init];
    [HTTPValues setObject:[NSString stringWithFormat:@"0_%@",self.TextFieldOfMobile.text] forKey:@"username"];
    [HTTPValues setObject:self.TextFieldOfPassword.text forKey:@"password"];
    [HTTPValues setObject:@"password" forKey:@"grant_type"];
    
    RestAPI *r = [[RestAPI alloc] initTokenRequestWithURI:@"/oauth/token" andHTTPMethod:@"POST" andHTTPValues:HTTPValues andDelegate:self];

    [r startConnection];
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error{
    
    NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode / 100 !=2){
        NSLog(@"%ld",statusCode);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSString *accessToken = [rcvDictionary objectForKey:@"access_token"];
    if(accessToken == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *refreshToken = [rcvDictionary objectForKey:@"refresh_token"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:accessToken forKey:@"accessToken"];
    [userDefaults setObject:refreshToken forKey:@"refreshToken"];
    [userDefaults setObject:[NSString stringWithFormat:@"0_%@",self.TextFieldOfMobile.text] forKey:@"username"];
    [userDefaults setObject:self.TextFieldOfPassword.text forKey:@"password"];
    [userDefaults synchronize];
    
    MainTabViewController *mainTabViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabView"];
    [self presentViewController:mainTabViewController animated:YES completion:nil];
    
}

@end

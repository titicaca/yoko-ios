//
//  EnterPasswordViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "EnterPasswordViewController.h"
#import "LoginInNavigationViewController.h"

@interface EnterPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ButtonOfFinish;
- (IBAction)ActionOfFinish:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldOfName;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldOfPassword;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldOfRepass;

@end

@implementation EnterPasswordViewController

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

- (IBAction)ActionOfFinish:(id)sender {
    
    
    if(![self.TextFieldOfPassword.text isEqualToString:self.TextFieldOfRepass.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码错误" message:@"两次输入的密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(self.TextFieldOfPassword.text.length<6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码过短" message:@"请输入6位以上密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *HTTPValues= [[NSMutableDictionary alloc] init];
    [HTTPValues setObject:self.TextFieldOfName.text forKey:@"name"];
    [HTTPValues setObject:[NSString stringWithFormat:@"0_%@",self.mobile] forKey:@"role_mobile"];
    [HTTPValues setObject:self.TextFieldOfPassword.text forKey:@"password"];
    
    RestAPI *r =[[RestAPI alloc] initSignUpRequestWithURI:@"/signup/user" andHTTPMethod:@"POST" andHTTPValues:HTTPValues andDelegate:self andIdentifier:nil];
    
    [r startConnection];
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode / 100 !=2){
        NSLog(@"%ld",statusCode);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败" message:@"连接失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    BOOL result = [rcvDictionary objectForKey:@"result"];
    
    if(result == true){
        LoginInNavigationViewController *loginInNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginInNavigationView"];
        [self presentViewController:loginInNavigationViewController animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"手机号已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}


@end

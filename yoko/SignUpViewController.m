//
//  SignUpViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "SignUpViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "EnterPasswordViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonOfGetCode;
@property (weak, nonatomic) IBOutlet UILabel *labelOfCounter;
- (IBAction)actionOfGetCode:(id)sender;
- (IBAction)actionOfSignUp:(id)sender;
- (IBAction)actionOfLogIn:(id)sender;

@end

@implementation SignUpViewController

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

- (void)TimerCount{
    static int secondCount=30;
    secondCount--;
    self.labelOfCounter.hidden = false;
    self.buttonOfGetCode.hidden = true;
    self.labelOfCounter.text = [NSString stringWithFormat: @"再次获取%d秒",secondCount];
    if(secondCount == 0){
        [self.timer invalidate];
        self.timer = nil;
        secondCount = 30;
            self.labelOfCounter.hidden = true;
        self.buttonOfGetCode.hidden = false;

    }
}

- (IBAction)actionOfGetCode:(id)sender {
    
    if([self VerifyPhone] == true){
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.textFieldOfPhone.text zone:@"86" result:nil];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerCount) userInfo:nil repeats:YES];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"手机号码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
       
    }
    
}

- (IBAction)actionOfSignUp:(id)sender {
    if([self VerifyCode]){
        [SMS_SDK commitVerifyCode:self.textFieldOfCode.text result:^(enum SMS_ResponseState state) {
            if(state == 1){
                EnterPasswordViewController *enterPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPasswordView"];
                enterPasswordViewController.mobile = self.textFieldOfPhone.text;
                [self.navigationController pushViewController:enterPasswordViewController animated:YES];
                
            }
            if(state == 0){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (IBAction)actionOfLogIn:(id)sender {
}

- (BOOL)VerifyPhone {
    if(self.textFieldOfPhone.text.length != 11){
        return false;
    }
    return true;
}

- (BOOL)VerifyCode {
    if(self.textFieldOfCode.text.length != 4){
        return false;
    }
    return true;
}

@end

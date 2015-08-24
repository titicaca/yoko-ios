//
//  UserSettingViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/24.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserServer.h"

@interface UserSettingViewController ()
- (IBAction)actionOfLogOut:(id)sender;

@end

@implementation UserSettingViewController

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

- (IBAction)actionOfLogOut:(id)sender {
    [UserServer logOut];
    UIViewController *loginInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginInNavigationView"];
    [self presentViewController:loginInViewController animated:YES completion:nil];
    
    
}
@end

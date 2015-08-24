//
//  UserInfoViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/24.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserServer.h"

@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelOfNickname;
@property (weak, nonatomic) IBOutlet UILabel *labelOfSign;
@property (weak, nonatomic) IBOutlet UILabel *labelOfLocation;

@property (weak, nonatomic) IBOutlet UILabel *labelOfCollectNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelOfEnrollNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelOfFriendNumber;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelOfNickname.text = [UserServer getNickname];
    self.labelOfLocation.text = [UserServer getLocation];
    self.labelOfCollectNumber.text = [NSString stringWithFormat:@"%d",[UserServer getCollectNumber]];
    self.labelOfEnrollNumber.text = [NSString stringWithFormat:@"%d",[UserServer getEnrollNumber]];
    self.labelOfFriendNumber.text = [NSString stringWithFormat:@"%d",[UserServer getFriendNumber]];
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

@end

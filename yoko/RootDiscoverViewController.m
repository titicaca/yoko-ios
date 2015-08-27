//
//  RootDiscoverViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "RootDiscoverViewController.h"



@interface RootDiscoverViewController ()

@end

@implementation RootDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *organizationView = [self.storyboard instantiateViewControllerWithIdentifier:@"OrganizationView"];
    organizationView.title = @"组织";
    UIViewController *activityView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityView"];
    activityView.title = @"活动";
    UIViewController *collectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"];
    collectionView.title = @"收藏";
    UIViewController *messageView = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageView"];
    messageView.title = @"消息";
    self.discoverTabViewController = [[DiscoverTabViewController alloc] initWithControllers:@[organizationView,activityView,collectionView,messageView]];
    [self.view addSubview:self.discoverTabViewController.view];
   // [self presentViewController:self.discoverTabViewController animated:NO completion:nil];

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

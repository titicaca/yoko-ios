//
//  OrganizationViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "DiscoverViewController.h"
#import "OrganizationViewController.h"

@interface DiscoverViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewOfOrganizaiton;
@property (weak, nonatomic) IBOutlet UIView *viewOfActivity;
@property (weak, nonatomic) IBOutlet UIView *viewOfCollection;
@property (weak, nonatomic) IBOutlet UIView *viewOfMessage;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarOfDiscover;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self selectView:self.pageIndex];
    [self.tabBarOfDiscover setSelectedItem:[self.tabBarOfDiscover.items objectAtIndex:self.pageIndex]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%ld",self.pageIndex);
    switch (self.pageIndex) {
        case 0:{
            RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/watch/orgs" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:[self.storyboard instantiateViewControllerWithIdentifier:@"OrganizationView"] andIdentifier:@"GetWatchOrgs"];
            [r startConnection];
        }
            break;
        case 1:{
            RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/activities" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityView"] andIdentifier:@"GetWatchOrgs"];
            [r startConnection];
        }
            break;
        case 2:{
            RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/collect/activities" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:[self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"] andIdentifier:@"GetWatchOrgs"];
            [r startConnection];
        }
            break;
            
        default:
            break;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%@",item);
    self.pageIndex = item.tag;
    [self selectView:self.pageIndex];
    [self.delegate callbackPageIndex:self.pageIndex];
}

- (void)selectView:(NSInteger)pageIndex{
    self.viewOfOrganizaiton.hidden = YES;
    self.viewOfActivity.hidden = YES;
    self.viewOfCollection.hidden = YES;
    self.viewOfMessage.hidden = YES;
    switch (pageIndex) {
        case 0:
            self.viewOfOrganizaiton.hidden = NO;
            break;
        case 1:
            self.viewOfActivity.hidden = NO;
            break;
        case 2:
            self.viewOfCollection.hidden = NO;
            break;
        case 3:
            self.viewOfMessage.hidden = NO;
            break;
        default:
            break;
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
    
    if([identifier isEqualToString:@"GetWatchOrgs"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
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

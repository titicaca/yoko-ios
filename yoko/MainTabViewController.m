//
//  MainTabViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/5.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "MainTabViewController.h"
#import "TableFriendInfo.h"
#import "TableFriendTag.h"
#import "UserServer.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/userinfo" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"userinfo"];
    [r startConnection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    
    if([identifier isEqualToString:@"userinfo"]){
        if(statusCode / 100 !=2){
            [UserServer logOut];
            return;
            
        }
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if(rcvDictionary == nil){
            [UserServer logOut];
            return;
        }
        [UserServer saveUserInfo:rcvDictionary];
        RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myfriend/allinfo" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"myfriendallinfo"];
        [r startConnection];
    }
    else if ([identifier isEqualToString:@"myfriendallinfo"]){
        
        if(statusCode / 100 !=2){
            [UserServer logOut];
            return;
            
        }
        
        NSDictionary *tableDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //  NSLog(@"%@",[tableDictionary objectForKey:@"list"]);
        
        
        if(tableDictionary == nil){
            RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myfriend/allinfo" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"myfriendallinfo"];
            [r startConnection];
            return;
        }
        
        NSArray *rcvArray = [tableDictionary objectForKey:@"list"];
        NSLog(@"%@",rcvArray);
        
        [TableFriendInfo createTable];
        [TableFriendInfo synFriendInfoRecords:rcvArray];
        [TableFriendTag createTable];
        [TableFriendTag synFriendTagRecords:rcvArray];
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

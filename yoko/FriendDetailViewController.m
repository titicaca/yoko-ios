//
//  FriendDetailViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "TableFriendInfo.h"


@interface FriendDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelOfId;
@property (weak, nonatomic) IBOutlet UILabel *labelOfNickname;

@end

@implementation FriendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FriendInfoRecord *friendInfoRecord = [TableFriendInfo getFriendInfoByFriendId:self.friendId];
    self.labelOfNickname.text = friendInfoRecord.nickname;
    
    self.labelOfId.text = [NSString stringWithFormat:@"%lu",self.friendId];
    RestAPI *r =[[RestAPI alloc] initNormalRequestWithURI:[NSString stringWithFormat:@"/user/myfriend/%ld/info",self.friendId] andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:nil];
    
    [r startConnection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier{
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",connection.currentRequest);
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
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

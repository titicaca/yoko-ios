//
//  CollectionViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "CollectionViewController.h"
#import "MJRefresh.h"
#import "ActivityTableViewCell.h"
@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewOfCollection;

@end

@implementation CollectionViewController
{
    NSInteger currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/collect/activities" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"GetCollection"];
    [r startConnection];
    [self setupRefresh:self.tableViewOfCollection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"ActivityCell"];
    }

    NSDictionary *collection = [self.collectionList objectAtIndex:indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labelOfName.text=[NSString stringWithFormat:@"%ld",[[collection objectForKey:@"id"] longValue]];
//    cell.accessoryType=UITableViewCellAccessoryNone;
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
//    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
//    cell.imageView.image=[UIImage imageNamed:@"1.png"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
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
    
    if([identifier isEqualToString:@"GetCollection"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.collectionList = [rcvDictionary objectForKey:@"list"];
        
    }
    else if([identifier isEqualToString:@"GetMoreCollection"]){
        NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.collectionList = [self.collectionList arrayByAddingObjectsFromArray:[rcvDictionary objectForKey:@"list"]];
    }
    [self.tableViewOfCollection reloadData];
    [self.tableViewOfCollection headerEndRefreshing];
    [self.tableViewOfCollection footerEndRefreshing];
    
}

- (void)setupRefresh:(UITableView *)tableView
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView.headerPullToRefreshText = @"下拉可以刷新了";
    tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView.headerRefreshingText = @"正在刷新中";
    
    tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView.footerReleaseToRefreshText = @"加载更多数据";
    tableView.footerRefreshingText = @"正在加载中";
}

- (void)headerRefreshing{
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/collect/activities" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"GetCollection"];
    [r startConnection];
}

- (void)footerRefreshing{
    RestAPI *r = [[RestAPI alloc] initNormalRequestWithURI:@"/user/myactivity/collect/activities" andHTTPMethod:@"GET" andHTTPValues:nil andDelegate:self andIdentifier:@"GetMoreCollection"];
    [r startConnection];
    
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

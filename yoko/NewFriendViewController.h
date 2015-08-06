//
//  NewFriendViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(retain, nonatomic) NSArray *friendList;

@end

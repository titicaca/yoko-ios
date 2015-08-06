//
//  FriendView.h
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "RestAPI.h"
@interface FriendView : UIViewController<UITableViewDelegate,UITableViewDataSource,RestAPIDelegate>


@property(retain, nonatomic)NSArray *friendAndTag;
@property(retain, nonatomic)NSArray *friendList;

@end

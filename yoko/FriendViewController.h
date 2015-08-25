//
//  FriendView.h
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"
@interface FriendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RestAPIDelegate>

@property(retain, nonatomic) NSMutableArray *friendList;

@end

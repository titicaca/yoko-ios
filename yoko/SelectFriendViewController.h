//
//  SelectFriendViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/25.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectFriend <NSObject>

@required
- (void)selectFriendData:(NSArray *)friendList;

@end

@interface SelectFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) NSMutableArray *friendList;
@property(nonatomic, retain) NSArray *oldFriendList;
@property(nonatomic, retain) id<SelectFriend> delegate;

@end

//
//  NewTagViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFriendViewController.h"
#import "RestAPI.h"
@interface NewTagViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,SelectFriend,UITextFieldDelegate,RestAPIDelegate>

@property(assign, nonatomic)int deleteFlag;

@property(nonatomic, retain) NSMutableArray *friendList;
@property(nonatomic, assign) NSInteger selectedTagId;
@property(nonatomic, retain) NSString *selectedTagname;
@end

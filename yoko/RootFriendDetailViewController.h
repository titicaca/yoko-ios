//
//  RootFriendDetailViewController.h
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDetailViewController.h"

@interface RootFriendDetailViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (assign, nonatomic) NSUInteger allPageIndex;
@property (assign, nonatomic) NSUInteger friendId;

@end

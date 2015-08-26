//
//  RootFriendDetailViewController.h
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootFriendDetailViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign, nonatomic) NSUInteger allPageIndex;
@property (retain, nonatomic) NSArray *friendList;
@property (assign, nonatomic) NSUInteger currentPageIndex;

@end

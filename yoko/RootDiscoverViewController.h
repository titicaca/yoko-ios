//
//  RootDiscoverViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverViewController.h"

@interface RootDiscoverViewController : UIViewController<UIPageViewControllerDataSource,callbackPageIndex>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

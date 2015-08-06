//
//  RootFriendDetailViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "RootFriendDetailViewController.h"

@interface RootFriendDetailViewController ()

@end

@implementation RootFriendDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //create the page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendDetailPageView"];
    self.pageViewController.dataSource = self;
    
    FriendDetailViewController *startingViewController = [self viewControllerAtIndex:self.friendId];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //change the size of the page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (FriendDetailViewController *)viewControllerAtIndex:(NSUInteger) index{
    
    
    FriendDetailViewController *friendDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendDetailView"];
    friendDetailViewController.pageIndex = index;
    
    return friendDetailViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((FriendDetailViewController*) viewController).pageIndex;
    
    if ((index == 1)||(index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((FriendDetailViewController*) viewController).pageIndex;
    
    if (index==self.allPageIndex || index == NSNotFound) {
        return nil;
    }
    index++;
   
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

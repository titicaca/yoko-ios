//
//  RootDiscoverViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "RootDiscoverViewController.h"


@interface RootDiscoverViewController ()

@end

@implementation RootDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscoverPageView"];
    self.pageViewController.dataSource = self;
    
    DiscoverViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //change the size of the page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DiscoverViewController *)viewControllerAtIndex:(NSUInteger)index{
    
    
    DiscoverViewController *organizationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DiscoverView"];
    organizationViewController.pageIndex = index;
    organizationViewController.delegate = self;
    return organizationViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = ((DiscoverViewController*) viewController).pageIndex;
    if ((index == 0)||(index == NSNotFound)) {
          return nil;
    }
    else index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = ((DiscoverViewController*) viewController).pageIndex;
    if (index==3 || index == NSNotFound) {
          return nil;
    }
    else index++;
    return [self viewControllerAtIndex:index];
}

- (void)callbackPageIndex:(NSInteger)pageIndex{
    UIViewController *startingViewController = [self viewControllerAtIndex:pageIndex];
    [self.pageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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

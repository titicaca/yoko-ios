//
//  OrganizationViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"

@protocol callbackPageIndex <NSObject>

@required
- (void)callbackPageIndex:(NSInteger)pageIndex;

@end

@interface DiscoverViewController : UIViewController<UITabBarDelegate,RestAPIDelegate>

@property(assign, nonatomic) NSInteger pageIndex;
@property(retain, nonatomic) id<callbackPageIndex> delegate;

@end

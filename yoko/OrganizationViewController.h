//
//  OrganizationViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"

@interface OrganizationViewController : UIViewController<RestAPIDelegate,UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSArray *organizationList;

@end

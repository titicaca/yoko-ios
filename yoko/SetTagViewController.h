//
//  SetTagViewController.h
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"

@interface SetTagViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RestAPIDelegate>

@property (retain, nonatomic)NSMutableArray *tagList;


@end

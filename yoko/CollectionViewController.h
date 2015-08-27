//
//  CollectionViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/26.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"
@interface CollectionViewController : UIViewController<RestAPIDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, retain) NSArray *collectionList;

@end

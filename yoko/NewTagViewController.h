//
//  NewTagViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTagViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(assign, nonatomic)int deleteFlag;

@property(nonatomic, retain) NSArray *friendList;
@property(nonatomic, assign) long selectedTagId;

@end

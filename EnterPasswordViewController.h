//
//  EnterPasswordViewController.h
//  yoko
//
//  Created by BlueSun on 15/7/30.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPI.h"

@interface EnterPasswordViewController : UIViewController<RestAPIDelegate>
@property(retain, nonatomic)NSString *mobile;

@end

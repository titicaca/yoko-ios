//
//  ViewController.h
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UIScrollViewDelegate>

@property(retain, nonatomic) NSCalendar *myCalendar;
@property(retain, nonatomic) NSDateComponents *myDate;

@end

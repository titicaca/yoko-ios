//
//  CalendarMainViewController.h
//  yoko
//
//  Created by BlueSun on 15/8/6.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarMainViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(retain, nonatomic) NSCalendar *myCalendar;
@property(retain, nonatomic) NSCalendar *myLunarCalendar;
@property(retain, nonatomic) NSDateComponents *myDateComponents;

@property(retain, nonatomic) NSArray *chineseDays;
@property(retain, nonatomic) NSDate *dateIterator;

@property(assign, nonatomic) NSInteger daysToContinue;
@property(assign, nonatomic) NSInteger allDaysContinued;

@end

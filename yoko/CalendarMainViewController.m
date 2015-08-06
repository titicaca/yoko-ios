//
//  CalendarMainViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/6.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "CalendarMainViewController.h"
#import "CalendarCollectionViewCell.h"

NSTimeInterval secondsPerDay = 86400;
NSUInteger calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear;

@interface CalendarMainViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewOfMonthCalendar;

@end

@implementation CalendarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initChineseDate];
    [self initCollectionView];
    [self initCalendar];
    
   // [[NSDate alloc] initwi]
    self.myDateComponents = [self.myCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
  //  NSLog(@"%@",[self.chineseDays objectAtIndex:(self.myDateComponents.day)]);
    NSLog(@"%li",self.myDateComponents.weekday);
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2015 ];
    [comps setMonth:8];
    [comps setDay:6];
    NSDate *date = [self.myCalendar dateWithEra:nil year:2015 month:8 day:6 hour:nil minute:nil second:nil nanosecond:nil];
    NSLog(@"%@",date);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 0.8;
    cell.layer.masksToBounds = true;
    cell.backgroundColor=[UIColor clearColor];
    
    if(indexPath.row<7) return cell;
    
    self.dateIterator = [NSDate dateWithTimeIntervalSince1970:(indexPath.row-7) * secondsPerDay * (indexPath.section + 1)];

    
    self.myDateComponents = [self.myCalendar components:calendarUnit fromDate:self.dateIterator];
    
    
    
    cell.LabelOfDay.text = [NSString stringWithFormat:@"%li",self.myDateComponents.day];
    
    self.myDateComponents = [self.myLunarCalendar components:calendarUnit fromDate:self.dateIterator];
    cell.LabelOfLunar.text = [self.chineseDays objectAtIndex:(self.myDateComponents.day)];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 49;
}

- (void)initCollectionView{
    [self.CollectionViewOfMonthCalendar registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:@"CalendarCollectionViewCell"];
    [self.CollectionViewOfMonthCalendar setPagingEnabled:NO];
}

- (void)initCalendar{
    self.myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [self.myCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    self.myLunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    [self.myLunarCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    self.dateIterator = [NSDate date];
    self.daysToContinue = 0;
    self.allDaysContinued = 0;
}

- (void)initChineseDate{
    self.chineseDays = [NSArray arrayWithObjects:@"",@"初一", @"初二", @"初三", @"初四", @"初五",
                        @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三",
                        @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一",
                        @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九",
                        @"三十",  nil];
}

//- (NSDate *)getDateWithCollectionViewSection:(NSInteger)section andRow:(NSInteger)row{
//    
//    if(row<7) return nil;
//    
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:1970 + section/12];
//    [comps setMonth:section % 12];
//    [comps setDay:1];
//    NSInteger weekday = [comps weekday];
//    return date;
//}

@end

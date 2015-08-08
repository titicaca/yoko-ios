//
//  CalendarViewController.m
//  Calendar
//
//  Created by 张凡 on 14-8-21.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"
#import <objc/runtime.h>

NSInteger secondsPerDay = 86400;

@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{

     NSTimer* timer;//定时器

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *ButtonOfTest;
- (IBAction)ActionOfTest:(id)sender;

@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"CalendarDayCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
        [self initView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initData];
    [self initView];
    
 //   NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-3*365*secondsPerDay];
    NSDate *startDate = [self dateFromYear:2015 andMonth:1 andDay:1];
    
  //  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if([userDefaults objectForKey:@"calendar"] == nil){
//    
//        self.calendarMonth = [self getMonthArrayOfDayNumber:3650 withDate:date ToDateforString:nil];
//        [userDefaults setObject:self.calendarMonth forKey:@"calendar"];
//    }
//    else{
//        self.calendarMonth = [userDefaults objectForKey:@"calendar"];
//    }
    
    self.calendarMonth = [self getMonthArrayOfDayNumber:365*5 withDate:startDate ToDateforString:nil];
    self.currentInitYear = [startDate YMDComponents].year;
    self.currentInitMonth = [startDate YMDComponents].month;
    [self goToDate:[NSDate date]];
    
    

   // CalendarDayModel *a=[[self.calendarMonth objectAtIndex:1] objectAtIndex:1];
    
   // size_t t = class_getInstanceSize([a class]);
   // NSLog(@"t = %zu",t);
//    date = [NSDate dateWithTimeIntervalSinceNow:-10*365*secondsPerDay];
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        self.calendarMonth = [self getMonthArrayOfDayNumber:365*50 withDate:startDate ToDateforString:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"test");
            
           [self.collectionView reloadData];
            self.currentInitYear = [startDate YMDComponents].year;
            self.currentInitMonth = [startDate YMDComponents].month;
            [self selectDate:self.selectedDate];
            
        });
     });
    
    [self selectDate:[NSDate date]];
    
}


//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day withDate:(NSDate *)date ToDateforString:(NSString *)todate
{
    
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    self.Logic = [[CalendarLogic alloc]init];
    
    return [self.Logic reloadCalendarView:date selectDate:nil  needDays:day];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView{
    
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    [self.collectionView setCollectionViewLayout:layout];
 //   self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    
    [self.collectionView addGestureRecognizer:doubleTapRecognizer];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    [self.view addSubview:self.collectionView];
    
    
    
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGestureRecongnizer{
    NSLog(@"tttt");
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    self.mutableDictionary = [[NSMutableDictionary alloc]init];
    self.selectedDate = [NSDate date];
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.calendarMonth.count;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];

    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [month_Array objectAtIndex:15];
        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%02ld",model.month];//@"日期";
        monthHeader.subLabel.text = [NSString stringWithFormat:@"%ld",model.year];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
        
        
        
    }
    return reusableview;
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return false;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];
    
   
    NSLog(@"click");

    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick || model.style ==   CellDayTypePast) {
       
        [self.Logic selectLogic:model];
        
    //    if (self.calendarblock) {
            
    //        self.calendarblock(model);//传递数组给上级
            
  //          timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
  //      }
        
        self.selectedDate = [self dateFromYear:model.year andMonth:model.month andDay:model.day];
        [self.collectionView reloadData];
    }
    else{
        
        //self.collectionView.hidden = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

//定时器方法
//- (void)onTimer{
//    
//  //  [timer invalidate];//定时器无效
//    
// //   timer = nil;
//    
// //   [self.navigationController popViewControllerAnimated:YES];
//}

- (void)goToDate:(NSDate *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
    NSLog(@"%li   %li",indexPath.row,indexPath.section);
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y-45)];
    
    
}

- (void)selectDate:(NSDate *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    int index = 0;
    for(CalendarDayModel *model in month_Array){
        if(model.day == [date YMDComponents].day){
            indexPath = [NSIndexPath indexPathForRow:index inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
            [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
        }
        index++;
    }

}

- (NSDate *)dateFromYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSDate *date = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:comps];
    return date;
}


- (IBAction)ActionOfTest:(id)sender {
    [self goToDate:[NSDate date]];
    [self selectDate:[NSDate date]];
    
}
@end

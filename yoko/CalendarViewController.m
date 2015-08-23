//
//  CalendarViewController.m
//  yoko
//
//  Created by BlueSun on 15/8/3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//


#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarWeekCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarWeekHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"
#import <objc/runtime.h>

#define Duration 0.2


NSInteger secondsPerDay = 86400;



@interface CalendarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    UIView *selectView;

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfMonth;
@property (weak, nonatomic) IBOutlet UIButton *ButtonOfTest;
- (IBAction)ActionOfTest:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOfWeek;
- (IBAction)actionOfChangeType:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelOfWeek;
@property (weak, nonatomic) IBOutlet UILabel *labelOfMonth;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOfSchedule;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewOfWeek;
//@property (weak, nonatomic) IBOutlet UIView *viewOfWeek;

@property (weak, nonatomic) IBOutlet UIScrollView *viewOfWeek;

@property (weak, nonatomic) IBOutlet UIView *viewOfGray;
- (IBAction)actionOfSetFunction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonOfFunctionView;
@property (weak, nonatomic) IBOutlet UIView *viewOfFunction;
@property (weak, nonatomic) IBOutlet UIView *viewOfAddSchedule;
@property (weak, nonatomic) IBOutlet UITextView *textViewOfEditSchedule;
- (IBAction)actionOfCloseView:(id)sender;

- (IBAction)actionOfOKView:(id)sender;

@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";
static NSString *WeekHeader = @"WeekHeaderView";
static NSString *DayCell = @"CalendarDayCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initData];
    [self initView];
    
 //   NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-3*365*secondsPerDay];
    NSDate *startDate = [NSDate dateFromYear:2015 andMonth:1 andDay:1];
    
    self.startDate = startDate;
    
    self.calendarMonth = [self getMonthArrayOfDayNumber:365*5 withDate:startDate ToDateforString:nil];
    [self transformFromMonthToWeek];
    self.currentInitYear = [startDate YMDComponents].year;
    self.currentInitMonth = [startDate YMDComponents].month;
    [self goToDate:[NSDate date]];
    

   // CalendarDayModel *a=[[self.calendarMonth objectAtIndex:1] objectAtIndex:1];
    
   // size_t t = class_getInstanceSize([a class]);
   // NSLog(@"t = %zu",t);
//    date = [NSDate dateWithTimeIntervalSinceNow:-10*365*secondsPerDay];
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        self.calendarMonth = [self getMonthArrayOfDayNumber:365*35 withDate:startDate ToDateforString:nil];
        [self transformFromMonthToWeek];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"test");
            
            [self.collectionViewOfMonth reloadData];
            [self.collectionViewOfWeek reloadData];
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
    [self.collectionViewOfMonth setCollectionViewLayout:layout];
    [self.collectionViewOfMonth setFrame:CGRectMake(0, 87, self.view.bounds.size.width, 334)];
    [self.collectionViewOfMonth setBackgroundColor:[UIColor whiteColor]];
 //   self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    [self.collectionViewOfMonth registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    [self.collectionViewOfMonth registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
//    self.collectionView.delegate = self;//实现网格视图的delegate
//    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.collectionViewOfMonth addGestureRecognizer:doubleTapRecognizer];
    
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTap:)];
    
    CalendarWeekCollectionViewLayout *weeklayout = [CalendarWeekCollectionViewLayout new];
    [self.collectionViewOfWeek setCollectionViewLayout:weeklayout];
    [self.collectionViewOfWeek setFrame:CGRectMake(50, 87, self.view.bounds.size.width, 50)];
    [self.collectionViewOfWeek setBackgroundColor:[UIColor whiteColor]];
    [self.collectionViewOfWeek setPagingEnabled:YES];
    [self.collectionViewOfWeek registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    [self.collectionViewOfWeek registerClass:[CalendarWeekHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WeekHeader];
    
    self.labelOfWeek.layer.opacity = 0;
    self.labelOfMonth.layer.opacity = 1;

    [self.viewOfWeek addGestureRecognizer:doubleTapRecognizer];
    [self.viewOfWeek addGestureRecognizer:singleTapRecognizer];
    [self.viewOfWeek addGestureRecognizer:pinchGestureRecognizer];
    
    [self.scrollViewOfWeek setContentSize:CGSizeMake(0, self.viewOfWeek.frame.size.height)];
    [self.scrollViewOfWeek setMaximumZoomScale:2.0];
    [self.scrollViewOfWeek setMinimumZoomScale:0.2];
    
    self.tableViewOfSchedule.layer.opacity = 1;
    
    self.scrollViewOfWeek.layer.opacity = 0;
    self.viewOfWeek.layer.opacity = 0;
    
    self.viewOfAddSchedule.layer.opacity = 0;
    
    
    self.viewOfFunction.layer.opacity = 0;
    
    self.viewOfGray.hidden = YES;
    
    
    [self.view addSubview:self.collectionViewOfWeek];
    [self.view addSubview:self.collectionViewOfMonth];
    
    [self.view addSubview:self.tableViewOfSchedule];
    [self.view addSubview:self.scrollViewOfWeek];
    [self.view addSubview:self.viewOfGray];
    [self.view addSubview:self.viewOfAddSchedule];
    
    [self.scrollViewOfWeek addSubview:self.viewOfWeek];
    [self.viewOfAddSchedule addSubview:self.viewOfFunction];

    
    
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    [self.scrollViewOfWeek setContentSize:CGSizeMake(0, self.viewOfWeek.frame.size.height)];
//    return self.viewOfWeek;
//}


- (void) doHandlePanAction:(UIPanGestureRecognizer *)sender{
    
    if(sender.view != selectView) return;
    CGPoint point = [sender translationInView:self.viewOfWeek];
    NSLog(@"X:%f;Y:%f",point.x,point.y);
    
    sender.view.center = CGPointMake(MIN(MAX(sender.view.center.x+point.x,25),300),  MIN(MAX(sender.view.center.y + point.y,25),440));
    NSLog(@"X:%f;Y:%f",sender.view.center.x+point.x,sender.view.center.y + point.y);
//    if(point.x>=45 ){
//        paramSender.view.center = CGPointMake((int)(paramSender.view.center.x+45)/45*45, paramSender.view.center.y);
//        [paramSender setTranslation:CGPointMake(0, 0) inView:self.viewOfWeek];
//
//    }
//    else if(point.x<=-45){
//        paramSender.view.center = CGPointMake((int)(paramSender.view.center.x-45)/45*45, paramSender.view.center.y);
//        [paramSender setTranslation:CGPointMake(0, 0) inView:self.viewOfWeek];
//
//
//    }
//    
//    else
        [sender setTranslation:CGPointMake(0, 0) inView:self.viewOfWeek];
    
    if(sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:Duration animations:^{
            sender.view.center = CGPointMake(((int)(sender.view.center.x+45/2)/45*45), sender.view.center.y);
        }];
    }

    
}

- (void)doubleTap:(UITapGestureRecognizer *)sender{
    if(sender.view == self.collectionViewOfMonth){
        NSLog(@"tttt");
    }
    else if(sender.view == self.viewOfWeek){
        CGPoint tapPoint = [sender locationInView:sender.view];
        NSLog(@"%lf %lf",tapPoint.x,tapPoint.y);

        self.testview = [[WeekScheduleView alloc] initWithFrame:CGRectMake(tapPoint.x-22.5, tapPoint.y-22.5, 45, 45)];
        self.testview.backgroundColor = [UIColor redColor];
        
        UILongPressGestureRecognizer *longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
        longTapRecognizer.minimumPressDuration = 0.25f;
        [self.testview addGestureRecognizer:longTapRecognizer];
        
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
        [self.testview addGestureRecognizer:panGestureRecognizer];
        
        [self.viewOfWeek addSubview:self.testview];
        
        [UIView animateWithDuration:Duration animations:^{
            self.viewOfAddSchedule.layer.opacity = 1;
            self.viewOfGray.hidden = NO;
        }];
        selectView = self.testview;
        [UIView animateWithDuration:Duration animations:^{
            
            //   sender.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
            selectView.alpha = 0.7;
        }];
        
    }
    else{
        NSLog(@"tt1");
    }
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    if(selectView != nil){
        if(sender.view!= selectView ){
            [UIView animateWithDuration:Duration animations:^{
    
        //        selectView.transform = CGAffineTransformIdentity;
                selectView.alpha = 1.0;
                
                selectView = nil;
            }];

        }
    }
    
}

- (void)longTap:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        if(selectView !=nil){
            [UIView animateWithDuration:Duration animations:^{
                selectView.transform = CGAffineTransformIdentity;
                selectView.alpha = 1.0;
                selectView = nil;
            }];
        }
        startPoint = [sender locationInView:sender.view];
        originPoint = sender.view.center;
        [UIView animateWithDuration:Duration animations:^{
            
         //   sender.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
            sender.view.alpha = 0.7;
        }];
        
        selectView = sender.view;
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
        if(sender.view == selectView){
        
            CGPoint newPoint = [sender locationInView:sender.view];
            CGFloat deltaX = newPoint.x-startPoint.x;
            CGFloat deltaY = newPoint.y-startPoint.y;
            sender.view.center = CGPointMake(MIN(MAX(sender.view.center.x+deltaX,25),300),  MIN(MAX(sender.view.center.y + deltaY,25),440));
        }
        //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
        if(selectView == sender.view){
            [UIView animateWithDuration:Duration animations:^{
                sender.view.center = CGPointMake(((int)(sender.view.center.x+45/2)/45*45), sender.view.center.y);
            }];
        }
    }

}

- (void)pinchTap:(UIPinchGestureRecognizer *)sender{
    sender.view.transform = CGAffineTransformScale(sender.view.transform, 1, sender.scale);
    sender.scale = 1;
    NSLog(@"%lf %lf",sender.view.frame.size.width,sender.view.frame.size.height);
    [self.scrollViewOfWeek setContentSize:sender.view.frame.size];
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc]init];//每个月份的数组
    self.calendarWeek = [[NSMutableArray alloc]init];//每个周的数组
    self.mutableDictionary = [[NSMutableDictionary alloc]init];
    self.selectedDate = [NSDate date];
    self.currentType = 0;
    
}



#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(collectionView == self.collectionViewOfMonth){
        return self.calendarMonth.count;
    }
    else if(collectionView == self.collectionViewOfWeek){
        return self.calendarWeek.count;
    }
    else{
        return 1;
    }
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.collectionViewOfMonth){
        NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:section];
        return monthArray.count;
    }
    else if(collectionView == self.collectionViewOfWeek){
        NSMutableArray *weekArray = [self.calendarWeek objectAtIndex:section];
        return weekArray.count;
    }
    else{
        return 1;
    }
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.collectionViewOfMonth){
        CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];

        
        NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
        
        CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
        
        cell.model = model;
        
        return cell;
    }
    else if(collectionView == self.collectionViewOfWeek){
        
        CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
        
        NSMutableArray *weekArray = [self.calendarWeek objectAtIndex:indexPath.section];
        
        CalendarDayModel *model = [weekArray objectAtIndex:indexPath.row];
        
        cell.model = model;
        
        return cell;

    }
    else{
        return nil;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if(collectionView == self.collectionViewOfMonth){
        if (kind == UICollectionElementKindSectionHeader){
            
            NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
            CalendarDayModel *model = [monthArray objectAtIndex:15];
            CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
            monthHeader.masterLabel.text = [NSString stringWithFormat:@"%02ld",model.month];//@"日期";
            monthHeader.subLabel.text = [NSString stringWithFormat:@"%ld",model.year];//@"日期";
            monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
            reusableview = monthHeader;
        }
        return reusableview;
    }
    else if(collectionView == self.collectionViewOfWeek){
        if (kind == UICollectionElementKindSectionHeader){
            
            NSMutableArray *weekArray = [self.calendarWeek objectAtIndex:indexPath.section];
            CalendarDayModel *model = [weekArray objectAtIndex:0];
            
      //      NSLog(@"click %li %li %li",model.year,model.month,model.day);
            CalendarWeekHeaderView *weekHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WeekHeader forIndexPath:indexPath];
            weekHeader.masterLabel.text = [NSString stringWithFormat:@"%02ld",model.month];//@"日期";
            weekHeader.subLabel.text = [NSString stringWithFormat:@"%ld",model.year];//@"日期";
            weekHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
            reusableview = weekHeader;
        }
        return reusableview;
    }
    else{
        return nil;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return false;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.collectionViewOfMonth){
        NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:indexPath.section];
        CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
       
        NSLog(@"click %li %li %li",model.year,model.month,model.day);

        if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick || model.style ==   CellDayTypePast) {
           
            [self.Logic selectLogic:model];
            
            self.selectedDate = [NSDate dateFromYear:model.year andMonth:model.month andDay:model.day];
            
        }
        
        
    }
    else if(collectionView == self.collectionViewOfWeek){
        
        NSMutableArray *weekArray = [self.calendarWeek objectAtIndex:indexPath.section];
        CalendarDayModel *model = [weekArray objectAtIndex:indexPath.row];
        
        NSLog(@"click %li %li %li",model.year,model.month,model.day);
        
        if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick || model.style ==   CellDayTypePast) {
            
            [self.Logic selectLogic:model];
            
            self.selectedDate = [NSDate dateFromYear:model.year andMonth:model.month andDay:model.day];
            
        }

    }
    [self.collectionViewOfMonth reloadData];
    [self.collectionViewOfWeek reloadData];
    [self.tableViewOfSchedule reloadData];
    [self.tableViewOfSchedule scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)goToDate:(NSDate *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
    [self.collectionViewOfMonth scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [self.collectionViewOfMonth setContentOffset:CGPointMake(0, self.collectionViewOfMonth.contentOffset.y-35)];
    
    NSInteger interval = [NSDate getDayNumbertoDay:[NSDate dateWithTimeInterval:3*secondsPerDay sinceDate:self.startDate] beforDay:date];
    interval = (interval / 7) * 8 ;
    
    [self.collectionViewOfWeek setContentOffset:CGPointMake(interval * 46, 0)];
}

- (void)selectDate:(NSDate *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
    int index = 0;
    for(CalendarDayModel *model in month_Array){
        if(model.day == [date YMDComponents].day){
            indexPath = [NSIndexPath indexPathForRow:index inSection:([date YMDComponents].year-self.currentInitYear)*12+[date YMDComponents].month-self.currentInitMonth];
            [self collectionView:self.collectionViewOfMonth didSelectItemAtIndexPath:indexPath];
            break;
        }
        index++;
    }
    
  //  indexPath = [NSIndexPath indexPathForRow:[NSDate getDayNumbertoDay:[NSDate dateWithTimeIntervalSince1970: -4*secondsPerDay] beforDay:date] inSection:0];
//    [self collectionView:self.collectionViewWeek didSelectItemAtIndexPath:indexPath];

    
}



- (void)changeToType:(NSInteger)type{
    if(type != self.currentType){
        if(type == 0){
            
            [UIView animateWithDuration:0.5f animations:^{
                CGRect rect = self.collectionViewOfMonth.frame;
                [self.collectionViewOfMonth setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 334)];
                self.collectionViewOfMonth.layer.opacity = 1;
                self.labelOfMonth.layer.opacity = 1;
                self.labelOfWeek.layer.opacity = 0;
                self.tableViewOfSchedule.layer.opacity = 1;
                self.scrollViewOfWeek.layer.opacity = 0;
                self.viewOfWeek.layer.opacity = 0;
            }];
           
        }
        else if(type == 1){
            [UIView animateWithDuration:0.5f animations:^{
                CGRect rect = self.collectionViewOfMonth.frame;
                [self.collectionViewOfMonth setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 50)];
                self.collectionViewOfMonth.layer.opacity = 0;
                self.labelOfMonth.layer.opacity = 0;
                self.labelOfWeek.layer.opacity = 1;
                self.tableViewOfSchedule.layer.opacity = 0;
                self.scrollViewOfWeek.layer.opacity = 1;
                self.viewOfWeek.layer.opacity = 1;
            }];
       }
        self.currentType = type;
        [self goToDate:self.selectedDate];
    }
}


- (IBAction)ActionOfTest:(id)sender {
    static int i = 0;
    [self goToDate:[NSDate dateWithTimeIntervalSinceNow:secondsPerDay*i]];
    [self selectDate:[NSDate dateWithTimeIntervalSinceNow:secondsPerDay*i]];

}
- (IBAction)actionOfChangeType:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            [self changeToType:0];
            break;
        case 1:
            [self changeToType:1];
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)transformFromMonthToWeek{
    self.calendarWeek = [[NSMutableArray alloc] init];
    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    NSInteger firstFlag = 1;
    for(NSMutableArray *monthArray in self.calendarMonth){
        for(CalendarDayModel *model in monthArray){
            if(model.style!=CellDayTypeEmpty){
                if(firstFlag == 1){
                    if(model.week !=7) continue;
                    else {
                        firstFlag = 0;
                        continue;
                    }
                }
                [weekArray addObject:model];
                if([weekArray count] == 7){
                    [self.calendarWeek addObject:weekArray];
                    weekArray = [[NSMutableArray alloc] init];
                }
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableViewOfSchedule){
        return 10;
    }
    else{
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableViewOfSchedule){
        UITableViewCell *cell = cell = [[UITableViewCell alloc]
                                        initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"Schedule"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text=[NSString stringWithFormat:@"%li %li %li",[self.selectedDate YMDComponents].year,[self.selectedDate YMDComponents].month,[self.selectedDate YMDComponents].day];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        return cell;


    }
    else{
        return nil;
    }
}

- (IBAction)actionOfSetFunction:(id)sender {
    if(self.viewOfFunction.layer.opacity == 1){
        self.viewOfFunction.layer.opacity = 0;
    }
    else{
        self.viewOfFunction.layer.opacity = 1;
    }
}
- (IBAction)actionOfCloseView:(id)sender {
    self.viewOfAddSchedule.layer.opacity = 0;
    self.viewOfGray.hidden = YES;
    [selectView removeFromSuperview];
    selectView = nil;
}

- (IBAction)actionOfOKView:(id)sender {
    self.viewOfAddSchedule.layer.opacity = 0;
    self.viewOfGray.hidden = YES;

}
@end

//
//  ViewController.m
//  yoko
//
//  Created by BlueSun on 15/7/28.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
    NSLog(@"%f",bounds.size.height);
    NSLog(@"%f",bounds.size.width);
    
    self.myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.myDate = [self.myCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    NSLog(@"%li",self.myDate.weekOfYear);
    
    
    [self.ScrollView setFrame:bounds];
    for(int i=0;i<300;i++){
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addButton setFrame:CGRectMake(0,50+i*bounds.size.height,50,50)];
        [addButton setBackgroundColor:[UIColor blueColor]];
        [addButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        addButton.titleLabel.textColor = [UIColor blackColor];
        addButton.showsTouchWhenHighlighted = true;
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTag:i];
        [self.ScrollView addSubview:addButton];
    }
    [self.ScrollView setContentSize:CGSizeMake(bounds.size.width, bounds.size.height*1200)];
    [self.ScrollView setContentOffset:CGPointMake(0, bounds.size.height*150) animated:NO];

}

- (void)addButtonClick:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  //  NSLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > 1200){
      //  [self.ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    }
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"top");
}

@end

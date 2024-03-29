//
//  CalendarDayCell.m
//  yoko
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//


#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    imgview.image = [UIImage imageNamed:@"chack.png"];
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -3, self.bounds.size.width, self.bounds.size.height)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:17];
    [self addSubview:day_lab];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0 , 11, self.bounds.size.width, self.bounds.size.height)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    

}


- (void)setModel:(CalendarDayModel *)model
{


    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
            
        case CellDayTypePast://过去的日期
//            [self hidden_NO];
//            
//            if (model.holiday) {
//                day_lab.text = model.holiday;
//            }else{
//                day_lab.text = [NSString stringWithFormat:@"%ld",model.day];
//            }
//            
//           // day_lab.textColor = [UIColor lightGrayColor];
//            day_lab.textColor = [UIColor blackColor];
//            day_title.text = model.Chinese_calendar;
//            imgview.hidden = YES;
//            break;
//            
        case CellDayTypeFutur://将来的日期
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%ld",model.day];
             //   day_lab.textColor = COLOR_THEME;
                day_lab.textColor = [UIColor blackColor];
            }
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
//        case CellDayTypeWeek://周末
//            [self hidden_NO];
//            
//            if (model.holiday) {
//                day_lab.text = model.holiday;
//                day_lab.textColor = [UIColor orangeColor];
//            }else{
//                day_lab.text = [NSString stringWithFormat:@"%ld",model.day];
//             //   day_lab.textColor = COLOR_THEME1;
//                day_lab.textColor = [UIColor blackColor];
//            }
//            
//            day_title.text = model.Chinese_calendar;
//            imgview.hidden = YES;
//            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%ld",model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = NO;
            
            break;
            
        default:
            
            break;
    }


}



- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}

-(NSString *)getDay_lab{
    return day_lab.text;
}


@end

//
//  CalendarCollectionViewCell.m
//  yoko
//
//  Created by BlueSun on 15/8/6.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "CalendarCollectionViewCell.h"

@implementation CalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.LabelOfDay = [[UILabel alloc] initWithFrame:CGRectMake(-3, 5, 42, 21)];
        self.LabelOfDay.textColor = [UIColor blackColor];
        self.LabelOfDay.font = [UIFont systemFontOfSize:17];
        self.LabelOfDay.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.LabelOfDay];
        
        self.LabelOfLunar = [[UILabel alloc] initWithFrame:CGRectMake(-4, 17, 42, 21)];
        self.LabelOfLunar.textColor = [UIColor blackColor];
        self.LabelOfLunar.font = [UIFont systemFontOfSize:9];
        self.LabelOfLunar.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.LabelOfLunar];


    }
    return self;
}

@end

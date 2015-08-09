//
//  CalendarWeekCollectionViewLayout.m
//  yoko
//
//  Created by BlueSun on 15/8/8.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "CalendarWeekCollectionViewLayout.h"

@implementation CalendarWeekCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerReferenceSize = CGSizeMake(46.0f, 50.0f);//头部视图的框架大小
        
        self.itemSize = CGSizeMake(46, 50);//每个cell的大小
        
        self.minimumLineSpacing = 0;//每行的最小间距
        
        self.minimumInteritemSpacing = 0;//每列的最小间距
        
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//网格视图的/上/左/下/右,的边距
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

@end

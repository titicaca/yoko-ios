//
//  NewTagCollectionViewCell.m
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "NewTagCollectionViewCell.h"

@implementation NewTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
  
    self = [super initWithFrame:frame];
    if(self){
        self.LabelOfName = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 40, 30)];
        self.LabelOfName.textColor = [UIColor yellowColor];
        self.LabelOfName.font = [UIFont systemFontOfSize:13];
        self.LabelOfName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.LabelOfName];
        
        self.ImageViewOfPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 50, 50)];
        [self addSubview:self.ImageViewOfPhoto];
        
        self.ButtonOfDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, -7, 30, 30)];
        [self.ButtonOfDelete setTitle:@"删除" forState:UIControlStateNormal];
        self.ButtonOfDelete.backgroundColor = [UIColor clearColor];
        self.ButtonOfDelete.titleLabel.textColor = [UIColor redColor];
        self.ButtonOfDelete.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.ButtonOfDelete.hidden = YES;
        self.ButtonOfDelete.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.ButtonOfDelete];
        
    }
    return self;
}



@end


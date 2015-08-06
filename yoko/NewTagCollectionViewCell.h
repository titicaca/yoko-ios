//
//  NewTagCollectionViewCell.h
//  yoko
//
//  Created by BlueSun on 15/8/2.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTagCollectionViewCell : UICollectionViewCell<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewOfPhoto;
@property (strong, nonatomic) IBOutlet UILabel *LabelOfName;
@property (strong, nonatomic) IBOutlet UIButton *ButtonOfDelete;

@end

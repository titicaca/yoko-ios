//
//  TableFriendTag.h
//  yoko
//
//  Created by BlueSun on 15/8/23.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableFriendTag : NSObject

+ (void)createTable;
+ (void)insertFriendTagRecords:(NSArray *)friendAndTagArray;
+ (NSMutableArray *)getTagArray;
+ (NSMutableArray *)getFriendArrayByTagId:(long)tagId;

@end

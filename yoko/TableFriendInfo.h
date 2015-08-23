//
//  TableFriendInfo.h
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfoRecord.h"

@interface TableFriendInfo : NSObject

+ (void)createTable;
+ (void)createUniqueIndex;
+ (void)insertRecord:(FriendInfoRecord *)friendInfoRecord;
+ (void)insertFriendInfoRecords:(NSArray *)friendAndTagArray;
+ (NSMutableArray *)getFriendInfoRecords;
@end

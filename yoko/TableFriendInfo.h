//
//  TableFriendInfo.h
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfoRecord.h"
#import "UserServer.h"
#import "TableFriendTag.h"

@interface TableFriendInfo : NSObject

+ (void)createTable;
+ (void)createUniqueIndex;
+ (void)insertRecord:(FriendInfoRecord *)friendInfoRecord;
+ (void)synFriendInfoRecords:(NSArray *)friendAndTagArray;
+ (NSMutableArray *)getFriendInfoRecords;
+ (FriendInfoRecord *)getFriendInfoByFriendId:(long)friendId;
+ (void)deleteFriendInfoRecordsByFriendId:(long)friendId;
@end

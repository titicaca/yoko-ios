//
//  TableFriendTag.h
//  yoko
//
//  Created by BlueSun on 15/8/23.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendTagRecord.h"
#import "UserServer.h"

@interface TableFriendTag : NSObject

+ (void)createTable;
+ (void)synFriendTagRecords:(NSArray *)friendAndTagArray;
+ (NSMutableArray *)getTagArray;
+ (NSMutableArray *)getFriendArrayByTagId:(long)tagId;
+ (NSString *)getTagNameByTagId:(long)tagId;
+ (void)insertFriendTagRecords:(NSArray *)friendTagArray;
+ (void)deleteFriendTagRecordsByTagId:(long)tagId;
+ (void)deleteFriendTagRecordsByFriendId:(long)friendId;
+ (void)updateFriendTagRecordsWithTagId:(long)tagId andFriendTagArray:(NSArray *)friendTagArray;
@end

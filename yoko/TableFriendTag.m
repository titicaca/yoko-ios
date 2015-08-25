//
//  TableFriendTag.m
//  yoko
//
//  Created by BlueSun on 15/8/23.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "TableFriendTag.h"
#import "DataConnection.h"
#import "DBConstants.h"

@implementation TableFriendTag

+ (void)createTable
{
    [DataConnection sharedDataBase];
    NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %s(%s INTEGER PRIMARY KEY AUTOINCREMENT, %s INT8, %s INT8, %s INT8, %s CHAR(255));",TABLE_FRIEND_TAG,COLUMN_FRIEND_TAG_RID,COLUMN_FRIEND_TAG_UID,COLUMN_FRIEND_TAG_FUID,COLUMN_FRIEND_TAG_TAGID,COLUMN_FRIEND_TAG_TAGNAME];
    [DataConnection execDataBase:createTable];
    [[self class] createUniqueIndex];
}

+ (void)createUniqueIndex{
    NSString *createUniqueIndex = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS %s_unique_index ON %s (%s, %s, %s)",TABLE_FRIEND_TAG,TABLE_FRIEND_TAG,COLUMN_FRIEND_TAG_UID,COLUMN_FRIEND_TAG_FUID,COLUMN_FRIEND_TAG_TAGID];
    [DataConnection execDataBase:createUniqueIndex];
}

+ (void)synFriendTagRecords:(NSArray *)friendAndTagArray{
    long uid = [UserServer getUserID];
    [DataConnection beginTransaction];
    
    DataStatement *stmt = nil;
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM %s WHERE uid = %ld",TABLE_FRIEND_TAG, uid];
    const char *cString  = [deleteString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    [stmt step];
    [stmt reset];
    [stmt finaliz];
    NSString *insertString = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %s VALUES(NULL,?,?,?,?)",TABLE_FRIEND_TAG];
    cString = [insertString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    for(NSDictionary *friendAndTag in friendAndTagArray){
        NSDictionary *friendInfo = [friendAndTag objectForKey:@"friend"];
        NSArray *friendTags = [friendAndTag objectForKey:@"tags"];
        for(NSDictionary *tagInfo in friendTags){
            [stmt bindInt64:uid forIndex:1];
            [stmt bindInt64:[[friendInfo objectForKey:@"id"] longValue] forIndex:2];
            [stmt bindInt64:[[tagInfo objectForKey:@"id"] longValue] forIndex:3];
            [stmt bindString:[tagInfo objectForKey:@"tagname"] forIndex:4];
            
            [stmt step];
            [stmt reset];
        }
    }
    [stmt finaliz];
    [DataConnection commitTransaction];
}

+ (NSMutableArray *)getTagArray{
    
    NSMutableArray *tagArray = [[NSMutableArray alloc] init];
    
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld AND fuid = %ld ORDER BY %s ASC ",TABLE_FRIEND_TAG, [UserServer getUserID], 0l, COLUMN_FRIEND_TAG_TAGID];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    
    while([stmt step] == SQLITE_ROW){
        FriendTagRecord *friendTagRecord = [[FriendTagRecord alloc] initWithUid:[stmt getInt64:1] andFuid:[stmt getInt64:2] andTagId:[stmt getInt64:3] andTagName:[stmt getString:4]];
        [tagArray addObject:friendTagRecord];
                                        
    }
    [stmt reset];
    [stmt finaliz];
    
    return tagArray;
}

+ (NSMutableArray *)getFriendArrayByTagId:(long)tagId{
    
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld AND fuid <> 0 AND tagId = %ld ORDER BY %s ASC ",TABLE_FRIEND_TAG, [UserServer getUserID], tagId, COLUMN_FRIEND_TAG_TAGID];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    while([stmt step] == SQLITE_ROW){
        FriendTagRecord *friendTagRecord = [[FriendTagRecord alloc] initWithUid:[stmt getInt64:1] andFuid:[stmt getInt64:2] andTagId:[stmt getInt64:3] andTagName:[stmt getString:4]];
        [friendArray addObject:friendTagRecord];
    }
    [stmt reset];
    [stmt finaliz];
    
    return friendArray;
}

+ (NSString *)getTagNameByTagId:(long)tagId{
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld AND tagId = %ld LIMIT 1",TABLE_FRIEND_TAG, [UserServer getUserID], tagId];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    if([stmt step] == SQLITE_ROW){
        return [stmt getString:4];
    }
    return NULL;
    
}

+ (void)insertFriendTagRecords:(NSArray *)friendTagArray{
    long uid = [UserServer getUserID];
    [DataConnection beginTransaction];
    
    DataStatement *stmt = nil;
    NSString *insertString = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %s VALUES(NULL,?,?,?,?)",TABLE_FRIEND_TAG];
    const char *cString = [insertString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    for(FriendTagRecord *friendTagRecord in friendTagArray){
        [stmt bindInt64:uid forIndex:1];
        [stmt bindInt64:friendTagRecord.fuid forIndex:2];
        [stmt bindInt64:friendTagRecord.tagId forIndex:3];
        [stmt bindString:friendTagRecord.tagName forIndex:4];
        
        [stmt step];
        [stmt reset];
    }
    [stmt finaliz];
    [DataConnection commitTransaction];
}

+ (void)deleteFriendTagRecordsByTagId:(long)tagId{
    
    DataStatement *stmt = nil;
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM %s WHERE uid = %ld AND tagId = %ld",TABLE_FRIEND_TAG, [UserServer getUserID],tagId];
    const char *cString  = [deleteString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    [stmt step];
}

+ (void)updateFriendTagRecordsWithTagId:(long)tagId andFriendTagArray:(NSArray *)friendTagArray{
    [[self class] deleteFriendTagRecordsByTagId:tagId];
    [[self class] insertFriendTagRecords:friendTagArray];
}



+ (void)deleteFriendTagRecordsByFriendId:(long)friendId{
    
    DataStatement *stmt = nil;
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM %s WHERE uid = %ld AND fuid = %ld",TABLE_FRIEND_TAG, [UserServer getUserID],friendId];
    const char *cString  = [deleteString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    [stmt step];
}




@end

//
//  TableFriendTag.m
//  yoko
//
//  Created by BlueSun on 15/8/23.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "TableFriendTag.h"
#import "FriendTagRecord.h"
#import "DataConnection.h"
#import "DBConstants.h"
#import "UserServer.h"

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

+ (void)insertFriendTagRecords:(NSArray *)friendAndTagArray{
    
    [DataConnection beginTransaction];
    
    DataStatement *stmt = nil;
    NSString *sqlString = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %s VALUES(NULL,?,?,?,?)",TABLE_FRIEND_TAG];
    const char *cString    = [sqlString cStringUsingEncoding:NSUTF8StringEncoding];
    
    stmt = [DataConnection statementWithQuery:cString];
    NSLog(@"%@",stmt);
    
    long uid = [UserServer getUserID];
    
    for(NSDictionary *friendAndTag in friendAndTagArray){
        NSDictionary *friendInfo = [friendAndTag objectForKey:@"friend"];
        NSArray *friendTags = [friendAndTag objectForKey:@"tags"];
        for(NSDictionary *tagInfo in friendTags){
            [stmt bindInt64:uid forIndex:1];
            [stmt bindInt64:[[friendInfo objectForKey:@"id"] longValue] forIndex:2];
            [stmt bindInt64:[[tagInfo objectForKey:@"id"] longValue] forIndex:3];
            [stmt bindString:[tagInfo objectForKey:@"tagname"] forIndex:4];
            
            if (SQLITE_DONE != [stmt step]) {
            }
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
        [tagArray addObject:[stmt getString:4]];
    }
    [stmt reset];
    [stmt finaliz];
    
    NSLog(@"%@",tagArray);
    
    return tagArray;
}

+ (NSMutableArray *)getFriendArrayByTagId:(long)tagId{
    
    NSMutableArray *friendArray = [[NSMutableArray alloc] init];
    
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld AND fuid <> 0 AND tagId = %ld ORDER BY %s ASC ",TABLE_FRIEND_TAG, [UserServer getUserID], tagId, COLUMN_FRIEND_TAG_TAGID];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    while([stmt step] == SQLITE_ROW){
        [friendArray addObject:[NSNumber numberWithLongLong:[stmt getInt64:2]]];
    }
    
    [stmt reset];
    [stmt finaliz];
    
    NSLog(@"%@",friendArray);
    
    return friendArray;

}



@end

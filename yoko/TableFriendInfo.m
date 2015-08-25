//
//  TableFriendInfo.m
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "TableFriendInfo.h"
#import "FriendInfoRecord.h"
#import "DataConnection.h"
#import "DBConstants.h"


@implementation TableFriendInfo

+ (void)createTable
{
    [DataConnection sharedDataBase];
    NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %s(%s INTEGER PRIMARY KEY AUTOINCREMENT, %s INT8, %s INT8, %s CHAR(255), %s CHAR(255), %s CHAR(15), %s CHAR(255), %s CHAR(255), %s CHAR(15), %s INT1, %s CHAR(255), %s CHAR(255), %s INTEGER, %s INTETGER, %s INTETGER, %s INT8 );",TABLE_FRIEND_INFO,COLUMN_FRIEND_INFO_RID,COLUMN_FRIEND_INFO_UID,COLUMN_FRIEND_INFO_FUID,COLUMN_FRIEND_INFO_EMAIL,COLUMN_FRIEND_INFO_LOCATION,COLUMN_FRIEND_INFO_MOBILE,COLUMN_FRIEND_INFO_NICKNAME,COLUMN_FRIEND_INFO_PICTURELINK,COLUMN_FRIEND_INFO_QQ,COLUMN_FRIEND_INFO_SEX,COLUMN_FRIEND_INFO_WECHAT,COLUMN_FRIEND_INFO_WEIBO,COLUMN_FRIEND_INFO_COLLECTNUMBER,COLUMN_FRIEND_INFO_ENROLLNUMBER,COLUMN_FRIEND_INFO_FRIENDNUMBER,COLUMN_FRIEND_INFO_LOGINTIME];
    [DataConnection execDataBase:createTable];
    [[self class] createUniqueIndex];
}

+ (void)createUniqueIndex{
    NSString *createUniqueIndex = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS %s_unique_index ON %s (%s, %s)",TABLE_FRIEND_INFO,TABLE_FRIEND_INFO,COLUMN_FRIEND_INFO_UID,COLUMN_FRIEND_TAG_FUID];
    [DataConnection execDataBase:createUniqueIndex];
}

+ (void)insertRecord:(FriendInfoRecord *)friendInfoRecord{
    DataStatement *stmt = nil;
    NSString *sqlString = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %s VALUES(NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_FRIEND_INFO];
    const char *cString    = [sqlString cStringUsingEncoding:NSUTF8StringEncoding];
    
    stmt = [DataConnection statementWithQuery:cString];
    NSLog(@"%@",stmt);
    [stmt bindInt64:friendInfoRecord.uid forIndex:1];
    [stmt bindInt64:friendInfoRecord.fuid forIndex:2];
    [stmt bindString:friendInfoRecord.email forIndex:3];
    [stmt bindString:friendInfoRecord.location forIndex:4];
    [stmt bindString:friendInfoRecord.mobile forIndex:5];
    [stmt bindString:friendInfoRecord.nickname forIndex:6];
    [stmt bindString:friendInfoRecord.picturelink forIndex:7];
    [stmt bindString:friendInfoRecord.qq forIndex:8];
    [stmt bindInt32:friendInfoRecord.sex forIndex:9];
    [stmt bindString:friendInfoRecord.wechat forIndex:10];
    [stmt bindString:friendInfoRecord.weibo forIndex:11];
    [stmt bindInt32:friendInfoRecord.collectnumber forIndex:12];
    [stmt bindInt32:friendInfoRecord.enrollnumber forIndex:13];
    [stmt bindInt32:friendInfoRecord.friendnumber forIndex:14];
    [stmt bindInt64:friendInfoRecord.logintime forIndex:15];
    
    if (SQLITE_DONE != [stmt step]) {
        [stmt reset];
 //       return nil;
    }
}

+ (void)synFriendInfoRecords:(NSArray *)friendAndTagArray{
    long uid = [UserServer getUserID];
    
    [DataConnection beginTransaction];
    
    DataStatement *stmt = nil;
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM %s WHERE uid = %ld",TABLE_FRIEND_INFO, uid];
    const char *cString  = [deleteString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    [stmt step];
    [stmt reset];
    [stmt finaliz];
    
    NSString *insertString = [NSString stringWithFormat:@"INSERT OR IGNORE INTO %s VALUES(NULL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_FRIEND_INFO];
    cString    = [insertString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    for(NSDictionary *friendAndTag in friendAndTagArray){
        NSDictionary *friendInfo = [friendAndTag objectForKey:@"friend"];
        if([[friendInfo objectForKey:@"id"] longValue] == 0l) continue;
        [stmt bindInt64:uid forIndex:1];
        [stmt bindInt64:[[friendInfo objectForKey:@"id"] longValue] forIndex:2];
        [stmt bindString:[friendInfo objectForKey:@"email"] forIndex:3];
        [stmt bindString:[friendInfo objectForKey:@"location"] forIndex:4];
        [stmt bindString:[friendInfo objectForKey:@"mobile"] forIndex:5];
        [stmt bindString:[friendInfo objectForKey:@"nickname"] forIndex:6];
        [stmt bindString:[friendInfo objectForKey:@"picturelink"] forIndex:7];
        [stmt bindString:[friendInfo objectForKey:@"qq"] forIndex:8];
        [stmt bindInt32:[[friendInfo objectForKey:@"sex"] intValue] forIndex:9];
        [stmt bindString:[friendInfo objectForKey:@"wechat"] forIndex:10];
        [stmt bindString:[friendInfo objectForKey:@"weibo"] forIndex:11];
        [stmt bindInt32:[[friendInfo objectForKey:@"collectnumber"] intValue] forIndex:12];
        [stmt bindInt32:[[friendInfo objectForKey:@"enrollnumber"] intValue] forIndex:13];
        [stmt bindInt32:[[friendInfo objectForKey:@"friendnumber"] intValue] forIndex:14];
        [stmt bindInt64:[[friendInfo objectForKey:@"logintime"] longValue] forIndex:15];
        
        [stmt step];
        [stmt reset];
    }
    [stmt finaliz];
    [DataConnection commitTransaction];
}

+ (NSMutableArray *)getFriendInfoRecords{
    NSMutableArray *friendInfoRecords = [[NSMutableArray alloc] init];
    
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld ORDER BY %s DESC ",TABLE_FRIEND_INFO, [UserServer getUserID], COLUMN_FRIEND_INFO_LOGINTIME];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    
    while([stmt step] == SQLITE_ROW){
        FriendInfoRecord *friendInfoRecord = [[FriendInfoRecord alloc] initWithFuid:[stmt getInt64:2] andNickname:[stmt getString:6] andPicturelink:[stmt getString:7] andLogintime:[stmt getInt64:15]];
        [friendInfoRecords addObject:friendInfoRecord];
    }
    [stmt reset];
    [stmt finaliz];
    
    
    return friendInfoRecords;
}

+ (FriendInfoRecord *)getFriendInfoByFriendId:(long)friendId{
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"SELECT * FROM %s WHERE uid = %ld AND fuid = %ld",TABLE_FRIEND_INFO, [UserServer getUserID], friendId];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    
    if([stmt step] == SQLITE_ROW){
        FriendInfoRecord *friendInfoRecord = [[FriendInfoRecord alloc] initWithFuid:[stmt getInt64:2] andNickname:[stmt getString:6] andPicturelink:[stmt getString:7] andLogintime:[stmt getInt64:15]];
        [stmt reset];
        [stmt finaliz];
        
        return friendInfoRecord;
    }
    else{
        return NULL;
    }
    

}

+ (void)deleteFriendInfoRecordsByFriendId:(long)friendId{
    
    DataStatement *stmt = nil;
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM %s WHERE uid = %ld AND fuid = %ld",TABLE_FRIEND_INFO, [UserServer getUserID],friendId];
    const char *cString  = [deleteString cStringUsingEncoding:NSUTF8StringEncoding];
    stmt = [DataConnection statementWithQuery:cString];
    [stmt step];
    
    [TableFriendTag deleteFriendTagRecordsByFriendId:friendId];
}

@end

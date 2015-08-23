//
//  SqliteManager.h
//  yoko
//
//  Created by BlueSun on 15/8/5.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SqliteManager : NSObject
{
    sqlite3 *db;
}

+ (SqliteManager *)dbManager;
- (int)insertFriendDataWithFriendId:(int)friend_id andTagId:(int)tag_id andTagname:(char *)tagname;
@end

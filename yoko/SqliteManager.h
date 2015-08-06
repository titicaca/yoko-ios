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
@property(retain, nonatomic) NSString *filename;

+ (SqliteManager *)dbManager;
- (void)createTable;
- (void)insertSql:(const char *)sql;
@end

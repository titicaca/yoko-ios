//
//  SqliteManager.m
//  yoko
//
//  Created by BlueSun on 15/8/5.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "SqliteManager.h"

@implementation SqliteManager

+(SqliteManager *) dbManager
{
    
    static SqliteManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbManager = [[self alloc] initWithDatabaseName:@"yoko"];
    });
    
    return dbManager;
}

- (id)initWithDatabaseName:(NSString *)databaseName{
    if([super init]){
        [self createDatabase:databaseName];
    }
    return self;
}

- (void)createDatabase:(NSString *)databaseName{
    NSString *allDatabaseName=[NSString stringWithFormat:@"%@.sqlite",databaseName];
    self.filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:allDatabaseName];
    NSLog(@"%@",self.filename);
}

- (void)createTable{

    int result = sqlite3_open(self.filename.UTF8String, &db);
    if (result == SQLITE_OK) {
        NSLog(@"成功打开");
        //3.创表
        const char *sql = "create TABLE if not EXISTS t_friend (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id int8, friend_id int8, tag_id int8, tagname char(30));";
        char *errorMesg = NULL;
        int result = sqlite3_exec(db, sql, NULL,NULL, &errorMesg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创建表XXX");
        }else{
            NSLog(@"创表失败：%s",errorMesg);
        }
        
    }else{
        NSLog(@"打开数据库失败");
    }
}

- (void)insertSql:(const char *)sql{
  //  const char *sql = "insert into t_student (name, age) values('jack', 20);";
    char *errorMesg = NULL;
    int result = sqlite3_exec(db,sql,NULL, NULL, &errorMesg);
    if (result == SQLITE_OK) {
        NSLog(@"成功添加数据");
    }else {
        NSLog(@"添加数据失败:%s",errorMesg);
    }

}

@end

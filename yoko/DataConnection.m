//
//  DatabaseConnection.m
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "DataConnection.h"

#define DATABASENAME @"yoko.sqlite"

static sqlite3 *dataBaseInstance = nil;
@implementation DataConnection

+ (void)execDataBase:(NSString*)sqlString{
    char *errorMsg;
    if (sqlite3_exec(dataBaseInstance, [sqlString UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
        NSAssert1(0, @"can not exec %@'.",sqlString);
    }
}

+ (sqlite3*)openDataBase:(NSString*)dataBaseName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [array objectAtIndex:0];
    NSString * databasePath = [path stringByAppendingPathComponent:dataBaseName];
    NSLog(@"%s",databasePath.UTF8String);
    if (sqlite3_open([databasePath UTF8String], &dataBaseInstance)!=SQLITE_OK){
        NSLog(@"can not open the database:%s",sqlite3_errmsg(dataBaseInstance));
        sqlite3_close(dataBaseInstance);
        return nil;
    }
    return dataBaseInstance;
}

+(sqlite3*)sharedDataBase{
    if (nil == dataBaseInstance) {
        @synchronized(self)
        {
            dataBaseInstance = [self openDataBase:DATABASENAME];
            
        }
    }
    return dataBaseInstance;
}

+(int)commitTransaction{
    char *errMessage;
    return sqlite3_exec(dataBaseInstance, "COMMIT", nil, nil, &errMessage);
}

+(int)beginTransaction{
    char *errMessage;
    return sqlite3_exec(dataBaseInstance, "BEGIN", nil, nil, &errMessage);
}

+(DataStatement *)statementWithQuery:(const char*)sql{
    [self sharedDataBase];
    DataStatement *dataStatement = [DataStatement statementWithDB:dataBaseInstance withQuery:sql];
    return dataStatement;
}


+(void)closeDataBase{
    sqlite3_close(dataBaseInstance);
    dataBaseInstance = nil;                  //数据库句柄一定要置空，不然重新建立连接的时候会有问题
}

+(void)alert{
    NSString *errorString = [NSString stringWithUTF8String:sqlite3_errmsg(dataBaseInstance)];
    NSLog(@"alert message:%@",errorString);
}

@end

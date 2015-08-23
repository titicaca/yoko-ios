//
//  DatabaseCenter.m
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "DatabaseCenter.h"
#import "DataConnection.h"

@implementation DatabaseCenter
+(void)createTable
{
    [DataConnection sharedDataBase];
    NSString *createTable   = @"create table if not exists user(userId integer primary key,name text not null,password text not null,flag integer not null);";
    [DataConnection execDataBase:createTable];
}

+ (id)getLastLoginUser
{
    static DataStatement *stmt = nil;
    if (!stmt)
    {
        stmt = [DataConnection statementWithQuery:"select * from user where flag = 1"];
    }
    if (SQLITE_ROW != [stmt step]) {
        [stmt reset];
        return nil;
    }
    NSString *userName = [stmt getString:1];
    NSString *password = [stmt getString:2];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"name",password,@"password", nil];
    return dic;
}

//根据用户名获取用户的数据
+ (id)getUserWithName:(NSString *)name
{
    DataStatement *stmt = nil;
    NSString *selectString = [NSString stringWithFormat:@"select * from user where name = %@",name];
    const char *cString    = [selectString cStringUsingEncoding:NSUTF8StringEncoding];
    if (!stmt)
    {
        stmt = [DataConnection statementWithQuery:cString];
    }
    if (SQLITE_ROW != [stmt step]) {
        [stmt reset];
        return nil;
    }
    NSString *userName = [stmt getString:1];
    NSString *password = [stmt getString:2];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"name",password,@"password", nil];
    return dic;
    
}

@end

//
//  DatabaseConnection.h
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DataStatement.h"

@interface DataConnection : NSObject

+ (void)execDataBase:(NSString*)createString;
+ (sqlite3*)sharedDataBase;      //访问单例
+ (void)closeDataBase;              //关闭数据库连接，置空句柄
+ (int)beginTransaction;          //开始事务
+ (int)commitTransaction;      //提交事务
+ (DataStatement*)statementWithQuery:(const char*)sql; //初始化一个连接
+ (void)alert; //提出警告
//+ (int)getRowsWithQury:(const char*)sql;  //获取select语句中结果数据的行数

@end

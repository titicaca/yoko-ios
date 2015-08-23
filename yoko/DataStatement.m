//
//  DataStatement.m
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "DataStatement.h"

@implementation DataStatement

-(id)initWithDB:(sqlite3 *)db withQuery:(const char *)sql{
    self = [super init];
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL)!=SQLITE_OK) {
        NSAssert2(0, @"can not compare '%s',(%s)", sql, sqlite3_errmsg(db));
    }
    return self;
}


+(id)statementWithDB:(sqlite3 *)DB withQuery:(const char *)sql{
    return [[DataStatement alloc]initWithDB:DB withQuery:sql];
}

-(int)step{
    return  sqlite3_step(stmt);
}

-(void)reset{
    sqlite3_reset(stmt);
}

- (void)finaliz{
    sqlite3_finalize(stmt);
}

- (int)getResultCount{
    return  sqlite3_column_count(stmt);
}

-(NSString*)getString:(int)index{
    if (NULL != (char*)sqlite3_column_text(stmt, index)) {
        return [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, index)];
    }
    else
        return nil;
}

-(int)getInt32:(int)index{
    return sqlite3_column_int(stmt, index);
}

-(long)getInt64:(int)index{
    return sqlite3_column_int64(stmt, index);
}

-(NSData*)getData:(int)index{
    int length =  sqlite3_column_bytes(stmt, index);
    return [NSData dataWithBytes:sqlite3_column_blob(stmt, index) length:length];
}

-(double)getDouble:(int)index{
    return sqlite3_column_double(stmt, index);
}

-(void)bindData:(NSData *)data forIndex:(int)index{
    sqlite3_bind_blob(stmt, index, data.bytes, (int)data.length, SQLITE_TRANSIENT);
}

-(void)bindString:(NSString *)value forIndex:(int)index{
    sqlite3_bind_text(stmt, index,[value UTF8String] , -1, SQLITE_TRANSIENT);
}

-(void)bindInt32:(int)value forIndex:(int)index{
    sqlite3_bind_int(stmt, index,value);
}

-(void)bindInt64:(long)value forIndex:(int)index{
    sqlite3_bind_int64(stmt, index, value);
}

-(void)bindDouble:(double)value forIndex:(int)index{
    sqlite3_bind_double(stmt, index, value);
}

@end

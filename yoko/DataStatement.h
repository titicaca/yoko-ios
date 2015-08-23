//
//  DataStatement.h
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DataStatement : NSObject
{
    sqlite3_stmt* stmt;
}
+(id)statementWithDB:(sqlite3*)DB withQuery:(const char *)sql;
-(id)initWithDB:(sqlite3*)db withQuery:(const char *)sql;
// method
- (int)step;
- (void)reset;
- (void)finaliz;
- (int)getResultCount;

// Getter
- (NSString*)getString:(int)index;
- (int)getInt32:(int)index;
- (long)getInt64:(int)index;
- (NSData*)getData:(int)index;
- (double)getDouble:(int)index;

// Binder
- (void)bindString:(NSString*)value forIndex:(int)index;
- (void)bindInt32:(int)value forIndex:(int)index;
- (void)bindInt64:(long)value forIndex:(int)index;
- (void)bindData:(NSData*)data forIndex:(int)index;
- (void)bindDouble:(double)value forIndex:(int)index;

@end

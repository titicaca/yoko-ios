//
//  DatabaseCenter.h
//  yoko
//
//  Created by BlueSun on 15/8/20.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface DatabaseCenter : NSObject
{
    sqlite3_stmt *stmt;
}
+ (void)createTable;
//user
+ (id)getLastLoginUser;
+ (id)getUserWithName:(NSString*)name;
@end

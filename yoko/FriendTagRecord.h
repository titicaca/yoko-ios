//
//  FriendTagRecord.h
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendTagRecord : NSObject

@property(nonatomic, assign) long rid;
@property(nonatomic, assign) long uid;
@property(nonatomic, assign) long fuid;
@property(nonatomic, assign) long tagId;
@property(nonatomic, retain) NSString *tagName;

@end

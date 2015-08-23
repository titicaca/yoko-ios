//
//  FriendTagRecord.m
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "FriendTagRecord.h"

@implementation FriendTagRecord

- (id)initWithFriendTagRecord:(FriendTagRecord *)friendTagRecord{
    self = [super init];
    if(self){
        self.rid = friendTagRecord.rid;
        self.uid = friendTagRecord.uid;
        self.fuid = friendTagRecord.fuid;
        self.tagId = friendTagRecord.tagId;
        self.tagName = friendTagRecord.tagName;
    }
    return self;
}

- (id)initWithUid:(long)uid andFuid:(long)fuid andTagId:(long)tagId andTagName:(NSString *)tagName{
    self = [super init];
    if(self){
        self.uid = uid;
        self.fuid = fuid;
        self.tagId = tagId;
        self.tagName = tagName;
    }
    return self;
}

@end

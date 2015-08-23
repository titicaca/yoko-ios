//
//  FriendInfoRecord.m
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "FriendInfoRecord.h"

@implementation FriendInfoRecord

- (id)initWithFriendInfoRecord:(FriendInfoRecord *) friendInfoRecord{
    self = [super init];
    if(self){
        self.rid = friendInfoRecord.rid;
        self.uid = friendInfoRecord.uid;
        self.fuid = friendInfoRecord.fuid;
        self.email = friendInfoRecord.email;
        self.location = friendInfoRecord.location;
        self.mobile = friendInfoRecord.mobile;
        self.nickname = friendInfoRecord.nickname;
        self.picturelink = friendInfoRecord.picturelink;
        self.qq = friendInfoRecord.qq;
        self.sex = friendInfoRecord.sex;
        self.wechat = friendInfoRecord.wechat;
        self.weibo = friendInfoRecord.weibo;
        self.collectnumber = friendInfoRecord.collectnumber;
        self.enrollnumber = friendInfoRecord.enrollnumber;
        self.friendnumber = friendInfoRecord.friendnumber;
        self.logintime = friendInfoRecord.logintime;
    }
    return self;
}

- (id)initWithUid:(long)uid andFuid:(long)fuid andEmail:(NSString *)email andLocation:(NSString *)location andMobile:(NSString *)mobile andNickname:(NSString *)nickname andPicturelink:(NSString *)picturelink andQq:(NSString *)qq andSex:(int)sex andWechat:(NSString *)wechat andWeibo:(NSString *)weibo andCollectnumber:(int)collectnumber andEnrollnumber:(int)enrollnumber andFriendnumber:(int)friendnumber andLogintime:(long)logintime{
    self = [super init];
    if(self){
        self.uid = uid;
        self.fuid = fuid;
        self.email = email;
        self.location = location;
        self.mobile = mobile;
        self.nickname = nickname;
        self.picturelink = picturelink;
        self.qq = qq;
        self.sex = sex;
        self.wechat = wechat;
        self.weibo = weibo;
        self.collectnumber = collectnumber;
        self.enrollnumber = enrollnumber;
        self.friendnumber = friendnumber;
        self.logintime = logintime;
    }
    return self;
}

- (id)initWithFuid:(long)fuid andNickname:(NSString *)nickname andPicturelink:(NSString *)picturelink andLogintime:(long)logintime{
    self = [super init];
    if(self){
        self.fuid = fuid;
        self.nickname = nickname;
        self.picturelink = picturelink;
        self.logintime = logintime;
    }
    return self;
}

@end

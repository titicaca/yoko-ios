//
//  FriendInfoRecord.h
//  yoko
//
//  Created by BlueSun on 15/8/18.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfoRecord : NSObject

@property(nonatomic, assign) long rid;
@property(nonatomic, assign) long uid;
@property(nonatomic, assign) long fuid;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *mobile;
@property(nonatomic, retain) NSString *nickname;
@property(nonatomic, retain) NSString *picturelink;
@property(nonatomic, retain) NSString *qq;
@property(nonatomic, assign) int sex;
@property(nonatomic, retain) NSString *wechat;
@property(nonatomic, retain) NSString *weibo;
@property(nonatomic, assign) int collectnumber;
@property(nonatomic, assign) int enrollnumber;
@property(nonatomic, assign) int friendnumber;
@property(nonatomic, assign) long logintime;

- (id)initWithFriendInfoRecord:(FriendInfoRecord *) friendInfoRecord;
- (id)initWithUid:(long)uid andFuid:(long)fuid andEmail:(NSString *)email andLocation:(NSString *)location andMobile:(NSString *)mobile andNickname:(NSString *)nickname andPicturelink:(NSString *)picturelink andQq:(NSString *)qq andSex:(int)sex andWechat:(NSString *)wechat andWeibo:(NSString *)weibo andCollectnumber:(int)collectnumber andEnrollnumber:(int)enrollnumber andFriendnumber:(int)friendnumber andLogintime:(long)logintime;
- (id)initWithFuid:(long)fuid andNickname:(NSString *)nickname andPicturelink:(NSString *)picturelink andLogintime:(long)logintime;
@end

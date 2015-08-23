//
//  LocalUser.h
//  yoko
//
//  Created by BlueSun on 15/8/21.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserServer : NSObject

+ (void)saveUserInfo:(NSDictionary *)userInfo;
+ (void)saveLogInInfoWithAccessToken:(NSString *)accessToken andRefreshToken:(NSString *)refreshToken andUserMobile:(NSString *)mobile andPassword:(NSString *)password;
+ (void)saveAccessToken:(NSString *)accessToken;
+ (long)getUserID;
+ (NSString *)getAccessToken;
+ (NSString *)getRefreshToken;
+ (NSString *)getMobileRole;
+ (NSString *)getPassword;


@end

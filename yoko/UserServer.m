//
//  LocalUser.m
//  yoko
//
//  Created by BlueSun on 15/8/21.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "UserServer.h"
#import "UserDefaultConstants.h"

@implementation UserServer

+ (void)saveUserInfo:(NSDictionary *)userInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[userInfo objectForKey:@"id"] forKey:[NSString stringWithUTF8String:USER_ID]];
    
    if([userInfo objectForKey:@"mobile"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"mobile"] forKey:[NSString stringWithUTF8String:USER_MOBILE]];
    
    if([userInfo objectForKey:@"nickname"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"nickname"] forKey:[NSString stringWithUTF8String:USER_NICKNAME]];
    
    [userDefaults setObject:[userInfo objectForKey:@"sex"] forKey:[NSString stringWithUTF8String:USER_SEX]];
    
    if([userInfo objectForKey:@"location"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"location"] forKey:[NSString stringWithUTF8String:USER_LOCATION]];
    
    if([userInfo objectForKey:@"picturelink"] != [NSNull null])
    [userDefaults setObject:[userInfo objectForKey:@"picturelink"] forKey:[NSString stringWithUTF8String:USER_PICTURELINK]];
    
    if([userInfo objectForKey:@"email"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"email"] forKey:[NSString stringWithUTF8String:USER_EMAIL]];
    
    if([userInfo objectForKey:@"qq"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"qq"] forKey:[NSString stringWithUTF8String:USER_QQ]];
    
    if([userInfo objectForKey:@"wechat"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"wechat"] forKey:[NSString stringWithUTF8String:USER_WECHAT]];
    
    if([userInfo objectForKey:@"weibo"] != [NSNull null])
        [userDefaults setObject:[userInfo objectForKey:@"weibo"] forKey:[NSString stringWithUTF8String:USER_WEIBO]];
    
    [userDefaults setObject:[userInfo objectForKey:@"collectnumber"] forKey:[NSString stringWithUTF8String:USER_COLLECTNUMBER]];
    [userDefaults setObject:[userInfo objectForKey:@"enrollnumber"] forKey:[NSString stringWithUTF8String:USER_ENROLLNUMBER]];
    [userDefaults setObject:[userInfo objectForKey:@"friendnumber"] forKey:[NSString stringWithUTF8String:USER_FRIENDNUMBER]];
    [userDefaults setObject:[userInfo objectForKey:@"logintime"] forKey:[NSString stringWithUTF8String:USER_LOGINTIME]];
    [userDefaults synchronize];
}

+ (void)saveLogInInfoWithAccessToken:(NSString *)accessToken andRefreshToken:(NSString *)refreshToken andUserMobile:(NSString *)mobile andPassword:(NSString *)password{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:accessToken forKey:[NSString stringWithUTF8String:USER_ACCESS_TOKEN]];
    [userDefaults setObject:refreshToken forKey:[NSString stringWithUTF8String:USER_REFRESH_TOKEN]];
    [userDefaults setObject:[NSString stringWithFormat:@"0_%@",mobile] forKey:[NSString stringWithUTF8String:USER_MOBILE_ROLE]];
    [userDefaults setObject:password forKey:[NSString stringWithUTF8String:USER_PASSWORD]];
    [userDefaults synchronize];
}

+ (void)saveAccessToken:(NSString *)accessToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:accessToken forKey:[NSString stringWithUTF8String:USER_ACCESS_TOKEN]];
    [userDefaults synchronize];

}

+ (void)setUserID:(long)userId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithLong:userId] forKey:[NSString stringWithUTF8String:USER_ID]];
}

+ (long)getUserID{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_ID]] longValue];
}

+ (NSString *)getAccessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_ACCESS_TOKEN]];
}

+ (NSString *)getRefreshToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_REFRESH_TOKEN]];
}

+ (NSString *)getPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_PASSWORD]];
}

+ (NSString *)getMobileRole{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_MOBILE_ROLE]];
}

+ (NSString *)getNickname{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_NICKNAME]];
}

+ (NSString *)getLocation{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_LOCATION]];
}

+ (int)getCollectNumber{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_COLLECTNUMBER]] intValue];
}

+ (int)getEnrollNumber{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_ENROLLNUMBER]] intValue];
}

+ (int)getFriendNumber{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithUTF8String:USER_FRIENDNUMBER]] intValue];
}

+ (void)logOut{
    [[self class] setUserID:0l];
}

@end

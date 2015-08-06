//
//  RestAPIReconnection.h
//  yoko
//
//  Created by BlueSun on 15/8/5.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestAPIReconnectionDelegate<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@required
- (void) RestAPIRefreshTokenResultWithStatusCode:(NSInteger) statusCode andReceiveData:(NSData *)data andError:(NSError *)error;

- (void) RestAPIAutoLoginResultWithStatusCode:(NSInteger) statusCode andReceiveData:(NSData *)data andError:(NSError *)error;
@end

@interface RestAPIReconnection : NSObject

@property id<RestAPIReconnectionDelegate> delegate;
@property(retain, nonatomic) NSURLConnection *mConn;
@property(retain, nonatomic) UIApplication* app;

@property(assign, nonatomic) NSInteger statusCode;
@property(assign, nonatomic) NSData *rcvData;
@property(assign, nonatomic) NSError *rcvError;
@property(assign, nonatomic) NSInteger tokenType;

@property(retain, nonatomic) NSString *strBaseUrl;
@property(retain, nonatomic) NSString *strBasic;
@property(retain, nonatomic) NSMutableURLRequest *request;
@property(assign, nonatomic) NSInteger delegateType;

- (id)initRefreshTokenWithDelegate:(id<RestAPIReconnectionDelegate>)delegate;
- (id)initAutoLoginWithDelegate:(id<RestAPIReconnectionDelegate>)delegate;
- (void)startConnection;
@end

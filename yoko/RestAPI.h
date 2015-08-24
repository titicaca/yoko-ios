//
//  RestAPI.h
//  yoko
//
//  Created by BlueSun on 15/8/3.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RestAPIReconnection.h"


@protocol RestAPIDelegate<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@required
- (void) RestAPIResultWithConnection:(NSURLConnection *)connection andStatusCode:(NSInteger) statusCode andReceiveData:(NSData *)data andError:(NSError *)error andIdentifier:(NSString *)identifier;
@end

@interface RestAPI : NSObject<RestAPIReconnectionDelegate>
@property(assign, nonatomic) NSInteger statusCode;
@property(retain, nonatomic) NSData *rcvData;
@property(assign, nonatomic) NSError *rcvError;
@property(assign, nonatomic) NSInteger tokenType;
@property(retain, nonatomic) NSURLConnection *mConn;
@property(retain, nonatomic) UIApplication* app;
@property(retain, nonatomic) NSMutableURLRequest *request;
@property(retain, nonatomic) NSString *identifier;
@property(retain, nonatomic) NSString *strBaseUrl;
@property(retain, nonatomic) NSString *strBasic;
@property id<RestAPIDelegate> delegate;

- (id)initSignUpRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier;
- (id)initTokenRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier;
- (id)initNormalRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier;
- (void)startConnection;

@end

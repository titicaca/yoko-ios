//
//  RestAPIReconnection.m
//  yoko
//
//  Created by BlueSun on 15/8/5.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "RestAPIReconnection.h"
#import "UserServer.h"

@implementation RestAPIReconnection

- (void)initWithDelegate:(id<RestAPIReconnectionDelegate>)delegate{
    self.strBaseUrl = @"http://139.196.16.75:8080";
    self.strBasic=@"YW5kcm9pZC15b2tvOjEyMzQ1Ng==";
    self.app = [ UIApplication sharedApplication ];
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",self.strBaseUrl, @"/oauth/token"];
    NSURL *url=[NSURL URLWithString:strUrl];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.request = request;
    self.delegate = delegate;
}

- (id)initRefreshTokenWithDelegate:(id<RestAPIReconnectionDelegate>)delegate{
    self = [super init];
    if(self){
        [self initWithDelegate:delegate];
        NSString *strUrl=[NSString stringWithFormat:@"%@%@",self.strBaseUrl, @"/oauth/token"];
        
        [self.request setValue:[NSString stringWithFormat:@"Basic %@",self.strBasic] forHTTPHeaderField:@"Authorization"];
        self.request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?refresh_token=%@&grant_type=refresh_token",strUrl,[UserServer getRefreshToken]]];
        
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
        self.delegate = delegate;
        self.delegateType=1;
    }
    return self;
}

- (id)initAutoLoginWithDelegate:(id<RestAPIReconnectionDelegate>)delegate{
    self = [super init];
    if(self){
        
        [self initWithDelegate:delegate];
        NSString *strUrl=[NSString stringWithFormat:@"%@%@",self.strBaseUrl, @"/oauth/token"];
        [self.request setValue:[NSString stringWithFormat:@"Basic %@",self.strBasic] forHTTPHeaderField:@"Authorization"];
        self.request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?password=%@&username=%@&grant_type=password",strUrl,[UserServer getPassword],[UserServer getMobileRole]]];
        
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];

        self.delegateType=2;
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSInteger code=[(NSHTTPURLResponse*)response statusCode];
    //   NSLog(@"%@",[connection currentRequest]);
    //   NSLog(@"didReceiveResponse....code=%ld",code);
    self.statusCode = code;
    if(code == 401){
        
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //   NSLog(@"didFailWithError...%@",[error description]);
    self.rcvError = error;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.app.networkActivityIndicatorVisible = false;
    //  NSLog(@"connectionDidFinishLoading....");
    if(self.delegateType == 1)
        [self.delegate RestAPIRefreshTokenResultWithStatusCode:self.statusCode andReceiveData:self.rcvData andError:self.rcvError];
    if(self.delegateType == 2)
        [self.delegate RestAPIAutoLoginResultWithStatusCode:self.statusCode andReceiveData:self.rcvData andError:self.rcvError];
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //   NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    //   NSLog(@"didReceiveData....data=%@",str);
    self.rcvData = data;
    
}

- (void)startConnection{
    [self.mConn start];
    self.app.networkActivityIndicatorVisible = true;
}



@end

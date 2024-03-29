//
//  RestAPI.m
//  yoko
//
//  Created by BlueSun on 15/8/3.
//  Copyright (c) 2015年 BlueSun. All rights reserved.
//

#import "RestAPI.h"
#import "UserServer.h"

@implementation RestAPI

- (void)initWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier{
    self.strBaseUrl = @"http://139.196.16.75:8080";
    self.strBasic=@"YW5kcm9pZC15b2tvOjEyMzQ1Ng==";
    self.app = [ UIApplication sharedApplication ];
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",self.strBaseUrl, URI];
    NSURL *url=[NSURL URLWithString:strUrl];
    self.request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.request setHTTPMethod:HTTPMethod];
    self.delegate = delegate;
    self.identifier = identifier;
}

- (id)initSignUpRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier{
    self = [super init];
    if(self){
        [self initWithURI:URI andHTTPMethod:HTTPMethod andDelegate:delegate andIdentifier:identifier];
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:HTTPValues options:NSJSONWritingPrettyPrinted error:nil];
        [self.request setHTTPBody:JSONData];
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
    }
    return self;
}

- (id)initTokenRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier{
    self = [super init];
    if(self){
        [self initWithURI:URI andHTTPMethod:HTTPMethod andDelegate:delegate andIdentifier:identifier];
        NSString *strUrl=[NSString stringWithFormat:@"%@%@",self.strBaseUrl, URI];
        self.request.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?password=%@&username=%@&grant_type=password",strUrl,[HTTPValues objectForKey:@"password"],[HTTPValues objectForKey:@"username"]]];
        [self.request setValue:[NSString stringWithFormat:@"Basic %@",self.strBasic] forHTTPHeaderField:@"Authorization"];
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
    }
    return self;
}

- (id)initNormalRequestWithURI:(NSString *)URI andHTTPMethod:(NSString *)HTTPMethod andHTTPValues:(NSMutableDictionary *)HTTPValues andDelegate:(id<RestAPIDelegate>)delegate andIdentifier:(NSString *)identifier{
    self = [super init];
    if(self){
        
        [self initWithURI:URI andHTTPMethod:HTTPMethod andDelegate:delegate andIdentifier:identifier];
        
        if(HTTPValues!=nil){
            NSData *JSONData = [NSJSONSerialization dataWithJSONObject:HTTPValues options:NSJSONWritingPrettyPrinted error:nil];
            [self.request setHTTPBody:JSONData];
        }
        
        NSString *token = [UserServer getAccessToken];
        [self.request setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
   NSInteger code=[(NSHTTPURLResponse*)response statusCode];
 //   NSLog(@"%@",[connection currentRequest]);
 //   NSLog(@"didReceiveResponse....code=%ld",code);
    self.statusCode = code;
    if(code == 401){
        RestAPIReconnection *restAPIReconnection = [[RestAPIReconnection alloc] initRefreshTokenWithDelegate:self];
        [restAPIReconnection startConnection];
    }
}

- (void)RestAPIRefreshTokenResultWithStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error{
    
    NSLog(@"test2222");
    NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    
    if(statusCode != 200){
        RestAPIReconnection *restAPIReconnection = [[RestAPIReconnection alloc] initAutoLoginWithDelegate:self];
        [restAPIReconnection startConnection];
        return;
    }
    NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *accessToken = [rcvDictionary objectForKey:@"access_token"];
    if(accessToken != nil){
        [UserServer saveAccessToken:accessToken];
        NSLog(@"callback%@",self.mConn);
        [self.request setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
        [self.mConn start];
    }
}

-(void)RestAPIAutoLoginResultWithStatusCode:(NSInteger)statusCode andReceiveData:(NSData *)data andError:(NSError *)error{
    NSLog(@"test2222");
    NSString *str=[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"%ld",statusCode);
    NSLog(@"%@",str);
    NSLog(@"%@",[error description]);
    if(statusCode != 200){

        return;
    }
    NSDictionary *rcvDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *accessToken = [rcvDictionary objectForKey:@"access_token"];
    if(accessToken != nil){
        [UserServer saveAccessToken:accessToken];
        NSLog(@"callback%@",self.mConn);
        [self.request setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
        self.mConn =[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:false];
        [self.mConn start];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
 //   NSLog(@"didFailWithError...%@",[error description]);
    self.rcvError = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.app.networkActivityIndicatorVisible = false;
  //  NSLog(@"connectionDidFinishLoading....");
    if(self.statusCode == 401) return;
    [self.delegate RestAPIResultWithConnection:connection andStatusCode:self.statusCode andReceiveData:self.rcvData andError:self.rcvError andIdentifier:self.identifier];
    
    
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

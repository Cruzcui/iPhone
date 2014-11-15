//
//  HHRequestManager.m
//  DalianPort
//
//  Created by mac on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHRequestManager.h"

#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "SBJson.h"
#import "CheckNetwork.h"
static NSString* version=nil;
static NSString* userID = nil;
static NSString* identifier = nil;

@implementation HHRequestManager

@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize tag = _tag;
@synthesize dictRequestObject = _dictRequestObject;


-(void) postDataWithURL:(NSString*) url  
                  Datas:(NSDictionary*) datas{
    
    if ([CheckNetwork isExistenceNetwork] == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isExistenceNetwork" object:nil];
        
        return;
    }
    
    
    // define New Http Request;
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    //set the request header
    
    if (version==nil) {
        version = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] copy];
    }
    
    if(userID==nil){
        NSDictionary *nsUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginInfo"];
        
        userID = [[nsUserInfo objectForKey:@"userName"] copy];
    }
    
    
    if(identifier==nil){
        //UIDevice *myDevice = [UIDevice currentDevice];
        //identifier = [myDevice.uniqueIdentifier copy];
    }
    
    
    [self.request addRequestHeader:@"mType" value:@"iPhone" ];
    [self.request addRequestHeader:@"version" value:version];
    if(userID!=nil)
        [self.request addRequestHeader:@"userID" value:userID];
    [self.request addRequestHeader:@"imei" value:@""];
    [self.request addRequestHeader:@"softCode" value:@"56366"];
    
    //MyProfile* profile = [MyProfile myProfile];
   
    //[self.request addRequestHeader:@"location" value:profile.urlCityName ];
        
    //NSLog(@"Request Header:%@",self.request.requestHeaders);
    
    // Set Post Data;
    if (datas != nil){
        NSArray *keys = [datas allKeys];  
        
        // values in foreach loop  
        for (NSString *key in keys) 
        {  
            [_request setPostValue:[datas objectForKey:key] forKey:key];
        }
    }
    
	
    [_request setTimeOutSeconds:20];
    [_request setShouldContinueWhenAppEntersBackground:YES];
	[_request setDelegate:self];
	[_request setDidFailSelector:@selector(didFailed:)];
	[_request setDidFinishSelector:@selector(didFinished:)];
    
                   
     //[_request setUserInfo:[NSDictionary dic:_tag,@"Tag", nil]];
    
    // Set And Save Request Object;
    self.tag += 1;
    
    [_request setTag:self.tag];
    
    if (self.dictRequestObject == nil){
        self.dictRequestObject = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    [self.dictRequestObject setValue:_request forKey:[NSString stringWithFormat:@"%d", self.tag]];
    
	[_request startAsynchronous];
}




-(void) dealloc{
    
    self.request = nil;
    self.dictRequestObject = nil;
    
    [super dealloc];
}

#pragma mark parsJson

-(NSDictionary *) getNsDicFromJsonString:(ASIHTTPRequest *)theRequest
{
    // Get Request Data
    if (theRequest) 
    {
        
        
        if ([theRequest responseString]) 
        {
            NSString *jsonString = [theRequest responseString];
            
            NSLog(@"JsonString:%@",jsonString);
            
            SBJsonParser * parser = [[SBJsonParser alloc] init]; 
            
            NSError * error = nil;
            
            NSDictionary *jsonDic = [parser objectWithString:jsonString error:&error]; 
            
            [parser release];
            
            return jsonDic;        
        }
        else 
        {
            return nil;	
        }
    }
    else 
    {
        return nil;		
    }
}

#pragma mark
-(void) didFinished:(ASIHTTPRequest *)theRequest{
    
    NSLog(@"Request Return Tag:%d",theRequest.tag);
    
    // Remove Dict
    [self.dictRequestObject removeObjectForKey:[NSString stringWithFormat:@"%d",theRequest.tag]];
    
    if (self.tag == theRequest.tag){
        
        if(_delegate){
            if ([theRequest error]) {
                [_delegate didRequestWithData:nil Status:-99 Sender:self];
            }else {
                NSDictionary* result = [self getNsDicFromJsonString:theRequest];
                
                if (result == nil) {
                    [_delegate didRequestWithData:nil Status:-98 Sender:self];
                }else {
                    int status = [(NSString*)[result objectForKey:@"status"] intValue];
                    [_delegate didRequestWithData:result Status:status Sender:self];
                }
            }
        }
    }
}

-(void) didFailed:(ASIHTTPRequest *)theRequest{
    
    NSLog(@"Http Request Error:%@ URL:%@",[theRequest error],[theRequest url]);
    
    NSLog(@"Request Return Tag:%d",theRequest.tag);
    
    // Remove Dict
    [self.dictRequestObject removeObjectForKey:[NSString stringWithFormat:@"%d",theRequest.tag]];
    
    if (self.tag == theRequest.tag){

        if(_delegate){
            [_delegate didRequestWithData:nil Status:-100 Sender:self];
        }
    }
}



@end

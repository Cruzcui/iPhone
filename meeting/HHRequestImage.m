//
//  HHRequestImage.m
//  DalianPort
//
//  Created by mac on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHRequestImage.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#define DOWMLOADPATH @"DownloadImages"


static ASINetworkQueue *_networkQueue = nil;
static HHRequestImage* _requestImageManager;

@interface HHRequestImage(){
    //NSMutableArray* requestList;
}

@end

@implementation HHRequestImage

@synthesize tag = _tag;
@synthesize dictRequestObject = _dictRequestObject;

+(id) requestImage{
    
    if (_requestImageManager!=nil) {
        return _requestImageManager;
    }
    
    @synchronized([HHRequestImage class]){
        _requestImageManager = [[HHRequestImage alloc] init];
        [_requestImageManager getNetWorkQueue];
        return _requestImageManager;
    }
    
    
}


-(ASINetworkQueue*) getNetWorkQueue{
    
    if (_networkQueue!=nil) {
        return _networkQueue;
    }
    
    @synchronized([HHRequestImage class]){
        _networkQueue = [[ASINetworkQueue alloc] init];
        [_networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [_networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
        [_networkQueue setDelegate:self];
        [_networkQueue setMaxConcurrentOperationCount:10];
        
        //requestList = [[NSMutableArray alloc] initWithCapacity:10];
        
        return _networkQueue;
    }
}


-(void) addDownloadJobWithURL:(NSString*) url FileName:(NSString*) filename Target:(id<HHRequestImageDelegate>) tag  UserInfo:(NSDictionary*) userInfo{
    
    ASIHTTPRequest *request;
    
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename]; 
    
    
    
    
    
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:filename,@"FileName",tag,@"Tag",filePath,@"FullPath",userInfo,@"UerInfo", nil]];
    
    [request setDownloadDestinationPath:filePath];
    [request setTimeOutSeconds:120];
    
    [request setDelegate:self];
    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
	[request setDidFailSelector:@selector(imageFetchFailed:)];
	[request setDidFinishSelector:@selector(imageFetchComplete:)];
    
    
    // Set And Save Request Object;
    self.tag += 1;
    
    [request setTag:self.tag];
    
    if (self.dictRequestObject == nil){
        self.dictRequestObject = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    [self.dictRequestObject setValue:request forKey:[NSString stringWithFormat:@"%d", self.tag]];

    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        
        [tag didImageDownload:self HttpRequest:request FileName:filename FullPath:filePath UserInfo:userInfo Success:YES];
        
        
        return;
    }
    else {
//        UIImage *image = [[UIImage imageNamed:@"56366Logo"] autorelease];
//        
//        NSData *imageData = nil;
//      
//        imageData = UIImageJPEGRepresentation(image,0);    
//       
//        [imageData writeToFile:filePath atomically:YES];      
//     
//        [tag didImageDownload:self HttpRequest:request FileName:filename FullPath:filePath UserInfo:userInfo Success:YES];
    }
    
	[request startAsynchronous];
    
	//[[self getNetWorkQueue] addOperation:request];
    
    //[[self getNetWorkQueue] go];
	
	

    
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    // Remove Dict
    [self.dictRequestObject removeObjectForKey:[NSString stringWithFormat:@"%d",request.tag]];
    
    NSDictionary* userInfo = [request userInfo];
    
    id<HHRequestImageDelegate> tag = (id<HHRequestImageDelegate>)[userInfo objectForKey:@"Tag"];
    NSString* fileName = (NSString*) [userInfo objectForKey:@"FileName"];
    NSString* fullPath = (NSString*) [userInfo objectForKey:@"FullPath"];
    
    NSLog(@"FullPath:%@",fullPath);
    
    if (tag) {
        
        if([request error]){
            
            NSLog(@"Download Image Error 1:%@ URL:%@",[request error],[request url]);
            
            
            [tag didImageDownload:self HttpRequest:request FileName:fileName FullPath:fullPath UserInfo:[userInfo objectForKey:@"UerInfo"] Success:NO];
            
        }else{
            [tag didImageDownload:self HttpRequest:request FileName:fileName FullPath:fullPath UserInfo:[userInfo objectForKey:@"UerInfo"] Success:YES];
        }
        
        
    }
    
    
}

- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
    
    NSLog(@"Download Image Error 2:%@ URL:%@",[request error],[request url]);
    
    // Remove Dict
    [self.dictRequestObject removeObjectForKey:[NSString stringWithFormat:@"%d",request.tag]];
    
    NSDictionary* userInfo = [request userInfo];
    
    id<HHRequestImageDelegate> tag = (id<HHRequestImageDelegate>)[userInfo objectForKey:@"Tag"];
    NSString* fileName = (NSString*) [userInfo objectForKey:@"FileName"];
    NSString* fullPath = (NSString*) [userInfo objectForKey:@"FullPath"];
    
    if (tag) {
        [tag didImageDownload:self HttpRequest:request FileName:fileName FullPath:fullPath UserInfo:[userInfo objectForKey:@"UerInfo"]  Success:NO];
    }
}

- (void)dealloc{
    
    self.dictRequestObject = nil;
    
    [super dealloc];
}

- (void) clearUnReturnRequestData{
    if (self.dictRequestObject != nil && 
        [self.dictRequestObject count] > 0){
        
        // values in foreach loop  
        NSArray *keys = [self.dictRequestObject allKeys];  
        
        // values in foreach loop  
        for (NSString *key in keys) 
        {  
            ASIHTTPRequest *tmpRequest = [self.dictRequestObject objectForKey:key];
            
            [tmpRequest clearDelegatesAndCancel];
            
            [self.dictRequestObject removeObjectForKey:key];
            
            
            tmpRequest = nil;
        }
        
    }
}

@end

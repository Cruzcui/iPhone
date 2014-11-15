//
//  HHRequestImage.h
//  DalianPort
//
//  Created by mac on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HHRequestImage;
@class ASINetworkQueue;
@class ASIHTTPRequest;

@protocol HHRequestImageDelegate <NSObject>

-(void)         didImageDownload:(HHRequestImage*) requestImage 
                     HttpRequest:(ASIHTTPRequest *)request
                        FileName:(NSString*) filename 
                        FullPath:(NSString*) fullPath
                        UserInfo:(NSDictionary*) userInfo 
                         Success:(BOOL) suc;
 
@end



@interface HHRequestImage : NSObject{
}


+(id) requestImage;

-(void) addDownloadJobWithURL:(NSString*) url FileName:(NSString*) filename Target:(id<HHRequestImageDelegate>) tag UserInfo:(NSDictionary*) userInfo;

@property (nonatomic) int tag;

@property (nonatomic,retain) NSMutableDictionary *dictRequestObject;

- (void) clearUnReturnRequestData;

@end

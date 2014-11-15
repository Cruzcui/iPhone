//
//  HHRequestManager.h
//  DalianPort
//
//  Created by mac on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"


@class HHRequestManager;

@protocol HHRequestManagerDelegate <NSObject>

-(void) didRequestWithData:(NSDictionary*) datas Status:(int) status Sender:(HHRequestManager*) requstManager;

@end


@interface HHRequestManager : NSObject{
}

@property (retain, nonatomic) ASIFormDataRequest *request;

@property (assign, nonatomic) id<HHRequestManagerDelegate> delegate;

@property (nonatomic) int tag;

@property (nonatomic,retain) NSMutableDictionary *dictRequestObject;

-(void) postDataWithURL:(NSString*) url
                  Datas:(NSDictionary*) datas;


-(void) didFinished:(ASIHTTPRequest *)theRequest;
-(void) didFailed:(ASIHTTPRequest *)theRequest;

@end

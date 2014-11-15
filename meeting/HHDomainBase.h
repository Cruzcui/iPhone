//
//  HHDomainBase.h
//  DalianPort
//
//  Created by mac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HHRequestManager.h"


@class HHDomainBase;

@protocol HHDomainBaseDelegate <NSObject>

@required
-(void) didParsDatas:(HHDomainBase*) domainData;


@end


#pragma mark HHDomainBase
@interface HHDomainBase : NSObject<HHRequestManagerDelegate>


@property (nonatomic,retain) HHRequestManager* requestManager;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int curPage;
@property (nonatomic,assign) int returnRowsNum;
@property (nonatomic,assign) int prevRowsNum;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,copy) NSString *resultMessage;
@property (nonatomic,copy) NSString *resultSearchTime;

@property (nonatomic,assign) id<HHDomainBaseDelegate> delegate;

@property (nonatomic,retain) NSArray *dataDetails;
@property (nonatomic,retain) NSDictionary *dataDictionary;
@property (nonatomic,retain) NSDictionary *responseDictionary;

@property (nonatomic) int tag;



-(void) requestData:(NSMutableDictionary *) nsDictParams;
-(void) parsDataWithDictionary:(NSDictionary*) datas;

- (void) clearUnReturnRequestData;

-(void) clearData;

@end






#pragma mark NSDictionary (StringConvert)
@interface NSDictionary (StringConvert)

-(NSString*) stringForKey:(id) key;

-(NSNumber*) numberForKey:(id) key;

-(NSArray*) arrayForKey:(id) key;

-(NSDictionary*) dictionaryForKey:(id) key;

-(NSDate*) dateForKey:(id)key;

-(NSString*) formatDateForKey:(id)key;

-(NSString*) formatShortDateForKey:(id)key;

-(NSString*) urlStringForKey:(id) key;
-(NSString*) formatChineseDateForKey:(id)key;

@end


@interface NSArray (PasertJson)

-(NSString*) toJson;

+(NSArray*) fromString:(NSString*) json;

+(NSArray*) fromData:(NSData*) data;

@end



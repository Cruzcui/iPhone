//
//  HHDomainBase.m
//  DalianPort
//
//  Created by mac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHDomainBase.h"
#import "MeetingConst.h"
#import "SBJson.h"

@interface HHDomainBase(){
    
    
}

@end

@implementation HHDomainBase

@synthesize requestManager = _requestManager;

@synthesize status = _status;
@synthesize curPage;
@synthesize returnRowsNum;
@synthesize prevRowsNum;
@synthesize resultMessage = _resultMessage;
@synthesize resultSearchTime = _resultSearchTime;
@synthesize delegate = _delegate;

@synthesize dataDetails = _dataDetails;
@synthesize dataDictionary = _dataDictionary;

@synthesize isLoading;

@synthesize tag;

-(id) init{
    
    self = [super init];
    
    if (self) {
        self.requestManager = [[[HHRequestManager alloc] init] autorelease];
        self.requestManager.delegate = self;
    
        isLoading = NO;
        
        self.prevRowsNum = 0;
        self.curPage = 1;
        self.tag = 0;
    }
    
    return self;
    
}

-(void) clearData{
    self.dataDetails = nil;
    self.dataDictionary = nil;
}

-(void) dealloc{
    
    self.resultMessage = nil;
    self.resultSearchTime = nil;
    self.requestManager = nil;
    self.dataDetails = nil;
    self.dataDictionary = nil;
    
    self.responseDictionary = nil;
    
    [super dealloc];
}


-(void) requestData:(NSMutableDictionary *) nsDictParams{
    
    
}

-(void) parsDataWithDictionary:(NSDictionary *)datas{
    
    if (datas != nil){
        // Get Return Rows Num
        
        self.responseDictionary = datas;
        
        if ([[datas objectForKey:JsonHead_data] isKindOfClass:[NSDictionary class]]) {
            self.dataDictionary =  [datas dictionaryForKey:JsonHead_data];
            
        }
        else{
            NSArray *arrayReturnData = [datas arrayForKey:JsonHead_data];
            
            if (arrayReturnData ==nil || [arrayReturnData count] < 1) {
                arrayReturnData = [datas arrayForKey:JsonHead_dataList];
            }
            
            
            if (arrayReturnData == nil){
                self.returnRowsNum = 0;
            }
            else{
                self.returnRowsNum = [arrayReturnData count];
            }
            
            
            
            // Get data Property
            if (self.curPage <= 1 || self.dataDetails == nil || [self.dataDetails count] == 0){
                self.dataDetails = arrayReturnData;
            }
            else{
                NSMutableArray *arrayTmpData = [NSMutableArray arrayWithArray:self.dataDetails];
                
                [arrayTmpData addObjectsFromArray:arrayReturnData];
                
                self.dataDetails = arrayTmpData;
                arrayTmpData = nil;
                
            }
            
            arrayReturnData = nil;
        }
        
    }
    else {
        if (self.curPage <= 1)
            self.dataDetails = [NSMutableArray arrayWithCapacity:5];
    }
    
    self.isLoading = NO;
}

- (void) clearUnReturnRequestData{
    if (self.requestManager.dictRequestObject != nil && 
        [self.requestManager.dictRequestObject count] > 0){
        
            NSArray *keys = [self.requestManager.dictRequestObject allKeys];  
            
            // values in foreach loop  
            for (NSString *key in keys) 
            {  
                ASIHTTPRequest *tmpRequest = [self.requestManager.dictRequestObject objectForKey:key];
                
                [tmpRequest clearDelegatesAndCancel];
                
                [self.requestManager.dictRequestObject removeObjectForKey:key];
                
                //[tmpRequest release];
                
                tmpRequest = nil;
            }
               
    }
}


#pragma mark requet manager deletegate
-(void) didRequestWithData:(NSDictionary *)datas Status:(int)status Sender:(HHRequestManager *)requstManager{
    
    if (status>=0) {
        self.status = status;
        [self parsDataWithDictionary:datas];
        
    }else {
        self.status = status;
        
        if(datas!=nil)
            self.resultMessage = [datas objectForKey:@"message"];
        
    }
    
    if (_delegate) {
        [_delegate didParsDatas:self];
    }
}

@end





#pragma mark -
#pragma mark NSDictionary (StringConvert)
@implementation NSDictionary (StringConvert)

-(NSString*) stringForKey:(id) key{
    
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return @"";
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }else {
        return [NSString stringWithFormat:@"%@",obj] ;
    }
}

-(NSNumber*) numberForKey:(id) key{
    
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSNumber numberWithInt:0];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)obj;
    }else {
        return [NSNumber numberWithInt:0];
    }
}

-(NSArray*) arrayForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableArray arrayWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray*)obj;
    }else {
        return [NSMutableArray arrayWithCapacity:5];
    }
}

-(NSDictionary*) dictionaryForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)obj;
    }else {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
}
-(NSDate*) dateForKey:(id)key{
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
        return date;
}

-(NSString*) formatDateForKey:(id)key{
    
    @try {
        NSNumber* mofityDT = [self objectForKey:key];
        
        if(mofityDT == nil){
            return @"";
        }
        
        long long int mmdt = [mofityDT longLongValue] / 1000 ;
        
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        
        return [dateFormatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
    
    
}

-(NSString*) formatShortDateForKey:(id)key{
    
    @try {
        NSNumber* mofityDT = [self objectForKey:key];
        
        if (mofityDT==nil) {
            return @"";
        }
        
        long long int mmdt = [mofityDT longLongValue] / 1000 ;
        
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        return [dateFormatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
    
    
    
}

-(NSString*) formatChineseDateForKey:(id)key{
    
    @try {
        NSNumber* mofityDT = [self objectForKey:key];
        
        if (mofityDT==nil) {
            return @"";
        }
        
        long long int mmdt = [mofityDT longLongValue] / 1000 ;
        
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        
        return [dateFormatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
    
    
    
}

-(NSString*) urlStringForKey:(id)key{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)[self stringForKey:key],
                                                                           NULL,
                                                                           CFSTR("!*'();@&=+$,?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

@end


@implementation NSArray(PasertJson)


-(NSString*) toJson{
    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
    
    
    NSString* jsonText = [writer stringWithObject:self];
    
    NSLog(@"%@",writer.error);
    
    [writer release];
    return jsonText;
}

+(NSArray*) fromString:(NSString *)json{
    
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    
    NSArray* array = [parser objectWithString:json];
    
    [parser release];
    
    return array;
    
    
}

+(NSArray*) fromData:(NSData *)data{
    
    
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    
    NSArray* array = [parser objectWithData:data];
    
    [parser release];
    
    return array;
    
}


@end





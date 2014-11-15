//
//  HHLocalDomainBase.m
//  HisGuidline
//
//  Created by kimi on 13-9-25.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HHLocalDomainBase.h"
#import "SBJson.h"

@implementation HHLocalDomainBase


-(id) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void) dealloc{
    [super dealloc];
}

-(NSDictionary*) requestData:(NSString *)filePath{
    
    NSString *contents = [[NSString alloc ] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    
    NSError * error = nil;
    
    NSDictionary* jsonDic = [parser objectWithString:contents error:&error];
    
    [parser release];
    [contents release];
    
    return jsonDic;
}

@end

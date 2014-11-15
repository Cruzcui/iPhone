//
//  HKGuidListDomain.m
//  HisGuidline
//
//  Created by kimi on 13-9-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKGuidListDomain.h"
#import "MeetingConst.h"

@implementation HKGuidListDomain


-(void) getGuidList:(NSString *)userName{
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [params setValue:userName forKey:@"userId"];
    
    [self.requestManager postDataWithURL:URL_GuidlineList Datas:params];

    
}

@end

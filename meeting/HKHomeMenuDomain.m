//
//  HKHomeMenuDomain.m
//  HisGuidline
//
//  Created by kimi on 13-10-15.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHomeMenuDomain.h"

@implementation HKHomeMenuDomain

@synthesize menuList;


-(void) dealloc{
    
    self.menuList = nil;
    [super dealloc];
}

-(void) requestMenu{
    
    [self.requestManager postDataWithURL:@"http://localhost" Datas:nil];
    
    
}


-(void) didRequestWithData:(NSDictionary *)datas Status:(int)status Sender:(HHRequestManager *)requstManager{
    
    //add Category for Testing
    self.menuList = [NSMutableArray arrayWithCapacity:2];
    [self.menuList addObject:@"我的信息"];
    [self.menuList addObject:@"设置"];
    
    [super didRequestWithData:datas Status:status Sender:requstManager];
    
}

@end

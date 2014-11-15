//
//  HKSysmessateDomain.m
//  HisGuidline
//
//  Created by kimi on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKSysmessateDomain.h"
#import "HKHeader.h"

@implementation HKSysmessateDomain


-(void) requestMessage:(NSMutableDictionary *)nsDictParams{
    [self.requestManager postDataWithURL:URLSysmessaee Datas:nsDictParams];
}



@end

//
//  MeetingDomain.m
//  HisGuidline
//
//  Created by cuiyang on 14-3-3.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "MeetingDomain.h"

@implementation MeetingDomain
-(void)getMeeting:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URL_huiyi Datas:params];
}

-(void)getMeetingDetails:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URL_huiyiDetail Datas:params];
}
@end

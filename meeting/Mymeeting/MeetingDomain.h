//
//  MeetingDomain.h
//  HisGuidline
//
//  Created by cuiyang on 14-3-3.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"
#import "HKHeader.h"
@interface MeetingDomain : HHDomainBase
-(void)getMeeting:(NSDictionary *)params;
-(void)getMeetingDetails:(NSDictionary *)params;
@end

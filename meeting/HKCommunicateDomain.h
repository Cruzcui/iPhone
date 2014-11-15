//
//  HKCommunicateDomain.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"

@interface HKCommunicateDomain : HHDomainBase
-(void)getDomainForMyPPTs:(NSDictionary *)params;
-(void)getDomainForPPTDetails:(NSDictionary *)params;
-(void)getDomainForMyBiBao:(NSDictionary *)params;
-(void)getDomainForMyVideo:(NSDictionary *)params;
-(void)getDomainForVotes:(NSDictionary *)params;
-(void)getDomainForPostAnswer:(NSDictionary *)params;
-(void)getFaQiPost:(NSDictionary *)params;
-(void)getHelperList:(NSDictionary *)params;
-(void)getHelperContent:(NSDictionary *)params;
-(void)postHelpReplay:(NSDictionary *)params;
-(void)PostHelpContent:(NSDictionary *)params;
-(void)getSelected:(NSDictionary *)params;
-(void)getUnSelected:(NSDictionary*)params;
-(void)getMySelectedBiBao:(NSDictionary *)params;
-(void)getMySelectedPPT:(NSDictionary *)params;
-(void)getMySelectedVideo:(NSDictionary *)params;
-(void)getMySelectedTools:(NSDictionary *)params;
@end

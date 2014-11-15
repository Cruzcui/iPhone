//
//  HKCommunicateDomain.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCommunicateDomain.h"
#import "HKHeader.h"
@implementation HKCommunicateDomain
-(void)getDomainForMyPPTs:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMyPPTs Datas:params];
}
-(void)getDomainForPPTDetails:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForDetailsPPTs Datas:params];
}
-(void)getDomainForMyBiBao:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForBiBao Datas:params];
}
-(void)getDomainForMyVideo:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForVideo Datas:params];
}
-(void)getDomainForVotes:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForVotes Datas:params];
}
-(void)getDomainForPostAnswer:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPostAnswer Datas:params];
}
-(void)getFaQiPost:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForFaQiPost Datas:params];
}
-(void)getHelperList:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForHelperList Datas:params];
}
-(void)getHelperContent:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForHelperContent Datas:params];
}
-(void)postHelpReplay:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForHelpPost Datas:params];
}
-(void)PostHelpContent:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPostHelp Datas:params];
}
-(void)getSelected:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForSelected Datas:params];
}
-(void)getUnSelected:(NSDictionary*)params {
    [self.requestManager postDataWithURL:URLForUnSelected Datas:params];
}
-(void)getMySelectedBiBao:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMySelectedBiBao Datas:params];
}
-(void)getMySelectedPPT:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMySelectedPPT Datas:params];
}
-(void)getMySelectedVideo:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMySelectedVideo Datas:params];
}
-(void)getMySelectedTools:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMySelectedTools Datas:params];
}
@end

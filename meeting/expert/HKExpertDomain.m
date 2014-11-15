//
//  HKExpertDomain.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKExpertDomain.h"
#import "HKHeader.h"
@implementation HKExpertDomain
-(void)getExpertContent:(NSDictionary *)params {
  [self.requestManager postDataWithURL:URLForGetExpertContent Datas:params];
}
-(void)getQuestionAndReplayList:(NSDictionary*)params {
    [self.requestManager postDataWithURL:URLForGetQuestionAndReplayList Datas:params];
}
-(void)postQuestions:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPostExpert Datas:params];
}
@end

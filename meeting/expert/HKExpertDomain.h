//
//  HKExpertDomain.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"

@interface HKExpertDomain : HHDomainBase
-(void)getExpertContent:(NSDictionary *)params;
-(void)getQuestionAndReplayList:(NSDictionary*)params;
-(void)postQuestions:(NSDictionary *)params;
@end

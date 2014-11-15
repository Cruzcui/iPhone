//
//  HKUserDomain.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"
#import "HKHeader.h"
@interface HKUserDomain : HHDomainBase
-(void) UpDateuserInfos:(NSDictionary *)params;
-(void) getUserinfos:(NSDictionary *)params;
-(void) postJianyi:(NSDictionary *)params;
-(void) changePassWord:(NSDictionary *)params;
@end

//
//  HKCategorySearchDomain.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"

@interface HKCategorySearchDomain : HHDomainBase
-(void)getDomainForZhiNanYuanWen:(NSDictionary *)params;
-(void)getDomainForYuanWenMuLu:(NSDictionary *)params;
-(void)getDomainDetail:(NSDictionary *)params;
-(void)getTestData:(NSDictionary *)params;
-(void)getDOmainPingLun:(NSDictionary *)params;
-(void)getScore:(NSDictionary *)params;
-(void)getPostContent:(NSDictionary *)params;
-(void)getDomainForNews:(NSDictionary *)params;
@end

//
//  HKToolsDomain.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HHDomainBase.h"
#import "HKHeader.h"
@interface HKToolsDomain : HHDomainBase
-(void)getToolsGuid:(NSDictionary *)params;
-(void)getToolsContent:(NSDictionary *)params;
-(void)getSelected:(NSDictionary *)params;
@end

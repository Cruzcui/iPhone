//
//  HKCategoryDomain.h
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHDomainBase.h"
#import "HKHeader.h"
@interface HKCategoryDomain : HHDomainBase

-(void) requestCategory;
-(void) getSystemOption:(NSDictionary *)params;
@end

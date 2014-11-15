//
//  HKHomeMenuDomain.h
//  HisGuidline
//
//  Created by kimi on 13-10-15.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHDomainBase.h"

@interface HKHomeMenuDomain : HHDomainBase


@property (nonatomic,retain) NSMutableArray* menuList;

-(void) requestMenu;

@end

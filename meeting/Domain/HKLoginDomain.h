//
//  HKLoginDomain.h
//  meeting
//
//  Created by kimi on 13-6-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HHDomainBase.h"

@interface HKLoginDomain : HHDomainBase

-(void) loginWithName:(NSString *)userName Password:(NSString *)password userType:(NSString *)userType;


-(void) changePassword:(NSDictionary*) params;

-(void) getValideCode:(NSString *)phone;

-(void) registerUser:(NSDictionary*) params;

-(void) checkVersion;

-(void) getPasswordBackDomain:(NSDictionary *)params;

@end

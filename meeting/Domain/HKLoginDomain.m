//
//  HKLoginDomain.m
//  meeting
//
//  Created by kimi on 13-6-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKLoginDomain.h"
#import "MeetingConst.h"


@implementation HKLoginDomain


-(void) checkVersion{
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:@"839983837" forKey:@"id"];
    
    
    [self.requestManager postDataWithURL:URL_CheckVersion Datas:params];
    
}


-(void) loginWithName:(NSString *)userName Password:(NSString *)password userType:(NSString *)userType{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params setValue:userName forKey:@"userId"];
    [params setValue:password forKey:@"password"];
    [params setValue:userType forKey:@"userType"];
    
    [self.requestManager postDataWithURL:URL_Login Datas:params];
    
    
}


-(void) changePassword:(NSDictionary *)params
{
    //[self.requestManager postDataWithURL:URL_ChangePassword Datas:params];
}

-(void) getValideCode:(NSString *)phone
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setValue:phone forKey:@"mobile"];
    //[self.requestManager postDataWithURL:URL_ApplayCode Datas:params];
}

-(void) registerUser:(NSDictionary *)params
{
    [self.requestManager postDataWithURL:URL_URL_REGIST Datas:params];
}
-(void) getPasswordBackDomain:(NSDictionary *)params {

    [self.requestManager postDataWithURL:URL_getPassBack Datas:params];
}
@end

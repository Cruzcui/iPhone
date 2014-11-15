//
//  HKUserDomain.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKUserDomain.h"

@implementation HKUserDomain
-(void) UpDateuserInfos:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForUpdateUserInfos Datas:params];
}
-(void) getUserinfos:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForgetUserInfos Datas:params];
}

-(void) postJianyi:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPostJianYi Datas:params];
}
-(void) changePassWord:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForChangePassWord Datas:params];
}
@end

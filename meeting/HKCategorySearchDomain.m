//
//  HKCategorySearchDomain.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCategorySearchDomain.h"
#import "HKHeader.h"
@implementation HKCategorySearchDomain
-(void)getDomainForZhiNanYuanWen:(NSDictionary *)params {
    
    [self.requestManager postDataWithURL:URLForZhiNanLieBiao Datas:params];
}
-(void)getDomainForYuanWenMuLu:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForYuanWenMuLu Datas:params];
}
-(void)getDomainDetail:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForMuLuDetail Datas:params];

}
-(void)getTestData:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForTest Datas:params];
}
-(void)getDOmainPingLun:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPingLunList Datas:params];
}
-(void)getScore:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForScore Datas:params];

}
-(void)getPostContent:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForPost Datas:params];
}
-(void)getDomainForNews:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForNews Datas:params];
}
@end

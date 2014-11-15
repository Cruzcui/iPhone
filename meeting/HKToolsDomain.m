//
//  HKToolsDomain.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKToolsDomain.h"

@implementation HKToolsDomain
-(void)getToolsGuid:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForToolsGuid Datas:params];
}
-(void)getToolsContent:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForToolsContent Datas:params];
}
-(void)getSelected:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForSelected Datas:params];
}
@end

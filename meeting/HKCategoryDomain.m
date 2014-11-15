//
//  HKCategoryDomain.m
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCategoryDomain.h"

@implementation HKCategoryDomain


-(id) init{
    self = [super init];
    
    if (self) {
        
        
        
    }
    
    return self;
}

-(void) dealloc{
    
    [super dealloc];
}

-(void) requestCategory{
    
    [self.requestManager postDataWithURL:URLCategoryListViewController Datas:nil];
    
    
}
-(void) getSystemOption:(NSDictionary *)params {
    [self.requestManager postDataWithURL:URLForSystemOption Datas:params];
}

//-(void) didRequestWithData:(NSDictionary *)datas Status:(int)status Sender:(HHRequestManager *)requstManager{
//    
//    //add Category for Testing
//    self.categoryList = [NSMutableArray arrayWithCapacity:10];
//    
////    [self.categoryList addObject:@"最新1111"];
////    [self.categoryList addObject:@"NCCN指南"];
////    [self.categoryList addObject:@"心内科"];
////    [self.categoryList addObject:@"血液科"];
////    [self.categoryList addObject:@"神经内科"];
////    [self.categoryList addObject:@"内分泌科"];
////    [self.categoryList addObject:@"消化科"];
////    [self.categoryList addObject:@"肝病科"];
////    [self.categoryList addObject:@"感染科"];
////    [self.categoryList addObject:@"肿瘤科"];
////    [self.categoryList addObject:@"呼吸科"];
////    [self.categoryList addObject:@"肾内科"];
////    [self.categoryList addObject:@"风湿免疫科"];
////    [self.categoryList addObject:@"精神科"];
////    [self.categoryList addObject:@"普通外科"];
////    [self.categoryList addObject:@"神经外科"];
////    [self.categoryList addObject:@"胸心外科"];
////    [self.categoryList addObject:@"骨科"];
////    [self.categoryList addObject:@"泌尿外科"];
////    [self.categoryList addObject:@"整形外科"];
////    [self.categoryList addObject:@"麻醉科"];
////    [self.categoryList addObject:@"妇产科"];
////    [self.categoryList addObject:@"儿科"];
////    [self.categoryList addObject:@"皮肤性病科"];
////    [self.categoryList addObject:@"眼科"];
////    [self.categoryList addObject:@"耳鼻咽喉科"];
////    [self.categoryList addObject:@"口腔科"];
////    [self.categoryList addObject:@"急诊/重症"];
////    [self.categoryList addObject:@"影像科"];
////    [self.categoryList addObject:@"检验科"];
//    
//    [super didRequestWithData:datas Status:status Sender:requstManager];
//    
//}

@end

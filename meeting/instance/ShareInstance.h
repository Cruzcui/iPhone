//
//  ShareInstance.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKCategoryViewController.h"
@interface ShareInstance : NSObject
@property (nonatomic,retain) HKCategoryViewController * categroyForZhinanYuanWen;
@property (nonatomic,retain) HKCategoryViewController * categroyForCommunicate;
@property (nonatomic,retain) HKCategoryViewController * categroyForTools;
@property (nonatomic,retain) NSDictionary * KeshiDic;
@property (nonatomic,retain) NSDictionary * MyZhiNanDic;
@property (nonatomic,copy) NSString * WenJianJiaName;
@property (nonatomic,assign) int PicName;
@property (nonatomic,retain) NSDictionary * MyNoteDic;
@property (nonatomic,retain) NSDictionary * MyPPTDic;
@property (nonatomic,retain) NSDictionary * MyVideoDic;
@property (nonatomic,retain) NSDictionary * MyBiBaoDic;
@property (nonatomic,retain) NSDictionary * MyToolsDic;
@property (nonatomic,retain) NSMutableDictionary * ZhiNanMuLu;

@property (nonatomic,retain) NSArray* categroyDatas;

+(ShareInstance *)instance;
@end

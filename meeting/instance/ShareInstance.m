//
//  ShareInstance.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "ShareInstance.h"

@implementation ShareInstance

static ShareInstance * shareInstance = nil;
+(ShareInstance *)instance{
    @synchronized(self) {
        if (shareInstance == nil) {
            shareInstance = [[ShareInstance alloc] init];
            shareInstance.categroyForZhinanYuanWen = nil;
            shareInstance.categroyForCommunicate = nil;
            shareInstance.categroyForTools = nil;
            shareInstance.KeshiDic = nil;
            shareInstance.MyZhiNanDic = nil;
            shareInstance.WenJianJiaName = @"";
            shareInstance.PicName = 9999;
            shareInstance.MyNoteDic = nil;
            shareInstance.MyBiBaoDic = nil;
            shareInstance.MyPPTDic = nil;
            shareInstance.MyVideoDic = nil;
            shareInstance.MyToolsDic = nil;
            shareInstance.ZhiNanMuLu = [[NSMutableDictionary alloc] init];
        }
    }
    return  shareInstance;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
            return  shareInstance;
        }
    }
    return  nil;
}

@end

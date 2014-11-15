//
//  HKMyPPTViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HHDomainBase.h"
#import "HKCommunicateDomain.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
@interface HKMyPPTViewController :  UITableViewController<HHDomainBaseDelegate,MWPhotoBrowserDelegate,MJRefreshBaseViewDelegate>{
    NSArray * _arrayData;
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataForHuanDeng;
    NSMutableDictionary * _HUANDENGparam;
    int _count;
    HKCommunicateDomain *domainDetail;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    HKCommunicateDomain * _domainSelected;
    HKCommunicateDomain * _domainDownload;
    int _index;
    int _fileName;
    int _totaCount;
    MBProgressHUD * _hud;
    MBProgressHUD * _huddownload;
}
@property (nonatomic,retain) NSMutableArray* photos;
@property (nonatomic,retain) NSMutableArray * urls;
@property (nonatomic,retain) NSArray * arrayMeeting;
@property (nonatomic,assign) BOOL meetingflag;
-(void)getDataFromHuandeng:(NSDictionary *)Params;
-(void)removeAllData;
@end

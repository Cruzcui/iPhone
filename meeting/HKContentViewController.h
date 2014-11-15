//
//  HKContentViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKToolsDomain.h"
#import "ShareInstance.h"
#import "MBProgressHUD.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "HKCommunicateDomain.h"
@interface HKContentViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    NSMutableArray * _dataArray;
    HKToolsDomain * _domain;
    ShareInstance * _share;
    int _count;
    MBProgressHUD * _hud;
    NSMutableDictionary * _paramDic;
    UIWindow *window;
    MJRefreshHeaderView * _header;
    MJRefreshFooterView * _footer;
    HKToolsDomain * _domainSelected;
}
@property (nonatomic,copy) NSString * dictcatkey;
@property (nonatomic,retain) NSDictionary * titleDic;
@end

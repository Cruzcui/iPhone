//
//  HKHelpViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MBProgressHUD.h"
@interface HKHelpViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKCommunicateDomain *_domain;
    NSMutableDictionary * _HelperParamsDic;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    int _NumberOfPage;
    MBProgressHUD * _hud;
}
-(void)removeAllData;
-(void)getDataFromHelper:(NSDictionary *)Params;
@end

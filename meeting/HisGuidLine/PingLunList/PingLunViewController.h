//
//  PingLunViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-28.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKReloadTableViewController.h"
#import "HHDomainBase.h"
#import "HKCommunicateDomain.h"
#import "HKCategorySearchDomain.h"
#import "MBProgressHUD.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface PingLunViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKCategorySearchDomain * _domain;
    NSMutableArray * _dataArray;
    int _count;
    NSMutableDictionary * params;
    MBProgressHUD * _hud;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
}
@property (nonatomic,retain) NSDictionary* guidline;
@property (nonatomic,copy) NSString * pkey;
-(id) initWithStyle:(UITableViewStyle)style GuidLine:(NSDictionary *)guidl andPkey:(NSString *)pkey;
@end

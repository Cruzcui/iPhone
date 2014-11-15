//
//  HKCalToolsViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-23.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKToolsDomain.h"
#import "HKHisListViewController.h"
#import "MBProgressHUD.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface HKCalToolsViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKToolsDomain * _domain;
    MBProgressHUD * _hud;
    UIWindow *window;
    HKToolsDomain * _domainNext;
    int _indexRow;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    
}
@property (nonatomic,retain) NSMutableArray* messages;
@property (nonatomic,copy) NSString * dictcattype;
@property (nonatomic,copy) NSString * parentkey;


@end

//
//  HKHelpContentViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpContentCell.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HKCommunicateDomain.h"
#import "DrHuiFuCell.h"
#import "HuiFuHuiFuCell.h"
@interface HKHelpContentViewController : UITableViewController<MJRefreshBaseViewDelegate,HHDomainBaseDelegate,CellDelegete,CellsDelegete> {
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    HKCommunicateDomain * _domain;
    NSMutableDictionary * _paramDic;
    int _NumberOfPage;
    NSMutableArray * _dataSourceArray;
}
@property (nonatomic,retain) NSDictionary * ContentDic;
@end

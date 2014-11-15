//
//  HKHelpContentViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HKExpertDomain.h"
#import "ExpertHuiFuCell.h"
#import "ExpertHuiFuHuiFuCell.h"
#import "ExpertHeader.h"
#import "ExpertContentCell.h"
@interface HKExpertContentViewController : UITableViewController<MJRefreshBaseViewDelegate,HHDomainBaseDelegate,CellDelegete> {
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    HKExpertDomain * _domain;
    HKExpertDomain * _domainForList;
    NSMutableDictionary * _paramDic;
    int _NumberOfPage;
    NSMutableArray * _dataSourceArray;
    ExpertHeader * Expertheader;
}
@property (nonatomic,retain) NSDictionary * ContentDic;
@end

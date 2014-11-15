//
//  HKExplainDetailViewController.h
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "HHDomainBase.h"
#import "HKCommunicateDomain.h"
#import "MWPhotoBrowser.h"
@interface HKExplainDetailViewController : UITableViewController<MWPhotoBrowserDelegate,HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataForHuanDeng;
    NSMutableDictionary * _HUANDENGparam;
    int _count;
    HKCommunicateDomain * _domainDetail;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
}
@property (nonatomic) int displayType;

- (id)initWithStyle:(UITableViewStyle)style ExplainData:(NSDictionary*) data;

@end

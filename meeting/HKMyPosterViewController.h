//
//  HKMyPosterViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HKCommunicateDomain.h"
#import "HKPostCell.h"
@interface HKMyPosterViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    NSMutableArray * _arrayForBiBao;
    NSMutableDictionary * _BiBaoParams;
    HKCommunicateDomain * _domain;
    int _count;
    HKCommunicateDomain * _domainSelected;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
}
-(void)getDataFromBiBao:(NSDictionary *)Params;
-(void)removeAllData;
@end

//
//  HKNewsTableViewController.h
//  HisGuidline
//
//  Created by kimi on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "HKCategorySearchDomain.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface HKNewsTableViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKCategorySearchDomain * _domain;
    NSMutableDictionary * _paramsDic;
    int _pageNumber;
    NSIndexPath * _IndexP;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
}
-(void) getNetData;
@end

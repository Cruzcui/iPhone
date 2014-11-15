//
//  HKSystemMessageViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"

@interface HKSystemMessageViewController : UITableViewController<MJRefreshBaseViewDelegate>{
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
}

@end

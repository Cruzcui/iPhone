//
//  HKHisToolsViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface HKHisToolsViewController : UIViewController<HKDLCategoryListViewControllerDelegate> {
    ShareInstance * _share;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;

}
@property (nonatomic,retain) NSDictionary * dic;
@end

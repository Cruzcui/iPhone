//
//  HKRegTableViewController.h
//  HisGuidline
//
//  Created by kimi on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLoginDomain.h"
#import "MBProgressHUD.h"
@interface HKRegTableViewController : UITableViewController<HHDomainBaseDelegate> {
    HKLoginDomain * _domain;
    MBProgressHUD * _hud;
}

@end

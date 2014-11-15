//
//  UserInfoController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-7.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeshiListController.h"
#import "HKUserDomain.h"
#import "MBProgressHUD.h"
@interface UserInfoController : UITableViewController<HKDLCategoryListViewControllerDelegate,HHDomainBaseDelegate> {
    int NumberOfRow;
    HKUserDomain * _domain;
    MBProgressHUD * _hud;
    UIToolbar * topView;
    CGRect Rootrect;
    UIViewController *topController;
    UIAlertView * _alert;
}
@property (nonatomic,retain) NSDictionary * userdic;
@end

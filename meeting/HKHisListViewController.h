//
//  HKHisListViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-4.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKToolsDomain.h"
#import "MBProgressHUD.h"
@interface HKHisListViewController : UITableViewController<HHDomainBaseDelegate> {
    HKToolsDomain * _domain;
    HKToolsDomain * _domainNext;
    int _indexRow;
    MBProgressHUD * _hud;
    UIWindow *window;
    
}
@property (nonatomic,retain) NSMutableArray* messages;
@property (nonatomic,copy) NSString * dictcattype;
@property (nonatomic,copy) NSString * parentkey;
@property (nonatomic,retain) NSDictionary *titleDic;
@end

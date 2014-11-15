//
//  HKMySelectedVideoViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "ShareInstance.h"
@interface HKMySelectedVideoViewController : UITableViewController<HHDomainBaseDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataArray;
    HKCommunicateDomain * _domainDelete;
    ShareInstance * _share;
    int  indexRow;
    UIAlertView * _alert;
}

@end

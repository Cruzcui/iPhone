//
//  MyBiBaoViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-2.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "ShareInstance.h"
@interface MyBiBaoViewController : UITableViewController<HHDomainBaseDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataArray;
    ShareInstance * _share;
    HKCommunicateDomain * _domainDelete;
}

@end

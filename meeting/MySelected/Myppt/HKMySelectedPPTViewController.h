//
//  HKMyPPTViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "MWPhotoBrowser.h"
#import "ShareInstance.h"
@interface HKMySelectedPPTViewController : UITableViewController<HHDomainBaseDelegate,MWPhotoBrowserDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataArray;
    HKCommunicateDomain * domainDetail;
    ShareInstance * _share;
    HKCommunicateDomain * _domainDelete;
    UIAlertView * _alert;
}
@property (nonatomic,retain) NSArray * file;
@property (nonatomic,retain) NSMutableArray* photos;
@property (nonatomic,retain) NSMutableArray * sortFiles;
@property (nonatomic,retain) NSMutableArray * PPTs;
@end

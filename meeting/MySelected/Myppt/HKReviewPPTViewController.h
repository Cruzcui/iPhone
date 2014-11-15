//
//  HKReviewPPTViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "MWPhotoBrowser.h"
#import "HKCommunicateDomain.h"
@interface HKReviewPPTViewController : UITableViewController<HHDomainBaseDelegate,MWPhotoBrowserDelegate> {
    ShareInstance * _share;
    HKCommunicateDomain * domainDetail;
    
}
@property (nonatomic,retain) NSMutableArray* photos;

@end

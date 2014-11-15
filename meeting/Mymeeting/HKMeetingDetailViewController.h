//
//  HKMeetingDetailViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-3-3.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingDomain.h"
@interface HKMeetingDetailViewController : UITableViewController<HHDomainBaseDelegate> {
    MeetingDomain * _domain;
}
@property (nonatomic,copy) NSString * Maintitle;
@property (nonatomic,copy) NSString * pkey;
@property (nonatomic,retain) NSDictionary * dataSource;
@end

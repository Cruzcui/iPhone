//
//  HKVotesViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HKCommunicateDomain.h"
#import "HHDomainBase.h"
#import "MBProgressHUD.h"
@interface HKVotesViewController : UITableViewController<HHDomainBaseDelegate,MJRefreshBaseViewDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataForVotes;
    NSMutableDictionary * _Votesparam;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    int _count;
    MBProgressHUD * _hud;

}
-(void)getDataFromVotes:(NSDictionary *)Params;
-(void)removeAllData;
@property (nonatomic,retain) NSArray * arrayForMeeting;
@property (nonatomic,assign) BOOL MeetingFlag;
@end

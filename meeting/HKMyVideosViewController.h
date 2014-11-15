//
//  HKMyVideosViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "HHDomainBase.h"
#import "HKCommunicateDomain.h"
#import "MWPhotoBrowser.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
@interface HKMyVideosViewController :  UITableViewController<HHDomainBaseDelegate,MWPhotoBrowserDelegate,MJRefreshBaseViewDelegate>{
    NSArray * _arrayData;
    HKCommunicateDomain * _domain;
    NSMutableArray * _dataForVidio;
    NSMutableDictionary * _Vidioparam;
    int _count;
    HKCommunicateDomain *domainDetail;
    MPMoviePlayerViewController *_play;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    HKCommunicateDomain * _domainSelected;
    MBProgressHUD * _hud;
}
@property (nonatomic,retain) NSMutableArray* photos;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,retain)NSDictionary * titleDic;
@property (nonatomic,retain) NSArray * arraymeeting;
@property (nonatomic,assign) BOOL meetingflag;
-(void)getDataFromVidio:(NSDictionary *)Params;
-(void)removeAllData;
@end

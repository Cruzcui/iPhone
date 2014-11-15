//
//  HKGuidSearchViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-8.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShareInstance.h"
#import "HKCategorySearchDomain.h"
#import "MBProgressHUD.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"


@interface HKGuidSearchViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate,UIAlertViewDelegate,HHDomainBaseDelegate,MJRefreshBaseViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate> {
    ShareInstance * _share;
    HKCategorySearchDomain * _domain;
    HKCategorySearchDomain * _domainMuLu;
    HKCategorySearchDomain * _domainDetail;
    NSMutableArray * _pkeyArray;
    NSMutableArray * _urlListArray;
    NSString * _childrenPkey;
    int  _childrenIndex;
    MBProgressHUD * _hud;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    //存放PDF 二进制流
    NSMutableData *_data;
    int _PDFIndex;
}

//2014-2-20 by kimi 页面类型 1:重点推荐 0:指南精度
@property (nonatomic) int pageType;

//当前科室ID，1：为重点推荐
@property (nonatomic,copy) NSString* sectionkey;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)  UITableView *cagetoryTableView;


@property (retain, nonatomic) IBOutlet UIView *detailView;

@property (nonatomic,retain) NSArray * arrayMeeting;
@property (nonatomic,assign) BOOL meetingFlag;
@property (nonatomic,assign) BOOL frashFlag;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(int)type;



@end

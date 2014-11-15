//
//  HKLatestZhiNanViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-2-10.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "HKCategorySearchDomain.h"
#import "MBProgressHUD.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface HKLatestZhiNanViewController : UITableViewController<UIAlertViewDelegate,HHDomainBaseDelegate,MJRefreshBaseViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate> {
    ShareInstance * _share;
    int selectedRow;
    NSMutableArray * _datasourceArray;
    NSMutableDictionary * _dicParams;
    NSDictionary * _datasourceDic;
    int _count;
    HKCategorySearchDomain * _domain;
    HKCategorySearchDomain * _domainMuLu;
    HKCategorySearchDomain * _domainDetail;
    NSMutableArray * _pkeyArray;
    NSString * _childrenPkey;
    int  _childrenIndex;
    MBProgressHUD * _hud;
    MJRefreshFooterView * _footer;
    MJRefreshHeaderView * _header;
    
    
    //NSMutableArray * _pkeyArray;
    NSMutableArray * _urlListArray;
   // NSString * _childrenPkey;
   // int  _childrenIndex;
    //MBProgressHUD * _hud;
    //MJRefreshFooterView * _footer;
   // MJRefreshHeaderView * _header;
    //存放PDF 二进制流
    NSMutableData *_data;
    int _PDFIndex;


}

@end

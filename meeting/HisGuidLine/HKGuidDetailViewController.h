//
//  HKGuidDetailViewController.h
//  HisGuidline
//
//  Created by kimi on 13-9-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCategorySearchDomain.h"
#import "PingLunCell.h"
#import "PingLunBtnCell.h"
#import "MBProgressHUD.h"
#import "ZhiNanViewCell.h"
#import "ShareInstance.h"


@interface HKGuidDetailViewController : UITableViewController<HHDomainBaseDelegate,CellDelegate> {
    HKCategorySearchDomain * _domainPingLun;
    HKCategorySearchDomain * _domainScore;
    NSArray * _ScoreData;
    NSMutableArray * _dataSourceArray;
    NSMutableDictionary * _flagBool;
    
    UITableView * _headertableView;
    UILabel * _labelTittle;
    UILabel * _labelPublisher;
    NSArray * _PingLunArray;
    int _flag;
    int _btnFlag;
    MBProgressHUD * _hud;
    MBProgressHUD * _hud1;
    UIWindow *window;
    ShareInstance * _share;
    int ExplainCount;
}

@property (nonatomic,retain) NSDictionary* guidline;
@property (nonatomic,copy) NSString * pkey;
@property (nonatomic,retain) NSMutableArray * allNodes;
@property (nonatomic,retain) NSMutableArray * childrenNodes;
@property (nonatomic,assign) BOOL pptflag;
@property (nonatomic,assign) BOOL videoflag;
-(id) initWithStyle:(UITableViewStyle)style GuidLine:(NSArray *)guidl andPkey:(NSString *)pkey andtitleDic:(NSDictionary *)titleDic andAllNodes:(NSMutableArray *)allNodes;

@end

//
//  PostVoteVIewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "MBProgressHUD.h"
@interface PostVoteVIewController : UIViewController<HHDomainBaseDelegate> {
    int _NumberOfQ;
    UITextView * titleView;
    UITextView * contentView;
    UILabel * labelmark;
    UITextField * contentQ;
    UIButton * addQ;
    UIScrollView * backScroll;
    UISegmentedControl * segment;
    UIButton * PostBtn;
    HKCommunicateDomain * _domain;
    UIToolbar * topView;
    CGRect Rootrect;
    UIViewController *topController;
    UIColor * mycolor;
    int _type;
    MBProgressHUD * _hud;
}
@property (nonatomic,retain) NSDictionary * dataSorce;
@end

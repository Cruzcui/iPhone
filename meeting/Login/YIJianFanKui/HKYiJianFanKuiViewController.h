//
//  HKYiJianFanKuiViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUserDomain.h"
#import "MBProgressHUD.h"
@interface HKYiJianFanKuiViewController : UIViewController<UITextViewDelegate,HHDomainBaseDelegate> {
    UIToolbar * topView;
    CGRect Rootrect;
    UIViewController *topController;
    HKUserDomain * _domain;
    MBProgressHUD * _hud;
}
@property (nonatomic,retain) IBOutlet UILabel * labelTitle;
@property (nonatomic,retain) IBOutlet UILabel *label1;
@property (nonatomic,retain) IBOutlet UILabel * label2;
@property (nonatomic,retain) IBOutlet UILabel * label3;
@property (nonatomic,retain) IBOutlet UITextView * textcontent;
@property (nonatomic,retain) IBOutlet UITextField * numberfield;
@property (nonatomic,retain) IBOutlet UIButton * btnSend;
@end

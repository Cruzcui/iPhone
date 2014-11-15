//
//  HKChangePasswordViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-20.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUserDomain.h"
#import "MBProgressHUD.h"
@interface HKChangePasswordViewController : UIViewController<HHDomainBaseDelegate> {
    HKUserDomain * _domain;
    MBProgressHUD * _hud;
     UIToolbar * topView;
}
@property (nonatomic,retain)IBOutlet UITextField * oldpassword;
@property (nonatomic,retain)IBOutlet UITextField * newpassword;
@property (nonatomic,retain)IBOutlet UITextField * configurepassword;
@property (nonatomic,retain) IBOutlet UIButton * btn;
@end

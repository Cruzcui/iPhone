//
//  HKLoginController.h
//  meeting
//
//  Created by kimi on 13-6-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLoginDomain.h"

@interface HKLoginController : UIViewController<HHDomainBaseDelegate,UIAlertViewDelegate> {
    UIToolbar * topView;
}

@property (nonatomic,retain) HKLoginDomain* loginDomain;

@end

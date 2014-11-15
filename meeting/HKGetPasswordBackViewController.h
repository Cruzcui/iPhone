//
//  HKGetPasswordBackViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-3-6.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLoginDomain.h"
@interface HKGetPasswordBackViewController : UIViewController<HHDomainBaseDelegate> {
    HKLoginDomain * _domain;
      UIToolbar * topView;
}
@property (nonatomic,retain) IBOutlet UITextField * account;
@property (nonatomic,retain) IBOutlet UITextField * phoneNumber;
@property (nonatomic,retain) IBOutlet UIButton * btn;
@end

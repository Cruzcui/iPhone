//
//  HelpContentPostViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "MBProgressHUD.h"
@interface HelpContentPostViewController : UIViewController<HHDomainBaseDelegate> {
    HKCommunicateDomain* _domain;
    UIToolbar * topView;
    UIViewController *topController;
    CGRect Rootrect;
    MBProgressHUD * _hud;

}
@property (nonatomic,retain) NSDictionary *InfoDic;
@property (nonatomic,retain) IBOutlet UITextView *titleView;
@property (nonatomic,retain) IBOutlet UITextView *contentView;
@end

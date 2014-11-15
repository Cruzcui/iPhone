//
//  HKGengXinViewController.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface HKGengXinViewController : UIViewController {
    MBProgressHUD * _hud;
}

@property (nonatomic,retain) IBOutlet UILabel* versionLabel;

@end

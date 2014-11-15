//
//  HKTabViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoController.h"
@interface HKTabViewController : UITabBarController {
    BOOL _flag;
 
    UserInfoController * _userInfo;
}

@end

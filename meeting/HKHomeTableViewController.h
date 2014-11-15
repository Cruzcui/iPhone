//
//  HKHomeTableViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "MyProfile.h"
@interface HKHomeTableViewController : UITableViewController {
    ShareInstance * _share;
    MyProfile * _profile;
}

@end

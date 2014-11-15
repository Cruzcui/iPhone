//
//  MyZhiNanMoreViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
@interface MyZhiNanMoreViewController : UITableViewController {
    ShareInstance * _share;
    NSMutableArray * sortFiles;
    
    UIAlertView * _alert;
}

@end

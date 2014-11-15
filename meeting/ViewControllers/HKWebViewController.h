//
//  HKWebViewController.h
//  meeting
//
//  Created by kimi on 13-7-2.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface HKWebViewController : UIViewController<UIWebViewDelegate> {
    MBProgressHUD * _hud;
    UIColor * _barColor;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Title:(NSString*) title HTML:(NSString*) html;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Title:(NSString*) title URL:(NSURL*) url;
@property (nonatomic,retain) NSDictionary * titleDics;
@property (nonatomic,assign) BOOL editFlag;
@property (nonatomic,assign) BOOL ZhiNanflag;
@property (nonatomic,assign) BOOL referrenceFlag;
@end

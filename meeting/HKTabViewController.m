//
//  HKTabViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKTabViewController.h"
#import "HKHomeTableViewController.h"
#import "HKGuidSearchViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "HKSystemMessageViewController.h"
#import "HKExplainListViewController.h"
#import "HKCommunicateController.h"
#import "HKMMDrawerController.h"
#import "HKCategoryViewController.h"
#import "HKHisToolsViewController.h"
#import "ShareInstance.h"
#import "HKMainViewController.h"
#import "HKLoginController.h"
#import "HKMianzeViewController.h"
#import "HKAboutUsViewController.h"
#import "HKGengXinViewController.h"
#import "HKYiJianFanKuiViewController.h"
#import "MyProfile.h"
#import "HKChangePasswordViewController.h"
#import "HKMyMeetingViewController.h"
#import "HKHomeTableViewController.h"
#import "MeetingConst.h"
#import "HHHelpViewController.h"
@interface HKTabViewController ()

@end

@implementation HKTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        //left button
     
        UIButton* btnBack = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
        
        [btnBack setBackgroundImage:[UIImage imageNamed:@"left_menu.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barItemBack = [[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
        
        self.navigationItem.leftBarButtonItem = barItemBack;
        
        
        
        //right message button
        
        UIButton* btnMessage = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
        
        [btnMessage setBackgroundImage:[UIImage imageNamed:@"right_fav.png"] forState:UIControlStateNormal];
        [btnMessage addTarget:self action:@selector(goSelecteds) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barItemMessage = [[[UIBarButtonItem alloc] initWithCustomView:btnMessage] autorelease];
        
        self.navigationItem.rightBarButtonItem = barItemMessage;

        _flag = NO;
       
        //添加用户及系统设置消息通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserInfoController) name:@"USERINFO" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserMianZeController) name:@"MIANZE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserAboutController) name:@"ABOUT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goGengXinController) name:@"GENGXIN" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goYiJianFanKui) name:@"FANKUI" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goZhiZhen) name:@"ZHIZHEN" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goChangePassword) name:@"CHANGEPASSWORD" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goSelected) name:@"MySelected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeddrawer) name:@"CLOSE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gocaozuozhinan) name:@"CAOZUOZHINAN" object:nil];


           }
    return self;
}
-(void) closeddrawer {
    [self.mm_drawerController setOpenDrawerGestureModeMask:0];
}

-(void)gocaozuozhinan {
    if (![self.navigationController.visibleViewController isKindOfClass:[HHHelpViewController class]]) {
        
        HHHelpViewController * help = [[[HHHelpViewController alloc] init] autorelease];
        [help loadImages:@"startView" count:6];
        //[help setSaveFlag:FirstRunFlag];
        [self presentViewController:help animated:YES completion:^{
            
        }];
        //[self.navigationController pushViewController:help animated:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];
        
    };
    
}

-(void)goChangePassword {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKChangePasswordViewController class]]) {
        
        HKChangePasswordViewController* yijian = [[[HKChangePasswordViewController alloc] initWithNibName:@"HKChangePasswordViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:yijian animated:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];
        
    };

}
-(void)goZhiZhen {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKMianzeViewController class]]) {
        MyProfile * proflie = [MyProfile myProfile];
        
        NSString * url = [NSString stringWithFormat:@"http://121.199.26.12:8080/mguid/user/phone/score/%@.html",[proflie.userInfo stringForKey:@"pkey"]];
        NSURL * urls = [NSURL URLWithString:url];
        HKMianzeViewController* webController = [[[HKMianzeViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:@"指针信息" URL:urls] autorelease];
        
        webController.editFlag = YES;
        
        [self.navigationController pushViewController:webController animated:YES];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        
    };

}
-(void)goYiJianFanKui {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKYiJianFanKuiViewController class]]) {
        
        HKYiJianFanKuiViewController* yijian = [[[HKYiJianFanKuiViewController alloc] initWithNibName:@"HKYiJianFanKuiViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:yijian animated:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        }];
        
    };
}
-(void)goUserInfoController {
  
    if (![self.navigationController.visibleViewController isKindOfClass:[UserInfoController class]]) {
      UserInfoController *userInfo = [[[UserInfoController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [self.navigationController pushViewController:userInfo animated:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];

    };
    
    
}
-(void)goUserMianZeController {
    
    if (![self.navigationController.visibleViewController isKindOfClass:[HKMianzeViewController class]]) {
        NSURL * url = [NSURL URLWithString:@"http://121.199.26.12:8080/mguid/description.html"];
        HKMianzeViewController* webController = [[[HKMianzeViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:@"免责声明" URL:url] autorelease];
        
        webController.editFlag = YES;
        
        [self.navigationController pushViewController:webController animated:YES];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        
    };

}
-(void)goUserAboutController {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKAboutUsViewController class]]) {
        NSURL * url = [NSURL URLWithString:@"http://121.199.26.12:8080/mguid/aboutus.html"];
        HKAboutUsViewController* webController = [[[HKAboutUsViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:@"关于我们" URL:url] autorelease];
        
        webController.editFlag = YES;
        
        [self.navigationController pushViewController:webController animated:YES];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        
    };

}
-(void) goGengXinController {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKGengXinViewController class]]) {
        
        HKGengXinViewController* gengxin = [[[HKGengXinViewController alloc] initWithNibName:@"HKGengXinViewController" bundle:nil] autorelease];
        
       
        
        [self.navigationController pushViewController:gengxin animated:YES];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        
    };

}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMCloseDrawerGestureModeAll];//开启滚动效果
   //开启滚动效果
   
    //登陆
//    if ([[NSUserDefaults  standardUserDefaults] objectForKey:@"username"]==nil || [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] == nil)
//    {
//        HKLoginController * loginController = [[HKLoginController alloc] init];
//        [self presentModalViewController:loginController animated:YES];
//    }
//    if ([[NSUserDefaults  standardUserDefaults] objectForKey:@"username"]!=nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] != nil)
//    {
//        
//    }
//    if (_flag == NO) {
//        HKLoginController * loginController = [[HKLoginController alloc] init];
//        [self presentModalViewController:loginController animated:YES];
//        _flag = YES;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    HKLoginController * loginController = [[HKLoginController alloc] init];
//    [self presentModalViewController:loginController animated:YES];

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.tabBar.translucent = NO;
        
        
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           getUIColor(Color_light_gray), UITextAttributeTextColor, nil]
                                                 forState:UIControlStateNormal];
        
        [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil] forState:UIControlStateSelected];
        

    }
       self.title = @"医学指南针";
    //单例初始化
    ShareInstance * share = [ShareInstance instance];
    
    //2014-2-20 by kimi 指南推荐
    
    HKGuidSearchViewController* guidFavViewController = [[[HKGuidSearchViewController alloc] initWithNibName:@"HKGuidSearchViewController" bundle:nil type:1] autorelease];
    [self addChildViewController:guidFavViewController];

    
    //指南原文
    HKCategoryViewController * categoryViewForZhiNanYuanWen = [[[HKCategoryViewController alloc] init] autorelease];
    share.categroyForZhinanYuanWen = categoryViewForZhiNanYuanWen;
    
    
    //指南精读
    HKGuidSearchViewController* guidViewController = [[[HKGuidSearchViewController alloc] initWithNibName:@"HKGuidSearchViewController" bundle:nil] autorelease];
    
    [self addChildViewController:guidViewController];

    
   
    //我的讨论
    HKCommunicateController* commViewController = [[[HKCommunicateController alloc] initWithNibName:@"HKCommunicateController" bundle:nil] autorelease];
    HKCategoryViewController * categoryForCommunicate = [[[HKCategoryViewController alloc] init]autorelease];
    
    share.categroyForCommunicate = categoryForCommunicate;
    
    MMDrawerController * drawerCommController = [[HKMMDrawerController alloc]
                                                 initWithCenterViewController:commViewController
                                                 leftDrawerViewController: categoryForCommunicate
                                                 rightDrawerViewController:nil];
    [drawerCommController setMaximumLeftDrawerWidth:160.0];
    [drawerCommController setMaximumRightDrawerWidth:160.0];
    [drawerCommController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerCommController setCloseDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    drawerCommController.tabBarItem.title = @"学术天地";
    drawerCommController.tabBarItem.image = [UIImage imageNamed:@"tab04.png"];
    [self addChildViewController:drawerCommController];
    
    
    //医学工具
    HKHisToolsViewController* toolViewController = [[[HKHisToolsViewController alloc] initWithNibName:@"HKHisToolsViewController" bundle:nil] autorelease];
    
    [self addChildViewController:toolViewController];

    
    //我的会议
    HKMyMeetingViewController* meetingController = [[[HKMyMeetingViewController alloc] initWithNibName:@"HKMyMeetingViewController" bundle:nil] autorelease];
    
    [self addChildViewController:meetingController];
    
    
    
    //tab bar 颜色
    
    [self.tabBar setBarTintColor:getUIColor(Color_tabbar_background)];
    [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    //[self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tab04.png"]];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"医学工具"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果
    }
    if ([item.title isEqualToString:@"学术天地"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果
    }
    if ([item.title isEqualToString:@"我的会议"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果
    }
    if ([item.title isEqualToString:@"指南精读"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果
        [self.mm_drawerController setCloseDrawerGestureModeMask:0];
    }
    if ([item.title isEqualToString:@"重点推荐"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];//开启滚动效果
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
}
-(void)goSelected {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKHomeTableViewController class]]) {
        
        HKHomeTableViewController* mySelected = [[[HKHomeTableViewController alloc] init] autorelease];
        
        
        
        [self.navigationController pushViewController:mySelected animated:YES];
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
        }];
        
        
    };
  [self.mm_drawerController setOpenDrawerGestureModeMask:0];//开启滚动效果

}
-(void)goSelecteds {
    if (![self.navigationController.visibleViewController isKindOfClass:[HKHomeTableViewController class]]) {
        
        HKHomeTableViewController* mySelected = [[[HKHomeTableViewController alloc] init] autorelease];
        
        
        
        [self.navigationController pushViewController:mySelected animated:YES];
        
        //        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        //
        //        }];
        
    };
    
    
}
//-(void)goSearchs {
//    [self setSelectedIndex:1];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:nil];
// }

-(void) leftButtonClick:(id) sender{
    
    UIViewController* currentController = [self.childViewControllers objectAtIndex:self.selectedIndex];
    if ( [currentController respondsToSelector:@selector(leftButtonClick:)] ) {
        [currentController performSelector:@selector(leftButtonClick:)];
    }else{
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
    
}

-(void) rightButtonClick:(id) sender{
    UIViewController* currentController = [self.childViewControllers objectAtIndex:self.selectedIndex];
    if ( [currentController respondsToSelector:@selector(rightButtonClick:)] ) {
        [currentController performSelector:@selector(rightButtonClick:)];
    }else{
        HKSystemMessageViewController* messageController = [[[HKSystemMessageViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        
        [self.navigationController pushViewController:messageController
                                             animated:YES];
    }
}
//-(BOOl)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
-(BOOL)shouldAutorotate {
    return NO;
}
-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end

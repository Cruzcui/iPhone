//
//  HKAppDelegate.m
//  meeting
//
//  Created by kimi on 13-6-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKAppDelegate.h"
#import "MyProfile.h"
//#import "BMapKit.h"
#import "MLNavigationController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "HKTabViewController.h"
#import "HKHomeNavigationController.h"
#import "HKLeftSideViewController.h"
#import "IQKeyBoardManager.h"
#import "HKLoginController.h"
#import "UIDevice+Resolutions.h"
#import "UMSocial.h"
#import "MobClick.h"
#import "MeetingConst.h"
#import "DES3Util.h"
@interface HKAppDelegate(){
   // BMKMapManager* _mapManager;
}

@end

@implementation HKAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addhud) name:@"isExistenceNetwork" object:nil];
    
    
    
    if (OSVersionIsAtLeastiOS7())
    {
        // handling statusBar (iOS7)
        self.window.clipsToBounds = YES;
        
        application.statusBarStyle = UIStatusBarStyleLightContent;
        
    }
    
    
    if (![UIDevice isRunningOniPhone5]) {
        HKLoginController *login = [[[HKLoginController alloc] initWithNibName:@"HKLoginFor5Controller" bundle:nil] autorelease];
        [self.window setRootViewController:login];

    }else {
        HKLoginController *login = [[[HKLoginController alloc] initWithNibName:@"HKLoginFor5Controller" bundle:nil] autorelease];
        [self.window setRootViewController:login];
    }

   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRoot) name:@"ROOT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZhuXiaoRoot) name:@"ZHUXIAO" object:nil];
    
    
    [UMSocialData setAppKey:@"52d65dfb56240b840a03efc2"];
    
    //设置微信AppId
    [UMSocialConfig setWXAppId:@"wxd9a39c7122aa6516" url:nil];
    //打开Qzone的SSO开关
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialConfig setQQAppId:@"100424468" url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
    //使用友盟统计
    [MobClick startWithAppkey:@"52d65dfb56240b840a03efc2"];
    
    
    [self.window makeKeyAndVisible];
    

    return YES;
}
-(void) addhud {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法连接网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


-(void) ZhuXiaoRoot {
    if (![UIDevice isRunningOniPhone5]) {
        HKLoginController *login = [[[HKLoginController alloc] initWithNibName:@"HKLoginFor5Controller" bundle:nil] autorelease];
        [self.window setRootViewController:login];
        
    }else {
        HKLoginController *login = [[[HKLoginController alloc] initWithNibName:@"HKLoginFor5Controller" bundle:nil] autorelease];
        [self.window setRootViewController:login];
    }

}
-(void)changeRoot {
    
    //主页面
    UINavigationController* navController = [[[HKHomeNavigationController alloc] init] autorelease];
  


    HKTabViewController* tabViewController = [[HKTabViewController alloc] init];
    
    [navController pushViewController:tabViewController animated:NO];
    
    //左侧菜单栏
    HKHomeNavigationController* lefNavController = [[[HKHomeNavigationController alloc] init] autorelease];
    lefNavController.isLeftMenu = YES;
    
    lefNavController.navigationBar.tintColor = [UIColor clearColor];
    //设置navigationbar的背景图片
    //[lefNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviback.jpg"] forBarMetrics:UIBarMetricsDefault];
    //    //自适应navigationbar的大小
    //lefNavController.navigationBar.clipsToBounds = YES;

    [lefNavController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor blackColor],
                                                            UITextAttributeTextColor,
                                                            [UIColor whiteColor],
                                                            UITextAttributeTextShadowColor,
                                                            [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                            UITextAttributeTextShadowOffset,
                                                            [UIFont boldSystemFontOfSize:0.0],
                                                            UITextAttributeFont,nil]];
    
    HKLeftSideViewController* leftTabViewController = [[[HKLeftSideViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    leftTabViewController.title = @"设置";
    [lefNavController pushViewController:leftTabViewController animated:NO];
    
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:navController
                                             leftDrawerViewController: lefNavController
                                             rightDrawerViewController:nil];
    [drawerController setMaximumLeftDrawerWidth:200.0];
    [drawerController setMaximumRightDrawerWidth:160.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    
    //////自定义抽屉手势   开始///////////
    
    //加密测试
    /*
    NSString* abc = @"自定义抽屉手势   开";
    NSString* coder = [DES3Util encrypt:abc];
   
    NSString* str = [DES3Util decrypt:@"+y01jTLjwD/uphPNHGRQjZbd9LJJf+8KACnMdPFFQaPFa97v0e0tNM/Y+ehqGc1REpIy/Kk5/wHA\nhs6Kk2dDWlS1khLAdJi47u5rouNfIGJLJHauUwo0oU5SqZuaNOkSrHMpMVR0mixup7YgpP+vDrWj\nmdDrU1sTKrt1UuQkHQ/QycEEoOeqqHZA0gGZsO9v3395Q7VJVklS4vpvM5JpUK5AK/mZjjZ7oUNQ\niuxK+YJhqE4J6EO7cYfk1Ly5tQSBKwN723/3CxkdZvV6gkcQVlMTtLpi6zHc65E5rmnvtaX/dfGZ\no0V0Io8/tKkR0nHuf719WLchA0spttCwsWb0EoOHs+0NBRWm8seSlIIIr83fYsB3WwrRwRGMrTNa\nzsopFoAvauWHVVgR3XjcayObpAfWUGL/9k+WGMx3R/WcHCuDWYOeoTRhKCG9OFw885IwDs5XlmW+\nMHAh9zgEaUMWm+su80P/R05Couh0gZgvdPp6HKHOVlpnnLZAHJ066J9azqtJXYO5BnlWogtWLMDN\nGHX2WRg5Fr0ClJbB+X3eSzCrVvEjb0TPoqULDI+u7yYQWdxdo2ErRJY6mUQxKuK4EBsTm7Phhrka\n1ORN3NwIWVxJaL2SBP10egqfuAXqK80mp1m456n8eineSBzZuLUbVg7SEZVum9OXamFfBH2Rwto1\nXamsuQf1KbPhUVwl/WLAcudLQjyw4NFFc5SmAXKdZyJB4aBqZPya7wyozJtF8MHvj1nGHyWOSBHN\nHrOKwimii0fvkEyKDgQt0G2OoiPYlJFtK31Tpo084lVH36DasrBnAL7pwwlHZvVYN3yw5YvmA0Zq\n4zapvrrQq0iI0SMdueE1ZJ65fIVNBcfu9l2cqwfgzH56BajYLgDDKi++35vnV8kczz5hr3sebvj4\niPK9TojSMesWjCkpUz/T8HRtZ92VFmyxsCrPKt2pUDD9OpmoSiJe7VJ1+iWlnJleEnGnIWBnF1qK\nS7RU1Ko+sokVnnG1t68o+PJluKIkYay/Lwf/up4COWUZCtGgArTZQ9wUdGItgsTxtb78/CQSdAzV\nyimrkG9RMzpB2j3AEA3zvqaDEXx9Ucm/LlVnroWbs/YJPugkAlb1ygwPjmCZUH9zOHJh9UHzzoSM\nwzJFgdKIkJ9n0Ie3hRj49QWOrU+yIawG3UOqlFKpi6eFXx93N1/jbg9S3Uo2NDGio8qBUoZBmvvY\nQxGzWFwY9VtslfBOgkbDCMWMPVGB8rMLSC1Avx9q/ot3VuKVDGV4lYtBLpuO0BMhkq04K6FW96r4\n/9dZjARd6jXeKszOiHZSKaxJVz1E40ta/N4srUKpkXB9D2EXgFoibY90Ncwz7NOQDj3cwwrQjPr3\naJNjUAlq6wHxwzJ8Bb52+o09FgkmRNp+9xWmfLaFOWHntBbolX1VSu3qiXWwvwiYKyAzCbTHTCcx\nVxJhbe+CCXqTP59fR+JY0ExFQJ7lHPTJhPQv/D3GrvBSTW/dXUGxI6/DYfbSxeiDQeVe5oQqUgWC\nJKWvy41UW1er1Zk0oG8/8NLgm1sTXAO0jAuNaYGOEUA5Z34t93zMvjzZVoUQJW3DxYyQOQ=="];
    
    NSLog(@"%@",str);
     */
    
    self.window.rootViewController = drawerController;

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//为了MPMoviePlayerViewController保持横平
//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
@end

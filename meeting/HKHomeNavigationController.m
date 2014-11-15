//
//  HKHomeNavigationController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHomeNavigationController.h"
#import "MWPhotoBrowser.h"
#import "UIViewController+MMDrawerController.h"
#import "MeetingConst.h"

@interface HKHomeNavigationController ()

@end

@implementation HKHomeNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isPresentModel = NO;
        self.isLeftMenu = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIColor * tintColor = getUIColor(Color_NavBarBackColor);
    
    if(OSVersionIsAtLeastiOS7()){
        
        // 禁用右滑切换
        self.interactivePopGestureRecognizer.enabled = NO;
        
        // 设置Bar背景色
        [self.navigationBar setBarTintColor:tintColor];
        
        // 设置Bar不透明
        [self.navigationBar setTranslucent:NO];
    }
    else {
        [self.navigationBar setTintColor:tintColor];
    }
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    /*
    if (viewController.navigationItem.rightBarButtonItem==nil) {
        
        
        //right button
        UIButton* btnHome = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
        
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
        [btnHome addTarget:self action:@selector(btnHomeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barItem = [[[UIBarButtonItem alloc] initWithCustomView:btnHome] autorelease];
        
        viewController.navigationItem.rightBarButtonItem = barItem;
        
        if (self.isPresentModel) {
            viewController.navigationItem.rightBarButtonItem = nil;
        }
        
    }
     */
    
    if (viewController.navigationItem.leftBarButtonItem == nil) {
        
        //back button
        
        if (!self.isLeftMenu) {
            UIButton* btnBack = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
            
            [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
            [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem* barItemBack = [[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
            
            viewController.navigationItem.leftBarButtonItem = barItemBack;
        }
        
        

    }
    
    if ([viewController isKindOfClass:[MWPhotoBrowser class]]) {
        self.mm_drawerController.autoRate = YES;
    }else{
        self.mm_drawerController.autoRate = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void) btnHomeClick:(id) sender{
    
    self.mm_drawerController.autoRate = NO;
    
    if (self.isPresentModel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popToRootViewControllerAnimated:YES];
    }
    
    
    
}

-(void) btnBackClick:(id) sender{
    self.mm_drawerController.autoRate = NO;
    if (self.isPresentModel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popViewControllerAnimated:YES];
    }
    
    
}

- (BOOL)shouldAutorotate

{
    
    
    return NO;
    
}


-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return UIInterfaceOrientationMaskLandscape;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    return NO;
    
}



@end

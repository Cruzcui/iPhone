//
//  HKLoginController.m
//  meeting
//
//  Created by kimi on 13-6-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKLoginController.h"
#import "MBProgressHUD.h"
#import "MyProfile.h"
#import "HKRegTableViewController.h"
#import "HKGetPasswordBackViewController.h"
#import "HKHomeNavigationController.h"
#import "HHHelpViewController.h"
#define FirstRunFlag @"SameCity_FirstRun_Flag_1.0"
@interface HKLoginController ()

@property (retain,nonatomic) IBOutlet UIImageView *imageView;

@property (retain,nonatomic) IBOutlet UITextField *txtUser;
@property (retain,nonatomic) IBOutlet UITextField *txtPwd;

@property (retain,nonatomic) IBOutlet UIButton * btnLogin;
@property (retain,nonatomic) IBOutlet UIButton * getPasswordBack;
@property (retain,nonatomic) MBProgressHUD* progressHud;

@end

@implementation HKLoginController

@synthesize imageView;
@synthesize txtUser;
@synthesize txtPwd;
@synthesize btnLogin;

@synthesize loginDomain;
@synthesize progressHud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //ini loginDomain;
        
        self.loginDomain = [[[HKLoginDomain alloc] init] autorelease];
        
        self.loginDomain.delegate = self;
        self.title = @"找回密码";
        
    }
    return self;
}


-(void) dealloc
{
    self.imageView = nil;
    self.txtPwd = nil;
    self.txtPwd = nil;
    self.btnLogin = nil;
    
    self.loginDomain = nil;
    self.progressHud = nil;
    
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [self.getPasswordBack addTarget:self action:@selector(getPassword) forControlEvents:UIControlEventTouchUpInside];

    //键盘处理
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    
    [topView setItems:buttonsArray];
    [self.txtPwd setInputAccessoryView:topView];
    [self.txtUser setInputAccessoryView:topView];

 
    [topView release];

    
}
-(void)dismissKeyBoard
{
    [self.txtPwd resignFirstResponder];
    [self.txtUser resignFirstResponder];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtPwd resignFirstResponder];
    [self.txtUser resignFirstResponder];
}
-(void)getPassword {
    HKGetPasswordBackViewController * passback = [[HKGetPasswordBackViewController new] autorelease];
    HKHomeNavigationController * nav = [[HKHomeNavigationController alloc] initWithRootViewController:passback];
    nav.isPresentModel = YES;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    Boolean isFirstRun = [[NSUserDefaults standardUserDefaults] boolForKey:FirstRunFlag];
//    if (!isFirstRun) {
//        HHHelpViewController *viewController = [[HHHelpViewController alloc] initWithNibName:@"HHHelpViewController" bundle:nil];
//        
//        [viewController loadImages:@"startview" count:4];
//        [viewController setSaveFlag:FirstRunFlag];
//        
//        [self presentViewController:viewController animated:NO completion:nil];
//        
//    }

    if (!isFirstRun) {
        HHHelpViewController * help = [[[HHHelpViewController alloc] init] autorelease];
        [help loadImages:@"startView" count:6];
        [help setSaveFlag:FirstRunFlag];

        [self presentViewController:help animated:NO completion:^{
            
        }];
        
        
    }
    else {
        if ([[NSUserDefaults  standardUserDefaults] objectForKey:@"username"]!=nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] != nil)
        {
            self.txtUser.text = [[NSUserDefaults  standardUserDefaults] objectForKey:@"username"];
            self.txtPwd.text = [[NSUserDefaults  standardUserDefaults] objectForKey:@"password"];
            [self progressShow:@"正在登陆，请稍后..." animated:YES];
            
            [loginDomain loginWithName:self.txtUser.text Password:self.txtPwd.text userType:@"APP"];
            
        }

    
    }
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark login click
-(IBAction) btnLoginClick:(id)sender{
    
    [self progressShow:@"正在登陆，请稍后..." animated:YES];
    
    [loginDomain loginWithName:self.txtUser.text Password:self.txtPwd.text userType:@"APP"];
    
    
    
}


-(IBAction) btnRegisClick:(id)sender
{
    HKRegTableViewController* regController = [[[HKRegTableViewController alloc]  initWithStyle:UITableViewStylePlain] autorelease];
    
    
    HKHomeNavigationController* navController = [[[HKHomeNavigationController alloc] initWithRootViewController:regController] autorelease];
    
    navController.isPresentModel = YES;
    navController.navigationBar.tintColor = [UIColor colorWithRed:0.16f green:0.49f blue:0.75f alpha:1];
    
    
    
    //[self presentModalViewController:navController animated:YES];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark process soft keyborad
- (IBAction)textFieldDoneEditing:(id)sender{
    
    if (sender != nil){
        
        
        [sender resignFirstResponder];
        
        if (![sender isKindOfClass:[UITextField class]]){
            CGRect frame = self.view.frame;
            if (frame.origin.y != 0){
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationDelegate:self];
                
                frame.origin.y = 20;
                
                [self.view setFrame:frame];
                
                [UIView commitAnimations];
            }
            
            [self.txtUser resignFirstResponder];
            [self.txtPwd resignFirstResponder];
        }
        
        
        
    }
}
- (IBAction)didEditBegin:(id)sender{
    
    // 计算是否达到显示区域
    UITextField *curTextField = (UITextField *)sender;
    
    CGRect frame = self.view.frame;
    CGRect frameTxt = curTextField.frame;
    
    if (frameTxt.origin.y + frame.origin.y > 100){
        
        frame.origin.y =100 - frameTxt.origin.y;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        
        [self.view setFrame:frame];
        
        [UIView commitAnimations];
    }
}

- (void)progressShow:(NSString*) title animated:(BOOL)animated{
    
    self.progressHud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
	[self.view addSubview:self.progressHud];
	
    self.progressHud.dimBackground = YES;
	//self.progressHud.delegate = self;
	self.progressHud.labelText = title;
	
	[self.progressHud show:YES];
}

- (void)progressHide:(BOOL)animated{
    
    if (self.progressHud != nil){
        [self.progressHud hide:animated];
        
        [self.progressHud removeFromSuperview];
        //[self.progressHud release];
        self.progressHud = nil;
        
    }
}


#pragma mark Domain Delegate
-(void) didParsDatas:(HHDomainBase *)domainData
{
    [self progressHide:YES];
    
    if(domainData.status ==0){
        
        MyProfile* profile = [MyProfile myProfile];
        profile.currentUser = self.txtUser.text;
        profile.userInfo = [domainData dataDictionary];
        [[NSUserDefaults standardUserDefaults] setObject:self.txtUser.text forKey:@"username"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.txtPwd.text forKey:@"password"];

      
        //TODO:保存用户名
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ROOT" object:nil];
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRoot) name:@"ROOT" object:nil];
        
//        [self dismissModalViewControllerAnimated:YES];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"登陆失败"
                                  message:domainData.resultMessage
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        //[self dismissModalViewControllerAnimated:NO];
    }
}
- (BOOL)shouldAutorotate {
    return NO;
}


-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
       //return UIInterfaceOrientationMaskLandscape
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


@end

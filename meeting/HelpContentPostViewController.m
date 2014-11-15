//
//  HelpContentPostViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HelpContentPostViewController.h"
#import "IQKeyBoardManager.h"
#import "MyProfile.h"
@interface HelpContentPostViewController ()

@end

@implementation HelpContentPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        self.title = @"发起求助";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }

	// Do any additional setup after loading the view.
    [IQKeyBoardManager installKeyboardManager];
    UIButton* btnPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPost setFrame:CGRectMake(0, 0, 40, 32 )];
    
    [btnPost setTitle:@"提交" forState:UIControlStateNormal];
    [btnPost setTintColor:[UIColor whiteColor]];
    UIBarButtonItem* barItemPost = [[[UIBarButtonItem alloc] initWithCustomView:btnPost] autorelease];
    
    [btnPost addTarget:self action:@selector(postHelpContent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItemPost;
    NSLog(@"%@",self.InfoDic);
    
	// Do any additional setup after loading the view.
    self.titleView.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleView.layer.borderWidth =1.0;
    self.titleView.layer.cornerRadius =5.0;
    
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth =1.0;
    self.contentView.layer.cornerRadius =5.0;
    
    
    //键盘处理
    topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    
    [topView setItems:buttonsArray];
    [self.titleView setInputAccessoryView:topView];
    [self.contentView setInputAccessoryView:topView];
    [topView release];
    
    topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Rootrect = topController.view.frame;


}
-(void) postHelpContent {
//    sectionkey=2
//    subject=互助标题
//    content=互助内容
//    userid=abc   发起人ID（登陆ID）
    if ([self.titleView.text length]==0 || [self.contentView.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"求助标题或者内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setValue:[self.InfoDic stringForKey:@"sectionkey"] forKey:@"sectionkey"];
    
    [paramsDic setValue:self.titleView.text forKey:@"subject"];
    [paramsDic setValue:self.contentView.text forKey:@"content"];
    MyProfile * profile = [MyProfile myProfile];
    [paramsDic setValue:[profile.userInfo stringForKey:@"pkey"] forKey:@"userid"];
    [_domain PostHelpContent:paramsDic];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";


}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        [self dismissKeyBoard];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        return;
    }else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        [self dismissKeyBoard];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"发布失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
    
}
-(void)dismissKeyBoard
{
    [self.titleView resignFirstResponder];
    [self.contentView resignFirstResponder];
    topController.view.frame = Rootrect;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

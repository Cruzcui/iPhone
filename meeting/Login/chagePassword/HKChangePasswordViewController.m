//
//  HKChangePasswordViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-20.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKChangePasswordViewController.h"
#import "MyProfile.h"
@interface HKChangePasswordViewController ()

@end

@implementation HKChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _domain = [[HKUserDomain alloc] init];
        [_domain setDelegate:self];
        self.title = @"修改密码";
    }
    return self;
}
- (void)dealloc
{
    [_oldpassword release];
    [_newpassword release];
    [_configurepassword release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [self.btn addTarget:self action:@selector(PostPassWord) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
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
    [self.oldpassword setInputAccessoryView:topView];
    [self.newpassword setInputAccessoryView:topView];
    [self.configurepassword setInputAccessoryView:topView];
    
    [topView release];
    
    
}

-(void)dismissKeyBoard
{
    [self.oldpassword resignFirstResponder];
    [self.newpassword resignFirstResponder];
    [self.configurepassword resignFirstResponder];

}

-(void)PostPassWord {
    if (self.oldpassword.text.length < 1 || self.newpassword.text.length < 1 || self.configurepassword.text.length < 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"所填内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (self.newpassword.text.length < 6 ||self.newpassword.text.length > 12) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码必须为6-12位数字/字母" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (self.oldpassword.text.length < 6 ||self.oldpassword.text.length > 12) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码必须为6-12位数字/字母" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    if (![self.newpassword.text isEqualToString:self.configurepassword.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入新密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
//    userId=kilxy
//    newPass=123456
//    oldPass=123456
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
    [params setObject:self.newpassword.text forKey:@"newPass"];
    [params setObject:self.oldpassword.text forKey:@"oldPass"];
    [_domain changePassWord:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

    
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    } else {
        
        
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[domainData.responseDictionary stringForKey:@"resultMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

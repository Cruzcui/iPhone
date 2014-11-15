//
//  HKRegisterController.m
//  meeting
//
//  Created by kimi on 13-8-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKRegisterController.h"
#import "HKPostTableViewAdapter.h"
#import "HHCustomEditCell.h"
#import "MBProgressHUD.h"
#import "HKLoginDomain.h"


@interface HKRegisterController ()
@property (nonatomic,retain) HKPostTableViewAdapter* adapter;
@property (retain,nonatomic) MBProgressHUD* progressHud;
@property (nonatomic,retain) HKLoginDomain* loginDomain;

@end

@implementation HKRegisterController

@synthesize adapter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    
    
    self.loginDomain = [[[HKLoginDomain alloc] init] autorelease];
    self.loginDomain.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftReturn:)] autorelease];
    
    self.adapter = [[[HKPostTableViewAdapter alloc] initWithFile:@"Register" PostURL:@""] autorelease];
    self.adapter.delegate = self;
    
    self.tableView.dataSource = self.adapter;
    self.tableView.delegate = self.adapter;
    
}

-(void) dealloc
{
    self.adapter = nil;
    self.loginDomain = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) leftReturn:(id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}



-(void) showMessage:(NSString*) message
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
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



#pragma mark BaseDomianDelegate
-(void) didParsDatas:(HHDomainBase *)domainData
{
    [self progressHide:YES];
    
    if(domainData.tag==0){ //获取验证码
        
        if(domainData.status == 0){
            
            [self showMessage:@"发送验证码成功，请检查您的短信以获取验证码"];
            
        }else{
            [self showMessage:domainData.resultMessage];
        }
        
        
    }else{
        if(domainData.status == 0){
            
            [self showMessage:@"注册成功，请使用您的用户名密码登陆"];
            
            [self dismissModalViewControllerAnimated:YES];
            
        }else{
            [self showMessage:domainData.resultMessage];
        }
    }
}

#pragma mark AdapterDelegate
-(void) doButtonClick:(HHCustomEditCell *)cell
{
    BOOL isGetCode = [cell.text isEqualToString:@"获取验证码"];
    
    NSDictionary* dic = [self.adapter getInputData];
    
    if (isGetCode) {
        
        
        if ([[dic stringForKey:@"phone"] isEqualToString:@""]) {
            [self showMessage:@"请输入电话号码，以获取验证码！"];
            return;
        }
        
        self.loginDomain.tag = 0;
        [self.loginDomain getValideCode:[dic stringForKey:@"phone"]];
        
        [self progressShow:@"正在获取验证码" animated:YES];
        
        
        
    }else{
        self.loginDomain.tag = 1;
        
        //校验注册信息
        if([[dic stringForKey:@"userId"] isEqualToString:@""]){
            [self showMessage:@"登录名不能为空"];
            return;
        }
        
        if([[dic stringForKey:@"password"] isEqualToString:@""]){
            [self showMessage:@"密码不能为空"];
            return;
        }
        
        if([[dic stringForKey:@"phone"] isEqualToString:@""]){
            [self showMessage:@"电话号码不能为空"];
            return;
        }
        
        if([[dic stringForKey:@"userName"] isEqualToString:@""]){
            [self showMessage:@"真实用户名不能为空"];
            return;
        }
        
        if([[dic stringForKey:@"valideCode"] isEqualToString:@""]){
            [self showMessage:@"验证码不能为空"];
            return;
        }
        
        
        NSString* pass = [dic stringForKey:@"password"] ;
        NSString* pass1 =[dic stringForKey:@"password1"];
        
        if(![pass isEqualToString:pass1] ){
            [self showMessage:@"两次输入密码不同"];
            return;
        }
        
        //应用ID
        [dic setValue:@"CSTAR" forKey:@"appId"];
        
        [self.loginDomain registerUser:dic];
        
        [self progressShow:@"正在注册" animated:YES];
        
    }
}

@end

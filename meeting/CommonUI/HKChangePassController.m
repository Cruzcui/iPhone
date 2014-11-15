//
//  HKChangePassController.m
//  meeting
//
//  Created by kimi on 13-6-28.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKChangePassController.h"
#import "MyProfile.h"
#import "HKLoginDomain.h"
#import "MBProgressHUD.h"

@interface HKChangePassController ()

@property (nonatomic,retain) IBOutlet UITableView* tableView;
@property (nonatomic,retain) HKPostTableViewAdapter* adapter;
@property (nonatomic,retain) HKLoginDomain* loginDomain;

@property (retain,nonatomic) MBProgressHUD* progressHud;

@end

@implementation HKChangePassController

@synthesize tableView;
@synthesize adapter;
@synthesize loginDomain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.loginDomain = [[[HKLoginDomain alloc] init] autorelease];
        self.loginDomain.delegate = self;
        
        self.title  = @"更改密码";
    }
    return self;
}

-(void) dealloc
{
    self.adapter = nil;
    self.tableView = nil;
    
    [super dealloc];
    
    
}


-(void) doButtonClick:(HHCustomEditCell *)cell{
    
    
    MyProfile* profile = [MyProfile myProfile];
    NSDictionary* dic = [self.adapter getInputData];
    
    [dic setValue:profile.currentUser forKey:@"userId"];
    
    NSString* newPass = [dic stringForKey:@"newPass"];
    NSString* newPass1 = [dic stringForKey:@"newPass1"];
    
    //校验数据
    if ([[dic stringForKey:@"newPass"] isEqualToString:@""]) {
        
        [self showMessage:@"请重新输入密码"];
        return;
    }
    
    if (![newPass isEqualToString:newPass1]) {
        
        [self showMessage:@"新密码不同，请重新输入"];
        return;
    }
    
    [self progressShow:@"正在提交请求，请稍后..." animated:YES];
    
    [self.loginDomain changePassword:dic];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adapter = [[[HKPostTableViewAdapter alloc] initWithFile:@"ChangePass" PostURL:@""] autorelease];
    self.adapter.delegate = self;
    self.tableView.dataSource = self.adapter;
    self.tableView.delegate = self.adapter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark DomainDelegate
-(void) didParsDatas:(HHDomainBase *)domainData
{
    
    [self progressHide:YES];
    
    
    if(domainData.status ==0){
        [self showMessage:@"更改密码成功！请您记住新密码。"];
        
    }else{
        [self showMessage:domainData.resultMessage];
    }
}

@end

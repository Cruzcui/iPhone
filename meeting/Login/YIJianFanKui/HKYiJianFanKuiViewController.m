//
//  HKYiJianFanKuiViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKYiJianFanKuiViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IQKeyBoardManager.h"
#import "MyProfile.h"
@interface HKYiJianFanKuiViewController ()

@end

@implementation HKYiJianFanKuiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"意见反馈";
        _domain = [[HKUserDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}
- (void)dealloc
{
    self.textcontent = nil;
    self.numberfield = nil;
    self.labelTitle= nil;
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.textcontent = nil;
    self.numberfield = nil;
    self.btnSend = nil;
    [_domain release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [IQKeyBoardManager installKeyboardManager];
    [self.textcontent setDelegate:self];
    self.textcontent.layer.borderColor = [UIColor grayColor].CGColor;
    self.textcontent.layer.borderWidth =1.0;
    self.textcontent.layer.cornerRadius =5.0;
    
    self.numberfield.layer.borderColor = [UIColor grayColor].CGColor;
    self.numberfield.layer.borderWidth =1.0;
    self.numberfield.layer.cornerRadius =5.0;
    //键盘处理
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
    [self.textcontent setInputAccessoryView:topView];
    [self.numberfield setInputAccessoryView:topView];
    [topView release];
    
    topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Rootrect = topController.view.frame;

    [self.btnSend addTarget:self action:@selector(SendYiJian) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
}


-(void)SendYiJian {
//    userid=kilxy    用户ID
//    content=abcdetesing  意见内容
    if (self.textcontent.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请填写反馈内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return; 
    }
    
    MyProfile * profile = [MyProfile myProfile];
    ;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userid"];
    [params setObject:self.textcontent.text forKey:@"content"];
    if (self.numberfield.text.length == 0) {
        self.numberfield.text = @"";
    }
    [params setObject:self.numberfield.text forKey:@"tel"];
    [_domain postJianyi:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
         [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见反馈成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
       
    }else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见反馈失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissKeyBoard
{
    [self.textcontent resignFirstResponder];
    [self.numberfield resignFirstResponder];
    topController.view.frame = Rootrect;
    
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    topController.view.frame = Rootrect;
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    topController.view.frame = Rootrect;
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.labelTitle.text = @"";
    self.label1.text = @"";
    self.label2.text = @"";
    self.label3.text = @"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

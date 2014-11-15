//
//  HKGetPasswordBackViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-3-6.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKGetPasswordBackViewController.h"

@interface HKGetPasswordBackViewController ()

@end

@implementation HKGetPasswordBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _domain = [[HKLoginDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"找回密码";
    // Do any additional setup after loading the view from its nib.
    [self.btn addTarget:self action:@selector(getPass) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.account setInputAccessoryView:topView];
    [self.phoneNumber setInputAccessoryView:topView];
    [topView release];
}

-(void)dismissKeyBoard
{
    [self.account resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
}



-(void) getPass {
    if (self.account.text.length == 0 || self.phoneNumber.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"用户名或电话不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:self.account.text forKey:@"key"];
    [params setValue:self.phoneNumber.text forKey:@"phone"];
    [params setValue:@"1" forKey:@"sendType"];
    [_domain getPasswordBackDomain:params];
    
    
//    sendType=1
//    key=kilxy2
//    phone=15566926082
}
-(void) didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息已发送请注意接受短信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }
    if (domainData.status == -1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无用户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }

    if (domainData.status == -2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息错误(电话号码或者邮箱不正确)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }

    if (domainData.status == -3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

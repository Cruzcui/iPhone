//
//  PostHelperViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-28.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostHelperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyProfile.h"
#import "IQKeyBoardManager.h"
@interface PostHelperViewController ()

@end

@implementation PostHelperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        self.title = @"回复";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [IQKeyBoardManager disableKeyboardManager];
    UIButton* btnPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPost setFrame:CGRectMake(0, 0, 40, 32 )];

    [btnPost setTitle:@"提交" forState:UIControlStateNormal];
    [btnPost setTintColor:[UIColor whiteColor]];
    UIBarButtonItem* barItemPost = [[[UIBarButtonItem alloc] initWithCustomView:btnPost] autorelease];
    
    [btnPost addTarget:self action:@selector(postHelpContent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItemPost;
    NSLog(@"%@",self.InfoDic);
    
	// Do any additional setup after loading the view.
    self.textInput.layer.borderColor = [UIColor grayColor].CGColor;
    self.textInput.layer.borderWidth =1.0;
    self.textInput.layer.cornerRadius =5.0;
    
    
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
    [self.textInput setInputAccessoryView:topView];
   
    [topView release];

    
    
}
-(void)dismissKeyBoard
{
    [self.textInput resignFirstResponder];
}
-(void)postHelpContent {
//    helpkey=1   互助pkey
//    content=aisiidfdfsf  回复内容
//    userid=abc
//    replaykey
    if ([self.textInput.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"回复内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    if (self.flag == NO) {
         [paramsDic setObject:[self.InfoDic stringForKey:@"pkey" ] forKey:@"helpkey"];
    }else {
        [paramsDic setObject:[self.InfoDic stringForKey:@"helpkey" ] forKey:@"helpkey"];
        [paramsDic setObject:[self.InfoDic stringForKey:@"pkey" ] forKey:@"replaykey"];
    }
   
    [paramsDic setObject:self.textInput.text forKey:@"content"];
    MyProfile * profile = [MyProfile myProfile];
    [paramsDic setObject:[profile.userInfo stringForKey:@"pkey" ] forKey:@"userid"];
    [_domain postHelpReplay:paramsDic];
    
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"回复成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        return;
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"回复失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

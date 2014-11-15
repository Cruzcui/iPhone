//
//  SocreView.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-29.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "SocreView.h"
#import "IQKeyBoardManager.h"
#import "MyProfile.h"
@interface SocreView ()

@end

@implementation SocreView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andGuidLine:(NSDictionary *)guidl andPkey:(NSString *)pkey
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dic = guidl;
        self.pkey = pkey;
        _domain = [[HKCategorySearchDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}
- (void)dealloc
{
    [_count release];
    [_submit release];
    [_one release];
    [_two release];
    [_three release];
    [_four release];
    [_five release];
    [_dic release];
    [_pkey release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IQKeyBoardManager installKeyboardManager];

	// Do any additional setup after loading the view.
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }

    [self.one addTarget:self action:@selector(ones) forControlEvents:UIControlEventTouchUpInside];
    
    [self.two addTarget:self action:@selector(twos) forControlEvents:UIControlEventTouchUpInside];
    [self.three addTarget:self action:@selector(threes) forControlEvents:UIControlEventTouchUpInside];
    [self.four addTarget:self action:@selector(fours) forControlEvents:UIControlEventTouchUpInside];
    [self.five addTarget:self action:@selector(fives) forControlEvents:UIControlEventTouchUpInside];
    [self.submit addTarget:self action:@selector(submits) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = [self.dic stringForKey:@"title"];
    
    
//    [IQKeyBoardManager disableKeyboardManager];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    //UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"Hello" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收起键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    
    [topView setItems:buttonsArray];
    [self.textContent setInputAccessoryView:topView];
    [topView release];
    
    topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Rootrect = topController.view.frame;


}
-(void)dismissKeyBoard
{
    [self.textContent resignFirstResponder];
    topController.view.frame = Rootrect;

}
-(void)ones {
    [self.one setTitle:@"★" forState:UIControlStateNormal];
    [self.two setTitle:@"☆" forState:UIControlStateNormal];
    [self.three setTitle:@"☆" forState:UIControlStateNormal];
    [self.four setTitle:@"☆" forState:UIControlStateNormal];
    [self.five  setTitle:@"☆" forState:UIControlStateNormal];
    _counts = @"1";
    self.count.text = [NSString stringWithFormat:@"您打的分数为%@星",_counts];
    
}
-(void)twos {
    [self.one setTitle:@"★" forState:UIControlStateNormal];
    [self.two setTitle:@"★" forState:UIControlStateNormal];
    [self.three setTitle:@"☆" forState:UIControlStateNormal];
    [self.four setTitle:@"☆" forState:UIControlStateNormal];
    [self.five  setTitle:@"☆" forState:UIControlStateNormal];
    _counts = @"2";
    self.count.text = [NSString stringWithFormat:@"您打的分数为%@星",_counts];

}
-(void)threes {
    [self.one setTitle:@"★" forState:UIControlStateNormal];
    [self.two setTitle:@"★" forState:UIControlStateNormal];
    [self.three setTitle:@"★" forState:UIControlStateNormal];
    [self.four setTitle:@"☆" forState:UIControlStateNormal];
    [self.five  setTitle:@"☆" forState:UIControlStateNormal];
    _counts = @"3";
    self.count.text = [NSString stringWithFormat:@"您打的分数为%@星",_counts];

}
-(void)fours {
    [self.one setTitle:@"★" forState:UIControlStateNormal];
    [self.two setTitle:@"★" forState:UIControlStateNormal];
    [self.three setTitle:@"★" forState:UIControlStateNormal];
    [self.four setTitle:@"★" forState:UIControlStateNormal];
    [self.five  setTitle:@"☆" forState:UIControlStateNormal];
    _counts = @"4";
    self.count.text = [NSString stringWithFormat:@"您打的分数为%@星",_counts];

}
-(void)fives {
    [self.one setTitle:@"★" forState:UIControlStateNormal];
    [self.two setTitle:@"★" forState:UIControlStateNormal];
    [self.three setTitle:@"★" forState:UIControlStateNormal];
    [self.four setTitle:@"★" forState:UIControlStateNormal];
    [self.five  setTitle:@"★" forState:UIControlStateNormal];
    _counts = @"5";
    self.count.text = [NSString stringWithFormat:@"您打的分数为%@星",_counts];


}
-(void) submits {
    if (_counts == nil || [_textContent.text length] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打分或评论内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:self.pkey forKey:@"medguidekey"];
    MyProfile * profile = [MyProfile myProfile];
    [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userid"];
    [params setObject:[NSString stringWithFormat:@"%@",_counts] forKey:@"rating"];
    [params setObject:_textContent.text forKey:@"comments"];
    
    [_domain getPostContent:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        [self dismissKeyBoard];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"评论成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        [self dismissKeyBoard];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"评论提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

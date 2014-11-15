//
//  PostVoteVIewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostVoteVIewController.h"
#import "IQKeyBoardManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MyProfile.h"
#define ContentHeight 35
@interface PostVoteVIewController ()

@end

@implementation PostVoteVIewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"发起投票";
        _NumberOfQ = 0;
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _type = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mycolor = [[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]retain];
    [IQKeyBoardManager installKeyboardManager];
	// Do any additional setup after loading the view.
    backScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UILabel * alertView = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.bounds.size.width - 10, 50)];
    [alertView setText:@"发布违法，反动投票信息将依据纪录提交公安机关处理，请不要发涉及敏感政治话题"];
    [alertView setBackgroundColor:mycolor];
    alertView.numberOfLines = 0;
    alertView.lineBreakMode = NSLineBreakByWordWrapping;
    [alertView setFont:[UIFont systemFontOfSize:14]];
    titleView = [[UITextView alloc] initWithFrame:CGRectMake(5, 60, self.view.bounds.size.width - 10, 50)];
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(5, 115, self.view.bounds.size.width -10 , 150)];
    titleView.layer.borderColor = [UIColor grayColor].CGColor;
    titleView.layer.borderWidth =1.0;
    titleView.layer.cornerRadius =5.0;
    titleView.font = [UIFont systemFontOfSize:17.0];
    contentView.layer.borderColor = [UIColor grayColor].CGColor;
    contentView.layer.borderWidth =1.0;
    contentView.layer.cornerRadius =5.0;
    //判断类型
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"单选",@"多选",nil];
    
    //初始化UISegmentedControl
    
    segment = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    [segment setFrame:CGRectMake(50, 270, self.view.bounds.size.width-100, 30)];
    [segment setTitle:@"单选" forSegmentAtIndex:0];
    [segment setTitle:@"多选" forSegmentAtIndex:1];
    [segment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    //添加选项
    labelmark = [[UILabel alloc] initWithFrame:CGRectMake(5, 305,60, ContentHeight)];
    [labelmark setText:@"A:"];
    [labelmark setBackgroundColor:mycolor];
    contentQ = [[UITextField alloc] initWithFrame:CGRectMake(50, 305, self.view.bounds.size.width - 77, ContentHeight)];
    
//    contentQ.font = [UIFont systemFontOfSize:23.0];
//    contentQ.textAlignment = NSTextAlignmentCenter;
    [contentQ setBackgroundColor:[UIColor whiteColor]];
    [contentQ setTag:_NumberOfQ + 101];
//    labelmark.layer.borderColor = [UIColor grayColor].CGColor;
//    labelmark.layer.borderWidth =1.0;
//    labelmark.layer.cornerRadius =5.0;
    contentQ.layer.borderColor = [UIColor grayColor].CGColor;
    contentQ.layer.borderWidth =1.0;
    contentQ.layer.cornerRadius =5.0;
    addQ = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addQ setFrame:CGRectMake(50,305 + ContentHeight + 2, self.view.bounds.size.width-100, 50)];
    [addQ setTitle:@"增加" forState:UIControlStateNormal];
   
    //增加问题调用方法
    [addQ addTarget:self action:@selector(addQuestion) forControlEvents:UIControlEventTouchUpInside];
    //删除问题
    
    
    //发布按钮
    PostBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [PostBtn setFrame:CGRectMake(50, 305 + ContentHeight + 2 + 50 , self.view.bounds.size.width-100, 50)];
    [PostBtn setTitle:@"发布" forState:UIControlStateNormal];
    [PostBtn.titleLabel setTextColor:[UIColor blackColor]];
    [PostBtn addTarget:self action:@selector(PostVotebtn) forControlEvents:UIControlEventTouchUpInside];
    [backScroll addSubview:PostBtn];

    [self.view addSubview:backScroll];
    [backScroll addSubview:alertView];
    [backScroll addSubview:titleView];
    [backScroll addSubview:contentView];
    [backScroll addSubview:segment];
    [backScroll addSubview:labelmark];
    [backScroll addSubview:contentQ];
    [backScroll addSubview:addQ];
    [backScroll release];
    [alertView release];
    [titleView release];
    [contentView release];
    [labelmark release];
    [contentQ release];
    [segment release];
    

    [backScroll setContentSize:CGSizeMake(0, 520)];
    
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
    [titleView setInputAccessoryView:topView];
    [contentView setInputAccessoryView:topView];
    [contentQ setInputAccessoryView:topView];
    [topView release];

    topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    Rootrect = topController.view.frame;
    [self.view setBackgroundColor:mycolor];
    
    contentView.font = [UIFont systemFontOfSize:17.0];
}
-(void)segmentAction:(UISegmentedControl *)Seg {
     NSInteger Index = Seg.selectedSegmentIndex;
    if (Index == 0) {
        _type = 1;
    }
    if (Index == 1) {
        _type = 2;
    }
}
-(void)dismissKeyBoard
{
    [titleView resignFirstResponder];
    [contentView resignFirstResponder];
    [contentQ resignFirstResponder];
    for (int i = 0; i <= _NumberOfQ; i++) {
        UITextField * qusetions = (UITextField*) [self.view viewWithTag:i + 101];
        [qusetions resignFirstResponder];
    }
    topController.view.frame = Rootrect;

}
-(void) addQuestion {
    if (_NumberOfQ  ==  25) {
        return;
    }
    _NumberOfQ ++;
   UILabel * labelmarks = [[UILabel alloc] initWithFrame:CGRectMake(5, 305 + (ContentHeight+2) * _NumberOfQ  ,60, ContentHeight)];
    [labelmarks setBackgroundColor:mycolor];
   UITextField * contentQs = [[UITextField alloc] initWithFrame:CGRectMake(50, 305 + (ContentHeight+2) * _NumberOfQ, self.view.bounds.size.width - 77, ContentHeight)];
    [contentQs setBackgroundColor:[UIColor whiteColor]];
    contentQs.layer.borderColor = [UIColor grayColor].CGColor;
    contentQs.layer.borderWidth =1.0;
    contentQs.layer.cornerRadius =5.0;
    char  mark = 65+ _NumberOfQ;
    NSLog(@"%c",mark);
    [labelmarks setText:[NSString stringWithFormat:@"%c:",mark]];
    [backScroll addSubview:labelmarks];
    [backScroll addSubview:contentQs];
    [contentQs setTag:_NumberOfQ + 101];
    [labelmarks release];
    [contentQs release];
    [addQ setFrame:CGRectMake(50,305 + (ContentHeight+2) * (_NumberOfQ+1), self.view.bounds.size.width-100, 50)];
    [PostBtn setFrame:CGRectMake(50, 415 + (ContentHeight + 2)* _NumberOfQ, self.view.bounds.size.width -100, 50)];
    [backScroll setContentSize:CGSizeMake(0, 425 + (ContentHeight+2) * (_NumberOfQ + 1) + 50)];
    
    [contentQs setInputAccessoryView:topView];

    
    //mark
    
}
-(void) PostVotebtn {
    //sectionkey=2  科室ID
    //votetitle=你好呀  投标标题
   // votetype=1   投票类型
   // userid=13456 用户ID
   // qtitles=aa,bbb,ccc,ddd 问题列表，使用逗号分割*/
   //判断投票题目，投票内容不为空
    if (titleView.text.length < 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"问题题目不能未空" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }
    if (contentView.text.length < 1) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"问题内容不能未空" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    //判断问题条数
    if (_type == 1) {
        if (_NumberOfQ < 1) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"单选问题不能小于2条" delegate:self
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;

        }
    }
    if (_type == 2) {
        if (_NumberOfQ < 2) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"多选问题不能小于3条" delegate:self
                                                   cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
            
        }
        

    }

    
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    NSString * qtitles = @"";
    for (int i = 0; i <= _NumberOfQ; i++) {
        UITextField * qusetions = (UITextField*) [self.view viewWithTag:i + 101];
        if ([qusetions.text length] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"问题内容不能未空" delegate:self
        cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        qtitles = [qtitles stringByAppendingString:[NSString stringWithFormat:@",%@",qusetions.text]];
    }
    MyProfile* profile = [MyProfile myProfile];
    
    NSMutableString *answerParams = [[NSMutableString  alloc] initWithString:qtitles];
    [answerParams deleteCharactersInRange:NSMakeRange(0,1)];
    [paramDic setObject:answerParams forKey:@"qtitles"];
    [paramDic setObject:[_dataSorce objectForKey:@"sectionkey"]  forKey:@"sectionkey"];
    [paramDic setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userid"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",_type] forKey:@"votetype"];
    [paramDic setObject:titleView.text forKey:@"votetitle"];
    [paramDic setObject:contentView.text forKey:@"votecontent"];
    [_domain getFaQiPost:paramDic];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";


}
-(void) didParsDatas:(HHDomainBase *)domainData {
    NSLog(@"%d",domainData.status);
    if (domainData.status == 0) {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        [alert release];
        [self dismissKeyBoard];
    }
}
#pragma mark UIAlertView delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

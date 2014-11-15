//
//  PostLPingLunView.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-29.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostLPingLunView.h"
#import "IQKeyBoardManager.h"
@interface PostLPingLunView ()

@end

@implementation PostLPingLunView

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
    [_domain release];
    [_button release];
    [_textContent release];
    [_dic release];
    [_pkey release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }

    [IQKeyBoardManager disableKeyboardManager];
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
    
    [self.button addTarget:self action:@selector(PostPingLun) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = [self.dic stringForKey:@"title"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyBoard
{
    [self.textContent resignFirstResponder];
}
-(void) PostPingLun {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:self.pkey forKey:@"medguidekey"];
    [params setObject:@"1234" forKey:@"userid"];
    [params setObject:_textContent.text forKey:@"comments"];
    [_domain getPostContent:params];
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData.status == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"评论成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
   
}
@end

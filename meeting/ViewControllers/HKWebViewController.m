//
//  HKWebViewController.m
//  meeting
//
//  Created by kimi on 13-7-2.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKWebViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "HKCommonsMakerViewController.h"
#import "HKHomeNavigationController.h"
#import "MyProfile.h"
#import "MeetingConst.h"
#import "HKTabBarItem.h"
#import "MeetingConst.h"


#define Color_Style_Key @"__Color_Style_Key"
#define Font_Size_Key @"__Font_Size_Key"

@interface HKWebViewController ()

@property (nonatomic,retain) IBOutlet UIWebView* webView;
@property (retain, nonatomic) IBOutlet UIToolbar *toobar;
@property (nonatomic,copy) NSString * actionHTML;

@property (retain, nonatomic) IBOutlet UIImageView *bottomImage;
@property MBProgressHUD* progressHud;

@property (retain,nonatomic) NSURL * url;
@property (nonatomic,assign) int flag;


@end

@implementation HKWebViewController

@synthesize webView;
@synthesize actionHTML;
@synthesize progressHud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Title:(NSString*) title HTML:(NSString*) html
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = title;
        self.actionHTML = html;
        self.flag = 1;
        //[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Title:(NSString*) title URL:(NSURL*) url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = title;
        self.url = url;
        self.flag = 2;
       
    }
    return self;
}

-(void) dealloc
{
    
    self.webView = nil;
    self.actionHTML = nil;
    self.progressHud = nil;
    self.url = nil;
    [_bottomImage release];
    [_toobar release];
    [super dealloc];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    if (self.ZhiNanflag && !self.referrenceFlag) {
         [self.navigationController.navigationBar setBarTintColor:getUIColor(Color_NavBarBackColor)];
    }
   

}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if (self.ZhiNanflag && !self.referrenceFlag) {
        [self.navigationController.navigationBar setBarTintColor:getUIColor(Color_NavBarBackColor)];
    }

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.ZhiNanflag) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.ZhiNanflag) {
         [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    self.webView.delegate = self;
    
    
    [self.webView setMultipleTouchEnabled:YES];
    [self.webView setScalesPageToFit:YES];
    [self.webView setUserInteractionEnabled:YES];
    
    
    self.bottomImage.image = [UIImage imageNamed:@"web_bottom.png"];
    
    
    //right message button
    if (self.editFlag == NO) {
        UIButton* btnMessage = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32 )] autorelease];
        
        [btnMessage setBackgroundImage:[UIImage imageNamed:@"right_pen.png"] forState:UIControlStateNormal];
        [btnMessage addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* barItemMessage = [[[UIBarButtonItem alloc] initWithCustomView:btnMessage] autorelease];
        
        self.navigationItem.rightBarButtonItem = barItemMessage;
    }

    if (self.flag == 1) {
        
        [self loadHTML];
        
    }if (self.flag == 2) {
        NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
    
    
    //判断是否为指南原文HTML
    if (self.ZhiNanflag) {
        self.toobar.hidden = NO;
        
        
        self.toobar.translucent = NO;
        [self.toobar setBarTintColor:getUIColor(Color_tabbar_background)];
        //[self.toobar setBackgroundColor:[UIColor redColor] ];//getUIColor(Color_tabbar_background) ];
        
        
        NSMutableArray* barItems = [NSMutableArray array];
        
        
        //上一章
        HKTabBarItem* itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"icon_pre.png"] title:@"上一章"];
        
        [itemView addTarget:self action:@selector(barBtnPreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem* preBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
        //[[[UIBarButtonItem alloc] initWithTitle:@"前一章" style:UIBarButtonItemStylePlain target:self action:@selector(barBtnPreClick:)] autorelease] ;
        
        [barItems addObject:preBtn];
        
        //分隔按钮
        UIBarButtonItem* splitBtn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:splitBtn2];
        
        
        itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"icon_color.png"] title:@"选择背景"];
        [itemView addTarget:self action:@selector(barBtnColorClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* colorBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
        [barItems addObject:colorBtn];

        
        
        //分隔按钮
        UIBarButtonItem* splitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:splitBtn];
        
        itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"icon_fontsize.png"] title:@"调节字体"];
        [itemView addTarget:self action:@selector(barBtnSizeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* sizeBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
        [barItems addObject:sizeBtn];
        
        
        
        //分隔按钮
        UIBarButtonItem* splitBtn3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:splitBtn3];
        
        
        
        itemView = [HKTabBarItem tabBarItem:[UIImage imageNamed:@"icon_next.png"] title:@"下一章"];
        [itemView addTarget:self action:@selector(barBtnNextClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* nextBtn = [[[UIBarButtonItem alloc] initWithCustomView:itemView] autorelease];
        
        [barItems addObject:nextBtn];
        
        
        
        
        [self.toobar setItems:barItems];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sectionChanged:) name:Notifaction_DidChange_Section object:nil];
        
        
    }else{
        self.toobar.hidden = YES;
        CGRect frame = self.webView.frame;
        frame.size.height = frame.size.height + self.toobar.frame.size.height;
        self.webView.frame = frame;
    }
    
    
    
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadHTML{
    
    MyProfile * profile = [MyProfile myProfile];
    NSString * html = [profile.SystemInfo stringForKey:@"profilecontent"];
    NSString* content = [NSString stringWithFormat:html,actionHTML];
    
    [self.webView loadHTMLString:content baseURL:nil];
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



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"正在加载";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if (self.ZhiNanflag) {
        NSString* colorStyle = [[NSUserDefaults standardUserDefaults] stringForKey:Color_Style_Key];
        
        if (colorStyle) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"webFun('%@')",colorStyle]];
            
            [self setWebViewColor];
        }
        
        
        NSString* fontSize = [[NSUserDefaults standardUserDefaults] stringForKey:Font_Size_Key];
        
        if (fontSize) {
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"webFun('fontSize','%@')",fontSize]];
            
        }

        
    }
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

-(void) setWebViewColor{
   NSString* result =  [self.webView stringByEvaluatingJavaScriptFromString:@"webFun('getColor')"];
    
    if (result) {
        NSLog(@"%@",result);
        
        UIColor* color =  getUIColor([result intValue]);
        
        self.webView.backgroundColor = color;
    }
    
    
    
    
}

- (void)viewDidUnload {
    [self setBottomImage:nil];
    [super viewDidUnload];
}


-(void) rightButtonClick:(id) sender{
    
    UIGraphicsBeginImageContextWithOptions(self.webView.bounds.size, self.webView.opaque, 0.0);
    [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    
    HKCommonsMakerViewController* commonsMakerController = [[HKCommonsMakerViewController alloc] initWithNibName:@"HKCommonsMakerViewController" bundle:nil];
    
    commonsMakerController.markImage = img;
    
    HKHomeNavigationController* navController = [[[HKHomeNavigationController alloc] initWithRootViewController:commonsMakerController] autorelease];
    navController.isPresentModel = YES;
    
    [navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIColor blackColor],
                                                            UITextAttributeTextColor,
                                                            [UIColor whiteColor],
                                                            UITextAttributeTextShadowColor,
                                                            [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                            UITextAttributeTextShadowOffset,
                                                            [UIFont boldSystemFontOfSize:0.0],
                                                            UITextAttributeFont,nil]];
    
    commonsMakerController.DicForPic = self.titleDics;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ] || [ [ requestURL scheme ] isEqualToString: @"applewebdata" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        //return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
        HKWebViewController * webViewS = [[HKWebViewController alloc] init];
        webViewS.title = @"参考文献";
        webViewS.flag = 2;
        webViewS.referrenceFlag = YES;
        //zhinanReferrence处理
//        if (self.ZhiNanflag == YES) {
//            NSString *urlstr = [requestURL absoluteString];
//            if ([urlstr hasSuffix:@"pdf"] || [urlstr hasSuffix:@"png"] || [urlstr hasSuffix:@"jpg"]) {
//                urlstr = [urlstr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
//                NSString * filepath =  [self WriteLocalFile:[self.titleDics stringForKey:@"pkey"] andsavefile:urlstr];
//                requestURL = [NSURL fileURLWithPath:filepath];
////                NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
////                [webViewS loadRequest:request];
//                
//            }
//        }
        
        webViewS.url = requestURL;
        webViewS.titleDics = self.titleDics;
        if(self.editFlag == YES) {
            webViewS.editFlag = YES;
        }
//        NSURLRequest *request =[NSURLRequest requestWithURL:requestURL];
        [self.navigationController pushViewController:webViewS animated:YES];
//        [webViewS.webView loadRequest:request];
        [webViewS release];
        return NO;
        
    }
    [ requestURL release ];
    return YES;
}
//读取本地文件
-(NSString  *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    //NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:realPath];
    return realPath;
}




#pragma mark -
#pragma mark toolbar 事件

-(void) barBtnPreClick:(id) sender{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"-1" forKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_Change_Section object:params];
    
    
}

-(void) barBtnSizeClick:(id) sender{
    
    
    
    NSString* result = [self.webView stringByEvaluatingJavaScriptFromString:@"webFun('fontSize')"];
    
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:Font_Size_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@",result);
}

-(void) barBtnColorClick:(id) sender{
    
    //self.webView.backgroundColor = [UIColor blackColor];
    
    
    
    NSString* result = [self.webView stringByEvaluatingJavaScriptFromString:@"webFun('colorStyle')"];
    
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:Color_Style_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setWebViewColor];
    
    NSLog(@"%@",result);
}

-(void) barBtnNextClick:(id) sender{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifaction_Change_Section object:params];
}


-(void) sectionChanged:(NSNotification *) notify {
    NSDictionary * dic = [notify object];
    
    NSString* title = [dic stringForKey:@"HTMLTitle"];
    self.actionHTML = [dic stringForKey:@"HTMLContent"];
    
    self.title = title;
    [self loadHTML];
    
    NSLog(@"%@",dic);
}

@end

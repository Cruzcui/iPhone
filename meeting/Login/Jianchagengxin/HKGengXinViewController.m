//
//  HKGengXinViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKGengXinViewController.h"
#import "HKLoginDomain.h"

@interface HKGengXinViewController ()<HHDomainBaseDelegate,UIAlertViewDelegate> {
    NSString * _urlString;

}

@property (nonatomic,retain) HKLoginDomain* domain;

@end

@implementation HKGengXinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.domain = [[[HKLoginDomain alloc] init] autorelease];
        self.domain.delegate = self;
    }
    return self;
}

-(void) dealloc{
    
    self.domain = nil;
    self.versionLabel = nil;
    [super dealloc];
}


-(IBAction) checkVersionClick:(id)sender{
    [self.domain checkVersion];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"正在检查版本信息";

}

-(void) didParsDatas:(HHDomainBase *)domainData{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *  build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (self.domain.responseDictionary != nil) {
        NSArray * versondic = [self.domain.responseDictionary objectForKey:@"results"];
        NSString * newVersion = [[versondic lastObject] stringForKey:@"version"];
        _urlString = [[versondic lastObject] stringForKey:@"trackViewUrl"];
        if (![build isEqualToString:newVersion]) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                message:[self.domain.responseDictionary stringForKey:@"description"]
                                                               delegate:self
                                                      cancelButtonTitle:@"暂不更新"
                                                      otherButtonTitles:@"马上更新", nil];
            alertView.tag = 2;
            [alertView show];
            [alertView release];
        }
        else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"目前版本为最新版本"
                                                                message:[self.domain.responseDictionary stringForKey:@"description"]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            alertView.tag = 1;
            [alertView show];
            [alertView release];
            
        }

    }
    
    //[self.domain.dataDictionary]
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex== 1) {
            NSURL *url = [NSURL URLWithString:_urlString];
            [[UIApplication sharedApplication]openURL:url];
           }

    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"版本信息";
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString* build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    
    self.versionLabel.text = [NSString stringWithFormat:@"iPhone版本 %@ Build(%@)",version,build];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

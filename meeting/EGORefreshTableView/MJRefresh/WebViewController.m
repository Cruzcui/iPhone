//
//  WebViewController.m
//  TestPullDrag
//
//  Created by cuiyang on 13-12-5.
//  Copyright (c) 2013年 cuiyang. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIWebView * web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url =[NSURL URLWithString:@"http://www.baidu.com"];
   
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    [self.view addSubview:web];
    [web release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

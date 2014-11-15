//
//  HHHelpViewController.m
//  DalianPort
//
//  Created by 翔 张 on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHHelpViewController.h"

@interface HHHelpViewController (){
    
    UIImageView* imgView1;
    UIImageView* imgView2;
    
    NSTimer* switchTimer;
}

@end

@implementation HHHelpViewController


@synthesize currentIndex;
@synthesize imageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self setIsReceiveCheckLoginOut:YES];
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = @"关于我们";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadImages:@""];
    // Do any additional setup after loading the view from its nib.
    
    [scrollView setBackgroundColor:[UIColor blackColor]];
    
    [self viewLoadingImage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
//    [self.imageArray removeAllObjects];
//    
//    [switchTimer invalidate];
//    [switchTimer release];
//    self.imageArray = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}



-(void) dealloc{
    [super dealloc];
}

-(void) loadImages:(NSString*) areaCode count:(int) intCount{
    
    if (self.imageArray == nil) {
        
        self.imageArray = [[NSMutableArray alloc] init];
        
        self.currentIndex = 0;
        
        pageControlBeingUsed = NO;
        
        
        //TODO:广告测试
        for (int i=0; i<intCount; i++) {
            
            UIImage * image = [UIImage imageNamed: [NSString stringWithFormat:@"%@%d",areaCode,i + 1]];
            
            [self.imageArray addObject:image];
        }
        
        
        
//        [self startSwitch];
        
    }
}

- (void) viewLoadingImage {
    
    if (self.imageArray != nil) {
        
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        for (int i=0; i<[self.imageArray count]; i++) {
            
            UIImageView* imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0+i*320, 0, 320, screenHeight)] autorelease];
            imgView.image = [self.imageArray objectAtIndex:i];
            
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            [scrollView addSubview:imgView];
        }
        
        pageControl.currentPage = 0;
        pageControl.numberOfPages = [self.imageArray count];
        
        scrollView.contentSize = CGSizeMake(pageControl.numberOfPages*320, screenHeight);
        
        if  (pageControl.numberOfPages == 1) {
            
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTouch:)];
            
            tapGesture.numberOfTapsRequired = 1; // The default value is 1.
            tapGesture.numberOfTouchesRequired = 1; // The default value is 1.
        
            [scrollView addGestureRecognizer:tapGesture];

        }
    }
}

-(void) startSwitch{
    
    
    
    switchTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                   target:self
                                                 selector:@selector(switchImages) userInfo:nil repeats:YES];
    
}

-(void) switchImages{
    
    NSLog(@"switchImages help AD");
    
    int page = pageControl.currentPage+1;
    
    if (page>=[pageControl.subviews count]) {
        page = 0;
    }
    
    
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * page;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
    //[scrollView setContentOffset:frame.origin animated:YES];
    
}


#pragma mark - deleget
/*
-(void) didParsDatas:(HHDomainBase *)domainData{
    
    //清楚原有记录
    [switchTimer invalidate];
    switchTimer = nil;
    self.currentIndex = 0;
    
    [self.imageArray removeAllObjects];
    
    for (UIView *imgView in scrollView.subviews) {
        
        if ([imgView isKindOfClass:[UIImageView class]]) {
            [imgView removeFromSuperview];
        }
    }
    
    int count = [self.ads.dataDetails count];
    
    //download img
    HHRequestImage* requestImg = [HHRequestImage requestImage];
    
    pageControl.currentPage = 0;
    pageControl.numberOfPages = count;
    
    for (int i=0; i<count; i++) {
        
        [self.imageArray addObject:[UIImage imageNamed:@"ad1.jpg"]];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0+i*320, 0, 320, 120)];
        [scrollView addSubview:imgView];
        
        [requestImg addDownloadJobWithURL:[[self.ads.dataDetails objectAtIndex:i] valueForKey:@"picURL"]
                                 FileName:[NSString stringWithFormat:@"ad_%d.jpg",i] 
                                   Target:self
                                 UserInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:i] forKey:@"id" ]];
    }
    
    scrollView.contentSize = CGSizeMake(count*320, 120);
    [self startSwitch];
    
}


-(void) didImageDownload:(HHRequestImage *)requestImage 
             HttpRequest:(ASIHTTPRequest *)request 
                FileName:(NSString *)filename 
                FullPath:(NSString *)fullPath 
                UserInfo:(NSDictionary *)userInfo 
                 Success:(BOOL)suc{
    
    if (suc>=0) {
        
        int index = [(NSNumber*)[userInfo objectForKey:@"id"] intValue];
        
        UIImage* img = [UIImage imageWithContentsOfFile:fullPath];
        
        if (img==nil) {
            return;
        }
        
        UIImageView* imgView = (UIImageView*)[scrollView.subviews objectAtIndex:index];
        imgView.image = img;
    }
    
}
*/

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		pageControl.currentPage = page;
	}else {
        
    }
    if (pageControl.currentPage+1 == self.imageArray.count) {
        self.btn.hidden = NO;
        [self.btn addTarget:self
                     action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        //[self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        self.btn.hidden = YES;

    }
}
-(void) dismiss {
    
    if (self.saveFlag != nil && ![self.saveFlag isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:self.saveFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewWillBeginDragging");
    pageControlBeingUsed = NO;
    [switchTimer invalidate];
    switchTimer = nil;
    //[switchTimer release];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scView willDecelerate:(BOOL)decelerate {
    
    
    NSLog(@"Scroll Length %f",scrollView.contentOffset.x - scrollView.contentSize.width);
    
    if (pageControl.currentPage == [self.imageArray count] - 1) {
        
        if (scrollView.contentOffset.x - scrollView.contentSize.width > - 280 ) {
            // close controller;
            if (self.saveFlag != nil && ![self.saveFlag isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:self.saveFlag];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            //[self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
//    [self startSwitch];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scView {
    pageControlBeingUsed = NO;
    
}

- (void) scrollViewTouch :(UIGestureRecognizer *) gesture {
    if (self.saveFlag != nil && ![self.saveFlag isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:self.saveFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}


-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return UIInterfaceOrientationMaskLandscape
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

@end

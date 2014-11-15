//
//  HHHomeAdCell.m
//  DalianPort
//
//  Created by mac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHHomeAdCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "HKWebViewController.h"
#import "HKHomeNavigationController.h"

@interface HHHomeAdCell(){
    
    UIImageView* imgView1;
    UIImageView* imgView2;
    
    NSTimer* switchTimer;
}

@property (nonatomic,retain) HHHomeAds* ads;

@end



@implementation HHHomeAdCell

@synthesize currentIndex;
@synthesize imageArray;
@synthesize ads;

-(void) dealloc{
    [self.imageArray removeAllObjects];
    
    [switchTimer invalidate];
    [switchTimer release];
    self.imageArray = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) changeWapADRequestURL{
   // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLWapAD]]];
}

-(void) loadImages:(NSString*) areaCode{
    
    
    //[self.webView setScalesPageToFit:YES];
    [self changeWapADRequestURL];
    
    if (self.imageArray == nil) {
        self.imageArray = [NSMutableArray arrayWithCapacity:5];
        self.currentIndex = 0;
        
        if (self.ads == nil) {
            self.ads = [[[HHHomeAds alloc] init] autorelease];
            self.ads.delegate = self;
        }
        
        pageControlBeingUsed = NO;
        
    }
    NSMutableDictionary * parse = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"adtype"];
    
    [self.ads requestData:parse];
    
    
    [self didParsDatas:nil];
}

-(void) startSwitch{
    
    
    
    switchTimer = [NSTimer scheduledTimerWithTimeInterval:10 
                                                   target:self
                                                 selector:@selector(switchImages) userInfo:nil repeats:YES];
    
}

-(void) switchImages{
    
    //[self changeWapADRequestURL];    
    int page = pageControl.currentPage+1;
    
    if (page>=[pageControl.subviews count]) {
        page = 0;
    }
    
    
    CGRect frame;
    frame.origin.x = scrollView.frame.size.width * page;
    frame.origin.y = 0;
    frame.size = scrollView.frame.size;
    [scrollView scrollRectToVisible:frame animated:YES];
    
}


#pragma mark - deleget

-(void) didParsDatas:(HHDomainBase *)domainData{
    
    //清楚原有记录
    [switchTimer invalidate];
    switchTimer = nil;
    self.currentIndex = 0;
    
    [self.imageArray removeAllObjects];
    
    for (UIButton *imgView in scrollView.subviews) {
        
        if ([imgView isKindOfClass:[UIButton class]]) {
            [imgView removeFromSuperview];
        }
    }
    
    //int count = 7;
   int count = [self.ads.dataDetails count];
    
    //download img
   // HHRequestImage* requestImg = [HHRequestImage requestImage];
  
    self.imageArray  =(NSMutableArray *) [domainData dataDetails];
    
    
    
    pageControl.currentPage = 0;
    pageControl.numberOfPages = count;
    
    for (int i=0; i<count; i++) {
        
//        [self.imageArray addObject:[UIImage imageNamed:@"56366AD.png"]];
        UIButton* imgView = [[[UIButton alloc] initWithFrame:CGRectMake(0+i*320, 0, 320, 120)] autorelease];
//        
       // imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad_%d.jpg",i]];
        NSString* picURL = [[self.imageArray objectAtIndex:i] stringForKey:@"picurl"];
//        NSNumber* modifyDT = [[self.ads.dataDetails objectAtIndex:i] objectForKey:@"modifyDT"];
//        [requestImg addDownloadJobWithURL:picURL
//                                 FileName:[NSString stringWithFormat:@"ad_%d_%.0f.jpg",[picURL hash],[modifyDT floatValue]]
//                                   Target:self
//                                 UserInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:i] forKey:@"id" ]];
        
        
        
        [imgView setImageWithURL:[NSURL URLWithString:picURL]  placeholderImage:[UIImage imageNamed:@"adplaceholder.jpg"]];
       
        //[imgView setBackgroundImage:bgImage.image forState:UIControlStateNormal];
        imgView.tag = i;
        
        [imgView addTarget:self action:@selector(adBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //labelTittle.text = [[self.imageArray objectAtIndex:i] stringForKey:@"title"];
        
        [scrollView addSubview:imgView];
        
        
        UILabel * labelTittle = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 40)];
        labelTittle.text =  [[self.imageArray objectAtIndex:i] stringForKey:@"title"];
        labelTittle.textColor = [UIColor whiteColor];
        labelTittle.textAlignment = NSTextAlignmentCenter;
        [labelTittle setBackgroundColor:[UIColor blackColor]];
        [labelTittle setAlpha:0.7];
        [imgView addSubview:labelTittle];
        [labelTittle release];
        
        


        
        
//        [requestImg addDownloadJobWithURL:picURL
//                                 FileName:[NSString stringWithFormat:@"ad_%d_%.0f.jpg",[picURL hash],[modifyDT floatValue]] 
//                                   Target:self
//                                 UserInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:i] forKey:@"id" ]];
        
        
    }
    
    //self.webView.frame = CGRectMake(count*320, 0,320,220);
    
    scrollView.contentSize = CGSizeMake(count*320, 120);
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 120) animated:NO];
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


#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		pageControl.currentPage = page;
	}else {
        
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewWillBeginDragging");
    pageControlBeingUsed = NO;
    [switchTimer invalidate];
    switchTimer = nil;
    //[switchTimer release];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scView willDecelerate:(BOOL)decelerate {
    
    
    NSLog(@"scrollViewDidEndDragging");
    
    /*
    if (abs(scrollView.contentOffset.x - pageControl.currentPage*-120)>5 ) {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        [scrollView scrollRectToVisible:frame animated:YES];
        
        NSLog(@"Fixed Frame:%d",pageControl.currentPage);
        
    }*/
    
    [self startSwitch];
    
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scView {
    pageControlBeingUsed = NO;
     
}


-(void) adBtnClick:(id) sender{
    
    UIButton* btn = (UIButton*)sender;
    NSDictionary* jsonData = [self.imageArray objectAtIndex:btn.tag];
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:[jsonData stringForKey:@"title"] URL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.199.26.12:8080/mguid/news/phone/news/%@.html",[jsonData stringForKey:@"newkey"]]]
                                           ] autorelease];
    webController.editFlag = YES;
    
    HKHomeNavigationController* nav = [[HKHomeNavigationController alloc] initWithRootViewController:webController];
    nav.isPresentModel = YES;
    
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

@end

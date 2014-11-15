//
//  HKMainViewController.m
//  HisGuidline
//
//  Created by kimi on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMainViewController.h"
#import "YGPSegmentedController.h"
#import "HKHomeTableViewController.h"
#import "HKSystemMessageViewController.h"
#import "HKLatestZhiNanViewController.h"

@interface HKMainViewController ()<YGPSegmentedControllerDelegate>

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain,nonatomic) YGPSegmentedController* ygpSegment;

@end

@implementation HKMainViewController
-(BOOL)shouldAutorotate {
    return NO;
}
-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tab01.png"];
        self.tabBarItem.title = @"重点推荐";
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    NSArray * TitielArray = [NSArray arrayWithObjects:@" 最新指南 ",@" 学术活动",@"我的收藏", nil];
    
    self.ygpSegment = [[[YGPSegmentedController alloc]initContentTitle:TitielArray CGRect:CGRectMake(0, 0, 320, 44)] autorelease];
    self.ygpSegment.Delegate = self;
    
    [self.view addSubview:self.ygpSegment];
    //最新动态
    HKLatestZhiNanViewController* lasetestZhiNan = [[[HKLatestZhiNanViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:lasetestZhiNan];

    
    //新闻咨询
    newsController = [[[HKNewsTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:newsController];
    
    //我的收藏
    HKHomeTableViewController* myFavController = [[[HKHomeTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:myFavController];

    
    
    for (UIViewController* viewController in self.childViewControllers) {
        
        viewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        
        [self.contentView addSubview:viewController.view];
        
    }
    
    [self segmentedViewController:self.ygpSegment touchedAtIndex:0];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_contentView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setContentView:nil];
    [super viewDidUnload];
}


#pragma mark YGPSegmentedController delegate
- (void)segmentedViewController:(YGPSegmentedController *)segmentedControl touchedAtIndex:(NSUInteger)index{
    if (index == 1) {
        [newsController getNetData];
    }
    
    
    
    UIViewController* viewController = [self.childViewControllers objectAtIndex:index];
    
    
    [self.contentView bringSubviewToFront:viewController.view];
}

@end

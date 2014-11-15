//
//  HKHisToolsViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//HKHisToolsViewController


#import "HKHisToolsViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "YGPSegmentedController.h"
#import "HKHisDictionaryViewController.h"
#import "HKCheckManualViewController.h"
#import "HKHisRefViewController.h"
#import "HKCalToolsViewController.h"

@interface HKHisToolsViewController ()<YGPSegmentedControllerDelegate>

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain,nonatomic) YGPSegmentedController* ygpSegment;

@end

@implementation HKHisToolsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
        
        self.tabBarItem.title = @"医学工具";
        self.tabBarItem.image = [UIImage imageNamed:@"tab03.png"];
    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE" object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _share.categroyForTools.delegate = self;

    NSArray * TitielArray = [NSArray arrayWithObjects:@"用药手册",@"检验手册",@"医学量表",@"计算工具", nil];
    
    self.ygpSegment = [[[YGPSegmentedController alloc]initContentTitle:TitielArray CGRect:CGRectMake(0, 0, 320, 44)] autorelease];
    self.ygpSegment.Delegate = self;
    
    [self.view addSubview:self.ygpSegment];
    
    //add child view controller
    
    //药典
    
    HKHisDictionaryViewController* hisDictController = [[[HKHisDictionaryViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:hisDictController];
    
    //检验手册
    
    HKCheckManualViewController* mainulController = [[[HKCheckManualViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:mainulController];
    
    //医学量表
    HKHisRefViewController* hisRefController = [[[HKHisRefViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:hisRefController];
    
    
    //计算工具
    HKCalToolsViewController* calToolRefController = [[[HKCalToolsViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:calToolRefController];
    
    
    for (UIViewController* viewController in self.childViewControllers) {
        
        viewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        
        [self.contentView addSubview:viewController.view];
        
    }
    
    [self segmentedViewController:self.ygpSegment touchedAtIndex:0];
    //接受消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData:) name:@"TOOLS" object:nil];
    
    
}
//改变科室调用其代理方法
-(void)hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(NSDictionary *)dataSourceDic {
    _share.KeshiDic = dataSourceDic;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];

}

-(void)initData:(NSNotification *)notify {
    self.dic = [notify object];
    _share.KeshiDic = self.dic;
}
-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //[self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
    
    //[self performSelector:@selector(toggleSide) withObject:nil afterDelay:1.5];
}


-(void) toggleSide{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_ygpSegment release];
    [_contentView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setYgpSegment:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}


#pragma mark YGPSegmentedController delegate
- (void)segmentedViewController:(YGPSegmentedController *)segmentedControl touchedAtIndex:(NSUInteger)index{
    
    UIViewController* viewController = [self.childViewControllers objectAtIndex:index];
    
    [self.contentView bringSubviewToFront:viewController.view];
}

@end


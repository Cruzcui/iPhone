//
//  HKCommunicateController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCommunicateController.h"
#import "UIViewController+MMDrawerController.h"
#import "YGPSegmentedController.h"


#import "HKHelpViewController.h"

@interface HKCommunicateController ()<YGPSegmentedControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) YGPSegmentedController* ygpSegment;

@end

@implementation HKCommunicateController
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE" object:nil];
;//开启滚动效果
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _domain = [[HKCommunicateDomain alloc] init];
//        [_domain setDelegate:self];
        _share = [ShareInstance instance];
        _dicParams = [[NSMutableDictionary alloc] init];
        _index = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    if ([UIDevice isRunningOniPhone5]) {
        
    }
    _share.categroyForCommunicate.delegate = self;
    [self.tableView setFrame:CGRectMake(0, 0, 320, 460)];
    //绑定子ViewController
    
    //投票
    _voteController = [[[HKVotesViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    [self addChildViewController:_voteController];
    
//   //壁报
//    _posterController = [[[HKMyPosterViewController alloc] init]autorelease];
//    [self addChildViewController:_posterController];
    
    //幻灯
    _pptController = [[[HKMyPPTViewController alloc] init] autorelease];
    [self addChildViewController:_pptController];
    
    //视频
    _videoController = [[[HKMyVideosViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    _videoController.flag = NO;
    [self addChildViewController:_videoController];
    
    //求助
    _helpController = [[[HKHelpViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:_helpController];


    
    NSArray * TitielArray = [NSArray arrayWithObjects:@" 投  票 ",@" 幻  灯 ",@" 视  频 ",@" 求  助 ", nil];
    
    self.ygpSegment = [[[YGPSegmentedController alloc]initContentTitle:TitielArray CGRect:CGRectMake(0, 0, 320,44)] autorelease];
    self.ygpSegment.Delegate = self;
    
    [self.view addSubview:self.ygpSegment];
    
    
    
    
    for (UIViewController* viewController in self.childViewControllers) {
        
        viewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width,self.contentView.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        
        [self.contentView addSubview:viewController.view];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData:) name:@"WODESHEQU" object:nil];
    [self segmentedViewController:self.ygpSegment touchedAtIndex:0];
    
    


    

}
-(void)initData:(NSNotification *)notify {
    NSDictionary * dic = [notify object];
    if (dic != nil) {
        [dic stringForKey:@"pkey"];
        [_dicParams setValue:[dic stringForKey:@"pkey"] forKey:@"sectionkey"];
        [_dicParams setValue:@"1" forKey:@"pageNumber"];
        [_dicParams setValue:@"10" forKey:@"pageSize"];
        //投票
        [_voteController getDataFromVotes:_dicParams];

    }
    
}
//改变科室调用其代理方法
-(void)hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(NSDictionary *)dataSourceDic {
    
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_dicParams setValue:[dataSourceDic stringForKey:@"pkey"] forKey:@"sectionkey"];
    [_dicParams setObject:countString forKey:@"pageNumber"];
    //网络请求
     [_pptController removeAllData];
     [_posterController removeAllData];
     [_videoController removeAllData];
     [_voteController removeAllData];
     [_helpController removeAllData];
    if (_index == 1) {
        [_pptController getDataFromHuandeng:_dicParams];
    }
//    if (_index == 1) {
//        //壁报请求
//        [_posterController getDataFromBiBao:_dicParams];
//    }
    if (_index == 2) {
        [_videoController getDataFromVidio:_dicParams];
    }
    if (_index == 0) {
        [_voteController getDataFromVotes:_dicParams];
    }
    if (_index == 3) {
        [_helpController getDataFromHelper:_dicParams];
    }
   // [self.tableView reloadData];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];

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
    [_tableView release];
    [_ygpSegment release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setYgpSegment:nil];
    [super viewDidUnload];
}


#pragma mark YgpDelegate
- (void)segmentedViewController:(YGPSegmentedController *)segmentedControl touchedAtIndex:(NSUInteger)index{
    _index = index;
       //点击不同得segement选项加载相对应数据
    if (index == 0) {
        if ([_dicParams objectForKey:@"sectionkey"] != nil) {
            [_voteController getDataFromVotes:_dicParams];
        }
    }
//    if (index == 1) {
//        //壁报
//        [_posterController getDataFromBiBao:_dicParams];
//
//    }
    if (index == 1) {
        //幻灯
        [_pptController getDataFromHuandeng:_dicParams];
    }
    if (index == 2) {
        //视频
        [_videoController getDataFromVidio:_dicParams];
          }
    if (index == 3) {
        //求助
        [_helpController getDataFromHelper:_dicParams];
    }
    UIViewController* viewController = [self.childViewControllers objectAtIndex:index];
    
    [self.contentView bringSubviewToFront:viewController.view];
    
    [self.tableView reloadData];

}

////初始化加载页面
-(void)testFinishedLoadData{
   //仅仅加载投票
   // [_voteController getDataFromVotes:_dicParams];
 }


@end

//
//  PingLunViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-28.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PingLunViewController.h"
#import "PingLunCell.h"

@interface PingLunViewController ()

@end

@implementation PingLunViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)dealloc
{
    [params release];
    [_domain release];
    [_dataArray release];
    [super dealloc];
}
-(id) initWithStyle:(UITableViewStyle)style GuidLine:(NSDictionary *)guidl andPkey:(NSString *)pkey{
    self = [self initWithStyle:style];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        params = [[NSMutableDictionary alloc] init];
        _count = 1;
        self.guidline = guidl;
        self.pkey = pkey;
        _domain = [[HKCategorySearchDomain alloc] init];
        [_domain setDelegate:self];
    }
    return  self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [params setObject:[self.guidline stringForKey:@"pkey"] forKey:@"medguidekey"];
    [params setObject:@"1" forKey:@"pageNumber"];
    [params setObject:@"10" forKey:@"pageSize"];
    [_domain getDOmainPingLun:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";
    self.title = [self.guidline stringForKey:@"title"];
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self testRealLoadMoreData];
        
    };



}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [_dataArray removeAllObjects];
        _count = 1;
        NSString * countString = [NSString stringWithFormat:@"%d",_count];
        [params setObject:countString forKey:@"pageNumber"];
        [_domain getDOmainPingLun:params];
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"loading";
    }
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    NSArray * array = [domainData dataDetails];
    for (NSDictionary * dic in array) {
        [_dataArray addObject:dic];
    }
    [_header endRefreshing];
    [_footer endRefreshing];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifiers = @"Cells";
    PingLunCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
    
    if (cell==nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PingLunCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }
    if ([_dataArray count] > 0) {
        NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
        cell.labelName.text = [dic stringForKey:@"userid"];
        cell.labelContent.text = [dic stringForKey:@"comments"];
        
        //Time处理
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic stringForKey:@"ratingdt"] doubleValue] / 1000];
        //时间戳转时间的方法:
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
       // [formatter release];

        
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
//        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"ratingdt"] longValue]];
        
        //NSLog(@"date1:%@",date1);
        cell.time.text = confromTimespStr;
        [formatter release];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    return  cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [params setObject:countString forKey:@"pageNumber"];
    [_domain getDOmainPingLun:params];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES
            ];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

  
}


@end

//
//  HKVotesViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKVotesViewController.h"
#import "HKDemoImageViewController.h"
#import "VotesHeader.h"
#import "GetVotesViewController.h"
#import "PostVotesViewController.h"
#import "PostVoteVIewController.h"
@interface HKVotesViewController ()

@property (nonatomic,retain) NSMutableArray* messages;

@end

@implementation HKVotesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        
        _dataForVotes = [[NSMutableArray alloc] init];
        _Votesparam  = [[NSMutableDictionary alloc] init];
        _count = 1;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    /*
    VotesHeader * votesHeader = [[[VotesHeader alloc] init] autorelease];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VotesHeader" owner:self options:nil];
    votesHeader = [array objectAtIndex:0];
    [votesHeader.postVotes addTarget:self action:@selector(GoPostVotes) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = votesHeader;
     */
    
  
    
    if (self.MeetingFlag == NO) {
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
    if (self.MeetingFlag) {
        _dataForVotes =(NSMutableArray *) self.arrayForMeeting;
        self.title = @"在线投票";
    }
    
    
}
-(void) GoPostVotes {
    PostVoteVIewController * post = [[[PostVoteVIewController alloc] init]autorelease];
    post.dataSorce = _Votesparam;
    [self.navigationController pushViewController:post animated:YES];
    
}
-(void)getDataFromVotes:(NSDictionary *)Params {
    
    if ([_dataForVotes count] > 0) {
        return;
    } else{
        [_Votesparam setObject:[Params objectForKey:@"sectionkey"] forKey:@"sectionkey"];
        [_Votesparam setObject:@"10" forKey:@"pageSize"];
        [_domain getDomainForVotes:Params];
          }
    _hud = nil;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}

//获取网络数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    NSArray * array = [domainData dataDetails];
       for (NSDictionary * dic in array) {
        [_dataForVotes addObject:dic];
    }
    [self.tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];
    if ([array count] == 0) {
        [_footer setState:RefreshStateAllData];
    }else {
        [_footer setState:RefreshStateNormal];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];


}
//网络请求
-(void)getDataForLoadMore{
    [_domain getDomainForVotes:_Votesparam];
}
-(void)removeAllData {
    [_dataForVotes removeAllObjects];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下拉刷新
-(void)testRealRefreshDataSource{
    [self removeAllData];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_Votesparam setObject:countString forKey:@"pageNumber"];
    [_Votesparam setObject:@"10" forKey:@"pageSize"];
    [self getDataFromVotes:_Votesparam];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_Votesparam setObject:countString forKey:@"pageNumber"];
    [self getDataForLoadMore];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataForVotes count];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [self.messages objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:16];;
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height + 20 > 50) {
        return labelSize.height + 50;
    } else {
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SystemMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([_dataForVotes count] > 0) {
        NSDictionary * dataDic = [_dataForVotes objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [dataDic stringForKey:@"votetitle"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;

    }
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataForVotes count] > 0) {
        GetVotesViewController * getVote = [[[GetVotesViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        getVote.keshi = _Votesparam;
        getVote.dataSorce = [_dataForVotes objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:getVote animated:YES];
    }
    
}

@end

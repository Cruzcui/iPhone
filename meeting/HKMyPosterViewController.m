//
//  HKMyPosterViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//


#import "HKMyPosterViewController.h"
#import "HKWebViewController.h"
#import "MyProfile.h"


@interface HKMyPosterViewController ()

@property (nonatomic,retain) NSMutableArray* messages;

@end

@implementation HKMyPosterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _count = 1;
        self.messages = [NSMutableArray arrayWithCapacity:4];
        _arrayForBiBao = [[NSMutableArray alloc] init];
        _BiBaoParams = [[NSMutableDictionary alloc] init];
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _domainSelected = [[HKCommunicateDomain alloc] init];
        [_domainSelected setDelegate:self];


    }
    return self;
}
- (void)dealloc
{
    [_arrayForBiBao release];
    [_BiBaoParams release];
    [_domain release];
    [_domainSelected release];
    [_header release];
    [_footer release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.title = @"我的壁报";
    
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
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//网络连接
-(void)getDataFromBiBao:(NSDictionary *)Params {
    
    if ([_arrayForBiBao count] > 0) {
        return;
    } else{
        [_BiBaoParams setObject:[Params objectForKey:@"sectionkey"] forKey:@"sectionkey"];
        [_BiBaoParams setObject:@"10" forKey:@"pageSize"];
        [_domain getDomainForMyBiBao:Params];
    }
}
-(void)getDataForLoadMore{
    [_domain getDomainForMyBiBao:_BiBaoParams];
}
-(void)removeAllData {
    [_arrayForBiBao removeAllObjects];
}
//接收返回数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domainSelected) {
        if (domainData.status == 0) {
            UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"通知" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            [aler release];
        } else  {
            UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"警告" message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            [aler release];
        }
    }
    NSArray * array = [domainData dataDetails];
    for (NSDictionary * dic in array) {
        [_arrayForBiBao addObject:dic];
    }
    [_header endRefreshing];
    [_footer endRefreshing];
    [self.tableView reloadData];
    if ([array count] == 0) {
        [_footer setState:RefreshStateAllData];
    }else {
        [_footer setState:RefreshStateNormal];
        
    }


}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_arrayForBiBao count];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PosterCell";
    HkPostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell == nil) {
     
        cell = [[[HkPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([_arrayForBiBao count] > 0) {
        NSDictionary * dicData = [_arrayForBiBao objectAtIndex:indexPath.row];
        cell.title.numberOfLines = 1;
        cell.title.text = [dicData stringForKey:@"title"];
        cell.title.font = [UIFont systemFontOfSize:20];
        cell.title.textColor = [UIColor blueColor];
        
        
        cell.publisher.numberOfLines = 0;
        cell.publisher.text = [dicData stringForKey:@"publisher"];
        cell.publisher.font = [UIFont systemFontOfSize:14];
        cell.publisher.textColor = [UIColor blackColor];
        
        
        cell.time.numberOfLines = 0;
        cell.time.text = [dicData stringForKey:@"publishdep"];
        cell.time.font = [UIFont systemFontOfSize:14];
        cell.time.textColor = [UIColor blackColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    return cell;
}

//下拉刷新
-(void)testRealRefreshDataSource{
    [self removeAllData];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_BiBaoParams setObject:countString forKey:@"pageNumber"];
    [_BiBaoParams setObject:@"10" forKey:@"pageSize"];
    [self getDataFromBiBao:_BiBaoParams];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_BiBaoParams setObject:countString forKey:@"pageNumber"];
    [self getDataForLoadMore];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_arrayForBiBao count] > 0) {
        NSDictionary * dicData = [_arrayForBiBao objectAtIndex:indexPath.row];
        NSURL* url = [NSURL URLWithString:[dicData stringForKey:@"picurl"]];
        
        HKWebViewController* demo = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:[dicData stringForKey:@"title"] URL: url] autorelease];
        
        demo.editFlag = YES;
        
        [self.navigationController pushViewController:demo animated:YES];
    }
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
    NSLog(@"收藏");
    if ([_arrayForBiBao count] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"正在刷新中，收藏失败" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary * dicData = [_arrayForBiBao objectAtIndex:indexPath.row];
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * SelectedDic = [NSMutableDictionary dictionary];
    [SelectedDic setObject:@"3" forKey:@"favtype"];
    [SelectedDic setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
    [SelectedDic setObject:[dicData stringForKey:@"pkey"] forKey:@"refkey"];
    [_domainSelected getSelected:SelectedDic];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    userId=kimi  用户ID
//    favtype=1  收藏类型
//    1：PPT
//    2：视频
//    3：壁报
//    4：工具
//    refkey=1
    return @"收藏";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end


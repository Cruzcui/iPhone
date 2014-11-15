//
//  HKNewsTableViewController.m
//  HisGuidline
//
//  Created by kimi on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKNewsTableViewController.h"
#import "HKWebViewController.h"
#import "NewsCell.h"
#import "UIImageView+WebCache.h"
@interface HKNewsTableViewController () {
    CGFloat  contentHeight;
}

@property (nonatomic,retain) NSMutableArray* messages;

@end

@implementation HKNewsTableViewController

- (void)dealloc
{
    [self.messages release];
    [_domain release];
    [_paramsDic release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
        _domain = [[HKCategorySearchDomain alloc] init];
        [_domain setDelegate:self];
        _paramsDic = [[NSMutableDictionary alloc] init];
        _pageNumber = 1;
        self.messages = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
-(void) viewDidLayoutSubviews {
    self.tableView.contentSize =CGSizeMake(320, contentHeight) ;
}
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    self.tableView.contentSize =CGSizeMake(320, contentHeight) ;
//    NSLog(@"%f",self.tableView.contentSize.height) ;
//}
-(void) getNetData {
    if (self.messages.count >0) {
        return;
    }
    
    [_paramsDic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"pageNumber"];
    [_paramsDic setObject:@"10" forKey:@"pageSize"];
    
    [_domain getDomainForNews:_paramsDic];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取网络数据
-(void)didParsDatas:(HHDomainBase *)domainData {
    NSArray * dicArray = [domainData dataDetails];
    for (NSDictionary * dic in dicArray) {
        [self.messages addObject:dic];
    }
    [self.tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];

    NSLog(@"%f",self.tableView.contentSize.height) ;
    contentHeight = self.tableView.contentSize.height;

    
}
//下拉刷新，上拉加载部分方法实现
//判断下拉上拉调用对应代理方法


//下拉刷新
-(void)testRealRefreshDataSource{
    [self.messages removeAllObjects];
    _pageNumber = 1;
    [_paramsDic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"pageNumber"];
    [_domain getDomainForNews:_paramsDic];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _pageNumber ++;
    [_paramsDic setObject:[NSString stringWithFormat:@"%d",_pageNumber] forKey:@"pageNumber"];
    [_domain getDomainForNews:_paramsDic];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.messages count];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsMessageCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        

    }
    if (self.messages.count > 0) {
        NSDictionary * dataDic = [self.messages objectAtIndex:indexPath.row];
        cell.title.text = [dataDic stringForKey:@"title"];
        cell.title.font = [UIFont systemFontOfSize:18];
      
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.author.text = [dataDic stringForKey:@"author"];
        [cell.imagetitle setImageWithURL:[NSURL URLWithString:[dataDic stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"user.png"]];
     
       
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"publicdt"] doubleValue] / 1000];
        //时间戳转时间的方法:
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        [formatter release];
        
        cell.time.text = confromTimespStr;
    }

    
    
       return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messages count] > 0) {
        NSDictionary * dic = [self.messages objectAtIndex:indexPath.row];
        
        HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                    bundle:nil Title:[dic stringForKey:@"title"] URL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.199.26.12:8080/mguid/news/phone/news/%@.html",[dic stringForKey:@"pkey"]]]
                                               ] autorelease];
        webController.editFlag = YES;
        
        [self.navigationController pushViewController:webController animated:YES];

}
     //   [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//    HKNewsTableViewController * news = [[HKNewsTableViewController alloc] init];
//    [self.navigationController pushViewController:news animated:YES];
}


@end

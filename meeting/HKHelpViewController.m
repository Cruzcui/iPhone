//
//  HKHelpViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHelpViewController.h"
#import "HKHelperCell.h"
#import "HHDomainBase.h"
#import "HelperHeader.h"
#import "HKHelpContentViewController.h"
#import "HelpContentPostViewController.h"
#import "UIImageView+WebCache.h"
#import "MeetingConst.h"
@interface HKHelpViewController ()

@property (nonatomic,retain) NSMutableArray* datas;

@end

@implementation HKHelpViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _HelperParamsDic = [[NSMutableDictionary alloc] init];
        self.datas = [[[NSMutableArray alloc] init] autorelease];
        _NumberOfPage = 1;

    }
    return self;
}
- (void)dealloc
{
    self.datas = nil;

    [_domain release];
    [_HelperParamsDic release];
    [_header release];
    [_footer release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    HelperHeader * header = [[[NSBundle mainBundle] loadNibNamed:@"HelperHeader" owner:self options:nil] objectAtIndex:0];
    [header.PostHelper setBackgroundColor:getUIColor(Color_NavBarBackColor)];
    [header.PostHelper addTarget:self action:@selector(PostHelpContent) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = header;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self loadMore];
        
    };
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self removeAllData];
    _NumberOfPage = 1;
    [_HelperParamsDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
    [_domain getHelperList:_HelperParamsDic];
    _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];

}

-(void) PostHelpContent {
    HelpContentPostViewController *postcontent = [[[HelpContentPostViewController alloc] init] autorelease];
    postcontent.InfoDic = _HelperParamsDic;
    [self.navigationController pushViewController:postcontent animated:YES];
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self removeAllData];
        _NumberOfPage = 1;
         [_HelperParamsDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
         [_domain getHelperList:_HelperParamsDic];
    }
 }
//下拉加载
-(void)loadMore {
    _NumberOfPage ++;
    [_HelperParamsDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
    [_domain getHelperList:_HelperParamsDic];

}
//网络请求
-(void)getDataFromHelper:(NSDictionary *)Params {
    
    if ([self.datas count] > 0) {
        return;
    } else{
        [_HelperParamsDic setObject:[NSString stringWithFormat:@"%d",_NumberOfPage] forKey:@"pageNumber"];
        [_HelperParamsDic setObject:[Params objectForKey:@"sectionkey"] forKey:@"sectionkey"];
        [_HelperParamsDic setObject:@"10" forKey:@"pageSize"];
        [_domain getHelperList:Params];
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    }
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    NSArray * array = [domainData dataDetails];
    for (NSDictionary * dic in array) {
        [self.datas addObject:dic];
    }
    [self.tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];
    [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

}
-(void)removeAllData {
    [self.datas removeAllObjects];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKHelpCell";
    HKHelperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKHelperCell" owner:nil options:nil] lastObject];
    }
    if ([self.datas count] > 0) {
        NSDictionary* data = [self.datas objectAtIndex:indexPath.row];
        NSDictionary * userDic = [data dictionaryForKey:@"user"];
        cell.title.text =[data stringForKey:@"subject"];
        cell.userName.text = [userDic stringForKey:@"username"];
        [cell.subImageView setImageWithURL:[NSURL URLWithString:[userDic stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"user.png"]];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"modifydt"] doubleValue] / 1000];
        //时间戳转时间的方法:
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        [formatter release];
        cell.timeLabel.text =confromTimespStr;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
       
    }
   return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.datas count] >0) {
        HKHelpContentViewController * help = [[[HKHelpContentViewController alloc] init] autorelease];
        help.ContentDic = [self.datas objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:help animated:YES];
    }
   
}

@end

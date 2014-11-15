//
//  HKSystemMessageViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKSystemMessageViewController.h"
#import "HKSysmessateDomain.h"
#import "MyProfile.h"
#import "HKHomeNavigationController.h"
#import "HKWebViewController.h"
#import "HKHeader.h"



@interface HKSystemMessageViewController ()<HHDomainBaseDelegate>

@property (nonatomic,retain) NSMutableArray* messages;

@property (nonatomic,retain) HKSysmessateDomain* domain;

@end

@implementation HKSystemMessageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.domain = [[HKSysmessateDomain alloc] init];
        self.domain.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"消息中心";
    
    self.messages = [NSMutableArray arrayWithCapacity:4];
    [self.messages addObject:@"<系统通知> 1.2版本重磅更新，请更新"];
    [self.messages addObject:@"<预告> 心血管内科有新指南发布，请下载"];
    [self.messages addObject:@"<私信> 您有一条新评论"];
    [self.messages addObject:@"<热点咨询> 从辩证的视角看临床热点"];
    
    [self requestData:YES];
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self requestData:NO];
        
    };
    
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self requestData:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) requestData:(BOOL) isFirst{
    
    if (isFirst) {
        self.domain.curPage = 1;
    }else{
        self.domain.curPage++;
    }
    
    
    MyProfile* profile = [MyProfile myProfile];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%d",self.domain.curPage] forKey:@"pageNumber"];
    [params setObject:@"10" forKey:@"pageSize"];
    
    [self.domain requestMessage:params];
    
    
}

#pragma mark -  domain delegate
-(void) didParsDatas:(HHDomainBase *)domainData{
    
    [self.tableView reloadData];
    
    
    
    
    [_header endRefreshing];
    [_footer endRefreshing];
    
    if ([self.domain.dataDetails count] < 10) {
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
    if (self.domain.dataDetails==nil) {
        return 1;
    }else{
        return [self.domain.dataDetails count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SystemMessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (self.domain.dataDetails==nil) {
        
        cell.textLabel.text = @"正在加载请稍后...";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    NSDictionary* josonData = [self.domain.dataDetails objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [josonData stringForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
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
    NSDictionary* josonData = [self.domain.dataDetails objectAtIndex:indexPath.row];
    
    NSString* urlStr = [NSString stringWithFormat:URLSysmessageDetail,[josonData stringForKey:@"pkey"]];
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil
                                                                                 Title:@"最新动态"
                                                                                   URL:[NSURL URLWithString:urlStr]
                                           ] autorelease];
    webController.editFlag = YES;
    
    HKHomeNavigationController* nav = [[[HKHomeNavigationController alloc] initWithRootViewController:webController] autorelease];
    
    nav.isPresentModel = YES;
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

@end

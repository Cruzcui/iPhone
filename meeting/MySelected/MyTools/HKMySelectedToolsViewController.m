//
//  HKMySelectedToolsViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMySelectedToolsViewController.h"
#import "MyProfile.h"
#import "HKWebViewController.h"
@interface HKMySelectedToolsViewController ()

@end

@implementation HKMySelectedToolsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _dataArray = [[NSMutableArray alloc] init];
        self.title = @"我的工具";
        _share = [ShareInstance instance];
        _domainDelete = [[HKCommunicateDomain alloc] init];
        [_domainDelete setDelegate:self];
    }
    return self;
}
- (void)dealloc
{
    [_domain clearUnReturnRequestData];   // [_dataArray release];
    [super dealloc];
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_domain clearUnReturnRequestData];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_domain clearUnReturnRequestData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getList];
}
-(void) getList {
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[profile.userInfo stringForKey:@"pkey"]  forKey:@"userId"];
    [_domain getMySelectedTools:paramsDic];

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        _dataArray =(NSMutableArray *) [domainData dataDetails];
        [self.tableView reloadData];
    }
    if (domainData == _domainDelete) {
        if (domainData.status == 0) {
            [self getList];
            _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
            
            
             NSDictionary* data = [_dataArray objectAtIndex:indexRow];
            if ([[_share.MyToolsDic stringForKey:@"pkey"] isEqualToString:[data stringForKey:@"pkey"]]) {
                _share.MyToolsDic = nil;
            }
            
        }else {
            _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
        }
    }
}
-(void) hideAlert {
    
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
    [_alert release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckManulListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([_dataArray count] > 0) {
        NSDictionary * dataDic = [_dataArray objectAtIndex:indexPath.row
                                  ];
        cell.textLabel.text = [dataDic stringForKey:@"title"];
        cell.detailTextLabel.text = [dataDic stringForKey:@"publisher"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArray count] > 0) {
        NSDictionary * dataDic = [_dataArray objectAtIndex:indexPath.row
                                  ];
        if ([[dataDic stringForKey:@"contenttype"] intValue] != 1) {
            NSString * filepath = [dataDic stringForKey:@"contenturl"];
            NSString * tittle = [dataDic stringForKey: @"title"];
            [self showHTMLWebView:filepath Title:tittle];
        } else {
            NSString * strHTML = [dataDic stringForKey:@"contenthtml"];
            NSString * title = [dataDic stringForKey: @"title"];
            [self showHTMLView:strHTML Title:title];
        }
               _share.MyToolsDic =dataDic;
        
    }
}
-(void) showHTMLWebView:(NSString*) filePaht Title:(NSString*) title{
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:title URL:[NSURL URLWithString:filePaht]
                                           ] autorelease];
    webController.editFlag = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    
}
-(void) showHTMLView:(NSString*) html Title:(NSString*) title{
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:title HTML:html
                                           ] autorelease];
    webController.editFlag = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    
}
/**************************删除收藏*****************************/
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
    NSDictionary* data = [_dataArray objectAtIndex:indexPath.row];
    //    userId=kimi  用户pkey
    //    favtype=2  收藏类型
    //    refkey=1  被搜藏的key
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
    [params setObject:[profile.userInfo stringForKey:@"pkey"]forKey:@"userId"];
    [params setObject:[data stringForKey:@"pkey"] forKey:@"refkey"];
    [params setObject:@"4" forKey:@"favtype"];
    [_domainDelete getUnSelected:params];
    indexRow = indexPath.row;

    
    //
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
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end

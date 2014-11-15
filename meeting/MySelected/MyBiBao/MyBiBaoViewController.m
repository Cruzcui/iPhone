//
//  MyBiBaoViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-2.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "MyBiBaoViewController.h"
#import "PosterCell.h"
#import "MyProfile.h"
#import "HKWebViewController.h"
@interface MyBiBaoViewController ()

@end

@implementation MyBiBaoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _dataArray = [[NSMutableArray alloc] init];
        self.title = @"我的壁报";
        _share = [ShareInstance instance];
        _domainDelete = [[HKCommunicateDomain alloc] init];
        [_domainDelete setDelegate:self];

    }
    return self;
}
- (void)dealloc
{
    [_domain clearUnReturnRequestData];    //[_dataArray release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    userId=kimi
//    pageNumber=1
//    pageSize=10
    [self getdataList];

}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_domain clearUnReturnRequestData];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_domain clearUnReturnRequestData];
}

-(void)getdataList {
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[profile.userInfo stringForKey:@"pkey"]  forKey:@"userId"];
    [_domain getMySelectedBiBao:paramsDic];

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        _dataArray = (NSMutableArray *)[domainData dataDetails];
        [self.tableView reloadData];
    }
    if (domainData == _domainDelete) {
        if (domainData.status == 0) {
            [self getdataList];
            
            UIAlertView * alert =[ [UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }else {
            UIAlertView * alert =[ [UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }
    }

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
    static NSString *CellIdentifier = @"Cell";
    PosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PosterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary * dicData = [_dataArray objectAtIndex:indexPath.row];
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
    cell.textLabel.text = @"cell";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

    

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataArray count] > 0) {
        NSDictionary * dicData = [_dataArray objectAtIndex:indexPath.row];
        NSURL* url = [NSURL URLWithString:[dicData stringForKey:@"picurl"]];
        
        HKWebViewController* demo = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:[dicData stringForKey:@"title"] URL: url] autorelease];
        
        demo.editFlag = YES;
        
        [self.navigationController pushViewController:demo animated:YES];
        _share.MyBiBaoDic = dicData;
    }
    
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
    [params setObject:@"3" forKey:@"favtype"];
    [_domainDelete getUnSelected:params];
    
    
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

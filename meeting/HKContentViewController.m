//
//  HKContentViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-3.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKContentViewController.h"
#import "HKWebViewController.h"
#import "MyProfile.h"
@interface HKContentViewController ()

@end

@implementation HKContentViewController
- (void)dealloc
{
    [_domainSelected release];
    [_domain clearUnReturnRequestData];
    [_dataArray release];
    [_domain release];
    [_paramDic release];
    [_titleDic release];
    [super dealloc];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_domain clearUnReturnRequestData];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc] init];
        _domain = [[HKToolsDomain alloc] init];
        [_domain setDelegate:self];
        
        _domainSelected = [[HKToolsDomain alloc] init] ;
        [_domainSelected setDelegate:self];
        _share = [ShareInstance instance];
        _count = 1;
        _paramDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void) didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        NSArray * array = [domainData dataDetails];
        for (NSDictionary * dic in array) {
            [_dataArray addObject:dic];
        }
        [self.tableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }
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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

//    Do any additional setup after loading the view.
//    sectionkey=1  科室ID
//    dictcatkey=100101 目录ID
//    pageNumber=1 起始页
//    pageSize=10 每页行数
    
    [_paramDic setObject:@"10" forKey:@"pageSize"];
    [_paramDic setObject:@"1" forKey:@"pageNumber"];
    NSString * pkey = [_share.KeshiDic stringForKey:@"pkey"];
   // [_paramDic setObject:pkey forKey:@"sectionkey"];
    [_paramDic setObject:self.dictcatkey forKey:@"dictcatkey"];
    [_domain getToolsContent:_paramDic];
    self.title = [self.titleDic stringForKey:@"title"];
    window = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";
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
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [_dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    if( (indexPath.row%2) ==0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
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
      

    }
}

//下拉刷新，上拉加载部分方法实现
//判断下拉上拉调用对应代理方法


//下拉刷新
-(void)testRealRefreshDataSource{
    [self removeAllData];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_paramDic setObject:countString forKey:@"pageNumber"];
    [_paramDic setObject:@"10" forKey:@"pageSize"];
    [_domain getToolsContent:_paramDic];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_paramDic setObject:countString forKey:@"pageNumber"];
    [_domain getToolsContent:_paramDic];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";

    
}

-(void)removeAllData {
    [_dataArray removeAllObjects];
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
//收藏工具
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
    NSLog(@"收藏");
    if ([_dataArray count] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"正在刷新中，收藏失败" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary * dicData = [_dataArray objectAtIndex:indexPath.row];
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * SelectedDic = [NSMutableDictionary dictionary];
    [SelectedDic setObject:@"4" forKey:@"favtype"];
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
    return @"收藏";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

//
//  HKLatestZhiNanViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-2-10.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKLatestZhiNanViewController.h"
#import "HHHomeAdCell.h"
#import "HKGuidListViewCell.h"
#import "SBJsonParser.h"
#import "HKGuidDetailViewController.h"
#import "SBJsonWriter.h"
#import "HKTestDetailViewController.h"
@interface HKLatestZhiNanViewController ()
@property (nonatomic,retain) HHHomeAdCell* adCell;
@property (nonatomic,retain) NSMutableDictionary * dicParams;
@end

@implementation HKLatestZhiNanViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"tab01.png"];
        self.tabBarItem.title = @"个人收藏";
        _share = [ShareInstance instance];
        self.dicParams = [[[NSMutableDictionary alloc] init] autorelease];
        
        _datasourceArray = [[NSMutableArray alloc] init];
        _share = [ShareInstance instance];
        _domain = [[HKCategorySearchDomain alloc] init];
        [_domain setDelegate:self];
        
        _domainMuLu = [[HKCategorySearchDomain alloc] init];
        [_domainMuLu setDelegate:self];
        
        
        _domainDetail = [[HKCategorySearchDomain alloc] init];
        [_domainDetail setDelegate:self];
        
        _pkeyArray = [[NSMutableArray alloc] init];
        _urlListArray = [[NSMutableArray alloc] init];

        
        
        _datasourceDic = [[NSDictionary alloc] init];
        
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

    self.title = @"个人收藏";
    
    
    //广告行
    self.adCell = [[[NSBundle mainBundle]loadNibNamed:@"HHHomeAdCell"owner:self options:nil] lastObject];
    
    [self.adCell loadImages:@""];
    
    self.tableView.tableHeaderView = self.adCell;
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self testRealLoadMoreData];
        
    };

    [self initZhiNanLieBiao];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}

-(void)initZhiNanLieBiao {
    [_dicParams setValue:@"1" forKey:@"sectionkey"];
    [_dicParams setValue:@"1" forKey:@"pageNumber"];
    [_dicParams setValue:@"10" forKey:@"pageSize"];
    [self testFinishedLoadData];
    
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
    return [_datasourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKGuidListViewCell";
    HKGuidListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HKGuidListViewCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    //    NSDictionary* guilds = [self.guidList objectAtIndex:indexPath.row];
    //    NSDictionary* guildData = [[guilds objectForKey:Json_GuidData] dictionaryForKey:JsonHead_data];
    if ([_datasourceArray count] > 0) {
        NSDictionary * dicdata = [_datasourceArray objectAtIndex:indexPath.row];
        
        
        
        cell.titleLabel.text = [dicdata stringForKey:@"title"];
        cell.authorLabel.text = [dicdata stringForKey:@"publisher"];
        cell.timeLabel.text = @"";
        cell.countZhizhen.textColor = [UIColor whiteColor];
        cell.countZhizhen.font = [UIFont systemFontOfSize:14];
        
        if ([self OpenLocalFile:[dicdata stringForKey:@"pkey"]] == NO && [[dicdata stringForKey:@"needscore"] intValue] == 0) {
            
            cell.downloadImageView.image = [UIImage imageNamed:@"freedownload.png"];
            cell.countZhizhen.text = @"免费下载";
            cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
            
            
        }if ([self OpenLocalFile:[dicdata stringForKey:@"pkey"]] == YES) {
            cell.downloadImageView.image = [UIImage imageNamed:@"downloaded.png"];
            cell.countZhizhen.text = @"已经下载";
            cell.countZhizhen.textColor = [UIColor grayColor];
            cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
            
        }
        if ([self OpenLocalFile:[dicdata stringForKey:@"pkey"]] == NO && [[dicdata stringForKey:@"needscore"] intValue] != 0) {
            cell.downloadImageView.image = [UIImage imageNamed:@"needZhiZhen.png"];
            cell.countZhizhen.text = [NSString stringWithFormat:@"      × %@",[dicdata stringForKey:@"needscore"]];
            cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
        }
        
        
        if ([[dicdata stringForKey:@"pptCount"] intValue] == 0) {
            cell.PPT.hidden = YES;
        }
        if ([[dicdata stringForKey:@"videoCount"] intValue] == 0) {
            cell.Video.hidden = YES;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    
    
    return cell;
}
#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.detailView.frame.origin.x>0) {
//        [self leftButtonClick:nil];
//    }else{
//        
//    }
    
    //    if (indexPath.row>0) {
    //        return;
    //    }
    
    
    selectedRow = indexPath.row;
    
    //
    //    UIAlertView* alerView = [[[UIAlertView alloc] initWithTitle:@"指南大闯关"
    //                                                       message:@"参与冲关游戏，可以获得10枚指南针，你会错过这次机会吗？"
    //                                                      delegate:self
    //                                             cancelButtonTitle:@"取消"
    //                                             otherButtonTitles:@"马上闯关",@"下次再说",@"永不提示", nil] autorelease];
    //    [alerView setTag:1];
    //    [alerView show];
    NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
    BOOL downLoad = [self OpenLocalFile:[dic stringForKey:@"pkey"]];
    if (downLoad == NO) {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此条目尚未下载，立即下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
        [alert setTag:2];
        [alert show];
    } else {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSData * str = [self WriteLocalFile:[dic stringForKey:@"pkey"] andsavefile:[dic stringForKey:@"pkey"]];
        NSArray * dicdata = [parser objectWithData:str];
        HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:dicdata andPkey:[dic stringForKey:@"pkey"] andtitleDic:dic andAllNodes:_pkeyArray ];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        [parser release];
        
    }
    
    
    
}
#pragma mark UIAlertView delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex==0) {
            return;
        }
        
        if (buttonIndex == 1) {
            
            
            NSDictionary* testes = [_datasourceArray objectAtIndex:selectedRow];
            HKTestDetailViewController *detailViewController = [[HKTestDetailViewController alloc] initWithStyle:UITableViewStyleGrouped TestData:testes];
            
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            return;
        }
        //原文目录数据请求
        //NSDictionary * dicdata = [_datasourceArray objectAtIndex:selectedRow];
        //查找本地数据
        
        //下载提示
        NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
        BOOL downLoad = [self OpenLocalFile:[dic stringForKey:@"pkey"]];
        if (downLoad == NO) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此条目尚未下载，立即下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
            [alert setTag:2];
            [alert show];
        } else {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSData * str = [self WriteLocalFile:[dic stringForKey:@"pkey"] andsavefile:[dic stringForKey:@"pkey"]];
            NSArray * dicdata = [parser objectWithData:str];
            HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:dicdata andPkey:[dic stringForKey:@"pkey"] andtitleDic:dic andAllNodes:_pkeyArray];
            
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            [parser release];
            
        }
        
        
    }
    if (alertView.tag == 2) {
        if (buttonIndex==0) {
            return;
        }
        if (buttonIndex == 1) {
            NSLog(@"下载");
            NSMutableDictionary * dicparams =[NSMutableDictionary dictionary];
            NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
            [dicparams setObject:[dic stringForKey:@"pkey" ] forKey:@"medguidekey"];
            [_domainMuLu getDomainForYuanWenMuLu:dicparams];
            _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.labelText = @"正在下载中";
            
        }
        
    }
}

//判断本地是否存在文件
-(BOOL)OpenLocalFile:(NSString*)fileName  {
    //NSDictionary * dicdata = [_datasourceArray objectAtIndex:selectedRows];
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    //NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return  [filemanage fileExistsAtPath:desPath];
    
    
}
//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:realPath];
    return dataInfile;
}


//保存文件
-(void)saveFile:(NSString*)fileName Data:(NSData *)data andsavefile:(NSString *)realfilename{
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:realPath atomically:YES];
    NSLog(@"%@",desPath);
}
//请求目录内容
-(void) getdetails:(NSString *)params{
    NSMutableDictionary * dicparmas = [NSMutableDictionary dictionary];
    [dicparmas setObject:params forKey:@"pkey"];
    [_domainDetail getDomainDetail:dicparmas];
}


//初始化加载页面
-(void)testFinishedLoadData{
    [_domain getDomainForZhiNanYuanWen:_dicParams];
    // [self.tableView reloadData];
}
//下拉刷新
-(void)testRealRefreshDataSource{
    // after refreshing data, call finishReloadingData to reset the header/footer view
    [_datasourceArray removeAllObjects];//刷新数据时，数组清空 重新加载
    
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_dicParams setObject:countString forKey:@"pageNumber"];
    [self testFinishedLoadData];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count += 1;//每次加载10条，数据增加10条数据
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_dicParams setObject:countString forKey:@"pageNumber"];
    [self testFinishedLoadData];
    
    
    
}
//获取列表数据
//获取列表数据
-(void) didParsDatas:(HHDomainBase *)domainData{
    if (domainData == _domain) {
        for (NSDictionary * dic in [domainData dataDetails]) {
            [_datasourceArray addObject:dic];
        }
        [self.tableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        self.tableView.showsVerticalScrollIndicator = YES;
    }
    //请求目录
    if (domainData == _domainMuLu) {
        NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
        SBJsonWriter * writer = [[SBJsonWriter alloc] init];
        NSString * str = [writer stringWithObject:[domainData dataDetails]];
        NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self saveFile:[dic stringForKey:@"pkey"] Data:jsonData andsavefile:[dic stringForKey:@"pkey"]];
        [self.tableView reloadData];
        [writer release];
        //保存列表
        SBJsonWriter * writers = [[SBJsonWriter alloc] init];
        NSString * str1 = [writers stringWithObject:dic];
        NSData* jsonData1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
        [self saveFile:[dic stringForKey:@"pkey"] Data:jsonData1 andsavefile:@"index"];
        [writers release];
        //多级目录下载保存
        NSArray * yijiMulu = [domainData dataDetails];
        
        
        [self searchAllNodes:yijiMulu];
        
        NSLog(@"%@",_pkeyArray);
        _childrenIndex = 0;
        [self getdetails:[_pkeyArray objectAtIndex:_childrenIndex]];
        
        //目录内容请求
        //获取每条目录下得pkey
        
        //        NSArray * MuLuDetailArray = [domainData dataDetails];
        //        for (NSDictionary * detail in MuLuDetailArray) {
        //            NSArray * parents = [detail arrayForKey:@"children"];
        //            if ([parents count] == 0) {
        //                [_pkeyArray addObject:[detail stringForKey:@"pkey"]];
        //            }else {
        //                for (NSDictionary * childrenpkey in parents) {
        //                    [_pkeyArray addObject:[childrenpkey stringForKey:@"pkey"]];
        //                }
        //            }
        //        }
        //        _childrenIndex = 0;
        //        if ([_pkeyArray count] > 0) {
        //            [self getdetails:[_pkeyArray objectAtIndex:_childrenIndex]];
        //        }
        //        else {
        //            [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        //
        //        }
    }
    //请求目录内容
    if (domainData == _domainDetail) {
        // NSArray *arrayForContent = [domainData dataDetails];
        //json反解析存入本地
        NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
        SBJsonWriter * writer = [[SBJsonWriter alloc] init];
        NSString * str = [writer stringWithObject:[domainData dataDictionary]];
        NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self saveFile:[dic stringForKey:@"pkey"] Data:jsonData andsavefile:[NSString stringWithFormat:@"%@with%@",[dic stringForKey:@"pkey"],[_pkeyArray objectAtIndex:_childrenIndex]]];
        _childrenIndex ++;
        [writer release];
        if (_childrenIndex != [_pkeyArray count]) {
            [self getdetails:[_pkeyArray objectAtIndex:_childrenIndex]];
        }else {
            [self savePDF];
        }
        
        
    }
    
}
//遍历所有目录
-(void) searchAllNodes:(NSArray * )Nodes {
    if ([Nodes count] > 0) {
        for (NSDictionary * dic in Nodes) {
            [_pkeyArray addObject:[dic stringForKey:@"pkey"]];
            NSArray * urlArray = [dic arrayForKey:@"urlList"];
            if ([urlArray count] > 0) {
                for (NSDictionary * dicurl in urlArray) {
                    [_urlListArray addObject:[dicurl stringForKey:@"url"]];
                }
            }
            [self searchAllNodes:[dic arrayForKey:@"children"]];
        }
    }
    return;
}
//保存PDF文件到本地
-(void)savePDF {
    if ([_urlListArray count] > 0) {
        _PDFIndex = 0;
        _data = [[NSMutableData alloc] init];
        NSString * urlStr = [_urlListArray objectAtIndex:_PDFIndex];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];

    } else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

    }
    
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];//获取一真调用一次
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
    NSString * PDFName = [[_urlListArray objectAtIndex:_PDFIndex] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    [self saveFile:[dic stringForKey:@"pkey"] Data:_data andsavefile:PDFName];
    [_data release];
    _PDFIndex ++;
    if (_PDFIndex != [_urlListArray count]) {
        _data = [[NSMutableData alloc] init];
        NSString * urlStr = [_urlListArray objectAtIndex:_PDFIndex];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _PDFIndex ++;
    if (_PDFIndex != [_urlListArray count]) {
        _data = [[NSMutableData alloc] init];
        NSString * urlStr = [_urlListArray objectAtIndex:_PDFIndex];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
    } else {
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
        
    }
    
    //NSLog(@"%@", [_urlListArray objectAtIndex:_PDFIndex]);
    NSLog(@"%s",__FUNCTION__);
    
}

@end

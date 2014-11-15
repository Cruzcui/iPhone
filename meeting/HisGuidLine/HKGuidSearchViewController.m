//
//  HKGuidSearchViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-8.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKGuidSearchViewController.h"
#import "HKLocalGuidListDomain.h"
#import "HHDomainBase.h"
#import "HKDLCategoryListViewController.h"
#import "HKGuidListViewCell.h"
#import "MeetingConst.h"
#import "HKDLCategoryListViewController.h"
#import "HKGuidDetailViewController.h"
#import "HKTestDetailViewController.h"
#import "HKCategoryViewController.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "UIDevice+Resolutions.h"
#import "UIViewController+MMDrawerController.h"
#import "MyTableViewController.h"
#import "HHHomeAdCell.h"
#import "YGPSegmentedController.h"
#import "MyProfile.h"
#import "CheckNetwork.h"
#import "ShareInstance.h"

@interface HKGuidSearchViewController ()<YGPSegmentedControllerDelegate,HKDLCategoryListViewControllerDelegate>{
    int selectedRow;
    NSMutableArray * _datasourceArray;
    NSMutableDictionary * _dicParams;
    NSDictionary * _datasourceDic;
    int _count;
}


@property (nonatomic,retain) UISearchBar* searchBar;

@property (nonatomic,retain) NSArray* guidList;
@property (nonatomic,retain) NSArray* testList;

@property (nonatomic,retain) HKCategoryViewController* categoryController;

@property (retain, nonatomic) IBOutlet UIButton *adImgButton;


//广告栏
@property (nonatomic,retain) HHHomeAdCell* adCell;

//科室收藏滚动栏
@property (nonatomic,retain) YGPSegmentedController* sgementedView;
@property (nonatomic,retain) UIView* sectionHeaderView;
@property (nonatomic,retain) UIButton* addFavButton;

@property (nonatomic,retain) NSMutableArray* favSectionArray;

@end

@implementation HKGuidSearchViewController

//2014-2-20 by kimi 根据页面类型初始化
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(int)type{
    
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageType = type;
        
        if (self.pageType == 0) {
            self.tabBarItem.image = [UIImage imageNamed:@"tab02.png"];
            self.tabBarItem.title = @"指南精读";
            self.sectionkey = nil;
        }else{
            self.tabBarItem.image = [UIImage imageNamed:@"tab01.png"];
            self.tabBarItem.title = @"重点推荐";
            self.sectionkey = @"1";
        }
    }
    
    return self;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.pageType = 0;
        
        self.tabBarItem.image = [UIImage imageNamed:@"tab02.png"];
        self.tabBarItem.title = @"指南精读";
        
        
        _datasourceArray = [[NSMutableArray alloc] init];
        _share = [ShareInstance instance];
        _domain = [[HKCategorySearchDomain alloc] init];
        [_domain setDelegate:self];
        
        _domainMuLu = [[HKCategorySearchDomain alloc] init];
        [_domainMuLu setDelegate:self];
        
        
        _domainDetail = [[HKCategorySearchDomain alloc] init];
        [_domainDetail setDelegate:self];
        
        
       
        
        _dicParams = [[NSMutableDictionary alloc] init];
        _datasourceDic = [[NSDictionary alloc] init];
        [_domain setDelegate:self];
        _count = 1;
        
        _pkeyArray = [[NSMutableArray alloc] init];
        _urlListArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc{
    
    self.guidList = nil;
    self.searchBar = nil;
    self.categoryController = nil;
    
    self.sectionkey = nil;
    self.adCell = nil;
    
    self.sgementedView = nil;
    self.sectionHeaderView = nil;
    self.addFavButton = nil;
    self.favSectionArray = nil;
    
    [_datasourceDic release];
    [_cagetoryTableView release];
    [_detailView release];
    [_adImgButton release];
    [_domain release];
    [_domainMuLu release];
    [_domainDetail release];
    [_dicParams release];
    [_pkeyArray release];
    [_urlListArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    if (self.meetingFlag == NO) {
        //self.title = @"指南精读";
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)] autorelease];
        self.searchBar.delegate = self;
        
        
        
        if (self.pageType == 1) { //推荐放广告
            self.adCell = [[[NSBundle mainBundle]loadNibNamed:@"HHHomeAdCell"owner:self options:nil] lastObject];
            
            [self.adCell loadImages:@""];
            
            self.tableView.tableHeaderView = self.adCell;
        }else{
            
            self.sectionHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
            
            //self.sectionHeaderView.backgroundColor = [UIColor redColor];
            
            [self reloadFavSectionView];
            
            //self.tableView.tableHeaderView = self.sectionHeaderView;
        }
        
        
        
        
        
        
        HKLocalGuidListDomain* guidDomain = [[[HKLocalGuidListDomain alloc] init] autorelease];
        
        NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/db/guid"];
        
        self.guidList = [guidDomain getGuidList:path];
        
        
        //2012-02-20 by kimi
        //self.detailView.backgroundColor =[UIColor clearColor];
        //self.cagetoryTableView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        
        
        
        
        //指南大闯关数据源
        HKLocalGuidListDomain* testdDomain = [[[HKLocalGuidListDomain alloc] init] autorelease];
        
        NSString* testPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/db/test"];
        
        self.testList = [testdDomain getGuidList:testPath];
        
        
        if (self.pageType == 1) { //重点推荐
            
        }
        _header = [[MJRefreshHeaderView alloc] init];
        _header.delegate = self;
        _header.scrollView = self.tableView;
        
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.tableView;
        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            [self testRealLoadMoreData];
            
        };
        
        [self searchData:YES];

    }
       /* 2014-2-20 by kimi 取消指南左侧科室列表监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initZhiNanLieBiao:) name:@"ZHINANLIEBIAO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchbarBecome) name:@"search" object:nil];
     */

    
    

     else {
         self.title = @"临床指南";
        _datasourceArray =(NSMutableArray *) self.arrayMeeting;
    }
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}


-(void) reloadFavSectionView{
    //todo:
    
    self.favSectionArray = [self loadFavSection];
    
    if (self.favSectionArray == nil || self.favSectionArray.count == 0) {
        self.favSectionArray = [NSMutableArray array];
        
        if (self.favSectionArray.count == 0) {
            NSMutableDictionary* defaultSection = [NSMutableDictionary dictionary];
            [defaultSection setObject:@"-1" forKey:@"pkey"];
            [defaultSection setObject:@"全学科" forKey:@"sname"];
            
            [self.favSectionArray addObject:defaultSection];
            
            NSArray* section = [ShareInstance instance].categroyDatas;
            if (section!=nil) {
                for (int i=0; i<3; i++) {
                    if (i<section.count) {
                        [self.favSectionArray addObject:[section objectAtIndex:i]];
                    }
                }
            }

        }
    }
    
    NSMutableArray* titleArray = [NSMutableArray array];
    for (NSDictionary* dic in self.favSectionArray) {
        [titleArray addObject:[dic stringForKey:@"sname"]];
    }
    
    
    if (self.sgementedView!=nil) {
        [self.sgementedView removeFromSuperview];
    }
    
    self.sgementedView = [[[YGPSegmentedController alloc] initContentTitle:titleArray CGRect:CGRectMake(0, 0, 320-50, 44)] autorelease];
    
    //self.sgementedView.backgroundColor = [UIColor redColor];
    //self.sgementedView
    
    self.sgementedView.Delegate = self;
    
    [self.sectionHeaderView addSubview:self.sgementedView];
    
    
    //增加收藏按钮
    
    
    
    
    self.addFavButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addFavButton setTitle:@"添加" forState:UIControlStateNormal];
    self.addFavButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addFavButton.titleLabel.textColor = [UIColor whiteColor];
    //self.addFavButton.tintColor = [UIColor whiteColor];
    [self.addFavButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.addFavButton.frame = CGRectMake(320-50, 8, 44, 28);
    self.addFavButton.backgroundColor = [UIColor whiteColor];
    
    
    
    self.addFavButton.backgroundColor = getUIColor(Color_NavBarBackColor);
    
    self.addFavButton.layer.borderWidth = 1.0f;
    self.addFavButton.layer.cornerRadius = 5.0f;
    self.addFavButton.layer.borderColor = getUIColor(Color_NavBarBackColor).CGColor;
    
    [self.addFavButton addTarget:self action:@selector(addFavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sectionHeaderView addSubview:self.addFavButton];
    
    self.sectionHeaderView.backgroundColor = [UIColor colorWithRed:229.0/255.0f green:242.0/255.0f blue:254.0/255.0f alpha:1];
    self.sectionHeaderView.alpha = 1;
    
    //默认显示订阅的第一个科室
    [self segmentedViewController:self.sgementedView touchedAtIndex:0];
    
}

//科室类表Sgment代理
-(void) segmentedViewController:(YGPSegmentedController *)segmentedControl touchedAtIndex:(NSUInteger)index{
    
    if (index<self.favSectionArray.count) {
        
        NSDictionary* sectionJson = [self.favSectionArray objectAtIndex:index];
        self.sectionkey = [sectionJson objectForKey:@"pkey"];
        
        if ([self.sectionkey isEqualToString:@"-1"]) {
            self.sectionkey = nil;
        }
        
        [self searchData:YES];
        
    }
    
}


//科室类表Secton Header
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.meetingFlag == NO) {
        if (self.pageType == 0) {
            return self.sectionHeaderView;
        }else{
            return nil;
        }

    }else
        return nil;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.meetingFlag == NO) {
        if (self.pageType == 0) {
            return 44;
        }else{
            return 0;
        }
    }else {
        return 0;
    }
   }

//弹出科室订阅页面
-(void) addFavButtonClick:(id) sender{
    
    HKCategoryViewController * categoryAddFav = [[[HKCategoryViewController alloc] init]autorelease];
    categoryAddFav.pageType = 1;
    
    categoryAddFav.favSectionArray = self.favSectionArray;
    categoryAddFav.delegate = self;
    
    [self.navigationController pushViewController:categoryAddFav animated:YES];
    
}


-(void) hkDLCategorytableView:(UITableViewController *)tableView didSelectFav:(NSMutableArray *)favArray{
    
    self.favSectionArray = favArray;
    
    [self saveFavSection];
    
    NSLog(@"%@",self.favSectionArray);
    
    [self reloadFavSectionView];
    
    
}


/* 2014-2-20 by kimi
-(void)initZhiNanLieBiao:(NSNotification *) notify {
    NSDictionary * dic = [notify object];
    _datasourceDic = dic;
    [dic stringForKey:@"pkey"];
    [_dicParams setValue:[dic stringForKey:@"pkey"] forKey:@"sectionkey"];
    [_dicParams setValue:@"1" forKey:@"pageNumber"];
    [_dicParams setValue:@"10" forKey:@"pageSize"];
    [self testFinishedLoadData];
    
}
*/


/*
-(void) leftButtonClick:(id)sender{
    
    [UIView beginAnimations:nil context:NULL]; {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
    if (self.detailView.frame.origin.x>0) {
        self.detailView.frame = CGRectMake(-10, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }else{
        self.detailView.frame = CGRectMake(150, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }}
    [UIView commitAnimations];
    
}
 */

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
            
            
            //2014-02-20 kimi 未下载隐藏图标
            
            cell.downloadImageView.hidden = YES;
            cell.countZhizhen.hidden = YES;
            
            //cell.downloadImageView.image = [UIImage imageNamed:@"freedownload.png"];
            //cell.countZhizhen.text = @"免费下载";
            //cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
            
            
        }if ([self OpenLocalFile:[dicdata stringForKey:@"pkey"]] == YES) {
            
            cell.downloadImageView.hidden = NO;
            cell.countZhizhen.hidden = NO;
            
            //cell.downloadImageView.image = [UIImage imageNamed:@"downloaded.png"];
            //cell.countZhizhen.text = @"已经下载";
            //cell.countZhizhen.textColor = [UIColor grayColor];
            //cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
        }
        
        
        /*
        if ([self OpenLocalFile:[dicdata stringForKey:@"pkey"]] == NO && [[dicdata stringForKey:@"needscore"] intValue] != 0) {
             cell.downloadImageView.image = [UIImage imageNamed:@"needZhiZhen.png"];
            cell.countZhizhen.text = [NSString stringWithFormat:@"      × %@",[dicdata stringForKey:@"needscore"]];
            cell.countZhizhen.textAlignment = NSTextAlignmentCenter;
        }
        */
        
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
    
    /*
    //测试收藏
     NSDictionary * dicData = [_datasourceArray objectAtIndex:indexPath.row];
    
    MyProfile* profile = [MyProfile myProfile];
    
    
    
    [profile saveFavFor:Fav_Type_MedGuid data:dicData key:[dicData stringForKey:@"pkey"]];
    
    [profile deleteFavFor:Fav_Type_MedGuid key:[dicData stringForKey:@"pkey"]];
    
    NSArray* list = [profile getFavList:Fav_Type_MedGuid];
    
    
    NSLog(@"%@",list);
    
    
    
    return;
    */
    
    
    
    selectedRow = indexPath.row;
    
//    
//    UIAlertView* alerView = [[[UIAlertView alloc] initWithTitle:@"指南大闯关"
//                                                       message:@"参与冲关游戏，可以获得10枚指南针，你会错过这次机会吗？"
//                                                      delegate:self
//                                             cancelButtonTitle:@"取消"
//                                             otherButtonTitles:@"马上闯关",@"下次再说",@"永不提示", nil] autorelease];
//    [alerView setTag:1];
//    [alerView show];
    if ([_datasourceArray count] > 0) {
        NSDictionary * dic = [_datasourceArray objectAtIndex:selectedRow];
        BOOL downLoad = [self OpenLocalFile:[dic stringForKey:@"pkey"]];
        if (downLoad == NO) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否下载此指南(建议wifi网络下载)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
            [alert setTag:2];
            [alert show];
        } else {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSData * str = [self WriteLocalFile:[dic stringForKey:@"pkey"] andsavefile:[dic stringForKey:@"pkey"]];
            NSArray * dicdata = [parser objectWithData:str];
            HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:dicdata andPkey:[dic stringForKey:@"pkey"] andtitleDic:dic andAllNodes:_pkeyArray ];
            NSDictionary * dicdatas = [_datasourceArray objectAtIndex:indexPath.row];
            if ([[dicdatas stringForKey:@"pptCount"] intValue] == 0) {
                detailViewController.pptflag = YES;
            }
            if ([[dicdatas stringForKey:@"videoCount"] intValue] == 0) {
                detailViewController.videoflag = YES;
            }
            
            
            
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            [parser release];
            
        }
    }


    
    
}




#pragma mark - Search Bar

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    // Set Cancel Button
    [self.searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [self.searchBar subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            break;
        }
    }
    
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:NO];
    
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    // Button Setting
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self doSearch:searchBar];
    
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self controlAccessoryView:0.9];// 显示遮盖层。
    return YES;
    
}
-(void)searchbarBecome {
    [self.searchBar becomeFirstResponder];

}
/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
//    _count = 1;
//    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    NSMutableDictionary * searchparams = [NSMutableDictionary dictionary];
    [searchparams setValue:[_datasourceDic stringForKey:@"pkey"] forKey:@"sectionkey"];
    [searchparams setObject:self.searchBar.text forKey:@"title"];
//    [_dicParams setObject:countString forKey:@"pageNumber"];
    [_datasourceArray removeAllObjects];
    [_domain getDomainForZhiNanYuanWen:searchparams];

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCagetoryTableView:nil];
    [self setDetailView:nil];
    [self setAdImgButton:nil];
    [super viewDidUnload];
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
            _hud.mode = MBProgressHUDModeDeterminate;
            _hud.labelText = @"正在下载中";
            //[_hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
        }

    }
}
//- (void)myProgressTask {
//    // This just increases the progress indicator in a loop
//    float progress = 0.0f;
//    while (progress < 1.0f) {
//        progress += 0.01f;
//        _hud.progress = progress;
//        usleep(50000);
//    }
//}
- (IBAction)adImgButtonClick:(id)sender {
    
    [UIView beginAnimations:nil context:NULL]; {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        
        self.adImgButton.frame = CGRectMake(0, self.view.bounds.size.height, 320, 75);
        
    }
    [UIView commitAnimations];
    
}
//获取列表数据
-(void) didParsDatas:(HHDomainBase *)domainData{
    if (domainData == _domain) {
        if (self.frashFlag == YES) {
            [_datasourceArray removeAllObjects];
        }
        
        for (NSDictionary * dic in [domainData dataDetails]) {
            [_datasourceArray addObject:dic];
        }
        [self.tableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
        
        _hud = nil;
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

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
        _hud.progress = (_childrenIndex * 0.1) / ([_pkeyArray count] * 0.1);
        [writer release];
        if (_childrenIndex != [_pkeyArray count]) {
            [self getdetails:[_pkeyArray objectAtIndex:_childrenIndex]];
          
            
        }else {
            NSString * str = @"downloadOk";
             NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self saveFile:[dic stringForKey:@"pkey"] Data:jsonData andsavefile:@"finishiflag"];

            _hud = nil;
            [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
            [self.tableView reloadData];

        }

        
    }

}

//得到保存关注列表的文件名
-(NSString*) favFileName{
    
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"FavSection"] ;
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    if (![filemanage fileExistsAtPath:docPath]) {
        
        [filemanage createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * desPath = [docPath stringByAppendingPathComponent:@"fav.data"] ;
    
    return desPath;
}

//保存关注列表
-(void) saveFavSection{
    NSString* fileName = [self favFileName];
    
    if (self.favSectionArray!=nil) {
        
        NSString* jsonStr = [self.favSectionArray toJson];
        
        
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [jsonData writeToFile:fileName atomically:NO];
        
        //[self.favSectionArray wr]
        //[self.favSectionArray writeToFile:fileName atomically:NO];
    }
    
}


//从文件中加载关注列表
-(NSMutableArray*) loadFavSection{
    NSString* fileName = [self favFileName];
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (![filemanage fileExistsAtPath:fileName]) {
        return nil;
    }else{
        NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:fileName];
        
        NSArray* arr = [NSArray fromData:dataInfile];
        
        return [NSMutableArray arrayWithArray:arr];
        
        //return [NSMutableArray arrayWithContentsOfFile:fileName];
    }
    
}


//请求目录内容
-(void) getdetails:(NSString *)params{
    NSMutableDictionary * dicparmas = [NSMutableDictionary dictionary];
    [dicparmas setObject:params forKey:@"pkey"];
    [_domainDetail getDomainDetail:dicparmas];
}


//初始化加载页面数据
-(void) searchData:(BOOL) isFirstPage {
    
    if (isFirstPage) {
        _count = 1;
        self.frashFlag = YES;
        //[_datasourceArray removeAllObjects];
    }else{
        self.frashFlag = NO;
        _count++;
    }
    
    
    //[_dicParams removeObjectForKey:@"sectionkey"];
    [_dicParams removeAllObjects];
    
    if (self.sectionkey) {
        [_dicParams setValue:self.sectionkey forKey:@"sectionkey"];
    }
    
    [_dicParams setValue:[NSString stringWithFormat:@"%d",_count] forKey:@"pageNumber"];
    [_dicParams setValue:@"10" forKey:@"pageSize"];
    
    [_domain getDomainForZhiNanYuanWen:_dicParams];
    
    if (_hud==nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.labelText = @"正在刷新数据";
    }
    if ([CheckNetwork isExistenceNetwork] == NO) {
        [_header endRefreshing];
        [_footer endRefreshing];

        
       
    }


    
 
   // [self.tableView reloadData];
}
//下拉刷新 -- 重新请求数据
-(void)testRealRefreshDataSource{
    
    //[_datasourceArray removeAllObjects];//刷新数据时，数组清空 重新加载
    [self searchData:YES];
    self.tableView.showsVerticalScrollIndicator = NO;
   
}

//上拉加载 -- 加载下一页数据
-(void)testRealLoadMoreData{
    [self searchData:NO];

   
}
//判断本地是否存在文件
-(BOOL)OpenLocalFile:(NSString*)fileName  {
    //NSDictionary * dicdata = [_datasourceArray objectAtIndex:selectedRows];
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [[docPath stringByAppendingPathComponent:fileName] stringByAppendingPathComponent:@"finishiflag"] ;
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
        _hud = nil;
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
        _hud = nil;
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
         _hud = nil;
         [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

     }

    //NSLog(@"%@", [_urlListArray objectAtIndex:_PDFIndex]);
    NSLog(@"%s",__FUNCTION__);
    
}


@end

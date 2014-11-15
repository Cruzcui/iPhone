   //
//  HKMyPPTViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMyVideosViewController.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"
#import "HKVideoViewController.h"
#import "DirectionMPMoviePlayerViewController.h"
#import "MyProfile.h"
@interface HKMyVideosViewController ()

@end

@implementation HKMyVideosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayData = [[NSArray alloc] init];
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        [_domain setTag:1];
        _dataForVidio = [[NSMutableArray alloc] init];
        _Vidioparam  = [[NSMutableDictionary alloc] init];
        _count = 1;
        domainDetail = [[HKCommunicateDomain alloc] init];
        [domainDetail setDelegate:self];
        [domainDetail setTag:2];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"HUANDENG" object:nil];
        _domainSelected = [[HKCommunicateDomain alloc] init];
        [_domainSelected setDelegate:self];

        
    }
    return self;
}



- (void)dealloc
{
    [_arrayData release];
    [_domain release];
    [_dataForVidio release];
    [_Vidioparam release];
    [domainDetail release];
    [_domainSelected release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        
    }

    //EGRORefresh
    if (self.meetingflag == NO) {
        if (_flag == NO) {
//            UIImage* adImage = [UIImage imageNamed:@"ad_comm.png"];
//            UIImageView* imgView = [[[UIImageView alloc] initWithImage:adImage] autorelease];
//            self.tableView.tableHeaderView = imgView;
        }
        self.title = [self.titleDic stringForKey:@"title"];
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
    else {
        self.title = @"视频";
        _dataForVidio = (NSMutableArray *)self.arraymeeting;
    }
    
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}
-(void)getData:(NSNotification *) notify {
    _arrayData = [[notify object] retain];
}
//网络请求
-(void)getDataFromVidio:(NSDictionary *)Params {
    
    if ([_dataForVidio count] > 0) {
        return;
    } else{
        if (_flag == NO) {
            [_Vidioparam setObject:[Params objectForKey:@"sectionkey"] forKey:@"sectionkey"];
        }if (_flag == YES) {
            [_Vidioparam setObject:[Params objectForKey:@"pkey"] forKey:@"medguidid"];
        }
        NSString * countString = [NSString stringWithFormat:@"%d",_count];
        [_Vidioparam setObject:@"10" forKey:@"pageSize"];
        [_Vidioparam setObject:@"1" forKey:@"pageNumber"];
        [_domain getDomainForMyVideo:_Vidioparam];
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    }
}
-(void)getDataForLoadMore{
    [_domain getDomainForMyVideo:_Vidioparam];
}
-(void)removeAllData {
    [_dataForVidio removeAllObjects];
}

//接受数据代理方法
-(void) didParsDatas:(HHDomainBase *)domainData {
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

    if (domainData == _domain) {
        NSArray * arraySorce = [domainData dataDetails];
        for (NSDictionary * dic in arraySorce) {
            [_dataForVidio addObject:dic];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.parentViewController.view  animated:YES];
    } if (domainData == domainDetail)  {
        self.photos = [NSMutableArray array];
        NSDictionary * dic = [domainData dataDictionary];
        NSArray * array = [dic objectForKey:@"contentEOs"];
        for (NSDictionary* photoDic in array) {
            NSURL * url = [NSURL URLWithString:[photoDic stringForKey:@"imgurl"]] ;
            [self.photos addObject:[MWPhoto photoWithURL:url]];
        }
        // Create & present browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // Set options
        browser.hidesBottomBarWhenPushed = YES;
        browser.displayActionButton = NO;
        browser.wantsFullScreenLayout = YES;
        [self.navigationController pushViewController:browser animated:YES];
      
    }
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataForVidio count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    if ([_dataForVidio count] >0) {
        NSDictionary* data = [_dataForVidio objectAtIndex:indexPath.row];
        
        //    cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
        [cell.imgTitle setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"nav_3@2x.png"]];
        
        cell.titleLabel.text = [data stringForKey:@"title"];
        cell.sectionLabel.text = [data stringForKey:@"author"];
        cell.timeLabel.text = [data stringForKey:@"time"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_flag == YES) {
        return @"Video";
    }else
        return nil;
}
//下拉刷新，上拉加载部分方法实现
//判断下拉上拉调用对应代理方法

//下拉刷新
-(void)testRealRefreshDataSource{
    [self removeAllData];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_Vidioparam setObject:countString forKey:@"pageNumber"];
    [_Vidioparam setObject:@"10" forKey:@"pageSize"];
    [_domain getDomainForMyVideo:_Vidioparam];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_Vidioparam setObject:countString forKey:@"pageNumber"];
    [self getDataForLoadMore];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataForVidio count] > 0) {
        NSDictionary* data = [_dataForVidio objectAtIndex:indexPath.row];
        [self createMPPlayerController:[data stringForKey:@"videourl"]];
    }
    
}
- (void)createMPPlayerController:(NSString *)sFileNamePath {
    
   MPMoviePlayerViewController *moviePlayer =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:sFileNamePath]];
    moviePlayer.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    [moviePlayer.moviePlayer prepareToPlay];
    
    [moviePlayer.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    
    [moviePlayer.view setFrame:self.view.bounds];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer]; // 这里是presentMoviePlayerViewControllerAnimated
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                            selector:@selector(movieFinishedCallback:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                              object:moviePlayer];
    
    [moviePlayer release];
    
}
-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                  object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return YES;
//}
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
#pragma mark - WMPhotobrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}
//收藏
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
    NSLog(@"收藏");
    if ([_dataForVidio count] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"正在刷新中，收藏失败" delegate:self
                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary * dicData = [_dataForVidio objectAtIndex:indexPath.row];
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * SelectedDic = [NSMutableDictionary dictionary];
    [SelectedDic setObject:@"2" forKey:@"favtype"];
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

//
//  HKMySelectedVideoViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMySelectedVideoViewController.h"
#import "MyProfile.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface HKMySelectedVideoViewController ()

@end

@implementation HKMySelectedVideoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        _domainDelete = [[HKCommunicateDomain alloc] init];
        [_domainDelete setDelegate:self];

        _dataArray = [[NSMutableArray alloc] init];
        self.title = @"我的视频";
        _share = [ShareInstance instance];
        [self getList];

    }
    return self;
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_domain clearUnReturnRequestData];
}
-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_domain clearUnReturnRequestData];
}
- (void)dealloc
{
    [_domain clearUnReturnRequestData];
    [_domainDelete release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getList];
}
-(void)getList {
    MyProfile * profile = [MyProfile myProfile];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:[profile.userInfo stringForKey:@"pkey"]  forKey:@"userId"];
    [_domain getMySelectedVideo:paramsDic];

}
-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        _dataArray = (NSMutableArray*)[domainData dataDetails];
//        for (NSDictionary * dic in array) {
//            [_dataArray addObject:dic];
//        }
        [self.tableView reloadData];
        
    }
    if (domainData == _domainDelete) {
        if (domainData.status == 0) {
            [self getList];

            _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_alert show];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
             NSDictionary* data = [_dataArray objectAtIndex:indexRow];
            if ([[_share.MyVideoDic stringForKey:@"pkey"] isEqualToString:[data stringForKey:@"pkey"]]) {
                _share.MyVideoDic = nil;
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    if ([_dataArray count] >0) {
        NSDictionary* data = [_dataArray objectAtIndex:indexPath.row];
        
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataArray count] > 0) {
        NSDictionary* data = [_dataArray objectAtIndex:indexPath.row];
        [self createMPPlayerController:[data stringForKey:@"videourl"]];
        _share.MyVideoDic = data;
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
    [params setObject:@"2" forKey:@"favtype"];
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

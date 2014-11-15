//
//  HKExplainDetailViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKExplainDetailViewController.h"
#import "HHDomainBase.h"
#import "MeetingConst.h"
#import "HKWebViewController.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"

@interface HKExplainDetailViewController ()

@property (nonatomic,retain) NSDictionary* explainData;
@property (nonatomic,assign) NSArray* ppts;
@property (nonatomic,assign) NSArray* videos;
@property (nonatomic,assign) NSArray* topics;

@property (nonatomic,retain) NSMutableArray* photos;

@end

@implementation HKExplainDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithStyle:(UITableViewStyle)style ExplainData:(NSDictionary *)data{
    self = [self initWithStyle:style];
    if (self) {
        
        self.explainData = data;
        _dataForHuanDeng = [[NSMutableArray alloc] init];
        _domain = [[HKCommunicateDomain alloc] init];
        _domainDetail = [[HKCommunicateDomain alloc] init];
        _HUANDENGparam = [[NSMutableDictionary alloc] init];
        [_domain setDelegate:self];
        [_domainDetail setDelegate:self];
        _count = 1;

    }
    
    return self;
}

-(void) dealloc{
    
    [_dataForHuanDeng release];
    [_domain release];
    [_HUANDENGparam release];
    [_domainDetail release];
    self.explainData = nil;
    self.photos = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        
    }

    NSDictionary* data = [[self.explainData dictionaryForKey:Json_GuidData] dictionaryForKey:JsonHead_data];
    
    
    self.title = [data stringForKey:Json_Explain_Name];
    
    self.ppts = [data arrayForKey:Json_Explain_PPTS];
    self.videos = [data arrayForKey:Json_Explain_Videos];
    self.topics = [data arrayForKey:Json_Explain_Topics];
    
    [self.tableView setFrame:self.view.bounds];
    
    [self getDataFromHuandeng:self.explainData];
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self testRealLoadMoreData];
        
    };

    
    self.title = [self.explainData stringForKey:@"title"];

}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}
//网络请求（ppt）
-(void)getDataFromHuandeng:(NSDictionary *)Params {
        NSString * countString = [NSString stringWithFormat:@"%d",_count];
        [_HUANDENGparam setObject:[Params objectForKey:@"pkey"] forKey:@"medguidid"];
        [_HUANDENGparam setObject:@"10" forKey:@"pageSize"];
        [_HUANDENGparam setObject:countString forKey:@"pageNumber"];
        [_domain getDomainForMyPPTs:_HUANDENGparam];
}
-(void)didParsDatas:(HHDomainBase *)domainData {
       if (domainData == _domainDetail) {
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
           UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:browser] autorelease];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
       
       }
       else {
           NSArray * array = [domainData dataDetails];
           for (NSDictionary * dic in array) {
               [_dataForHuanDeng addObject:dic];
           }
           [_header endRefreshing];
           [_footer endRefreshing];

           [self.tableView reloadData];

       }
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:    //PPT
            return self.displayType==0?[_dataForHuanDeng count]:0;
            
        case 1:
            return self.displayType==1?[self.videos count]:0;
            
        case 2:
            return self.displayType==2?[self.topics count]:0;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];

    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
    }
        if ([_dataForHuanDeng count] > 0) {
            NSDictionary* data = [_dataForHuanDeng objectAtIndex:indexPath.row];
            
            cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
            [cell.imgTitle setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"nav_3@2x.png"]];
            
            cell.titleLabel.text = [data stringForKey:@"title"];
            cell.sectionLabel.text = [data stringForKey:@"author"];
            cell.timeLabel.text = [data stringForKey:@"time"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
  
    return cell;

    }
    
    
    
    ///////////////////////
    
//    if (cell==nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    
//    if (indexPath.section == 0) {
//        
//        NSDictionary* ppt = [_dataForHuanDeng objectAtIndex:indexPath.row];
//        cell.textLabel.text = [ppt stringForKey:@"title"];
//        
//    }else if(indexPath.section ==1){
//        
//        NSDictionary* video = [self.videos objectAtIndex:indexPath.row];
//        cell.textLabel.text = [video stringForKey:Json_Explain_Video_Name];
//        
//    }else{
//        
//        NSDictionary* topic = [self.topics objectAtIndex:indexPath.row];
//        cell.textLabel.text = [topic stringForKey:Json_Explan_Topic_Subject];
//    }
//    [self setFooterView];
//    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            
            return self.displayType==0?@"PPT":nil;
            
        case 1:
            return self.displayType==1?@"视频":nil;
            
        case 2:
            return self.displayType==2?@"病例分享":nil;
            
        default:
            return nil;
    }
    
}
//下拉刷新，上拉加载部分方法实现
//判断下拉上拉调用对应代理方法

//初始化加载页面
//-(void)testFinishedLoadData{
//    //仅仅加载投票
//}
//下拉刷新
-(void)testRealRefreshDataSource{
    [_dataForHuanDeng removeAllObjects];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_HUANDENGparam setObject:countString forKey:@"pageNumber"];
    [_HUANDENGparam setObject:@"10" forKey:@"pageSize"];
    [_domain getDomainForMyPPTs:_HUANDENGparam];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_HUANDENGparam setObject:countString forKey:@"pageNumber"];
     [_domain getDomainForMyPPTs:_HUANDENGparam];
    
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
    
    if (indexPath.section == 0) {  //PPT
        self.photos = [NSMutableArray array];
        
        if ([_dataForHuanDeng count] > 0) {
            NSDictionary * dic = [_dataForHuanDeng objectAtIndex:indexPath.row];
            NSMutableDictionary *dicpramas = [NSMutableDictionary dictionaryWithObject:[dic stringForKey:@"pkey"]  forKey:@"key"];
            
            [_domainDetail getDomainForPPTDetails:dicpramas];

        }
        }else if(indexPath.section ==1){  //video
        
        NSString* path = [self.explainData stringForKey:Json_GuidFolder];
        
        NSDictionary* video = [self.videos objectAtIndex:indexPath.row];
        
        
        NSString* fullPaht = [path stringByAppendingFormat:@"/%@",[video stringForKey:@"videoUrl"]];
        
        NSLog(@"fullPaht:%@",fullPaht);
        
        //NSURL* url = [NSURL URLWithString:@""];
        
        HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                    bundle:nil
                                                                                     Title:@"视频"
                                                                                       URL:[NSURL fileURLWithPath:fullPaht]] autorelease];
        
        [self.navigationController pushViewController:webController animated:YES];
        
    }else if(indexPath.section == 2){ //病例分享
        
        NSDictionary* topic = [self.topics objectAtIndex:indexPath.row];
        
        NSString* filePath = [topic stringForKey:@"url"];
        NSString* fullPaht = [[self.explainData stringForKey:Json_GuidFolder] stringByAppendingFormat:@"/%@",filePath];
        
        NSLog(@"fullPaht:%@",fullPaht);
        
        HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                    bundle:nil
                                                                                     Title:@"病例分享"
                                                                                       URL:[NSURL fileURLWithPath:fullPaht]] autorelease];
        
        [self.navigationController pushViewController:webController animated:YES];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
}

#pragma mark - WMPhotobrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end

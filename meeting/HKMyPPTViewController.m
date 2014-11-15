//
//  HKMyPPTViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMyPPTViewController.h"
#import "HKMyPPTcommonsCell.h"
#import "UIImageView+WebCache.h"
#import "MyProfile.h"
#import "HKSavePicture.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
@interface HKMyPPTViewController ()

@end

@implementation HKMyPPTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayData = [[NSArray alloc] init];
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        [_domain setTag:1];
         _dataForHuanDeng = [[NSMutableArray alloc] init];
        _HUANDENGparam  = [[NSMutableDictionary alloc] init];
        _count = 1;
        domainDetail = [[HKCommunicateDomain alloc] init];
        [domainDetail setDelegate:self];
        [domainDetail setTag:2];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"HUANDENG" object:nil];
        _domainSelected = [[HKCommunicateDomain alloc] init];
        [_domainSelected setDelegate:self];
        
        _domainDownload = [[HKCommunicateDomain alloc] init];
        [_domainDownload setDelegate:self];
        _fileName = 0;
    }
    return self;
}
- (void)dealloc
{
    [_domainDownload release];
    [_domainSelected release];
    [_arrayData release];
    [_domain release];
    [_dataForHuanDeng release];
    [_HUANDENGparam release];
    [domainDetail release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     //EGRORefresh
    if (self.meetingflag == NO) {
//        UIImage* adImage = [UIImage imageNamed:@"ad_comm.png"];
//        UIImageView* imgView = [[[UIImageView alloc] initWithImage:adImage] autorelease];
//        self.tableView.tableHeaderView = imgView;
        
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
        self.title = @"幻灯";
        _dataForHuanDeng = (NSMutableArray *)self.arrayMeeting;
    }
   
    
}
-(void)getData:(NSNotification *) notify {
    _arrayData = [[notify object] retain];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self testRealRefreshDataSource];
    }
}
//网络请求
-(void)getDataFromHuandeng:(NSDictionary *)Params {
    
    if ([_dataForHuanDeng count] > 0) {
        return;
    } else{
        [_HUANDENGparam setObject:[Params objectForKey:@"sectionkey"] forKey:@"sectionkey"];
        [_HUANDENGparam setObject:@"10" forKey:@"pageSize"];
        [_domain getDomainForMyPPTs:Params];
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];

    }
    NSLog(@"%f",self.tableView.contentSize.height) ;

}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"%f",self.tableView.contentSize.height) ;
   


}
-(void)getDataForLoadMore{
    [_domain getDomainForMyPPTs:_HUANDENGparam];
}
-(void)removeAllData {
    [_dataForHuanDeng removeAllObjects];
}

//接受数据代理方法
-(void) didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domainSelected) {
        if (domainData.status == 0) {
            UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"通知" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            [aler release];
        }
        else{
            UIAlertView * aler = [[UIAlertView alloc] initWithTitle:@"警告" message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            [aler release];
        }

    }

    if (domainData == _domain) {
        NSArray * arraySorce = [domainData dataDetails];
        for (NSDictionary * dic in arraySorce) {
            [_dataForHuanDeng addObject:dic];
        }
        [_header endRefreshing];
        [_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];

        
        [self.tableView reloadData];
    } if (domainData == domainDetail) {
        self.photos = [NSMutableArray array];
        NSDictionary * dic = [domainData dataDictionary];
        NSArray * array = [dic objectForKey:@"contentEOs"];
       
            for (NSDictionary* photoDic in array) {
              NSURL * url = [NSURL URLWithString:[photoDic stringForKey:@"imgurl"]] ;       
                    [self.photos addObject:[MWPhoto photoWithURL:url]];
             }
                // Create & present browser
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self] ;
                // Set options
                browser.hidesBottomBarWhenPushed = YES;
                browser.displayActionButton = NO;
                browser.wantsFullScreenLayout = YES;
//                [self.navigationController pushViewController:browser animated:YES];
        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:browser] autorelease];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
//                [browser release];
    }
    if (domainData == _domainDownload) {
         HKSavePicture * savePicture = [[HKSavePicture alloc] init];
        //下载PPT JSON文件
        NSDictionary * dics= [_dataForHuanDeng objectAtIndex:_index];
        SBJsonWriter * writer = [[SBJsonWriter alloc] init];
        NSString * str = [writer stringWithObject:dics];
        NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self saveFile:[dics stringForKey:@"pkey"] Data:jsonData andsavefile:@"index"];
        //XXXXXXXXXX
        //找document路径
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
 
        NSString * desPath = [docPath stringByAppendingPathComponent:[dics stringForKey:@"pkey"]] ;

        UIImage * imageFromURL = [savePicture getImageFromURL:[dics stringForKey:@"picurl"]];
        [savePicture saveImage:imageFromURL withFileName:@"imagetitle" ofType:@"jpg" inDirectory:desPath];

        
        //下载PPT
        
        NSDictionary * dic = [domainData dataDictionary];
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadPPt:) object:dic];
        [thread start];
        
        [savePicture release];
        
       
    }
   
}
//主线程下载图片
-(void) downloadPPt:(NSDictionary *) dic {
    HKSavePicture * savePicture = [[HKSavePicture alloc] init];

    self.urls = [NSMutableArray array];
    
    NSArray * array = [dic objectForKey:@"contentEOs"];
    _fileName = 0;
    _totaCount = array.count;
    
    for (NSDictionary* photoDic in array) {
        [self.urls addObject:[photoDic stringForKey:@"imgurl"]];
        
        //找document路径
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
        NSDictionary * dic = [_dataForHuanDeng objectAtIndex:_index];
        NSString * desPath = [docPath stringByAppendingPathComponent:[dic stringForKey:@"pkey"]] ;
        //存放图片的文件夹
        //Get Image From URL
        UIImage * imageFromURL = [savePicture getImageFromURL:[photoDic stringForKey:@"imgurl"]];
        
        //Save Image to Directory
        [savePicture saveImage:imageFromURL withFileName:[NSString stringWithFormat:@"%d",_fileName] ofType:@"jpg" inDirectory:desPath];
        _fileName ++;
        //[self myProgressTask];
       // [self performSelectorInBackground:@selector(myProgressTask) withObject:nil];
//        [self performSelector:@selector(myProgressTask) withObject:nil afterDelay:0.1];
        [self performSelectorOnMainThread:@selector(myProgressTask) withObject:nil waitUntilDone:YES];

        
    }
    [MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
    [savePicture release];
    [self.tableView reloadData];

}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataForHuanDeng count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMyPPTcommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMyPPTcommonsCell" owner:self options:nil] lastObject];
        
    }
    if ([_dataForHuanDeng count] > 0) {
        NSDictionary* data = [_dataForHuanDeng objectAtIndex:indexPath.row];
        BOOL downLoad = [self OpenLocalFile:[data stringForKey:@"pkey"]];
        if (downLoad) {
            [cell.btndownload setTitle:@"已经下载" forState:UIControlStateNormal];
            [cell.btndownload setBackgroundImage:[UIImage imageNamed:@"downloaded.png"] forState:UIControlStateNormal];
            [cell.btndownload setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.download setImage:[UIImage imageNamed:@"download.png"]];
        }else {
            [cell.btndownload setTitle:@"免费下载" forState:UIControlStateNormal];
            [cell.btndownload setBackgroundImage:[UIImage imageNamed:@"freedownload.png"] forState:UIControlStateNormal];
        }
        
        cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
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
//下拉刷新，上拉加载部分方法实现
//判断下拉上拉调用对应代理方法


//下拉刷新
-(void)testRealRefreshDataSource{
    [self removeAllData];
    _count = 1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_HUANDENGparam setObject:countString forKey:@"pageNumber"];
    [_HUANDENGparam setObject:@"10" forKey:@"pageSize"];
    [self getDataFromHuandeng:_HUANDENGparam];
    
}



//上拉加载
-(void)testRealLoadMoreData{
    _count +=1;
    NSString * countString = [NSString stringWithFormat:@"%d",_count];
    [_HUANDENGparam setObject:countString forKey:@"pageNumber"];
    [self getDataForLoadMore];
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_dataForHuanDeng count] > 0) {
//        NSDictionary * dic = [_dataForHuanDeng objectAtIndex:indexPath.row];
//        NSMutableDictionary *dicpramas = [NSMutableDictionary dictionaryWithObject:[dic stringForKey:@"pkey"]  forKey:@"key"];
//        
//        [domainDetail getDomainForPPTDetails:dicpramas];
        NSDictionary * dic = [_dataForHuanDeng objectAtIndex:indexPath.row];
        BOOL downLoad = [self OpenLocalFile:[dic stringForKey:@"pkey"]];
        if (downLoad == NO) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要确认下载此幻灯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] autorelease];
            [alert setTag:2];
            [alert show];
            _index = indexPath.row;
        } else {
        
            self.photos = [NSMutableArray array];
            //NSDictionary * stringfileName = [_dataForHuanDeng objectAtIndex:indexPath.row];
//            NSData * data = [self WriteLocalFile:[stringfileName stringForKey:@"FileName"] andsavefile:@"index"];
//            SBJsonParser * parser = [[SBJsonParser alloc]init];
//            NSDictionary * dataDic = [parser objectWithData:data];
//            [parser release];
            
            NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
            NSString * desPath = [docPath stringByAppendingPathComponent:[dic stringForKey:@"pkey"]] ;
            NSFileManager* fileManager = [NSFileManager defaultManager];
            NSArray* dirs = [fileManager contentsOfDirectoryAtPath:desPath error:NULL];
            
            
            
            int maxIndex = 0;
            
            for (NSString * str in dirs) {
                if (![str isEqualToString:@"index"] && ![str isEqualToString:@"imagetitle.jpg"]) {
//                    NSString * imagePath = [NSString stringWithFormat:@"%@/%@",desPath,str];
                    int strleng = str.length;
                    NSString *b = [str substringToIndex:strleng - 4];
                    int index = [b intValue];
                    
                    if (index>maxIndex) {
                        maxIndex = index;
                    }
                    
                    
                }
                
                
            }
            
            
            for (int i=0; i<=maxIndex; i++) {
                  NSString * imagePath = [NSString stringWithFormat:@"%@/%d.jpg",desPath,i];
                
                [self.photos addObject:[MWPhoto photoWithFilePath:imagePath]];
            }
            
            // Create & present browser
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self] ;
            // Set options
            browser.hidesBottomBarWhenPushed = YES;
            browser.displayActionButton = NO;
            browser.wantsFullScreenLayout = YES;
            //                [self.navigationController pushViewController:browser animated:YES];
            UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:browser] autorelease];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
            

        }
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSDictionary * dic = [_dataForHuanDeng objectAtIndex:_index];
            NSMutableDictionary *dicpramas = [NSMutableDictionary dictionaryWithObject:[dic stringForKey:@"pkey"]  forKey:@"key"];
            [_domainDownload getDomainForPPTDetails:dicpramas];
            _huddownload = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
            _huddownload.mode = MBProgressHUDModeDeterminate;
            _huddownload.labelText = @"正在下载中";
            //[_hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
            

        }
    }
}
-(void) myProgressTask {
    float newprogress = (_fileName * 0.1) / (_totaCount * 0.1);
    NSLog(@"**********%f",newprogress);
    //[_hud setProgress:newprogress] ;
    _huddownload.progress = newprogress;
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
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
//    NSLog(@"收藏");
//    if ([_dataForHuanDeng count] == 0) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"正在刷新中，收藏失败" delegate:self
//                                               cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return;
//    }
////    NSDictionary * dicData = [_dataForHuanDeng objectAtIndex:indexPath.row];
////    MyProfile * profile = [MyProfile myProfile];
////    NSMutableDictionary * SelectedDic = [NSMutableDictionary dictionary];
////    [SelectedDic setObject:@"1" forKey:@"favtype"];
////    [SelectedDic setObject:[profile.userInfo stringForKey:@"pkey"] forKey:@"userId"];
////    [SelectedDic setObject:[dicData stringForKey:@"pkey"] forKey:@"refkey"];
////    [_domainSelected getSelected:SelectedDic];
//    
////    NSDictionary * dic = [_dataForHuanDeng objectAtIndex:indexPath.row];
////    NSMutableDictionary *dicpramas = [NSMutableDictionary dictionaryWithObject:[dic stringForKey:@"pkey"]  forKey:@"key"];
////    
////    [_domainDownload getDomainForPPTDetails:dicpramas];
////    _index = indexPath.row;
//    
//
//    
//    
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"收藏";
//}
////设置进入编辑状态时，Cell不会缩进
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//保存文件
-(void)saveFile:(NSString*)fileName Data:(NSData *)data andsavefile:(NSString *)realfilename{
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
    
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:realPath atomically:YES];
    NSLog(@"%@",desPath);
}
//判断本地是否存在文件
-(BOOL)OpenLocalFile:(NSString*)fileName  {
    //NSDictionary * dicdata = [_datasourceArray objectAtIndex:selectedRows];
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    //NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    return  [filemanage fileExistsAtPath:desPath];
    
    
}
//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:realPath];
    return dataInfile;
}

@end

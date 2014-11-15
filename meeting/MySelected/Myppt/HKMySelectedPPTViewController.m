//
//  HKMyPPTViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMySelectedPPTViewController.h"
#import "MyProfile.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
@interface HKMySelectedPPTViewController ()

@end

@implementation HKMySelectedPPTViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[HKCommunicateDomain alloc] init];
        [_domain setDelegate:self];
        domainDetail = [[HKCommunicateDomain alloc] init];
        [domainDetail setDelegate:self];
        _dataArray = [[NSMutableArray alloc] init];
        self.title = @"我的幻灯";
        _share = [ShareInstance instance];
        _domainDelete = [[HKCommunicateDomain alloc] init];
        [_domainDelete setDelegate:self];
    }
    return self;
}
- (void)dealloc
{
    [_domainDelete release];
    [_domain clearUnReturnRequestData];
    //[_dataArray release];
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
    
    
    
   [self getdataList];
    
    
}

-(void)getdataList {
//    MyProfile * profile = [MyProfile myProfile];
//    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
//    [paramsDic setObject:[profile.userInfo stringForKey:@"pkey"]  forKey:@"userId"];
//    [_domain getMySelectedPPT:paramsDic];
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
    self.sortFiles = [NSMutableArray array];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* dirs = [fileManager contentsOfDirectoryAtPath:docPath error:NULL];
    for (NSString * fileName in dirs) {
        NSString* fullName = [NSString stringWithFormat:@"%@/%@",docPath,fileName];
        NSDictionary* fileAttr = [[NSFileManager defaultManager]attributesOfItemAtPath:fullName error:nil];
        NSMutableDictionary* fileData = [NSMutableDictionary dictionaryWithDictionary:fileAttr];
        [fileData setObject:fullName forKey:@"FullName"];
        [fileData setObject:fileName forKey:@"FileName"];
        [self.sortFiles addObject:fileData];
        
    }
    NSSortDescriptor* sortDescription = [[NSSortDescriptor alloc] initWithKey:NSFileCreationDate ascending:NO ];
    [self.sortFiles sortUsingDescriptors:[NSArray arrayWithObject:sortDescription]];
    [sortDescription release];
    
    NSLog( @"%@",dirs);
    
    self.photos =self.sortFiles;


}
-(void)didParsDatas:(HHDomainBase *)domainData {
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
    if (domainData == _domain) {
        _dataArray = (NSMutableArray *)[domainData dataDetails];
        [self.tableView reloadData];
    }
    if (domainData == domainDetail) {
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
    return [self.photos count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    if ([self.photos count] > 0) {
        NSDictionary * stringfileName = [self.photos objectAtIndex:indexPath.row];
        NSData * data = [self WriteLocalFile:[stringfileName stringForKey:@"FileName"] andsavefile:@"index"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
         NSDictionary * dataDic = [parser objectWithData:data];
        [parser release];

        NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
        NSString * desPath = [docPath stringByAppendingPathComponent:[stringfileName stringForKey:@"FileName"]] ;

        NSString* fullName = [NSString stringWithFormat:@"%@/imagetitle.jpg",desPath];     cell.imgTitle.image =[UIImage imageWithContentsOfFile:fullName];
        
//        [cell.imgTitle setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"nav_3@2x.png"]];
//        
        cell.titleLabel.text = [dataDic stringForKey:@"title"];
        cell.sectionLabel.text = [dataDic stringForKey:@"author"];
        cell.timeLabel.text = [dataDic stringForKey:@"time"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.photos count] > 0) {
//        NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
//        NSMutableDictionary *dicpramas = [NSMutableDictionary dictionaryWithObject:[dic stringForKey:@"pkey"]  forKey:@"key"];
//        
//        [domainDetail getDomainForPPTDetails:dicpramas];
        self.PPTs = [NSMutableArray array];
        NSDictionary * stringfileName = [self.photos objectAtIndex:indexPath.row];
        NSData * data = [self WriteLocalFile:[stringfileName stringForKey:@"FileName"] andsavefile:@"index"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dataDic = [parser objectWithData:data];
        _share.MyPPTDic = dataDic;
        [parser release];

        NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
        NSString * desPath = [docPath stringByAppendingPathComponent:[stringfileName stringForKey:@"FileName"]] ;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray* dirs = [fileManager contentsOfDirectoryAtPath:desPath error:NULL];
        for (NSString * str in dirs) {
            if (![str isEqualToString:@"index"] && ![str isEqualToString:@"imagetitle.jpg"]) {
                NSString * imagePath = [NSString stringWithFormat:@"%@/%@",desPath,str];
                [self.PPTs addObject:[MWPhoto photoWithFilePath:imagePath]];
            }
         
            
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
#pragma mark - WMPhotobrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.PPTs.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.PPTs.count)
        return [self.PPTs objectAtIndex:index];
    return nil;
}
/**************************删除收藏*****************************/
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)    indexPath{
//    NSDictionary* data = [_dataArray objectAtIndex:indexPath.row];
//    //    userId=kimi  用户pkey
//    //    favtype=2  收藏类型
//    //    refkey=1  被搜藏的key
//    MyProfile * profile = [MyProfile myProfile];
//    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
//    [params setObject:[profile.userInfo stringForKey:@"pkey"]forKey:@"userId"];
//    [params setObject:[data stringForKey:@"pkey"] forKey:@"refkey"];
//    [params setObject:@"1" forKey:@"favtype"];
//    [_domainDelete getUnSelected:params];
    NSDictionary * stringfileName = [self.photos objectAtIndex:indexPath.row];
    
    NSData * data = [self WriteLocalFile:[stringfileName stringForKey:@"FileName"] andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary * dataDic = [parser objectWithData:data];
    
    if ([[dataDic stringForKey:@"pkey"] isEqualToString:[_share.MyPPTDic stringForKey:@"pkey"]] ) {
        _share.MyPPTDic = nil;
    }

    [self removeFile:[stringfileName stringForKey:@"FileName"]];
    [self getdataList];
    [self.tableView reloadData];
    _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];
    [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];

  
    
    //
}
-(void) hideAlert {
    
    [_alert dismissWithClickedButtonIndex:0 animated:NO];
    [_alert release];
    
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
//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:realPath];
    return dataInfile;
}
-(void) removeFile:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filenames;
    while ((filenames = [e nextObject])) {
        
        if ([filenames  isEqualToString:fileName]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filenames] error:NULL];
        }
    }
}

@end

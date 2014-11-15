//
//  HKReviewPPTViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKReviewPPTViewController.h"
#import "HKMycommonsCell.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
@interface HKReviewPPTViewController ()

@end

@implementation HKReviewPPTViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
        domainDetail = [[HKCommunicateDomain alloc] init];
        [domainDetail setDelegate:self];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ////Load Image From Directory
    //找document路径
 
    
    
    
    //取得目录下所有文件名
   
  
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    if (_share.MyPPTDic) {
        NSDictionary* datas = _share.MyPPTDic;
        
//        NSDictionary * stringfileName = [data stringForKey:@"pkey"];
        NSData * data = [self WriteLocalFile:[datas stringForKey:@"pkey"] andsavefile:@"index"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dataDic = [parser objectWithData:data];
        [parser release];
        
        NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
        NSString * desPath = [docPath stringByAppendingPathComponent:[datas stringForKey:@"pkey"]] ;
        
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_share.MyPPTDic) {
        self.photos = [NSMutableArray array];
        //NSDictionary * stringfileName = [self.photos objectAtIndex:indexPath.row];
        NSData * data = [self WriteLocalFile:[_share.MyPPTDic stringForKey:@"pkey"] andsavefile:@"index"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSDictionary * dataDic = [parser objectWithData:data];
        _share.MyPPTDic = dataDic;
        [parser release];
        
        NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"PPT"] ;
        NSString * desPath = [docPath stringByAppendingPathComponent:[_share.MyPPTDic stringForKey:@"pkey"]] ;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray* dirs = [fileManager contentsOfDirectoryAtPath:desPath error:NULL];
        for (NSString * str in dirs) {
            if (![str isEqualToString:@"index"] && ![str isEqualToString:@"imagetitle.jpg"]) {
                NSString * imagePath = [NSString stringWithFormat:@"%@/%@",desPath,str];
                [self.photos addObject:[MWPhoto photoWithFilePath:imagePath]];
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
//-(void)didParsDatas:(HHDomainBase *)domainData {
//      if (domainData == domainDetail) {
//        self.photos = [NSMutableArray array];
//        NSDictionary * dic = [domainData dataDictionary];
//        NSArray * array = [dic objectForKey:@"contentEOs"];
//        for (NSDictionary* photoDic in array) {
//            NSURL * url = [NSURL URLWithString:[photoDic stringForKey:@"imgurl"]] ;
//            [self.photos addObject:[MWPhoto photoWithURL:url]];
//            
//            
//            
//        }
//        // Create & present browser
//        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self] ;
//        // Set options
//        browser.hidesBottomBarWhenPushed = YES;
//        browser.displayActionButton = NO;
//        browser.wantsFullScreenLayout = YES;
//        //                [self.navigationController pushViewController:browser animated:YES];
//        UINavigationController * nav = [[[UINavigationController alloc] initWithRootViewController:browser] autorelease];
//        [self presentViewController:nav animated:YES completion:^{
//            
//        }];
//        //                [browser release];
//    }
//    
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
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

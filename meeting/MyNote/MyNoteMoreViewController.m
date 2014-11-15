//
//  MyNoteMoreViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-19.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "MyNoteMoreViewController.h"
#import "MyNoteCell.h"
#import "SBJsonParser.h"
#import "HKCommonMethod.h"
@interface MyNoteMoreViewController ()

@end

@implementation MyNoteMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       _dataDic = [[NSMutableDictionary alloc] init];
        _ZhiNanArray = [[NSMutableArray alloc] init];
        _PicArray = [[NSMutableArray alloc] init];
        _share = [ShareInstance instance];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的笔记";
    if (self.jingduFlag == NO) {
        [self getlist];
    }
    else {
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
        NSString * realpath = [despath stringByAppendingPathComponent:self.pkey];
        NSArray* WenJianJiaNameArray = [fileManager contentsOfDirectoryAtPath:realpath error:NULL];
        NSMutableArray * PicArrays = [NSMutableArray array];
        for (NSString * picName in WenJianJiaNameArray) {
            if ([picName hasPrefix:@"pizhu"]) {
                NSString * pictureName =  [self loadPicName:self.pkey andPicName:picName];
                [PicArrays addObject:pictureName];
                
            }
        }
        if ([PicArrays count] > 0) {
             [_dataDic setObject:PicArrays forKey:self.pkey];
             [_ZhiNanArray addObject:self.pkey];
          }
    }

//    UIView * footerView = [[UIView new] autorelease];
//    self.tableView.tableFooterView = footerView;



}
-(void) getlist {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSArray* dirs = [fileManager contentsOfDirectoryAtPath:despath error:NULL];
    NSLog( @"%@",dirs);
    
    //self.explainList = dirs;
    //[self.tableView reloadData];
    for (NSString * WenJianJiaName in dirs) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
        NSString * realpath = [despath stringByAppendingPathComponent:WenJianJiaName];
        NSArray* WenJianJiaNameArray = [fileManager contentsOfDirectoryAtPath:realpath error:NULL];
        NSMutableArray * PicArrays = [NSMutableArray array];
        for (NSString * picName in WenJianJiaNameArray) {
            if ([picName hasPrefix:@"pizhu"]) {
                NSString * pictureName =  [self loadPicName:WenJianJiaName andPicName:picName];
                [PicArrays addObject:pictureName];
                
            }
        }
        if ([PicArrays count] > 0) {
            [_dataDic setObject:PicArrays forKey:WenJianJiaName];
            [_ZhiNanArray addObject:WenJianJiaName];
        }
    }

}

-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[[NSData alloc] initWithContentsOfFile:realPath] autorelease];
    return dataInfile;
}
-(NSString *) loadPicName:(NSString *)ZhiNanName andPicName:(NSString *) picName {
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:ZhiNanName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:picName];
    return  realPath;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_ZhiNanArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MyNoteCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
    }
    NSString * ZhiNanStr = [_ZhiNanArray objectAtIndex:indexPath.row
                            ];
   NSData * JSON =  [self WriteLocalFile:ZhiNanStr andsavefile:@"index"];
   SBJsonParser * parser = [[SBJsonParser alloc]init];
   NSDictionary * dic = [parser objectWithData:JSON];
   [parser release];
   cell.titleLabel.text = [dic objectForKey:@"title"];
   //笔记数量
   NSArray * dataArray = [_dataDic objectForKey:ZhiNanStr];
    cell.picCount.text = [NSString stringWithFormat:@"笔记数为:%d",[dataArray count]];
    
    // Configure the cell...
    [cell.picImage setImage:[UIImage imageWithContentsOfFile:[dataArray objectAtIndex:0]]];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  106;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * ZhiNanStr = [_ZhiNanArray objectAtIndex:indexPath.row
                            ];
     NSArray * dataArray = [_dataDic objectForKey:ZhiNanStr];
    if ([_PicArray count] >0) {
        [_PicArray removeAllObjects];
    }
    for (NSString *filePath in dataArray) {
        [_PicArray addObject:[MWPhoto photoWithFilePath:filePath]];
    }
    
  
    
    // Create & present browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self] ;
    // Set options
    browser.hidesBottomBarWhenPushed = YES;
    browser.displayActionButton = NO;
    browser.wantsFullScreenLayout = YES;
    [self.navigationController pushViewController:browser animated:YES];
    
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:dataArray,ZhiNanStr,nil];
    if (self.jingduFlag == NO) {
        _share.MyNoteDic = dic;
    }
    
    
    
}
#pragma mark - WMPhotobrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_PicArray count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [_PicArray count])
        return [_PicArray objectAtIndex:index];
    return nil;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath{
    NSString * zhinanPkey  =  [_ZhiNanArray objectAtIndex:indexPath.row];
    NSArray * picArray = [_dataDic objectForKey:zhinanPkey];
    
    for (NSString * fileName in picArray) {
        [HKCommonMethod removeFile:fileName andZhinanName:zhinanPkey];
    }
    [_ZhiNanArray removeObjectAtIndex:indexPath.row];
    [_dataDic removeObjectForKey:zhinanPkey];
    [self.tableView reloadData];
    if ([_dataDic objectForKey:[[_share.MyNoteDic allKeys] lastObject]] == nil) {
        _share.MyNoteDic = nil;
    }
    
    _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [_alert show];
    [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
    

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


@end

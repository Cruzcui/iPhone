#import "MyZhiNanMoreViewController.h"
#import "HHDomainBase.h"
#import "HKLocalGuidListDomain.h"
#import "HHDomainBase.h"
#import "MeetingConst.h"
#import "HKExplainDetailViewController.h"
#import "KxMenu.h"
#import "HKExplainDetailViewController.h"
#import "HKDemoImageViewController.h"
#import "SBJson.h"
#import "HKMyVideosViewController.h"
#import "HKGuidDetailViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ZhiNanCell.h"
#import "MyProfile.h"
@interface MyZhiNanMoreViewController (){
    int selectedIndex;
    NSDictionary * _dataDic;
}

@property (nonatomic,retain) NSArray* explainList;

@end

@implementation MyZhiNanMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"我的指南";
        self.tabBarItem.image = [UIImage imageNamed:@"tab03.png"];
        _dataDic = [[NSDictionary alloc] init];
        _share = [ShareInstance instance];
        sortFiles = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc{
    
    self.explainList = nil;
    [sortFiles release];
    [_dataDic release];
    [super dealloc];
}


-(void)viewDidAppear:(BOOL)animated{
    MyProfile * profile = [MyProfile myProfile];
    self.explainList = [profile getFavList:Fav_Type_MedGuid];
    [self.tableView reloadData];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];//开启滚动效果
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMCloseDrawerGestureModeNone];//开启滚动效果

}
 


- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
//    NSArray* dirs = [fileManager contentsOfDirectoryAtPath:despath error:NULL];
//    for (NSString * fileName in dirs) {
//        NSString* fullName = [NSString stringWithFormat:@"%@/%@",despath,fileName];
//        NSDictionary* fileAttr = [[NSFileManager defaultManager]attributesOfItemAtPath:fullName error:nil];
//        NSMutableDictionary* fileData = [NSMutableDictionary dictionaryWithDictionary:fileAttr];
//        [fileData setObject:fullName forKey:@"FullName"];
//        [fileData setObject:fileName forKey:@"FileName"];
//        [sortFiles addObject:fileData];
//        
//    }
//    NSSortDescriptor* sortDescription = [[NSSortDescriptor alloc] initWithKey:NSFileCreationDate ascending:NO ];
//    [sortFiles sortUsingDescriptors:[NSArray arrayWithObject:sortDescription]];
//    [sortDescription release];
//    
//    NSLog( @"%@",dirs);
//    
//    self.explainList = sortFiles;
//    [self.tableView reloadData];

    //    HKLocalGuidListDomain* guidDomain = [[[HKLocalGuidListDomain alloc] init] autorelease];
    //
    //    NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/db/explain"];
    //
    //    self.explainList = [guidDomain getGuidList:path];
    
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
  
}

    


//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[[NSData alloc] initWithContentsOfFile:realPath] autorelease];
    return dataInfile;
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
    return self.explainList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dataDic = [self.explainList objectAtIndex:indexPath.row];
    NSData * data = [self WriteLocalFile:[dataDic objectForKey:@"key"] andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    _dataDic = [parser objectWithData:data];
    [parser release];
    
    
    static NSString *CellIdentifier = @"Cell";
    ZhiNanCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZhiNanCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    
    cell.title.text = [_dataDic stringForKey:@"title"];
    cell.title.numberOfLines = 3;
    
    cell.publisher.text = [_dataDic stringForKey:@"publisher"];
    //cell.publisher.textAlignment = UITextAlignmentRight;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
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
     NSDictionary * dataDic = [self.explainList objectAtIndex:indexPath.row];
    NSData * data = [self WriteLocalFile:[dataDic objectForKey:@"key"]  andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    _dataDic = [parser objectWithData:data];
    [parser release];
    //单利传值
    _share.MyZhiNanDic = _dataDic;
    
    SBJsonParser * parsers = [[SBJsonParser alloc]init];
    NSData * str = [self WriteLocalFile:[_dataDic stringForKey:@"pkey"] andsavefile:[_dataDic stringForKey:@"pkey"]];
    
    NSArray * dicdata = [parser objectWithData:str];
    
    HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:dicdata andPkey:[_dataDic stringForKey:@"pkey"] andtitleDic:_dataDic andAllNodes:nil];
   
    
    
    if ([[_dataDic stringForKey:@"pptCount"] intValue] == 0) {
        detailViewController.pptflag = YES;
    }
    if ([[_dataDic stringForKey:@"videoCount"] intValue] == 0) {
        detailViewController.videoflag = YES;
    }

    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [parsers release];
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath{
    
    if (indexPath.row < [self.explainList count]) {
        NSDictionary * dataDic = [self.explainList objectAtIndex:indexPath.row];

        NSData * data = [self WriteLocalFile:[dataDic objectForKey:@"pkey"] andsavefile:@"index"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        _dataDic = [parser objectWithData:data];
        [parser release];
        if ([[_share.MyZhiNanDic stringForKey:@"pkey"] isEqualToString:[_dataDic stringForKey:@"pkey"]]) {
            _share.MyZhiNanDic = nil;
        }


        [self removeFile:[dataDic objectForKey:@"pkey"]];
        MyProfile * profile = [MyProfile myProfile];
        [profile deleteFavFor:Fav_Type_MedGuid key:[dataDic objectForKey:@"pkey"]];
        self.explainList = [profile getFavList:Fav_Type_MedGuid];
//        NSFileManager* fileManager = [NSFileManager defaultManager];
//        NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
//        NSArray* dirs = [fileManager contentsOfDirectoryAtPath:despath error:NULL];
//        NSLog( @"%@",dirs);
        [sortFiles removeAllObjects];
        
        [self.tableView reloadData];
//        for (NSString * fileName in dirs) {
//            NSString* fullName = [NSString stringWithFormat:@"%@/%@",despath,fileName];
//            NSDictionary* fileAttr = [[NSFileManager defaultManager]attributesOfItemAtPath:fullName error:nil];
//            NSMutableDictionary* fileData = [NSMutableDictionary dictionaryWithDictionary:fileAttr];
//            [fileData setObject:fullName forKey:@"FullName"];
//            [fileData setObject:fileName forKey:@"FileName"];
//            [sortFiles addObject:fileData];
//            
//        }
//        NSSortDescriptor* sortDescription = [[NSSortDescriptor alloc] initWithKey:NSFileCreationDate ascending:NO ];
//        [sortFiles sortUsingDescriptors:[NSArray arrayWithObject:sortDescription]];
//        [sortDescription release];
//        
//        NSLog( @"%@",dirs);
//        
//       
//
//       [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
//        self.explainList = sortFiles;
        
        _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_alert show];
        [self performSelector:@selector(hideAlert) withObject:nil afterDelay:1.0];
        }
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
-(void) removeFile:(NSString *)fileName  {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
//    NSString * desPath = [documentsDirectory stringByAppendingPathComponent:ZhiNanName] ;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    [fileManager removeItemAtPath:fileName error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filenames;
        while ((filenames = [e nextObject])) {
    
            if ([filenames  isEqualToString:fileName]) {
    
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filenames] error:NULL];
            }
        }
}


@end

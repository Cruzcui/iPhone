//
//  HKExplainListViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKExplainListViewController.h"
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
#import "HKExpertContentViewController.h"
#import "ZhiNanCell.h"
@interface HKExplainListViewController (){
    int selectedIndex;
    NSDictionary * _dataDic;
}

@property (nonatomic,retain) NSArray* explainList;

@end

@implementation HKExplainListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"我的会议";
        self.tabBarItem.image = [UIImage imageNamed:@"tab03.png"];
        _dataDic = [[NSDictionary alloc] init];
    }
    return self;
}

-(void) dealloc{
    
    self.explainList = nil;
    [_dataDic release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    HKLocalGuidListDomain* guidDomain = [[[HKLocalGuidListDomain alloc] init] autorelease];
//    
//    NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/db/explain"];
//    
//    self.explainList = [guidDomain getGuidList:path];
    
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *despath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSArray* dirs = [fileManager contentsOfDirectoryAtPath:despath error:NULL];
    NSLog( @"%@",dirs);
    
    self.explainList = dirs;
    [self.tableView reloadData];

}
//读取本地文件
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Maindata"];
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
    return [self.explainList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData * data = [self WriteLocalFile:[self.explainList objectAtIndex:indexPath.row] andsavefile:@"index"];
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
    
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"指南深析"
                     image:nil
                    target:nil
                    action:NULL
                       tag:-1],
      
      [KxMenuItem menuItem:@"视频"
                     image:[UIImage imageNamed:@"tab03.png"]
                    target:self
                    action:@selector(pushMenuItem:)
                       tag:1],
      
      [KxMenuItem menuItem:@"幻灯"
                     image:[UIImage imageNamed:@"tab03.png"]
                    target:self
                    action:@selector(pushMenuItem:)
                       tag:0],
       ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    
    //[self.tableView cellForRowAtIndexPath:indexPath].bounds
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:rectInSuperview
                 menuItems:menuItems];
    
    
    selectedIndex = indexPath.row;
    /*
    HKExplainDetailViewController *detailViewController = [[HKExplainDetailViewController alloc] initWithStyle:UITableViewStylePlain ExplainData:[self.explainList objectAtIndex:indexPath.row]];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     */
}

-(void) pushMenuItem:(id) sender{
    KxMenuItem* menuItem = (KxMenuItem*) sender;
    NSData * data = [self WriteLocalFile:[self.explainList objectAtIndex:selectedIndex] andsavefile:@"index"];
    SBJsonParser * parser = [[SBJsonParser alloc]init];
    NSDictionary * dic = [parser objectWithData:data];
    [parser release];
    if (menuItem.tag== 0) {
        
        HKExplainDetailViewController *detail = [[HKExplainDetailViewController alloc] initWithStyle:UITableViewStylePlain ExplainData:dic];
        
        detail.displayType = menuItem.tag;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if(menuItem.tag == 99){
        HKExpertContentViewController* demo = [[[HKExpertContentViewController alloc] init] autorelease];
        demo.ContentDic = dic;
        
        
        [self.navigationController pushViewController:demo animated:YES];
    } else if (menuItem.tag == 1) {
        HKMyVideosViewController * video = [[[HKMyVideosViewController alloc] init] autorelease];
        video.flag = YES;
        video.titleDic = dic;
        [video getDataFromVidio:dic];
        [self.navigationController pushViewController:video animated:YES];
    }
}

@end

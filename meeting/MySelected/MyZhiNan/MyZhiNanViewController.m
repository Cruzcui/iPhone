//
//  MyZhiNanViewController.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-18.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "MyZhiNanViewController.h"
#import "HKGuidDetailViewController.h"
#import "SBJsonParser.h"
@interface MyZhiNanViewController ()

@end

@implementation MyZhiNanViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
        self.title = @"我的指南";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_share.MyZhiNanDic == nil) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"没有纪录";
    }
    if (_share.MyZhiNanDic) {
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [_share.MyZhiNanDic stringForKey:@"title"];
        cell.textLabel.numberOfLines = 3;
        
        cell.detailTextLabel.text = [_share.MyZhiNanDic stringForKey:@"publisher"];
        cell.detailTextLabel.textAlignment = UITextAlignmentRight;
    }

    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!_share.MyZhiNanDic) {
        return;
    }
    SBJsonParser * parsers = [[SBJsonParser alloc]init];
    NSData * str = [self WriteLocalFile:[_share.MyZhiNanDic stringForKey:@"pkey"] andsavefile:[_share.MyZhiNanDic stringForKey:@"pkey"]];
    NSArray * dicdata = [parsers objectWithData:str];
    HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:dicdata andPkey:[_share.MyZhiNanDic stringForKey:@"pkey"] andtitleDic:_share.MyZhiNanDic andAllNodes:nil];
    
    if ([[_share.MyZhiNanDic stringForKey:@"pptCount"] intValue] == 0) {
        detailViewController.pptflag = YES;
    }
    if ([[_share.MyZhiNanDic stringForKey:@"videoCount"] intValue] == 0) {
        detailViewController.videoflag = YES;
    }

    
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [parsers release];
    
}
-(NSData *)WriteLocalFile:(NSString*)fileName andsavefile:(NSString *)realfilename {
    
    NSString *docPath =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放JSON的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    NSData * dataInfile = [[[NSData alloc] initWithContentsOfFile:realPath] autorelease];
    return dataInfile;
}
@end

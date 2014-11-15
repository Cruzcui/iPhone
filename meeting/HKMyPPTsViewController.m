//
//  HKMyPPTsViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMyPPTsViewController.h"
#import "HKMycommonsCell.h"
#import "HHDomainBase.h"
#import "UIImageView+WebCache.h"
@interface HKMyPPTsViewController ()

@property (nonatomic,retain) NSMutableArray* datas;

@end

@implementation HKMyPPTsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _arrayData = [[NSArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"HUANDENG" object:nil];

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的幻灯";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)getData:(NSNotification *) notify {
    _arrayData = [[notify object] retain];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];
        
    }
    
    NSDictionary* data = [_arrayData objectAtIndex:indexPath.row];
    
    cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
    [cell.imgTitle setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"nav_3@2x.png"]];
    
    cell.titleLabel.text = [data stringForKey:@"title"];
    cell.sectionLabel.text = [data stringForKey:@"author"];
    cell.timeLabel.text = [data stringForKey:@"time"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  110;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	if (_refreshHeaderView) {
//        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    }
//	
//	if (_refreshFooterView) {
//        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//	if (_refreshHeaderView) {
//        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
//	
//	if (_refreshFooterView) {
//        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
//    }
}

@end


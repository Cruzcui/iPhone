//
//  HKGuidListViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKGuidListViewController.h"
#import "HKLocalGuidListDomain.h"
#import "HKGuidListViewCell.h"
#import "MeetingConst.h"
#import "HHDomainBase.h"
#import "HKGuidDetailViewController.h"
#import "HKDLCategoryListViewController.h"

@interface HKGuidListViewController ()

@property (nonatomic,retain) NSArray* guidList;

@end

@implementation HKGuidListViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc{
    
    self.guidList = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HKLocalGuidListDomain* guidDomain = [[[HKLocalGuidListDomain alloc] init] autorelease];
    
    NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/db/guid"];
    
    self.guidList = [guidDomain getGuidList:path];
    
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonClick:)];
    
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"download.png"] landscapeImagePhone:[UIImage imageNamed:@"download.png"]  style:UIBarButtonItemStyleBordered target:nil action:nil];*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) rightButtonClick:(id) sender{
    
    HKDLCategoryListViewController* dlCategoryController = [[HKDLCategoryListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:dlCategoryController];
    navController.navigationBar.tintColor = [UIColor colorWithRed:0.16f green:0.49f blue:0.75f alpha:1];
    
    [self presentModalViewController:navController animated:YES];
    
    [dlCategoryController release];
    [navController release];
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.guidList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKGuidListViewCell";
    HKGuidListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HKGuidListViewCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSDictionary* guilds = [self.guidList objectAtIndex:indexPath.row];
    NSDictionary* guildData = [[guilds objectForKey:Json_GuidData] dictionaryForKey:JsonHead_data];
    
    cell.titleLabel.text = [guildData stringForKey:Json_Guid_Name];
    cell.authorLabel.text = [guildData stringForKey:Json_Guid_Author];
    cell.timeLabel.text = [guildData formatShortDateForKey:Json_Guid_Time];
    
    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row>0) {
        return;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    
     HKGuidDetailViewController *detailViewController = [[HKGuidDetailViewController alloc] initWithStyle:UITableViewStylePlain GuidLine:[self.guidList objectAtIndex:indexPath.row]];
     
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    
}


@end

//
//  HKMeetingDetailViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-3-3.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMeetingDetailViewController.h"
#import "HKMeetingDetailtitleCell.h"
#import "UIImageView+WebCache.h"
#import "HKVotesViewController.h"
#import "HKGuidSearchViewController.h"
#import "HKMyPPTViewController.h"
#import "HKMyVideosViewController.h"
@interface HKMeetingDetailViewController ()

@end

@implementation HKMeetingDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _domain = [[MeetingDomain alloc] init];
        [_domain setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.Maintitle;
    
    [self requestData];
    
    UIView * view = [[[UIView alloc] init] autorelease];
    self.tableView.tableFooterView = view;
   
}

-(void) requestData {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:self.pkey forKey:@"key"];
    [_domain getMeetingDetails:params];
    
}
-(void)didParsDatas:(HHDomainBase *)domainData {
    self.dataSource = [domainData dataDictionary];
    [self.tableView reloadData];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HKMeetingDetailtitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMeetingDetailtitleCell" owner:self options:nil] lastObject];
            }
        [cell.touxiang setImageWithURL:[NSURL URLWithString:[self.dataSource stringForKey:@"picurl"]] placeholderImage:[UIImage imageNamed:@"Touxianglogo.png"]];
        cell.titlelabel.text = [self.dataSource stringForKey:@"title"];
        cell.adresslabel.text = [NSString stringWithFormat:@"地点:%@",[self.dataSource stringForKey:@"address"]];
        cell.adresslabel.numberOfLines = 0;
        
              NSString *confromTimespStr = [self.dataSource formatChineseDateForKey:@"beginTime"] ;

        cell.timelabel.text = [NSString stringWithFormat:@"时间:%@",confromTimespStr];
        return  cell;
    }
    
    
    if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.dataSource stringForKey:@"description"];
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    if (indexPath.row == 2) {
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"在线投票";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
    if (indexPath.row == 3) {
        static NSString *CellIdentifier = @"Cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"临床指南";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }

    if (indexPath.row == 4) {
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"幻灯";
        return cell;
    }
    if (indexPath.row == 5) {
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"视频";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *cellText =[self.dataSource stringForKey:@"address"];
        UIFont *cellFont = [UIFont systemFontOfSize:16];
        CGSize constraintSize = CGSizeMake(182.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 21) {
            return  120;

        }
        else {
            return 120 + labelSize.height;
        }
    }
    if (indexPath.row == 1) {
        NSString *cellText =[self.dataSource stringForKey:@"description"];
        UIFont *cellFont = [UIFont systemFontOfSize:20];
        CGSize constraintSize = CGSizeMake(320.0f, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 40) {
            return 40;
        }else
            return labelSize.height;
    }
    return 40;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        //投票
        HKVotesViewController * vote = [[[HKVotesViewController alloc] init] autorelease];
        vote.MeetingFlag = YES;
        vote.arrayForMeeting = [self.dataSource arrayForKey:@"votes"];
        [self.navigationController pushViewController:vote animated:YES];
        
    }
    if (indexPath.row == 3) {
        //指南
        
        HKGuidSearchViewController * zhinan = [[HKGuidSearchViewController new] autorelease];
        zhinan.meetingFlag = YES;
        zhinan.arrayMeeting = [self.dataSource arrayForKey:@"medguides"];
        [self.navigationController pushViewController:zhinan animated:YES];
    }
    if (indexPath.row == 4) {
        //幻灯
        HKMyPPTViewController * ppt = [[HKMyPPTViewController new] autorelease];
        ppt.meetingflag = YES;
        ppt.arrayMeeting = [self.dataSource arrayForKey:@"ppts"];
        [self.navigationController pushViewController:ppt animated:YES];
    }
    if (indexPath.row == 5) {
        //视频
        HKMyVideosViewController * video = [[HKMyVideosViewController new] autorelease];
        video.meetingflag = YES;
        video.arraymeeting = [self.dataSource arrayForKey:@"videos"];
        [self.navigationController pushViewController:video animated:YES];
        
    }
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end

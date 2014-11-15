//
//  HKHisRefListViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-23.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHisRefListViewController.h"
#import "HKDemoImageViewController.h"

@interface HKHisRefListViewController ()

@property (nonatomic,retain) NSMutableArray* messages;

@end

@implementation HKHisRefListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"心血管系统";
    
    self.messages = [NSMutableArray arrayWithCapacity:4];
    [self.messages addObject:@"CRUSADE出血风险评分量表（ESC，2011）"];
    [self.messages addObject:@"房颤患者卒中风险评分（CHADS2 score for AF,ACC-AHA-ESC 2006）"];
    [self.messages addObject:@"房颤相关症状分级（EHRA积分）"];
    [self.messages addObject:@"房颤患者卒中风险评分（CHADS2 score for AF，ESC 2010）"];
    [self.messages addObject:@"房颤症状评分（CCS-SAF symptom score for AF, CSS 2009）"];
    [self.messages addObject:@"Framingham 心脏危险评分（女性）"];
    [self.messages addObject:@"Framingham 心脏危险评分（男性）"];
    [self.messages addObject:@"非ST段太高型心肌梗死TIMI评分（TIMI rish score）"];
    [self.messages addObject:@"国人未来10年缺血性心血管疾病（ICVD）"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
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
    return  self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HisRefListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row];
     cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if( (indexPath.row%2) ==0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HKDemoImageViewController* demo = [[[HKDemoImageViewController alloc] initWithNibName:@"HKDemoImageViewController" bundle:nil] autorelease];
    
    demo.title = @"心血管系统";
    demo.image = [UIImage imageNamed:@"hisref_1.png"];
    
    [self.navigationController pushViewController:demo animated:YES];
}

@end

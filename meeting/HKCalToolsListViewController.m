//
//  HKCalToolsListViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-23.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKCalToolsListViewController.h"
#import "HKDemoImageViewController.h"

@interface HKCalToolsListViewController ()
@property (nonatomic,retain) NSMutableArray* messages;
@end

@implementation HKCalToolsListViewController

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

    self.messages = [NSMutableArray arrayWithCapacity:4];
    [self.messages addObject:@"肺循环阻力"];
    [self.messages addObject:@"每搏输出量"];
    [self.messages addObject:@"脉压-补液试验反应预测"];
    [self.messages addObject:@"平板运动试验Duke评分"];
    [self.messages addObject:@"平均动脉压"];
    [self.messages addObject:@"体循环阻力"];
    [self.messages addObject:@"心瓣膜面积（Gorlin公式）"];
    [self.messages addObject:@"新输出量（超声）"];
    [self.messages addObject:@"校正QT间期（Bazett公式）"];
    [self.messages addObject:@"心指数"];
    [self.messages addObject:@"心脏射雪分数"];
    [self.messages addObject:@"氧气使用分率"];
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
    static NSString *CellIdentifier = @"CalToolsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
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
    demo.image = [UIImage imageNamed:@"caltool_1.png"];
    
    [self.navigationController pushViewController:demo animated:YES];
}

@end

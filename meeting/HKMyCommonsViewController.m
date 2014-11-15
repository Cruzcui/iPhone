//
//  HKMyCommonsViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMyCommonsViewController.h"
#import "HKMycommonsCell.h"
#import "HHDomainBase.h"
#import "HKDemoImageViewController.h"

@interface HKMyCommonsViewController ()

@property (nonatomic,retain) NSMutableArray* datas;

@end

@implementation HKMyCommonsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.datas = [NSMutableArray arrayWithCapacity:2];
        
        NSMutableDictionary* common = [NSMutableDictionary dictionaryWithCapacity:3];
        [common setValue:@"中国慢性髓性白血病诊断与治疗指南(2013年版)" forKey:@"title"];
        [common setValue:@"CML慢性期患者初始治疗" forKey:@"section"];
        [common setValue:@"时间：2013年10月11日" forKey:@"time"];
        [common setValue:@"my_commons_01" forKey:@"image"];
        
        
        [self.datas addObject:common];
        
        
        common = [NSMutableDictionary dictionaryWithCapacity:3];
        [common setValue:@"2010中国急性肺血栓栓塞诊断治疗专家共识" forKey:@"title"];
        [common setValue:@"流行病学" forKey:@"section"];
        [common setValue:@"时间：2013年10月11日" forKey:@"time"];
        [common setValue:@"my_commons_02" forKey:@"image"];
        
        [self.datas addObject:common];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void) dealloc{
    
    self.datas = nil;
    [super dealloc];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HKMycommonsCell";
    HKMycommonsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HKMycommonsCell" owner:self options:nil] lastObject];

    }
    
    NSDictionary* data = [self.datas objectAtIndex:indexPath.row];
    
    cell.imgTitle.image =[UIImage imageNamed:[data stringForKey:@"image"]];
    cell.titleLabel.text = [data stringForKey:@"title"];
    cell.sectionLabel.text = [data stringForKey:@"section"];
    cell.timeLabel.text = [data stringForKey:@"time"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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

    demo.title = @"我的笔记";
    demo.image = [UIImage imageNamed:@"my_common_demo.png"];
    
    [self.navigationController pushViewController:demo animated:YES];
}

@end

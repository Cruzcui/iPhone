 //
//  HKDLCategoryListViewController.m
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKDLCategoryListViewController.h"

#import "HKCategoryDomain.h"

@interface HKDLCategoryListViewController ()

@property (nonatomic,retain) HKCategoryDomain* cagegoryDomain;

@end

@implementation HKDLCategoryListViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.cagegoryDomain = [[[HKCategoryDomain alloc] init] autorelease];
        
        self.cagegoryDomain.delegate = self;
    }
    return self;
}

-(void) dealloc{
    
    self.cagegoryDomain = nil;
    [super dealloc];
}

- (void)requestCategory
{
    [self.cagegoryDomain requestCategory];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   if([_arrayCategoryList count] == 0)  {
    return 1;
    }
    return [_arrayCategoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([_arrayCategoryList count] == 0) {
        cell.textLabel.text = @"正在加载，请稍后...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        NSDictionary * categoryDic = [_arrayCategoryList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [categoryDic stringForKey:@"sname"];
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        NSDictionary * dataSourceDic =  [_arrayCategoryList objectAtIndex:indexPath.row];
       // [_delegate hkDLCategorytableView:tableView didSelectRowAtIndexPath:indexPath];
        [_delegate hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:dataSourceDic];
    }
}

#pragma mark  - DomainDelegate
-(void) didParsDatas:(HHDomainBase *)domainData{
    
    if (_delegate) {
        _arrayCategoryList  =[domainData dataDetails];
        [_delegate didParsDatas:domainData];
    }
    
}

@end

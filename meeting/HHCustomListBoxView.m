//
//  CityListViewController.m
//
//  Created by Big Watermelon on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HHCustomListBoxView.h"

@interface HHCustomListBoxView ()

@end

@implementation HHCustomListBoxView

@synthesize tbView;
@synthesize content;
@synthesize delegate;
@synthesize backCell;
@synthesize prevValue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
tableViewStyle:(UITableViewStyle) style dictData:(NSArray *) arrayData {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
             
        self.tbView = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,320,436) style:style] autorelease];
        [self.tbView setDelegate:self];
        [self.tbView setDataSource:self];
        
        [self.view addSubview:self.tbView];
        
        self.content = arrayData;
        
        [self.tbView reloadData];
        
        self.prevValue = @"";
    }
    return self;
}

- (void)dealloc
{
    self.tbView = nil;
    self.content = nil;
    self.backCell = nil;
    
    [super dealloc];
    }

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(content != nil){
        return [content count];
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    } 
    
    // Configure the cell...
    //cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    NSDictionary *nsData = [self.content objectAtIndex:indexPath.row];
    
    if (nsData != nil){
        
        cell.textLabel.text = [nsData objectForKey:@"p_Name"];
        
        // 检测是否存在plist Details
        if ([nsData objectForKey:@"p_Details"] != nil){
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{  
//    NSString *key = [keys objectAtIndex:section];  
//    return key;  
//}  

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
//{  
//    if (self.isHaveSectionIndex){
//        return keys;  
//    }
//    else {
//        return nil;
//    }
//} 


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
    /*    
     //clear previous selection first
     [checkImgView removeFromSuperview];
     
     //add new check mark
     UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
     
     //make sure the image size is fit for cell height;
     
     CGRect cellRect = cell.bounds;
     float imgHeight = cellRect.size.height * 2 / 3; // 2/3 cell height
     float imgWidth = 20.0; //hardcoded
     
     
     checkImgView.frame = CGRectMake(cellRect.origin.x + cellRect.size.width - 100, //shift for index width plus image width 
     cellRect.origin.y + cellRect.size.height / 2 - imgHeight / 2, 
     imgWidth, 
     imgHeight);
     
     [cell.contentView addSubview:checkImgView];
     checkImgView.hidden = false;
     */    
    //clear previous
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        NSDictionary *nsData = [self.content objectAtIndex:indexPath.row];
        
        NSArray *arrayData = [nsData objectForKey:@"p_Details"];
        
        HHCustomListBoxView *detailsView = [[HHCustomListBoxView alloc] initWithNibName:@"HHCustomListBoxView" bundle:nil tableViewStyle:UITableViewStyleGrouped dictData:arrayData];
        
        [detailsView setBackCell:self.backCell];
        
        [detailsView setDelegate:self];
        
        [detailsView setPrevValue:[NSString stringWithFormat:@"%@%@",self.prevValue,cell.textLabel.text]];
        
        [self.navigationController pushViewController:detailsView animated:YES];
        
    }
    else {
        
        if (self.backCell != nil){
            [self.backCell setText:[NSString stringWithFormat:@"%@%@",self.prevValue,cell.textLabel.text]];
        }
                
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
    }
}

- (void)selectedFinish{
    
    if (delegate != nil){
        [delegate selectedFinish];
    }
    
    [self.navigationController popToViewController:self animated:NO]; 
    
    
    
    
}

@end

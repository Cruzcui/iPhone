//
//  HKReviewToolsViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKReviewToolsViewController.h"
#import "HKWebViewController.h"
@interface HKReviewToolsViewController ()

@end

@implementation HKReviewToolsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _share = [ShareInstance instance];
        self.title = @"我的工具";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CheckManulListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if (_share.MyToolsDic) {
        NSDictionary * dataDic = _share.MyToolsDic                                  ;
        cell.textLabel.text = [dataDic stringForKey:@"title"];
        cell.detailTextLabel.text = [dataDic stringForKey:@"publisher"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_share.MyToolsDic) {
        NSDictionary * dataDic = _share.MyToolsDic;
        if ([[dataDic stringForKey:@"contenttype"] intValue] != 1) {
            NSString * filepath = [dataDic stringForKey:@"contenturl"];
            NSString * tittle = [dataDic stringForKey: @"title"];
            [self showHTMLWebView:filepath Title:tittle];
        } else {
            NSString * strHTML = [dataDic stringForKey:@"contenthtml"];
            NSString * title = [dataDic stringForKey: @"title"];
            [self showHTMLView:strHTML Title:title];
        }
        
        
    }
}
-(void) showHTMLWebView:(NSString*) filePaht Title:(NSString*) title{
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:title URL:[NSURL URLWithString:filePaht]
                                           ] autorelease];
    webController.editFlag = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    
}
-(void) showHTMLView:(NSString*) html Title:(NSString*) title{
    
    
    HKWebViewController* webController = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController"
                                                                                bundle:nil Title:title HTML:html
                                           ] autorelease];
    webController.editFlag = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    
}


@end

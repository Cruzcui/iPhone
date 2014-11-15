//
//  HKReviewBiBaoViewController.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKReviewBiBaoViewController.h"
#import "PosterCell.h"
#import "HKWebViewController.h"
@interface HKReviewBiBaoViewController ()

@end

@implementation HKReviewBiBaoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
            _share = [ShareInstance instance];
            self.title = @"我的壁报";
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
    static NSString *CellIdentifier = @"Cell";
    PosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PosterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (_share.MyBiBaoDic) {
        NSDictionary * dicData = _share.MyBiBaoDic;
        cell.title.numberOfLines = 1;
        cell.title.text = [dicData stringForKey:@"title"];
        cell.title.font = [UIFont systemFontOfSize:20];
        cell.title.textColor = [UIColor blueColor];
        
        
        cell.publisher.numberOfLines = 0;
        cell.publisher.text = [dicData stringForKey:@"publisher"];
        cell.publisher.font = [UIFont systemFontOfSize:14];
        cell.publisher.textColor = [UIColor blackColor];
        
        
        cell.time.numberOfLines = 0;
        cell.time.text = [dicData stringForKey:@"publishdep"];
        cell.time.font = [UIFont systemFontOfSize:14];
        cell.time.textColor = [UIColor blackColor];
        cell.textLabel.text = @"cell";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    return cell;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_share.MyBiBaoDic) {
        NSDictionary * dicData = _share.MyBiBaoDic;
        NSURL* url = [NSURL URLWithString:[dicData stringForKey:@"picurl"]];
        
        HKWebViewController* demo = [[[HKWebViewController alloc] initWithNibName:@"HKWebViewController" bundle:nil Title:[dicData stringForKey:@"title"] URL: url] autorelease];
        
        demo.editFlag = YES;
        
        [self.navigationController pushViewController:demo animated:YES];
        _share.MyBiBaoDic = dicData;
    }
    
}


@end

//
//  HKHisDictionaryViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-23.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHisDictionaryViewController.h"
#import "HKContentViewController.h"
@interface HKHisDictionaryViewController ()



@end

@implementation HKHisDictionaryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.parentkey = @"ROOT";
        _domain = [[HKToolsDomain alloc] init];
        [_domain setDelegate:self];
        _domainNext = [[HKToolsDomain alloc] init];
        [_domainNext setDelegate:self];

        }
    return self;
}
- (void)dealloc
{
    [_domain release];
    self.messages = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"1" forKey:@"dictcattype"];
    [paramsDic setObject:self.parentkey forKey:@"parentkey"];
    [_domain getToolsGuid:paramsDic];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    
  
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
        [paramsDic setObject:@"1" forKey:@"dictcattype"];
        [paramsDic setObject:self.parentkey forKey:@"parentkey"];
        [_domain getToolsGuid:paramsDic];
    }
}

-(void)didParsDatas:(HHDomainBase *)domainData {
    if (domainData == _domain) {
        self.messages =(NSMutableArray *) [domainData dataDetails];
        [self.tableView reloadData];
        [_header endRefreshing];
        
    }
    if (domainData == _domainNext) {
        if ([[domainData dataDetails] count] > 0) {
            //有子目录
            HKHisListViewController * HisList = [[[HKHisListViewController alloc] init] autorelease];
            HisList.messages =(NSMutableArray *) [domainData dataDetails];
            HisList.titleDic = [self.messages objectAtIndex:_indexRow];
            [self.navigationController pushViewController:HisList animated:YES];
        }else {
            //没有子目录
            NSString * pkey = self.parentkey;
            HKContentViewController * content = [[[HKContentViewController alloc] init] autorelease];
            content.dictcatkey = pkey;
            content.titleDic = [self.messages objectAtIndex:_indexRow];
            [self.navigationController pushViewController:content animated:YES];
            
        }
        [MBProgressHUD hideHUDForView:window animated:YES];
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
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HisDictionaryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary * dic = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic stringForKey:@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if( (indexPath.row%2) ==0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:245.0/255.0 blue:247.0/255.0 alpha:1];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary * dic = [self.messages objectAtIndex:indexPath.row];
//    NSLog(@"%d",[[dic stringForKey:@"parentkey"] intValue]);
//     if ([[dic stringForKey:@"parentkey"] intValue] == 0) {
//         NSString * pkey = [dic stringForKey:@"pkey"];
//         HKContentViewController * content = [[[HKContentViewController alloc] init] autorelease];
//         content.dictcatkey = pkey;
//         [self.navigationController pushViewController:content animated:YES];
//     }
//    if ([[dic stringForKey:@"parentkey"] intValue] != 0) {
//        NSString * parentkey = [dic stringForKey:@"parentkey"];
//        HKHisDictionaryViewController * HisListController = [[HKHisDictionaryViewController alloc] init];
//        HisListController.parentkey = parentkey;
//        [self.navigationController pushViewController:HisListController animated:YES];
//    }
    self.parentkey = [dic stringForKey:@"pkey"];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"1" forKey:@"dictcattype"];
    [paramsDic setObject:self.parentkey forKey:@"parentkey"];
    [_domainNext getToolsGuid:paramsDic];
    _indexRow = indexPath.row;
    window = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";
    
      
}

@end

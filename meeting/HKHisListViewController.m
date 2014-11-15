//
//  HKHisDictionaryViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-23.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//


#import "HKContentViewController.h"
#import "HKHisListViewController.h"





@implementation HKHisListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.parentkey = @"";
        _domain = [[HKToolsDomain alloc] init];
        [_domain setDelegate:self];
        
    }
    return self;
}
- (void)dealloc
{
    [_domain release];
    self.messages = nil;
    self.titleDic  = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
//    [paramsDic setObject:@"1" forKey:@"dictcattype"];
//    [paramsDic setObject:self.parentkey forKey:@"parentkey"];
//    [_domain getToolsGuid:paramsDic];
    self.title = [self.titleDic stringForKey:@"title"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

}
-(void)didParsDatas:(HHDomainBase *)domainData {

        if ([[domainData dataDetails] count] > 0) {
            //有子目录
            [MBProgressHUD hideHUDForView:window animated:YES];
            HKHisListViewController * HisList = [[[HKHisListViewController alloc] init] autorelease];
            HisList.messages =(NSMutableArray *) [domainData dataDetails];
            [self.navigationController pushViewController:HisList animated:YES];
            HisList.titleDic = [self.messages objectAtIndex:_indexRow];
        }else {
            //没有子目录
            [MBProgressHUD hideHUDForView:window animated:YES];
            NSString * pkey = self.parentkey;
            HKContentViewController * content = [[[HKContentViewController alloc] init] autorelease];
            content.dictcatkey = pkey;
            content.titleDic = [self.messages objectAtIndex:_indexRow];
            [self.navigationController pushViewController:content animated:YES];
            
        }
     [MBProgressHUD hideHUDForView:window animated:YES];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

    self.parentkey = [dic stringForKey:@"pkey"];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"1" forKey:@"dictcattype"];
    [paramsDic setObject:self.parentkey forKey:@"parentkey"];
    [_domain getToolsGuid:paramsDic];
    
    _indexRow = indexPath.row;
    window = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = @"loading";
}

@end

//
//  HKCategoryViewController.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "KeshiListController.h"
#import "HKCategoryDomain.h"
#import "MyProfile.h"
@interface KeshiListController ()<HHDomainBaseDelegate>


@property (nonatomic,retain) HKCategoryDomain* cagegoryDomain;
@property (nonatomic,retain) HKCategoryDomain* SystemOptionDomain;
@end

@implementation KeshiListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.cagegoryDomain = [[[HKCategoryDomain alloc] init] autorelease];
        
        self.cagegoryDomain.delegate = self;
        
        self.SystemOptionDomain = [[[HKCategoryDomain alloc] init] autorelease];
        
        self.SystemOptionDomain.delegate = self;
        
        _arrayCategoryList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.cagegoryDomain setDelegate:self];
    [self.cagegoryDomain requestCategory];
    [self.SystemOptionDomain setDelegate:self];
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    [params setObject:@"html_iphone" forKey:@"pkey"];
//    [self.SystemOptionDomain getSystemOption:params];
    
    self.title = @"选择科室";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
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
    if ([_arrayCategoryList count] < 1) {
        return 1;
    }else{
        return [_arrayCategoryList count] ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([_arrayCategoryList count] < 1) {
        cell.textLabel.text = @"正在加载，请稍后...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        NSDictionary * dicArray = [_arrayCategoryList objectAtIndex:indexPath.row];
        cell.textLabel.text = [dicArray stringForKey:@"sname"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        NSDictionary * dataSourceDic =  [_arrayCategoryList objectAtIndex:indexPath.row];
        // [_delegate hkDLCategorytableView:tableView didSelectRowAtIndexPath:indexPath];
        [_delegate hkDLCategorytableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:dataSourceDic];
           }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

#pragma mark  - DomainDelegate
-(void) didParsDatas:(HHDomainBase *)domainData{
    if (domainData == self.cagegoryDomain) {
        NSArray * array = [domainData dataDetails];
        for (int i  = 0; i < [array count]; i ++) {
            if (i != 0) {
                [_arrayCategoryList addObject:[array objectAtIndex:i]];
            }
        }
        [self.tableView reloadData];
        // [_delegate didParsDatas:domainData];
//        if ([_arrayCategoryList count] > 0) {
//            NSDictionary * dicsource = [_arrayCategoryList objectAtIndex:0];
//            //指南原/Users/cuiyang/Desktop/2013_11_医学指南针/代码/iPhone/meeting/HisGuidLine/HKGuidListViewCell.h文发送初始化消息数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZHINANLIEBIAO" object:dicsource];
//            //我的社区发送初始化消息数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"WODESHEQU" object:dicsource];
//            //医学工具发送初始化消息数据
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"TOOLS" object:dicsource];
//        }
        
    }
//    if (domainData == self.SystemOptionDomain) {
//        MyProfile * profile = [MyProfile myProfile];
//        profile.SystemInfo = [domainData dataDictionary];
//    }
    
    
}

@end

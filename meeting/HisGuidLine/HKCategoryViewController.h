//
//  HKCategoryViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HHDomainBase.h"

@protocol HKDLCategoryListViewControllerDelegate <NSObject>

- (void)didParsDatas:(HHDomainBase *)domainData;
- (void)hkDLCategorytableView:(UITableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(NSDictionary * )dataSourceDic;

@optional
- (void)hkDLCategorytableView:(UITableViewController *)tableView didSelectFav:(NSMutableArray*) favArray;

@end

@interface HKCategoryViewController : UITableViewController<HHDomainBaseDelegate>

@property (nonatomic,assign) int indexRow;
@property (nonatomic,retain) NSMutableArray * arrayCategoryList;
@property (nonatomic,assign) id<HKDLCategoryListViewControllerDelegate> delegate;

//科室订阅为 1，其它为0
@property (nonatomic) int pageType;
@property (nonatomic,retain) NSMutableArray* favSectionArray;


@end

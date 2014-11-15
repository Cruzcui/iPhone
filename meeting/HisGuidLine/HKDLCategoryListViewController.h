//
//  HKDLCategoryListViewController.h
//  HisGuidline
//
//  Created by kimi on 13-9-30.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHDomainBase.h"
#import "HKCategoryViewController.h"

@interface HKDLCategoryListViewController : NSObject<UITableViewDataSource,UITableViewDelegate, HHDomainBaseDelegate>
@property (nonatomic,retain) NSArray * arrayCategoryList;

@property (nonatomic,assign) id<HKDLCategoryListViewControllerDelegate> delegate;

- (void)requestCategory;

@end

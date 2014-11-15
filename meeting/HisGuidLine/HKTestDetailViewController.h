//
//  HKTestDetailViewController.h
//  HisGuidline
//
//  Created by kimi on 13-9-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCategorySearchDomain.h"
@interface HKTestDetailViewController : UITableViewController<HHDomainBaseDelegate> {
    NSMutableDictionary * _dicforRow;
}



@property (nonatomic,retain) NSDictionary* testDictionary;

- (id)initWithStyle:(UITableViewStyle)style TestData:(NSDictionary*) testDic;

@end

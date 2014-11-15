//
//  GetVoteViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-12.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
#import "MyProfile.h"
@interface GetVotesViewController : UITableViewController<HHDomainBaseDelegate> {
    NSArray * _questionArray;
    NSMutableDictionary * _questionDic;
    HKCommunicateDomain * _domain;
    HKCommunicateDomain * _domains;
    MyProfile * profile;
}
@property (nonatomic,retain) NSDictionary * dataSorce;
@property (nonatomic,retain) NSDictionary * keshi;
@end

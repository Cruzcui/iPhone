//
//  HKCommunicateController.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import "ShareInstance.h"
#import "HKMyPPTViewController.h"
#import "HKMyPosterViewController.h"
#import "HKMyVideosViewController.h"
#import "HKVotesViewController.h"
#import "HKHelpViewController.h"
#import "UIDevice+Resolutions.h"
@interface HKCommunicateController:UIViewController<HKDLCategoryListViewControllerDelegate,UIScrollViewDelegate> {
    HKCommunicateDomain * _domain;
    NSMutableDictionary * _dicParams;
    NSMutableArray * _dataForHuanDeng;
    int _count;
    ShareInstance * _share;
    int _index;
    HKMyPPTViewController* _pptController;
    HKMyPosterViewController* _posterController;
    HKMyVideosViewController* _videoController;
    HKVotesViewController* _voteController;
    HKHelpViewController* _helpController;
    
}
@property (retain, nonatomic) IBOutlet UIView *contentView;
@end

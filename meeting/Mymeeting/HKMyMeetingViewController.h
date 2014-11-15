//
//  HKMyMeetingViewController.h
//  HisGuidline
//
//  Created by kimi on 14-2-25.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingDomain.h"
@interface HKMyMeetingViewController : UIViewController<HHDomainBaseDelegate> {
    UIToolbar * topView;
    MeetingDomain * _domain;
}

@property (retain, nonatomic) IBOutlet UITextField *txtMeetingid;

@property (retain, nonatomic) IBOutlet UIButton *btnStartMetting;

@property (retain, nonatomic) IBOutlet UIButton *btnScanMeeting;

@property (retain,nonatomic) IBOutlet UILabel * txtlabel;
@end

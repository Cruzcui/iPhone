//
//  HKMyPPTcommonsCell.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-22.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKMyPPTcommonsCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgTitle;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *sectionLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain,nonatomic) IBOutlet UIButton * btndownload;
@property (retain,nonatomic) IBOutlet UIImageView * download;
@end

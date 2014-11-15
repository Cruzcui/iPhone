//
//  HKGuidListViewCell.h
//  HisGuidline
//
//  Created by kimi on 13-9-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKGuidListViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel* titleLabel;

@property (nonatomic,retain) IBOutlet UILabel* authorLabel;

@property (nonatomic,retain) IBOutlet UILabel* timeLabel;

@property (retain, nonatomic) IBOutlet UIImageView *downloadImageView;

@property (retain ,nonatomic) IBOutlet UILabel * countZhizhen;


@property (retain,nonatomic) IBOutlet UIImageView * PPT;
@property (retain,nonatomic) IBOutlet UIImageView * Video;
@end

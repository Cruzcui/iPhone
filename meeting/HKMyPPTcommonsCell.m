//
//  HKMyPPTcommonsCell.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-22.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMyPPTcommonsCell.h"

@implementation HKMyPPTcommonsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc {
    [_titleLabel release];
    [_sectionLabel release];
    [_timeLabel release];
    [_imgTitle release];
    [super dealloc];
}

@end

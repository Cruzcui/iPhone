//
//  HKMycommonsCell.m
//  HisGuidline
//
//  Created by kimi on 13-10-22.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKMycommonsCell.h"

@implementation HKMycommonsCell

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

//
//  HKHomeButtonCell.m
//  HisGuidline
//
//  Created by kimi on 13-12-2.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKHomeButtonCell.h"

@implementation HKHomeButtonCell

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
    [_ImageView release];
    [_TitleLabel release];
    [_SubTitleLabel release];
    [_moreButton release];
    [super dealloc];
}
@end

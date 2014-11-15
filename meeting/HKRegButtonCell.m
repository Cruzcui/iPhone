//
//  HKRegButtonCell.m
//  HisGuidline
//
//  Created by kimi on 14-1-15.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKRegButtonCell.h"

@implementation HKRegButtonCell

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
    [_btnSubmit release];
    [_btnCancel release];
    [super dealloc];
}
@end

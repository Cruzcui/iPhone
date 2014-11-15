//
//  HKGuidListViewCell.m
//  HisGuidline
//
//  Created by kimi on 13-9-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKGuidListViewCell.h"

@implementation HKGuidListViewCell

@synthesize titleLabel;
@synthesize authorLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc{
    
    self.titleLabel = nil;
    self.authorLabel = nil;
    self.timeLabel = nil;
    self.downloadImageView = nil;
    self.countZhizhen = nil;
    [_downloadImageView release];
    [super dealloc];
}

@end

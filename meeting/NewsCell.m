//
//  NewsCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (void)dealloc
//{
//    [_title release];
//    [_author release];
//    [_time release];
//    [super dealloc];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

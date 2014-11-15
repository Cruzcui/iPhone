//
//  PosterCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PosterCell.h"

@implementation PosterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _title = [[UILabel alloc] initWithFrame:CGRectMake(19, 0, 280, 39)];
        _time = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, 87, 21)];
        _publisher = [[UILabel alloc] initWithFrame:CGRectMake(178, 64, 135, 21)];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_time];
        [self.contentView addSubview:_publisher];
        [_title release];
        [_time release];
        [_publisher release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews {

}
- (void)dealloc
{
    [_publisher release];
    [_title release];
    [_time release];
    [super dealloc];
}
@end

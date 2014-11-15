//
//  HkPostCell.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-6.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HkPostCell.h"

@implementation HkPostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _title = [[UILabel alloc] initWithFrame:CGRectMake(19, 0, 280, 39)];
        _time = [[UILabel alloc] initWithFrame:CGRectMake(20, 64, 87, 21)];
        _publisher = [[UILabel alloc] initWithFrame:CGRectMake(178, 64, 135, 21)];
//        _selectedBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
//        [_selectedBtn setFrame:CGRectMake(298, 0, 20, 39)];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_time];
        [self.contentView addSubview:_publisher];
        [self.contentView addSubview:_selectedBtn];
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

@end

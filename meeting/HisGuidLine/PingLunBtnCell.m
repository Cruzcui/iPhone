//
//  PingLunBtnCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PingLunBtnCell.h"

@implementation PingLunBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


    }
    return self;
}
- (void)dealloc
{
   [_btnPinglunList release];
   [_btnPinglunPost release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

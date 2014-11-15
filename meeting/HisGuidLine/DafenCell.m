//
//  DafenCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "DafenCell.h"

@implementation DafenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
    }
    return self;
}

- (void)dealloc
{
   [_btnDaFen release];
    [_averageStar release];
    [_totalCount release];
    [_fiveStar release];
    [_fourStrar release];
    [_threeStar release];
   [_twoStar release];
    [_oneStar release];
    [_fiveLine release];
    [_fourLine release];
    [_threeLine release];
    [_twoLine release];
    [_oneLine release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setFrameToLine5:(CGRect) rect{
    [self.fiveLine setFrame:rect];
}
-(void) setFrameToLine4:(CGRect) rect{
    [self.fourLine setFrame:rect];
}
-(void) setFrameToLine3:(CGRect) rect{
    [self.threeLine setFrame:rect];
}
-(void) setFrameToLine2:(CGRect) rect{
    [self.twoLine setFrame:rect];
}
-(void) setFrameToLine1:(CGRect) rect{
    [self.oneLine setFrame:rect];
}
@end

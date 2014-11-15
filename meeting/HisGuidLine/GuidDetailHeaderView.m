//
//  GuidDetailHeaderView.m
//  HisGuidline
//
//  Created by cuiyang on 13-11-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "GuidDetailHeaderView.h"

@implementation GuidDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self setFrame:CGRectMake(0, 0, 320, 140)];

    }
    return self;
}
- (void)dealloc
{
   [_titlelabel release];
   [_publisherlabel release];
   [_btnDaFen release];
   [_btnPingLun release];
   [_tableViewheader release];
   [_btnppt release];
   [_btnvideo release];
   [_btnpizhu release];
   [_btnselected release];
   [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

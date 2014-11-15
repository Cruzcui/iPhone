//
//  UserInfoHeader.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "UserInfoHeader.h"
#import "MeetingConst.h"
@implementation UserInfoHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc
{
    [_status release];
    [_btn release];
    [super dealloc];
}
-(void)layoutSubviews {
    [self.btn setBackgroundColor:getUIColor(Color_NavBarBackColor)];
    [self.status setTextColor:getUIColor(Color_NavBarBackColor)];
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

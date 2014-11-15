//
//  HKMeetingDetailtitleCell.m
//  HisGuidline
//
//  Created by cuiyang on 14-3-3.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKMeetingDetailtitleCell.h"

@implementation HKMeetingDetailtitleCell

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
-(void) layoutSubviews {
    NSString *cellText =self.adresslabel.text;
    UIFont *cellFont = [UIFont systemFontOfSize:16];
    CGSize constraintSize = CGSizeMake(182.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect rect = self.adresslabel.frame;
    rect.size.height = labelSize.height;
    
    self.adresslabel.frame = rect;
}
@end

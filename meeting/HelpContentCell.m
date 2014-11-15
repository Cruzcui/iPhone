//
//  HelpContentCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HelpContentCell.h"
#import "MeetingConst.h"
@implementation HelpContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       }
    return self;
}
-(void)layoutSubviews {
    self.helpContent.numberOfLines = 0;
    self.helpContent.lineBreakMode = NSLineBreakByWordWrapping;
    self.helpTitle.numberOfLines = 2;
    self.helpTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.helpTitle.font = [UIFont boldSystemFontOfSize:23.0f];
    self.helpTitle.textAlignment = NSTextAlignmentCenter;
    self.helpContent.font = [UIFont systemFontOfSize:14.0f];

    CGSize constraintSize = CGSizeMake(310.0f, MAXFLOAT);
    CGSize labelSize = [self.helpContent.text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize titleContrainSize = CGSizeMake(310.0f, 90);
    CGSize titleSize = [self.helpContent.text sizeWithFont:[UIFont boldSystemFontOfSize:23.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
    
    self.helpTitle.frame = CGRectMake(5, 5, 310, titleSize.height);
    self.helpContent.frame =CGRectMake (5, 10 + titleSize.height, 320-10,labelSize.height);
    self.huiFuBtn.frame = CGRectMake(130,15+titleSize.height +labelSize.height, 60, 30);
    [self.huiFuBtn setBackgroundColor:getUIColor(Color_NavBarBackColor)];
    
   }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

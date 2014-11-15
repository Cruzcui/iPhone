//
//  HuiFuHuiFuCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.


#import "HuiFuHuiFuCell.h"

@implementation HuiFuHuiFuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews {
    CGSize titleContrainSize = CGSizeMake(241.0f, MAXFLOAT);
    CGSize titleSize = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
    [self.content setFrame:CGRectMake(59, 28, 241, titleSize.height)];
    [self.time setFrame:CGRectMake(20, 35 + titleSize.height, 138, 21)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

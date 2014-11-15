//
//  SelectedCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-12.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "SelectedCell.h"

@implementation SelectedCell

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
-(void)layoutSubviews {
    NSString *cellText =self.qtitle.text;
    UIFont *cellFont = [UIFont systemFontOfSize:14];
    CGSize constraintSize = CGSizeMake(205.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect rectqla = self.qselected.frame;
    CGRect rectqt = self.qtitle.frame;
    if (labelSize.height < 48) {
        rectqla.size.height = 48;
        rectqt.size.height = 48;
    }
    else {
        rectqla.size.height = labelSize.height + 2;
        rectqt.size.height = labelSize.height;

    }
      self.qselected.frame = rectqla;
    self.qtitle.frame = rectqt;
}
@end

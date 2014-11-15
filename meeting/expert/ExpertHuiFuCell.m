//
//  DrHuiFuCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "ExpertHuiFuCell.h"

@implementation ExpertHuiFuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews {
    CGSize titleContrainSize = CGSizeMake(310.0f, MAXFLOAT);
    CGSize titleSize = [self.content.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
    [self.content setFrame:CGRectMake(5, 88, 307, titleSize.height)];
    [self.btn setFrame:CGRectMake(258, 100+titleSize.height, 44, 30)];
    [self.btn addTarget:self action:@selector(GoHuiFu) forControlEvents:UIControlEventTouchUpInside];
 }
-(void) GoHuiFu {

    [self.delegate Huifu:self.InFoDic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

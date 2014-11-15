//
//  UserInfoCell1.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "UserInfoCell1.h"

@implementation UserInfoCell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.notLayoutSubView = NO;
    }
    return self;
}
-(void) layoutSubviews {
    
   if (!self.notLayoutSubView) {
       CGSize titleContrainSize = CGSizeMake(310.0f, MAXFLOAT);
        CGSize titleSize = [self.name.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:titleContrainSize lineBreakMode:UILineBreakModeTailTruncation];
       //[self.name setFrame:CGRectMake(10, 15, titleSize.width, 27)];
       [self.properties setFrame:CGRectMake(15+titleSize.width, 7, 300-18-titleSize.width, 30)];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

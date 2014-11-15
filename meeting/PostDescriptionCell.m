//
//  PostDescriptionCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-16.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostDescriptionCell.h"

@implementation PostDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 320 - 10, self.contentView.bounds.size.height-10)];
        [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_textView];
        [_textView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

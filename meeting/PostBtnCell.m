//
//  PostBtnCell.m
//  HisGuidline
//
//  Created by cuiyang on 13-12-13.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "PostBtnCell.h"

@implementation PostBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setFrame:self.contentView.bounds];
        [_postBtn setBackgroundColor:[UIColor grayColor]];
        [_postBtn setTintColor:[UIColor blackColor]];
        [self.contentView addSubview:_postBtn];
        [_postBtn setTitle:@"投票" forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

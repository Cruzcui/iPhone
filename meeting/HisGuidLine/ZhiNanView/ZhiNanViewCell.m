//
//  ZhiNanViewCell.m
//  HisGuidline
//
//  Created by cuiyang on 14-2-11.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "ZhiNanViewCell.h"

@implementation ZhiNanViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.btn = nil;
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    self.contentLabel = nil;
    self.btnExplain = nil;
    self.PkeyinCell = nil;
    [super dealloc];
}
-(void) layoutSubviews {
    
    [self.btnExplain addTarget:self action:@selector(explan:) forControlEvents:UIControlEventTouchUpInside];
    _share = [ShareInstance instance];
    
    
}
-(void)explan:(id) sender {
    
    
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [mutableDictionary setDictionary:[_share.ZhiNanMuLu objectForKey:self.PkeyinCell]];
     if ([[mutableDictionary objectForKey:@"Zhankai"] isEqualToString:@"0"]) {
        [mutableDictionary setValue:@"1" forKey:@"Zhankai"];
        [_share.ZhiNanMuLu setObject:mutableDictionary forKey:self.PkeyinCell];
        [self.CellDelegate change:self.PkeyinCell andRowNumber:self.RowNumber];
//        [self.btnExplain setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];

    }
   
     else if ([[mutableDictionary objectForKey:@"Zhankai"] isEqualToString:@"1"]) {
        [mutableDictionary setValue:@"0" forKey:@"Zhankai"];
        [_share.ZhiNanMuLu setObject:mutableDictionary forKey:self.PkeyinCell];

        [self.CellDelegate changeShouSuo:self.PkeyinCell andRowNumber:self.RowNumber];
    }
  }

@end

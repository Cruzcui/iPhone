//
//  MyNoteCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNoteCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UIImageView * picImage;
@property (nonatomic,retain) IBOutlet UILabel * titleLabel;
@property (nonatomic,retain) IBOutlet UILabel * picCount;
@end

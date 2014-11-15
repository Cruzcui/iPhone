//
//  SelectedCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-12.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel * qid;
@property (nonatomic,retain) IBOutlet UILabel * qtitle;
@property (nonatomic,retain) IBOutlet UILabel * qselected;
@property (nonatomic,retain) IBOutlet UIImageView * image;
@end

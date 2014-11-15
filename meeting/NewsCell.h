//
//  NewsCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-24.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel * title;
@property (nonatomic,retain) IBOutlet UILabel * author;
@property (nonatomic,retain) IBOutlet UILabel * time;
@property (nonatomic,retain) IBOutlet UIImageView * imagetitle;
@end

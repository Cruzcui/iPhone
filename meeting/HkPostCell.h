//
//  HkPostCell.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-6.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HkPostCell : UITableViewCell
@property (nonatomic,retain) UILabel * publisher;
@property (nonatomic,retain) UILabel * title;
@property (nonatomic,retain) UILabel * time;
@property (nonatomic,retain) UIButton * selectedBtn;
@property (nonatomic,retain) NSDictionary * cellinfo;
@end

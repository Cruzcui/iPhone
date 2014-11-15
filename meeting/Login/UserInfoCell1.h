//
//  UserInfoCell1.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-14.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell1 : UITableViewCell


@property (nonatomic) BOOL notLayoutSubView;

@property (nonatomic,retain) IBOutlet UILabel * name;

@property (nonatomic,retain) IBOutlet UITextField * properties;

@property (nonatomic,retain) IBOutlet UIView* spliView;

@property (nonatomic,retain) IBOutlet UIImageView* rightImage;

@property (nonatomic,retain) IBOutlet UILabel * top;
@property (nonatomic,retain) IBOutlet UILabel * buttom;
@property (nonatomic,retain) IBOutlet UILabel * left;
@property (nonatomic,retain) IBOutlet UILabel * right;

//@property (nonatomic,retain) IBOutlet UIButton * btn;
@end

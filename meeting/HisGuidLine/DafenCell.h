//
//  DafenCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-27.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DafenCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UIButton * btnDaFen;
@property (nonatomic,retain) IBOutlet UILabel * averageStar;
@property (nonatomic,retain) IBOutlet UILabel * totalCount;
@property (nonatomic,retain) IBOutlet UILabel * fiveStar;
@property (nonatomic,retain) IBOutlet UILabel * fourStrar;
@property (nonatomic,retain) IBOutlet UILabel * threeStar;
@property (nonatomic,retain) IBOutlet UILabel * twoStar;
@property (nonatomic,retain) IBOutlet UILabel * oneStar;
@property (nonatomic,retain) IBOutlet UILabel * fiveLine;
@property (nonatomic,retain) IBOutlet UILabel * fourLine;
@property (nonatomic,retain) IBOutlet UILabel * threeLine;
@property (nonatomic,retain) IBOutlet UILabel * twoLine;
@property (nonatomic,retain) IBOutlet UILabel * oneLine;
-(void) setFrameToLine5:(CGRect) rect;
-(void) setFrameToLine4:(CGRect) rect;
-(void) setFrameToLine3:(CGRect) rect;

-(void) setFrameToLine2:(CGRect) rect;
-(void) setFrameToLine1:(CGRect) rect;
@end

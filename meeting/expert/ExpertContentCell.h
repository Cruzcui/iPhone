//
//  HelpContentCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellsDelegete
-(void) Huisfu:(NSDictionary *)InfoDic;
@end
@interface ExpertContentCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel * helpTitle;
@property (nonatomic,retain) IBOutlet UILabel * helpContent;
@property (nonatomic,retain) IBOutlet UIButton * huiFuBtn;
@property (nonatomic,retain) NSDictionary *Infodic;
@property (nonatomic,assign)id<CellsDelegete>delegates;
@end

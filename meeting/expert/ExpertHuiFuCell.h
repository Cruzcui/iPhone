//
//  DrHuiFuCell.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-26.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CellDelegete
-(void) Huifu:(NSDictionary *)InfoDic;
@end
@interface ExpertHuiFuCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel * level;
@property (nonatomic,retain) IBOutlet UILabel * time;
@property (nonatomic,retain) IBOutlet UILabel *userName;
@property (nonatomic,retain) IBOutlet UIImageView * TouxiangImage;
@property (nonatomic,retain) IBOutlet UILabel * content;
@property (nonatomic,retain) IBOutlet UIButton * btn;
@property (nonatomic,retain) IBOutlet UILabel * keshilabel;
@property (nonatomic,retain) NSDictionary *InFoDic;
@property (nonatomic,assign)id<CellDelegete>delegate;
@end

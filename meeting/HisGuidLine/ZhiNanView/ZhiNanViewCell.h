//
//  ZhiNanViewCell.h
//  HisGuidline
//
//  Created by cuiyang on 14-2-11.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
@protocol CellDelegate
- (void)change:(NSString *)pkey andRowNumber:(int) RowNumber;
- (void)changeShouSuo:(NSString *)pkey andRowNumber:(int) RowNumber;
@end


@interface ZhiNanViewCell : UITableViewCell {
    ShareInstance * _share;
}
@property (nonatomic,retain) IBOutlet UILabel * contentLabel;
@property (nonatomic,retain) IBOutlet UIButton * btnExplain;
@property (nonatomic,copy) NSString * PkeyinCell;
@property (nonatomic,assign) int RowNumber;
//@property (nonatomic,assign)  BOOL clickFlag;
@property (nonatomic,retain) UIButton * btn;

@property(nonatomic, assign) id<CellDelegate> CellDelegate;
@end

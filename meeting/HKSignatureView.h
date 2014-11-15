//
//  HKSignatureView.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSignatureView : UIControl
@property (nonatomic,retain) UIImage * ima;
-(void) qieTu:(CGRect)rect;
-(void)save;
-(void) savePicture:(NSString*)fileName andsavefile:(NSString *)realfilename;
@end

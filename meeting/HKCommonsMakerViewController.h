//
//  HKCommonsMakerViewController.h
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareInstance.h"
#import "HKSignatureView.h"
#import "ACEDrawingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TextInput.h"
@interface HKCommonsMakerViewController : UIViewController {
    
    ShareInstance * _share;
    TextInput * text;
    UIToolbar * topView;
}
@property (nonatomic,retain) NSDictionary * DicForPic;
@property (nonatomic,retain) UIImage* markImage;
@property (nonatomic,retain) IBOutlet ACEDrawingView* singView;

@property (nonatomic,retain) IBOutlet UIBarButtonItem* undoButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* redoButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* textbtn;

@property (nonatomic) BOOL canMark;


@end

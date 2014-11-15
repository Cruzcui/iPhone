//
//  PostHelperViewController.h
//  HisGuidline
//
//  Created by cuiyang on 13-12-28.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCommunicateDomain.h"
@interface PostHelperViewController : UIViewController<HHDomainBaseDelegate> {
    HKCommunicateDomain * _domain;
    UIToolbar * topView;
}
@property (nonatomic,retain) IBOutlet  UITextView * textInput;
@property (nonatomic,retain) NSDictionary *InfoDic;
@property (nonatomic,assign) BOOL *flag;
@end

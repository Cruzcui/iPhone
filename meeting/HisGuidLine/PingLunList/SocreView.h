//
//  SocreView.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-29.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCategorySearchDomain.h"
#import "MBProgressHUD.h"
@interface SocreView : UIViewController<HHDomainBaseDelegate> {
    HKCategorySearchDomain * _domain;
    NSString * _counts;
    UIViewController *topController;
    CGRect Rootrect;
    MBProgressHUD * _hud;
}
@property (nonatomic,retain) IBOutlet UILabel* count;
@property (nonatomic,retain) IBOutlet UIButton *submit;
@property (nonatomic,retain) IBOutlet UIButton *one;
@property (nonatomic,retain) IBOutlet UIButton *two;
@property (nonatomic,retain) IBOutlet UIButton *three;
@property (nonatomic,retain) IBOutlet UIButton *four;
@property (nonatomic,retain) IBOutlet UIButton *five;
@property (nonatomic,retain) IBOutlet UITextView * textContent;

@property (nonatomic,retain) NSDictionary * dic;
@property (nonatomic,copy) NSString * pkey;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andGuidLine:(NSDictionary *)guidl andPkey:(NSString *)pkey;
@end

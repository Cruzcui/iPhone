//
//  PostLPingLunView.h
//  HisGuidline
//
//  Created by cuiyang on 13-11-29.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCategorySearchDomain.h"
@interface PostLPingLunView : UIViewController<HHDomainBaseDelegate>{
    HKCategorySearchDomain *_domain;
}

@property (nonatomic,retain) IBOutlet UITextView * textContent;
@property (nonatomic,retain) IBOutlet UIButton * button;
@property (nonatomic,retain) NSDictionary * dic;
@property (nonatomic,copy) NSString * pkey;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andGuidLine:(NSDictionary *)guidl andPkey:(NSString *)pkey;
@end

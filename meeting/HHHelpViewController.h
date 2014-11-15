//
//  HHHelpViewController.h
//  DalianPort
//
//  Created by 翔 张 on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHelpViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIPageControl* pageControl;
    BOOL pageControlBeingUsed;
    BOOL direction;
    
}
@property (nonatomic,retain) IBOutlet UIButton * btn;
@property (nonatomic) int currentIndex;
@property (nonatomic,retain) NSMutableArray* imageArray;

@property (nonatomic,retain) NSString *saveFlag;


-(void) loadImages:(NSString*) areaCode count:(int) intCount;

-(void) startSwitch;
-(void) switchImages;
@end

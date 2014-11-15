//
//  HHHomeAdCell.h
//  DalianPort
//
//  Created by mac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HHRequestImage.h"
#import "HHHomeAds.h"

@interface HHHomeAdCell : UIView<HHRequestImageDelegate,HHDomainBaseDelegate,UIScrollViewDelegate>{
    
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIPageControl* pageControl;
   // IBOutlet UILabel * labelTittle;
    BOOL pageControlBeingUsed;
    BOOL direction;
}

@property (nonatomic) int currentIndex;
@property (nonatomic,retain) NSMutableArray* imageArray;


-(void) loadImages:(NSString*) areaCode;

-(void) startSwitch;
-(void) switchImages;

@end

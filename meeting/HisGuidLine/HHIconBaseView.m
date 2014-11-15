//
//  HHIconBaseView.m
//  DalianPort
//
//  Created by mac on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHIconBaseView.h"

@implementation HHIconBaseView


@synthesize titleImage;
@synthesize titleLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(3, 85, 100, 22)] autorelease];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        [self.titleLabel setBackgroundColor: [UIColor clearColor]];
        
        self.titleImage = [[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 80, 80)] autorelease];
        
        [self addSubview:self.titleImage];
        [self addSubview:self.titleLabel];

    }
    return self;
}


- (void)dealloc{
    self.titleLabel = nil;
    self.titleImage = nil;
    
    [super dealloc];
}

@end

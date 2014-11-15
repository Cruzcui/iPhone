//
//  HKTabBarItem.m
//  HisGuidline
//
//  Created by kimi on 14-3-4.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKTabBarItem.h"
#import "MeetingConst.h"

@implementation HKTabBarItem

+(instancetype) tabBarItem:(UIImage *)image title:(NSString *)title{
    
    HKTabBarItem* item = [[[HKTabBarItem alloc] initWithFrame:CGRectMake(0, 0, 42, 42)] autorelease];
    
    item.backgroundColor = [UIColor clearColor];
    
    
    //图标
    UIImageView* imgView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imgView.frame = CGRectMake(5, 1, 30, 30);
    
    [item addSubview:imgView];
    
    //文字
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 44, 12)];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = getUIColor(Color_light_gray);
    label.text = title;
    
    [item addSubview:label];
    
    
    
    return item;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end

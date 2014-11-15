//
//  UIButton+HHStyle.m
//  idut
//
//  Created by kimi on 14-2-12.
//  Copyright (c) 2014年 DUT. All rights reserved.
//

#import "UIButton+HHStyle.h"
#import "MeetingConst.h"


@implementation UIButton (UIButton_HHStyle)




-(void) hhStyle{

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        
        
        
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        
        UIColor* color =  getUIColor(Color_NavBarBackColor);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = color;
        
        self.layer.borderWidth = 1.0f;
        //self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [color CGColor];
    }
    
    
}


@end


@implementation UITableView (UITableView_HHStyle)

-(void) hhStyle{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        //这句在ios6下会挂掉
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}

@end

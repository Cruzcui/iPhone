//
//  MyView.h
//  Shouzhiqietu
//
//  Created by dlios on 13-8-5.
//  Copyright (c) 2013年 lpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView  {
    BOOL _flag;
}
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;
@property (nonatomic,retain) NSMutableArray *line;
@property (nonatomic,retain) UIImage * ima;
@end
@interface UIView (setCenter)

@end
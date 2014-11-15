//
//  MyView.m
//  Shouzhiqietu
//
//  Created by dlios on 13-8-5.
//  Copyright (c) 2013年 lpf. All rights reserved.
//

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect rect1 = CGRectMake(_startPoint.x,_startPoint.y, _endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextAddRect(context,rect1);
   
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"%s",__FUNCTION__);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _startPoint = point;
    NSLog(@"%f,%f",_startPoint.x,_startPoint.y);
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    _flag = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _endPoint = point;
    CGRect rect1 = CGRectMake(_startPoint.x,_startPoint.y, _endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    [self qieTu:rect1];
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   
    UIImageWriteToSavedPhotosAlbum(_ima, nil, nil, nil);
//    _flag = YES;
}

-(void) qieTu:(CGRect)rect {
    NSLog(@"%s",__FUNCTION__);
    CGPoint sp = _startPoint;
    CGPoint ep = _endPoint;
    _startPoint = CGPointZero;
    _endPoint = CGPointZero;
    [self setNeedsDisplay];
    UIGraphicsBeginImageContext(self.superview.bounds.size);
    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imager = CGImageCreateWithImageInRect(viewImage.CGImage, rect);
    self.ima = [UIImage imageWithCGImage:imager];
    _startPoint = sp;
    _endPoint = ep;
}




@end
@implementation UIView (setCenter)
-(void)beCenter{
    CGPoint centerPoint = CGPointMake(self.superview.bounds.size.width / 2, self.superview.bounds.size.height);
    self.center = centerPoint;
}

@end





















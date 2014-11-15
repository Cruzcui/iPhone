/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ACEDrawingTools.h"

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark - ACEDrawingPenTool

@implementation ACEDrawingPenTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize tag=_tag;
@synthesize isSelected = _isSelected;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}

-(BOOL) isSelected:(CGPoint)point{
    self.isSelected = NO;
    return NO;
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end


@implementation ACEDrawingCureTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize tag=_tag;
@synthesize isSelected = _isSelected;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.lineCapStyle = kCGLineCapRound;
        self.lineColor = [UIColor clearColor];
    }
    return self;
}


-(void) setLineColor:(UIColor *)lineColor{

#if !ACE_HAS_ARC
    if (_lineColor!=nil) {
        [_lineColor release];
    }
    
    _lineColor = [[UIColor clearColor] retain];
    
#endif
    
#if ACE_HAS_ARC
    _lineColor = [UIColor clearColor];
    
#endif
   
    
    
}

- (void)setInitialPoint:(CGPoint)firstPoint
{
    [self moveToPoint:firstPoint];
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    [self addQuadCurveToPoint:midPoint(endPoint, startPoint) controlPoint:startPoint];
}

- (void)draw
{
    [self.lineColor setStroke];
    [self strokeWithBlendMode:kCGBlendModeCopy alpha:self.lineAlpha];
}

-(BOOL) isSelected:(CGPoint)point{
    self.isSelected = NO;
    return NO;
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end




#pragma mark - ACEDrawingLineTool

@interface ACEDrawingLineTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingLineTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize tag=_tag;
@synthesize isSelected = _isSelected;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the line properties
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the line
    CGContextMoveToPoint(context, self.firstPoint.x, self.firstPoint.y);
    CGContextAddLineToPoint(context, self.lastPoint.x, self.lastPoint.y);
    CGContextStrokePath(context);
}


-(BOOL) isSelected:(CGPoint)point{
    self.isSelected = NO;
    return NO;
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - ACEDrawingRectangleTool

@interface ACEDrawingRectangleTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingRectangleTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize tag=_tag;
@synthesize isSelected = _isSelected;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the rectangle
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);    
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);        
    }
}

-(BOOL) isSelected:(CGPoint)point{
    self.isSelected = NO;
    return NO;
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif

@end

#pragma mark - ACEDrawingEllipseTool

@interface ACEDrawingEllipseTool ()
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@end

#pragma mark -

@implementation ACEDrawingEllipseTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize tag=_tag;
@synthesize isSelected = _isSelected;

- (void)setInitialPoint:(CGPoint)firstPoint
{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    self.lastPoint = endPoint;
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    
    // draw the ellipse
    CGRect rectToFill = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    if (self.fill) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
        
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(UIGraphicsGetCurrentContext(), rectToFill);
    }
}

-(BOOL) isSelected:(CGPoint)point{
    self.isSelected = NO;
    return NO;
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    [super dealloc];
}

#endif
@end

#pragma mark - ACEDrawingTextTool
@interface ACEDrawingTextTool ()

@property (nonatomic, assign) CGPoint firstPoint;


@end

@implementation ACEDrawingTextTool

@synthesize lineColor = _lineColor;
@synthesize lineAlpha = _lineAlpha;
@synthesize lineWidth = _lineWidth;
@synthesize tag = _tag;
@synthesize isSelected = _isSelected;

-(id) init{
    
    self = [super init];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:14 ];
        self.width = 100;
        self.orientation = 1;
        self.hasbackground = YES;
        self.isSelected = NO;
    }
    
    return self;
    
}

- (void)setInitialPoint:(CGPoint)firstPoint{
    self.firstPoint = firstPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    
    float xOffset = endPoint.x - startPoint.x;
    float yOffset = endPoint.y - startPoint.y;
    
    self.firstPoint = CGPointMake(self.firstPoint.x + xOffset, self.firstPoint.y+ yOffset);
    
    CGSize maxContentSize = CGSizeMake(self.width, INFINITY);
    
    self.size = [self.text sizeWithFont:self.font
                      constrainedToSize:maxContentSize
                            lineBreakMode:NSLineBreakByCharWrapping];
    
    
}

- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
   
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (self.hasbackground) {
        //画矩形
        
        float ox = self.firstPoint.x;
        float oy = self.firstPoint.y;
        float rw = self.size.width;
        float rh = self.size.height;
        float r = 5;
        int Orientation = self.orientation;
        
        CGPathMoveToPoint(path,NULL,ox,oy+r);
        
        CGPathAddArcToPoint(path,NULL,ox,oy+rh,ox+r,oy+rh,r);
        
        CGPathAddArcToPoint(path ,NULL ,ox+rw ,oy+rh ,ox+rw ,oy+rh-r ,r);
        
        CGPathAddArcToPoint(path ,NULL ,ox+rw ,oy ,ox+rw-r ,oy ,r);
        
        CGPathAddArcToPoint(path ,NULL ,ox, oy ,ox,oy+r,r);
        
        
        
        //画箭头
        
        switch (Orientation) {
                
            case 0:
                
                CGPathMoveToPoint(path ,NULL,ox+r+10.0, oy+rh);
                
                CGPathAddLineToPoint(path ,NULL ,ox+r+10.0, oy+rh+20);
                
                CGPathAddLineToPoint(path, NULL ,ox+r+30.0 ,oy+rh);
                
                break;
                
            case 1:
                
                CGPathMoveToPoint(path ,NULL,ox+rw-r-10.0 ,oy+rh);
                
                CGPathAddLineToPoint(path ,NULL ,ox+rw-r-10.0 ,oy+rh+20);
                
                CGPathAddLineToPoint(path, NULL ,ox+rw-r-30.0 ,oy+rh);
                
                break;
                
            case 2:
                
                CGPathMoveToPoint(path, NULL,ox+rw, oy+rh-r-10);
                
                CGPathAddLineToPoint(path ,NULL, ox+rw+20, oy+rh-r-10);
                
                CGPathAddLineToPoint(path, NULL ,ox+rw ,oy+rh-r-30);
                
                break;
                
            case 3:
                
                CGPathMoveToPoint(path ,NULL,ox+rw ,oy+r+10);
                
                CGPathAddLineToPoint(path ,NULL ,ox+rw+20 ,oy+r+10);
                
                CGPathAddLineToPoint(path, NULL ,ox+rw ,oy+r+30);
                
                break;
                
            case 4:
                
                CGPathMoveToPoint(path ,NULL,ox+rw-r-10.0 ,oy);
                
                CGPathAddLineToPoint(path, NULL ,ox+rw-r-10.0 ,oy-20);
                
                CGPathAddLineToPoint(path ,NULL ,ox+rw-r-30.0 ,oy);
                
                break;
                
            case 5:
                
                CGPathMoveToPoint(path ,NULL,ox+r+10.0, oy);
                
                CGPathAddLineToPoint(path ,NULL ,ox+r+10.0 ,oy-20);
                
                CGPathAddLineToPoint(path ,NULL, ox+r+30.0 ,oy);
                
                break;
                
            case 6:
                
                CGPathMoveToPoint(path, NULL,ox ,oy+r+10);
                
                CGPathAddLineToPoint(path ,NULL, ox-20, oy+r+10);
                
                CGPathAddLineToPoint(path, NULL, ox, oy+r+30);
                
                break;
                
            case 7:
                
                CGPathMoveToPoint(path, NULL,ox ,oy+rh-r-10);
                
                CGPathAddLineToPoint(path ,NULL, ox-20 ,oy+rh-r-10);
                
                CGPathAddLineToPoint(path, NULL, ox, oy+rh-r-30);
                
                break;
                
            default:
                
                break;
                
        }
        
        
        
        
        
        //描边 以及添加阴影效果
        
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGFloat zStrokeColour[4]    = {180.0/255 ,180.0/255.0 ,180.0/255.0 ,0.7};
        
        CGContextSetLineWidth(context, 3.0);
        
        CGContextAddPath(context,path);
        
        CGContextSetStrokeColorSpace(context, CGColorSpaceCreateDeviceRGB());
        
        CGContextSetStrokeColor(context, zStrokeColour);
        
        CGContextStrokePath(context);
        
        
        
        CGSize myShadowOffset = CGSizeMake (0 ,0);
        
        CGContextSaveGState(context);
        
        
        
        CGContextSetShadow (context, myShadowOffset ,5);
        
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGFloat zStrokeColour1[4]    = {228.0/255 ,168.0/255.0 ,81.0/255.0 ,0.7};
        
        CGContextSetLineWidth(context ,3.0);
        
        CGContextAddPath(context,path);
        
        CGContextSetStrokeColorSpace(context, CGColorSpaceCreateDeviceRGB());
        
        CGContextSetStrokeColor(context, zStrokeColour1);
        
        CGContextStrokePath(context);
        
        
        
        CGContextRestoreGState(context);
        
        
        
        //填充矩形内部颜色
        
        CGContextAddPath(context,path);
        
        CGContextSetFillColorSpace(context,CGColorSpaceCreateDeviceRGB());
        
        CGFloat zFillColour1[4]    = {229.0/255 ,229.0/255.0 ,231.0/255.0 ,0.7};
        
        CGContextSetFillColor(context, zFillColour1);
        
        CGContextEOFillPath(context);
        
        
        
    }
    
    
    
    //画文字
    // set the properties
    CGContextSetAlpha(context, self.lineAlpha);
    if (self.text!=nil) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        
        
        
        [self.text drawInRect:CGRectMake(self.firstPoint.x, self.firstPoint.y, self.size.width , self.size.height)
                     withFont:self.font
                lineBreakMode:NSLineBreakByCharWrapping];
        
        
        //画选中框
        if (self.isSelected) {
            
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextSetLineWidth(context, 1);
            CGRect rectToFill = CGRectMake(self.firstPoint.x -2, self.firstPoint.y -2, self.size.width+2, self.size.height+2);
            CGContextStrokeRect(UIGraphicsGetCurrentContext(), rectToFill);
        }
        
        /*
        [self.text drawAtPoint:self.firstPoint
                      forWidth:200.0f
                      withFont:[UIFont systemFontOfSize:14 ]
                      fontSize:14
                 lineBreakMode:NSLineBreakByCharWrapping
            baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
         */
    }
    
}

-(BOOL) isSelected:(CGPoint)point{
    
    CGRect rect = CGRectMake(self.firstPoint.x, self.firstPoint.y, self.size.width, self.size.height);
    
    self.isSelected =CGRectContainsPoint(rect, point);
    
    return self.isSelected;
}


#if !ACE_HAS_ARC

- (void)dealloc
{
    self.lineColor = nil;
    self.text = nil;
    self.font = nil;
    [super dealloc];
}

#endif

@end



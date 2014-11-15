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

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0

@interface ACEDrawingView ()
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<ACEDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@end

#pragma mark -

@implementation ACEDrawingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    // init the private arrays
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
#endif
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


-(id<ACEDrawingTool>) selectedTools:(CGPoint) point{
    
    id<ACEDrawingTool> toolSelected = nil;
    
    for (id<ACEDrawingTool> too in self.pathArray) {
        
        if ([too isSelected:point ]) {
            toolSelected = too;
        }
        
    }
    
    
    return toolSelected;
    
}

- (id<ACEDrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool) {
        case ACEDrawingToolTypePen:
        {
            return ACE_AUTORELEASE([ACEDrawingPenTool new]);
        }
            
        case ACEDrawingToolTypeCure:
        {
            return ACE_AUTORELEASE([ACEDrawingCureTool new]);
        }
            
        case ACEDrawingToolTypeLine:
        {
            return ACE_AUTORELEASE([ACEDrawingLineTool new]);
        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTextTool:
        {
            ACEDrawingTextTool *tool =ACE_AUTORELEASE([ACEDrawingTextTool new]);
            tool.text = self.tooltext;
            return tool;
        }
    }
}


-(void) addTextTools:(NSString*) text At:(CGPoint) firstPoint{
    
    ACEDrawingTextTool *tool =ACE_AUTORELEASE([ACEDrawingTextTool new]);
    tool.text = self.tooltext;
    
    self.currentTool = tool;
    
    self.currentTool.lineWidth = self.lineWidth;
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineAlpha = self.lineAlpha;
    [self.pathArray addObject:self.currentTool];
    
    [self.currentTool setInitialPoint:firstPoint];
    [self.currentTool moveFromPoint:firstPoint toPoint:firstPoint];
    
    [self updateCacheImage:YES];
    
    self.currentTool = nil;
    
    [self setNeedsDisplay];
}


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    CGPoint firstPoint = [touch locationInView:self];
    
    self.currentTool = [self selectedTools:firstPoint];
    
    
    
    if (self.currentTool == nil) {
        // init the bezier path
        self.currentTool = [self toolWithCurrentSettings];
        self.currentTool.lineWidth = self.lineWidth;
        self.currentTool.lineColor = self.lineColor;
        self.currentTool.lineAlpha = self.lineAlpha;
        [self.pathArray addObject:self.currentTool];
        
        [self.currentTool setInitialPoint:firstPoint];

    }else{
        [self.pathArray removeObject:self.currentTool];
        
        [self updateCacheImage:YES];
        
        [self.pathArray addObject:self.currentTool];
    }
    
    
    
    
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    // add the current point to the path
    CGPoint currentLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    [self.currentTool moveFromPoint:previousLocation toPoint:currentLocation];
    
    
    /*
    if(self.currentTool.isSelected) {
        [self updateCacheImage:YES];
    }
     */
    
    
#if PARTIAL_REDRAW
    // calculate the dirty rect
    CGFloat minX = fmin(previousLocation.x, currentLocation.x) - self.lineWidth * 0.5;
    CGFloat minY = fmin(previousLocation.y, currentLocation.y) - self.lineWidth * 0.5;
    CGFloat maxX = fmax(previousLocation.x, currentLocation.x) + self.lineWidth * 0.5;
    CGFloat maxY = fmax(previousLocation.y, currentLocation.y) + self.lineWidth * 0.5;
    [self setNeedsDisplayInRect:CGRectMake(minX, minY, (maxX - minX), (maxY - minY))];
#else
    [self setNeedsDisplay];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    
    
    self.currentTool.isSelected = NO;
    
    // update the image
    if(self.currentTool.isSelected) {
        [self updateCacheImage:YES];
    }else{
        [self updateCacheImage:NO];
    }
    
    
    // clear the current tool
    self.currentTool = nil;
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}


#pragma mark - Actions

- (void)clear
{
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        id<ACEDrawingTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        id<ACEDrawingTool>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    [super dealloc];
}

#endif
-(void) qieTu:(CGRect)rect {
    
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    //UIGraphicsBeginImageContext(self.bounds.size);
    
    
    
    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //CGImageRef imager = CGImageCreateWithImageInRect(viewImage.CGImage, rect);
    
    self.ima = viewImage;//[UIImage imageWithCGImage:imager];
    
}
-(void) save {
    UIImageWriteToSavedPhotosAlbum(_ima, nil, nil, nil);
}
//保存图片
-(void) savePicture:(NSString*)fileName andsavefile:(NSString *)realfilename {
    if (self.ima!=nil) {
        //找document路径
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Maindata"];
        
        NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
        //存放图片的文件夹
        NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
        BOOL result = [UIImagePNGRepresentation(self.ima) writeToFile:realPath atomically:YES];
        if (result) {
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"图片保存成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //[alert show];
            //[alert release];
        }
    }else {
        //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"图片保存失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[alert show];
        //[alert release];
    }
    
}
-(void)saveFile:(NSString*)fileName Data:(NSData *)data andsavefile:(NSString *)realfilename{
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"];
    
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:realPath atomically:YES];
    NSLog(@"%@",desPath);
}



@end

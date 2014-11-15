//
//  HKSignatureView.m
//  HisGuidline
//
//  Created by kimi on 13-10-20.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKSignatureView.h"




@interface HKSignatureView() {
    CGContextRef imgcontext;
}

@end

@implementation HKSignatureView

CGPoint oldlocation;
CGPoint newlocation;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        imgcontext = CGBitmapContextCreate(nil,frame.size.width,frame.size.height,8,0,
                                                     colorSpace,kCGImageAlphaPremultipliedLast);
        CFRelease(colorSpace);
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);

    
    CGImageRef imgRef = CGBitmapContextCreateImage(imgcontext);
    
    CGContextDrawImage(context, self.frame, imgRef);
    
    CGImageRelease(imgRef);
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    
    NSLog(@"%0.0f,%0.0f --- %0.0f,%0.0f",oldlocation.x,oldlocation.y,newlocation.x,newlocation.y);
    
    
    // Drawing Rect
    //[[UIColor redColor] setFill];　　　　　　　　　　　　　  // red
    //[[UIColor redColor] setFill];
    //UIRectFill(CGRectInset(self.bounds, 100, 100));

    
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    
    oldlocation = location;
    
}



//是指触摸移动时，调touchesMoved

#define ZOOM_IN_TOUCH_SPACING_RATIO       (0.75)
#define ZOOM_OUT_TOUCH_SPACING_RATIO      (1.5)

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    //获取当前touch的点
    CGPoint location = [touch locationInView:self];
    
    
    if (abs( location.x-oldlocation.x)>5 || abs(location.y-oldlocation.y)>5) {
        newlocation = location;
        
        CGContextSetRGBStrokeColor(imgcontext, 1, 0, 0, 1);
        CGContextSetRGBFillColor(imgcontext, 1, 0, 0, 1);
        
        CGContextMoveToPoint(imgcontext, oldlocation.x , oldlocation.y);
        CGContextAddLineToPoint(imgcontext, newlocation.x,newlocation.y);
        
        CGContextClosePath(imgcontext);
        CGContextStrokePath(imgcontext);
        
        [self setNeedsDisplay];
        
        oldlocation = location;
    }
    
    
    
}



//结束时调用touchesEnded

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}
-(void) qieTu:(CGRect)rect {
    UIGraphicsBeginImageContext(self.superview.bounds.size);
    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imager = CGImageCreateWithImageInRect(viewImage.CGImage, rect);
    self.ima = [UIImage imageWithCGImage:imager];

}
-(void) save {
     UIImageWriteToSavedPhotosAlbum(_ima, nil, nil, nil);
}
//保存图片
-(void) savePicture:(NSString*)fileName andsavefile:(NSString *)realfilename {
    if (self.ima!=nil) {
        //找document路径
        NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
        
        NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
        //存放图片的文件夹
        NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
        BOOL result = [UIImagePNGRepresentation(self.ima) writeToFile:realPath atomically:YES];
        if (result) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"图片保存成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"图片保存失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}
-(void)saveFile:(NSString*)fileName Data:(NSData *)data andsavefile:(NSString *)realfilename{
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    
    NSString * desPath = [docPath stringByAppendingPathComponent:fileName] ;
    //存放图片的文件夹
    NSString *realPath =[desPath stringByAppendingPathComponent:realfilename];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
    [data writeToFile:realPath atomically:YES];
    NSLog(@"%@",desPath);
}
//读取图片


//删除图片






@end

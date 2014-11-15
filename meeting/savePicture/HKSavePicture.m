//
//  HKSavePicture.m
//  HisGuidline
//
//  Created by cuiyang on 14-1-21.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKSavePicture.h"

@implementation HKSavePicture
//从网络下载图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

//将所下载的图片保存到本地
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        
//        NSString* fullPaht = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
//        
//        NSData* data = UIImagePNGRepresentation(image);
//        
//        NSError* error;
//        [data writeToFile:fullPaht options:NSDataWritingAtomic
//                    error:&error];
//        
//        NSLog(@"%@",error);
        
        
       //[ writeToFile:fullPaht atomically:YES];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

//读取本地保存的图片
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}

//从网络下载图片，保存，并用 UIImageView 从保存中显示
//NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//NSLog(@"保存路径:%@",documentsDirectoryPath);
////Get Image From URL
//UIImage * imageFromURL = [self getImageFromURL:@"http://file.duteba.com/phone/2009/04/5/ftGxL8kcUL.jpg"];
//
////Save Image to Directory
//[self saveImage:imageFromURL withFileName:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
//
////Load Image From Directory
//UIImage * imageFromWeb = [self loadImage:@"MyImage" ofType:@"jpg" inDirectory:documentsDirectoryPath];
//[img setImage:imageFromWeb];
//
////取得目录下所有文件名
//NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:documentsDirectoryPath];
////NSLog(@"%d",[file count]);
//NSLog(@"%@",file);
@end

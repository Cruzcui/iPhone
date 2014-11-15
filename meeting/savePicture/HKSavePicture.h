//
//  HKSavePicture.h
//  HisGuidline
//
//  Created by cuiyang on 14-1-21.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSavePicture : NSObject
-(UIImage *) getImageFromURL:(NSString *)fileURL;
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath; 
@end

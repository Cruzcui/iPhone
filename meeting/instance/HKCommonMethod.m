//
//  HKCommonMethod.m
//  HisGuidline
//
//  Created by cuiyang on 14-3-4.
//  Copyright (c) 2014年 yyhtec. All rights reserved.
//

#import "HKCommonMethod.h"

@implementation HKCommonMethod
+(void) removeFile:(NSString *)fileName andZhinanName:(NSString *)ZhiNanName {

       NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"Maindata"] ;
    NSString * desPath = [documentsDirectory stringByAppendingPathComponent:ZhiNanName] ;
    //NSArray *contents = [fileManager contentsOfDirectoryAtPath:desPath error:NULL];
     [fileManager removeItemAtPath:fileName error:NULL];
//    NSEnumerator *e = [contents objectEnumerator];
//    NSString *filenames;
//    while ((filenames = [e nextObject])) {
//
//        if ([filenames  isEqualToString:fileName]) {
//
//            [fileManager removeItemAtPath:[desPath stringByAppendingPathComponent:filenames] error:NULL];
//        }
//    }
}

@end

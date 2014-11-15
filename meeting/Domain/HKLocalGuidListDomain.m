//
//  HKLocalGuidListDomain.m
//  HisGuidline
//
//  Created by kimi on 13-9-25.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import "HKLocalGuidListDomain.h"
#import "HHLocalDomainBase.h"
#import "MeetingConst.h"
#import "HHDomainBase.h"

@interface HKLocalGuidListDomain()

@property (nonatomic,retain) HHLocalDomainBase* jsonDomain;

@end

@implementation HKLocalGuidListDomain

@synthesize jsonDomain;

-(id) init{
    self = [super init];
    if (self) {
        self.jsonDomain = [[[HHLocalDomainBase alloc] init] autorelease];
    }
    
    return self;
}

-(void) dealloc{
    self.jsonDomain = nil;
    [super dealloc];
}



-(NSArray*) getGuidList:(NSString *)path{
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSArray* dirs = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:dirs.count];
    
    for (NSString* file in dirs) {
        NSString* indexPath =  [NSString stringWithFormat:@"%@/%@",path,[file stringByAppendingString:@"/index.json"] ];
        
        
        //创建文件内容字典
        NSMutableDictionary* fileData = [NSMutableDictionary dictionaryWithCapacity:2];
        [result addObject:fileData];
        
        
        //读取&设置指南信息
        if ([fileManager fileExistsAtPath:indexPath]) {
            NSDictionary* jsonData = [self.jsonDomain requestData:indexPath];
            
            NSLog(@"indexPath:%@",indexPath);
            
            //指南名称
            [fileData setObject:[NSString stringWithFormat:@"%@/%@",path,file] forKey:Json_GuidFolder ];
            
            //指南数据
            [fileData setObject:jsonData forKey:Json_GuidData];
        }
        
        
    }

    
    return result;
    
    
}

@end

//
//  HKPostTableViewAdapter.h
//  meeting
//
//  Created by kimi on 13-8-15.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HHCustomEditCell;

@protocol HKPostTableViewAdapterDelegate <NSObject>

@required
-(void) doButtonClick:(HHCustomEditCell*) cell;

@end


@interface HKPostTableViewAdapter : NSObject<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,assign) id<HKPostTableViewAdapterDelegate> delegate;

-(id) initWithFile:(NSString*) profile PostURL:(NSString*) url;

-(NSMutableDictionary*) getInputData;

@end

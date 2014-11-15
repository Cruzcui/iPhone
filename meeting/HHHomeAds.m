//
//  HHHomeAdsDetails.m
//  DalianPort
//
//  Created by mac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HHHomeAds.h"
#import "HKHeader.h"

@implementation HHHomeAds





-(void) requestData:(NSDictionary *) nsDictParams{
    
        
    // Call Bass Function
    [self.requestManager postDataWithURL:URLHomeAD
                    Datas:nsDictParams];
    
}

-(void) parsDataWithDictionary:(NSDictionary *)datas{
    
   
    
    // Get Status Property
    if ([datas objectForKey:JsonHead_status])
        self.status = [(NSString*)[datas objectForKey:JsonHead_status] intValue];
    
    // Get ResultMsg Property
    self.resultMessage = (NSString*)[datas stringForKey:JsonHead_resultMsg];
    
    // Get data Property
    if ([datas arrayForKey:JsonHead_data] == nil || [[datas arrayForKey:JsonHead_data] count] < 1) {
        self.dataDetails = [datas arrayForKey:JsonHead_dataList];

    } else
        self.dataDetails = [datas arrayForKey:JsonHead_data];
}

@end


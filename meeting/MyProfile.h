//
//  MyProfile.h
//  DalianPort
//
//  Created by 翔 张 on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#define Fav_Type_MedGuid @"Fav_Type_MedGuid"
#define Fav_Type_PPT @"Fav_Type_PPT"
#define Fav_Type_Video @"Fav_Type_Video"
#define Fav_Type_Cal @"Fav_Type_Cal"
#define Fav_Type_Tool @"Fav_Type_Tool"



#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface MyProfile : NSObject<CLLocationManagerDelegate,MKReverseGeocoderDelegate>



@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,copy) NSString* cityName;
@property (nonatomic,copy) NSString* urlCityName;

@property (nonatomic,copy) NSString* currentUser;
@property (nonatomic,retain) NSDictionary * userInfo;
@property (nonatomic,retain) NSDictionary * SystemInfo;
//@property (nonatomic,assign) MMDrawerController * drawerController;

+(id) myProfile;


-(void) startUpdateLocation;


//保存收藏
-(void) saveFavFor:(NSString*) favType data:(NSDictionary*) data key:(NSString*) key;

//得到某个key已经收藏的索引，若果为-1表示未收藏
-(int) indexOfFaved:(NSString*) favType key:(NSString*) key;

//得到收藏列表
-(NSArray*) getFavList:(NSString*) favType;

-(void) deleteFavFor:(NSString*) favType key:(NSString*) key;

@end


@interface NSDictionary (StringConvert)

-(NSString*) stringForKey:(id) key;

-(NSNumber*) numberForKey:(id) key;

-(NSArray*) arrayForKey:(id) key;

-(NSDictionary*) dictionaryForKey:(id) key;

-(NSDate*) dateForKey:(id)key;

-(NSString*) formatDateForKey:(id)key;

-(NSString*) formatShortDateForKey:(id)key;

-(NSString*) urlStringForKey:(id) key;

@end

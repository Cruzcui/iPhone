//
//  MyProfile.m
//  DalianPort
//
//  Created by 翔 张 on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyProfile.h"
#import "HHDomainBase.h"


static MyProfile* _myProfile = nil;


@interface MyProfile(){
    MKReverseGeocoder* reverseCoordinateInfo;
}

@property (nonatomic,retain) NSMutableDictionary* favDictData;

@end

@implementation MyProfile

@synthesize locationManager;
@synthesize cityName;
@synthesize urlCityName;
@synthesize currentUser;

+(id) myProfile{
    
    @synchronized(self){
        
        if (_myProfile==nil) {
            
            _myProfile = [[MyProfile alloc] init];
            
        }
        return _myProfile;
    }
    
}

-(id) init{
    self = [super init];
    if (self) {
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        self.cityName = @"";
        self.urlCityName = @"NA";
        self.favDictData = [NSMutableDictionary dictionary];
        
        reverseCoordinateInfo = nil;
        
        return self;
    }
    
    return nil;
}

-(void) startUpdateLocation{
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    
    [locationManager stopUpdatingLocation];
    
    CLLocation *curPos = newLocation;
    
    NSString *latitude = [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue]; 
    
    NSString *longitude = [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
    
    self.cityName = [latitude stringByAppendingFormat:@", %@",longitude];
    self.urlCityName = self.cityName;
    
    if(reverseCoordinateInfo){
        [reverseCoordinateInfo release];
    }
    
    reverseCoordinateInfo = [[MKReverseGeocoder alloc] initWithCoordinate:curPos.coordinate];
    [reverseCoordinateInfo setDelegate:self];
    [reverseCoordinateInfo  start];
    
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    self.cityName = [placemark locality];
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self.cityName,
                                                                           NULL,
                                                                           CFSTR("!*'();@&=+$,?%#[]"),
                                                                           kCFStringEncodingUTF8);
    self.urlCityName = result;
    [result autorelease];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    
}



#pragma mark 收藏代码

//得到保存关注列表的文件名
-(NSString*) favFileName:(NSString*) favType{
    
    //找document路径
    NSString *docPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"FavSection"] ;
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    if (![filemanage fileExistsAtPath:docPath]) {
        
        [filemanage createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * desPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",favType]] ;
    
    return desPath;
}

//保存到文件
-(void) saveToFile:(NSString*) favType{
    NSMutableArray* favArray = [self.favDictData objectForKey:favType];
    
    NSString* jsonStr = [favArray toJson];
    
    
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString* fileName = [self favFileName:favType];
    [jsonData writeToFile:fileName atomically:NO];
    
}

//从文件中加载关注列表
-(NSMutableArray*) loadFavFromFile:(NSString*) favType{
    NSString* fileName = [self favFileName:favType];
    
    NSFileManager *filemanage = [NSFileManager defaultManager];
    if (![filemanage fileExistsAtPath:fileName]) {
        return nil;
    }else{
        NSData * dataInfile = [[NSData alloc] initWithContentsOfFile:fileName];
        
        NSArray* arr = [NSArray fromData:dataInfile];
        
        return [NSMutableArray arrayWithArray:arr];
        
    }
    
}



-(void) saveFavFor:(NSString *)favType data:(NSDictionary *)data key:(NSString *)key{
    
    
    //从变量里面取出收藏列表
    NSMutableArray* favArray = [self.favDictData objectForKey:favType];
    
    if (favArray == nil) {
        favArray = [self loadFavFromFile:Fav_Type_MedGuid];
        
        if (favArray == nil) {
            favArray = [NSMutableArray array];
        }
    }
    
    //判断是否已经被收藏
    int index = [self indexOfFaved:favType key:key];
    if (index>=0) {
        [favArray removeObjectAtIndex:index];
    }
    
    //保存收藏到数组中
    NSMutableDictionary* favData = [NSMutableDictionary dictionary];
    
    [favData setObject:key forKey:@"key"];
    [favData setObject:data forKey:@"data"];
    
    [favArray addObject:favData];
    
    [self.favDictData setObject:favArray forKey:favType];
    
    //保存到文件中
    [self saveToFile:favType];
    
    
}



-(int) indexOfFaved:(NSString *)favType key:(NSString *)key{
    NSMutableArray* favArray = [self.favDictData objectForKey:favType];
    
    if (favArray == nil) {
        favArray = [self loadFavFromFile:Fav_Type_MedGuid];
        
        if (favArray == nil) {
            favArray = [NSMutableArray array];
        }
        
        [self.favDictData setObject:favArray forKey:favType];

    }
    
    int index = -1;
    
    int result = 0;
    for (NSMutableDictionary* dict in favArray) {
        
        if ([[dict stringForKey:@"key"] isEqualToString:key]) {
            return result;
        }
        result++;
    }
    
    return index;
    
}


-(NSArray*) getFavList:(NSString *)favType{
    
    NSMutableArray* favArray = [self.favDictData objectForKey:favType];
    
    if (favArray == nil) {
        favArray = [self loadFavFromFile:favType];
        
        if (favArray==nil) {
            favArray = [NSMutableArray array];
        }
        
        
        [self.favDictData setObject:favArray forKey:favType];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSMutableDictionary* dict in favArray) {
        
        [result addObject:[dict objectForKey:@"data"]];
        
    }
    
    return result;
    
}

-(void) deleteFavFor:(NSString *)favType key:(NSString*) key{
    
    int index = [self indexOfFaved:favType key:key];
    
    if (index>=0) {
        NSMutableArray* favArray = [self.favDictData objectForKey:favType];
        
        [favArray removeObjectAtIndex:index];
        
        [self.favDictData setObject:favArray forKey:favType];
        
        [self saveToFile:favType];
    }
    
}



@end


@implementation NSDictionary (StringConvert)

-(NSString*) stringForKey:(id) key{
    
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return @"";
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }else {
        return @"";
    }
}

-(NSNumber*) numberForKey:(id) key{
    
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSNumber numberWithInt:0];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)obj;
    }else {
        return [NSNumber numberWithInt:0];
    }
}

-(NSArray*) arrayForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableArray arrayWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray*)obj;
    }else {
        return [NSMutableArray arrayWithCapacity:5];
    }
}

-(NSDictionary*) dictionaryForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)obj;
    }else {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
}
-(NSDate*) dateForKey:(id)key{
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    return date;
}

-(NSString*) formatDateForKey:(id)key{
    
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSString*) formatShortDateForKey:(id)key{
    
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
    
}
-(NSString*) urlStringForKey:(id)key{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)[self stringForKey:key],
                                                                           NULL,
                                                                           CFSTR("!*'();@&=+$,?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

@end

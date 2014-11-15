//
//  MeetingConst.h
//  meeting
//
//  Created by kimi on 13-6-25.
//  Copyright (c) 2013年 yyhtec. All rights reserved.
//

#ifndef meeting_MeetingConst_h
#define meeting_MeetingConst_h


#define TAB_Meeting  0
#define TAB_Survey  1
#define TAB_Project_Common  2
#define TAB_Project_ICU 3

#pragma mark Http request URL

#define Notifaction_Change_Section @"Notifaction_Change_Section"
#define Notifaction_DidChange_Section @"Notifaction_DidChange_Section"

#define URL_CheckVersion @"http://itunes.apple.com/lookup"
#define URL_Login @"http://121.199.26.12:8080/mguid/user/phone/login.do"
#define URL_URL_REGIST @"http://121.199.26.12:8080/mguid/user/phone/register.do"
#define URL_GuidlineList @"http://121.199.26.12:8080/mapserver/filemanager.jsp"
#define URL_getPassBack @"http://121.199.26.12:8080/mguid/user/phone/getpass.do"
#pragma mark JSON
#define JsonHead_data @"data"
#define JsonHead_dataList @"dataList"


#define Json_GuidFolder @"guidFolder"
#define Json_GuidName @"guidname"
#define Json_GuidData @"guidData"

#define Json_Guid_Name @"guidname"
#define Json_Guid_Author @"writer"
#define Json_Guid_Time @"publicTM"
#define Json_Guid_Section @"sections"

#define Json_guid_Section_Name @"sectionName"
#define Json_Guid_Section_Child @"childSection"
#define Json_Section_URL @"sectionUrl"


#define Json_Test_Title @"testTtile"
#define Json_Test_Questions @"questions"
#define Json_Test_Questions_Title @"question"
#define Json_Test_Questions_Answers @"answers"
#define Json_Test_Answer_Title @"answerTitle"
#define Json_Test_CorrectAnswerId @"correctAnswerId"
#define Json_Test_AnswerId @"answerId"


#define Json_Explain_Name @"explainName"
#define Json_Explain_CreateTM @"publicTM"
#define Json_Explain_PPTS @"PPTs"
#define Json_Explain_Videos @"videos"
#define Json_Explain_Topics @"topics"
#define Json_Explain_PPT_Name @"pptName"
#define Json_Explain_Video_Name @"videoName"
#define Json_Explan_Topic_Subject @"topicSubject"
#define Json_Explain_PPTS_pptUrls @"pptUrls"

#define EachReturnDataRowsNum 10


static inline NSString * getDateAndWeekString(NSDate* curDate){
    
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:curDate];
    int weekday = [componets weekday];
    
    NSString *strWeek = @"";
    
    switch (weekday) {
        case 1:
            strWeek = @"周日";
            break;
        case 2:
            strWeek = @"周一";
            break;
        case 3:
            strWeek = @"周二";
            break;
        case 4:
            strWeek = @"周三";
            break;
        case 5:
            strWeek = @"周四";
            break;
        case 6:
            strWeek = @"周五";
            break;
        case 7:
            strWeek = @"周六";
            break;
        default:
            break;
    }
    
    
    return [NSString stringWithFormat:@"%@ %@", currentDateStr,strWeek];
    
}

static inline NSString * getDateTicker(NSDate * curDate, Boolean isZero){
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //    //NSTimeZone* localzone = [NSTimeZone localTimeZone];
    //    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    //
    //    [dateFormatter setTimeZone:GTMzone];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];
    
    if (isZero){
        currentDateStr = [NSString stringWithFormat:@"%@ 00:00:00.000",currentDateStr];
    }
    else {
        currentDateStr = [NSString stringWithFormat:@"%@ 23:59:59.999",currentDateStr];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSDate *resultDate = [dateFormatter dateFromString:currentDateStr];
    
    long long intInVa = [resultDate timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%llu",intInVa];
    
}

static inline NSDate * getDataAddDay(NSInteger addDate){
    
    NSDate *curDate = [[NSDate alloc] init];
    
    NSCalendar *gregorian = [[[NSCalendar alloc]
                              initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    NSDateComponents* dc1 = [[[NSDateComponents alloc] init] autorelease];
    [dc1 setDay:addDate];
    
    NSDate *resultDate = [gregorian dateByAddingComponents:dc1 toDate:curDate options:0];
    
    return resultDate;
}

static inline int getWordsLines(NSString * txtWords,float txtWidth,UIFont * txtFont)
{
    CGSize maxContentSize = CGSizeMake(txtWidth, INFINITY);
    
    CGSize lineHeight = [txtWords sizeWithFont:txtFont];
    
    CGSize contentSize = [txtWords sizeWithFont:txtFont
                              constrainedToSize:maxContentSize
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    return contentSize.height/lineHeight.height;
}

static inline float getWordsHeight(NSString * txtWords,float txtWidth,UIFont * txtFont)
{
    CGSize maxContentSize = CGSizeMake(txtWidth, INFINITY);
    
    //CGSize lineHeight = [txtWords sizeWithFont:txtFont];
    
    CGSize contentSize = [txtWords sizeWithFont:txtFont
                              constrainedToSize:maxContentSize
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    return contentSize.height;
}



//判断系统
static BOOL OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}


//颜色定义

#define Color_tabbar_background 0x202328
#define Color_light_gray 0x999999
#define Color_NavBarBackColor 0x0B79EC


///*!
// @discussion NavBar背景色
// */
//static int Color_NavBarBackColor1 = 0x1E64F0;

/*!
 @method getColorP(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result P / 255.0
 */
static inline float getColorP(int intColor){
    return 1.0 - ((intColor & 0xFF000000)>> 0x18) / 255.0f;
}

/*!
 @method getColorR(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result R / 255.0
 */
static inline float getColorR(int intColor){
    return ((intColor & 0x00FF0000) >> 0x10 ) / 255.0f;
}

/*!
 @method getColorG(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result G / 255.0
 */
static inline float getColorG(int intColor) {
    return ((intColor & 0x0000FF00) >> 0x08 ) / 255.0f;
}

/*!
 @method getColorB(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result B / 255.0
 */
static inline float getColorB(int intColor) {
    return (intColor & 0x000000FF) / 255.0f;
}


/*!
 @method getColorP(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result P / 255.0
 */
static inline UIColor* getUIColor(int intColor){
    
    return [UIColor colorWithRed:getColorR(intColor) green:getColorG(intColor) blue:getColorB(intColor) alpha:getColorP(intColor)];
}

static inline UIColor* getUIColorRGB(NSString* rgb){
    
    @try {
        return [UIColor whiteColor];
        
    }
    @catch (NSException *exception) {
        return [UIColor whiteColor];
    }
    @finally {
        return [UIColor whiteColor];
    }
    
    
}



#endif

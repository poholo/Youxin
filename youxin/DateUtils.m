//
//  DateUtils.m
//  youxin
//
//  Created by fei on 13-9-28.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils
#pragma mark - 处理当前年月得到月份 - 一个月多少天
+(int)getYear:(NSDate*)date{
    NSString *tmStr = [date description];
    
    NSString *currentYear = [tmStr substringToIndex:4];
    
    return [currentYear intValue];
}

+(int)getYearFromStr:(NSString*)datestr{
    return [[datestr substringToIndex:4] intValue];
}
+(int)getMonth:(NSDate*)date{
    NSString *tmStr = [date description];
    NSRange range = [tmStr rangeOfString:@"-"];
    NSString *tmMonth = [tmStr substringFromIndex:range.location+1];
    NSString *currentMonth = [tmMonth substringToIndex:2];
    
    return [currentMonth intValue];
    
    
}

+(int)getMothFromStr:(NSString*)datestr{

    
    NSRange range = [datestr rangeOfString:@"-"];
    NSString *tmMonth = [datestr substringFromIndex:range.location+1];
    NSString *currentMonth = [tmMonth substringToIndex:2];
    
    return [currentMonth intValue];
}

+(int)getDaysOfMonth:(int)month year:(int)year{
    if(year%4==0||(year%100==0&&year%4==0)){
        return [[RUN_ARR objectAtIndex:month-1] intValue];
    }
    else{
        return [[UNRUN_ARR objectAtIndex:month-1] intValue];
    }
    
}
//2013-09-28
+(int)getDay:(NSDate *)date{
    NSString *tmStr = [date description];
        
    return [DateUtils getDayFromStr:tmStr];
}

+(int)getDayFromStr:(NSString*)datestr{
     NSRange range = NSMakeRange(8, 2);
    return [[datestr substringWithRange:range] intValue];
}


+(NSString*)convertDateToString:(NSDate *)date{
    NSString *str = [date description];
    
    return [str substringToIndex:10];
}



+(NSDate *)dateStartOfWeek:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}
+(NSDate*)covnertStrToDate:(NSString*)dateStr{
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:dateStr];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"fromdate=%@",fromDate);

    return fromDate;
}
@end

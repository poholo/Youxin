//
//  DateUtils.h
//  youxin
//
//  Created by fei on 13-9-28.
//  Copyright (c) 2013年 mjc. All rights reserved.
//


#define RUN_ARR [[NSArray alloc] initWithObjects:@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil]
#define UNRUN_ARR [[NSArray alloc] initWithObjects:@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31", nil]

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject
+(int)getYear:(NSDate*)date;
+(int)getYearFromStr:(NSString*)datestr;
+(int)getMonth:(NSDate*)date;
+(int)getMothFromStr:(NSString*)datestr;
+(int)getDaysOfMonth:(int)month year:(int)year;
+(int)getDay:(NSDate*)date;
+(int)getDayFromStr:(NSString*)datestr;



+(NSString*)convertDateToString:(NSDate*)date;
+(NSDate *)dateStartOfWeek:(NSDate *)date;
+(NSDate*)covnertStrToDate:(NSString*)dateStr;
@end

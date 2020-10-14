//
//  NSDate+ChatTimeFormat.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 11/4/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "NSDate+ChatTimeFormat.h"

@implementation NSDate (ChatTimeFormat)

+ (NSString *)relativeDateStringForDate:(NSTimeInterval)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24];
    NSDate * refDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString]) {
        return @"Today";
    }
    else if ([refDateString isEqualToString:yesterdayString]) {
        return @"Yesterday";
    }
    else {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        return [dateFormatter stringFromDate:refDate];
    }
}

@end

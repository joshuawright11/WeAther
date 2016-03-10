//
//  Utilities.m
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)timeString: (NSDate *)date {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";

    NSString *dateString = [timeFormatter stringFromDate: date];
    
    if([dateString characterAtIndex:0] == '0') {
        dateString = [dateString substringFromIndex:1];
    }
    
    return dateString;
}

@end

//
//  WeatherData.m
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

+ (id)fromJSON:(NSDictionary *)dict {
    
    WeatherData *data = [[WeatherData alloc] init];
    
    data.name = dict[@"name"];
    data.temperature = dict[@"main"][@"temp"];
    data.humidityPercentage = dict[@"main"][@"humidity"];
    data.windMPH = dict[@"wind"][@"speed"];
    data.generalDescription = dict[@"weather"][0][@"main"];
    
    data.sunrise = [NSDate dateWithTimeIntervalSince1970:[dict[@"sys"][@"sunrise"] integerValue]];;
    data.sunset = [NSDate dateWithTimeIntervalSince1970:[dict[@"sys"][@"sunset"] integerValue]];;
    
    data.searchTime = [[NSDate alloc] init];
    
    return data;
}

@end

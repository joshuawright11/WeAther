//
//  WeatherData.h
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

// General Data
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *humidityPercentage;
@property (nonatomic, strong) NSNumber *windMPH;
@property (nonatomic, strong) NSString *generalDescription;

// Sun Times
@property (nonatomic, strong) NSDate *sunset;
@property (nonatomic, strong) NSDate *sunrise;

// Search Data
@property (nonatomic, strong) NSDate *searchTime;

// Convenience Initializer
+ (id)fromJSON:(NSDictionary *)dict;

@end

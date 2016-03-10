//
//  WebManager.h
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WebManager : NSObject

+ (void)getWeatherDataForLocationString:(NSString *)string completion:(void (^)(WeatherData *weatherData, BOOL success))callback;

@end

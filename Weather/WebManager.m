//
//  WebManager.m
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import "WebManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation WebManager

typedef NS_ENUM(NSInteger, InputType) {
    Coordinates,
    Name,
    Zip,
    Invalid
};

static NSString *BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";
static NSString *API_KEY_PARAMETER = @"&APPID=ae79b6cc63f8961324d6a003c6febaeb";

+ (void)getWeatherDataForLocationString:(NSString *)input completion:(void (^)(WeatherData *weatherData, BOOL success))callback {
    
    InputType inputType = [WebManager checkInput:input];

    NSString *parameter;
    switch (inputType) {
        case Coordinates: {
            double lat = 1.0;
            double lon = 2.0;
            parameter = [NSString stringWithFormat:@"?lat=%f&lon=%f", lat, lon];
            break;
        }
        case Name:
            parameter = [NSString stringWithFormat:@"?q=%@", input];
            break;
        case Zip:
            parameter = [NSString stringWithFormat:@"?zip=%@,us", input];
            break;
        case Invalid:
            callback(nil, NO);
            return;
    }
    
    NSString *requestURL = [[BASE_URL stringByAppendingString:parameter] stringByAppendingString:API_KEY_PARAMETER];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {

             WeatherData *data = [WeatherData fromJSON:responseObject];
             callback(data, YES);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             callback(nil, NO);
         }
     ];
}

+ (InputType)checkInput:(NSString *)input {
    return Zip;
}

@end

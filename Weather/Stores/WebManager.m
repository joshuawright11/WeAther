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

// Simple enum to reflect the type of input
typedef NS_ENUM(NSInteger, InputType) {
    Coordinates,
    Name,
    Zip,
    Invalid
};

static NSString *BASE_URL = @"http://api.openweathermap.org/data/2.5/weather";

// The site needs an API key
static NSString *API_KEY_PARAMETER = @"&APPID=ae79b6cc63f8961324d6a003c6febaeb";

+ (void)getWeatherDataForLocationString:(NSString *)input completion:(void (^)(WeatherData *weatherData, BOOL success))callback {
    
    InputType inputType = [WebManager checkInput:input];

    NSString *parameter;
    switch (inputType) {
        // Not functional yet.
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
    
    // For spaces in the input
    NSString *encodedURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:encodedURL
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


// Check the input to see what kind of search should be performed (very basic)
+ (InputType)checkInput:(NSString *)input {
    
    // If there are no numbers assume that it is a place name
    if ([input rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
        return Name;
    // If there are numbers and it contains a ',' assume that it is a coordinate
    } else if ([input containsString:@","]){
        return Coordinates;
    // If it is 5 characters long (and contains a number) assume it's a zip
    } else if (input.length == 5){
        return Zip;
    // Otherwise assume invalid input
    } else {
        return Invalid;
    }
}

@end

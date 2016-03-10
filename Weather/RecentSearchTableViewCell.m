//
//  RecentSearchTableViewCell.m
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import "RecentSearchTableViewCell.h"
#import "Utilities.h"

@implementation RecentSearchTableViewCell

- (void)configureForWeatherData:(WeatherData *)data {
    self.dataLabel.text = [Utilities timeString:data.searchTime];
    self.titleLabel.text = data.name;
}

@end

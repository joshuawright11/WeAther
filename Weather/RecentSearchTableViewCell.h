//
//  RecentSearchTableViewCell.h
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@interface RecentSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

- (void)configureForWeatherData:(WeatherData *)data;

@end

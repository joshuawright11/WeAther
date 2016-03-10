//
//  ViewController.m
//  Weather
//
//  Created by Josh Wright on 3/9/16.
//  Copyright © 2016 WeDo. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "WebManager.h"
#import "Utilities.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipTextField;

@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIView *dataBackgroundView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dataTitleLabels;

@property (weak, nonatomic) IBOutlet UILabel *temperatureDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsDataLabel;

@property (weak, nonatomic) IBOutlet UIView *sunBackgroundView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sunDataTitleLabels;
@property (weak, nonatomic) IBOutlet UILabel *sunriseDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetDataLabel;

@property (weak, nonatomic) IBOutlet UITableView *recentsTableView;

@property (weak, nonatomic) WeatherData *currentData;

@end

@implementation ViewController

- (void)setCurrentData:(WeatherData *)currentData {
    _currentData = currentData;
    
    self.todayLabel.text = [@"Today in " stringByAppendingString:currentData.name];
    
    NSNumber *temperatureInF = @([currentData.temperature doubleValue]*(9.0/5.0) - 459.67);
    NSString *temperatureText = [NSString stringWithFormat:@"%d", [temperatureInF intValue]];
    self.temperatureDataLabel.text = [temperatureText stringByAppendingString:@"° F"];
    self.humidityDataLabel.text = [[currentData.humidityPercentage stringValue] stringByAppendingString:@"%"];
    self.windDataLabel.text = [[currentData.windMPH stringValue] stringByAppendingString:@" MPH"];
    self.cloudsDataLabel.text = currentData.generalDescription;
    
    self.sunriseDataLabel.text = [Utilities timeString:currentData.sunrise];
    self.sunsetDataLabel.text = [Utilities timeString:currentData.sunset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doDesign];
    
    [WebManager getWeatherDataForLocationString:@"06268" completion:^(WeatherData *weatherData, BOOL success) {
        if (success) {
            self.currentData = weatherData;
        } else {
            NSLog(@"SAD!");
        }
    }];
    
}

- (void)doDesign {
    
    // Background Colors
    self.view.backgroundColor = wColorMain;
    self.zipTextField.backgroundColor = [UIColor whiteColor];
    
    // Text Colors
    self.todayLabel.textColor = [UIColor whiteColor];
    self.sunriseDataLabel.textColor = [UIColor whiteColor];
    self.sunsetDataLabel.textColor = [UIColor whiteColor];

    for (UILabel* label in self.sunDataTitleLabels) {
        label.textColor = [UIColor whiteColor];
    }
    
    // Rounded Edges
    self.dataBackgroundView.layer.cornerRadius = 9.0;
    self.sunBackgroundView.layer.cornerRadius = 9.0;
    self.recentsTableView.layer.cornerRadius = 9.0;
    self.zipTextField.layer.cornerRadius = 9.0;
}

- (void)viewDidLayoutSubviews {
    [self setupSunGradients];
}

- (void)setupSunGradients {
    self.sunBackgroundView.clipsToBounds = YES;
    [self addGradientToView:self.sunBackgroundView withTopColor:wColorSunriseTop bottomColor:wColorSunriseBottom leftHalf:YES];
    [self addGradientToView:self.sunBackgroundView withTopColor:wColorSunsetTop bottomColor:wColorSunsetBottom leftHalf:NO];
}

- (void)addGradientToView:(UIView *)view withTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor leftHalf:(BOOL)left{
    
    // Create the gradient
    CAGradientLayer *viewGradient = [CAGradientLayer layer];
    viewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    
    CGFloat gradientFrameX = left ? 0 : view.bounds.size.width/2.0;
    CGRect frame = CGRectMake(gradientFrameX, 0, view.bounds.size.width/2, view.bounds.size.height);
    viewGradient.frame = frame;
    
    //Add gradient to view
    [view.layer insertSublayer:viewGradient atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

@end

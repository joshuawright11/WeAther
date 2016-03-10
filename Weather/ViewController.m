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
#import "RecentSearchTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - UIView Outlets

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

#pragma mark - AutoLayout Constraints
// for animations

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zipYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recentsYConstraint;

#pragma mark - Private Instance Properties

@property (strong, nonatomic) WeatherData *currentData;
@property (strong, nonatomic) NSMutableArray *recentSearches;
@property (nonatomic) BOOL searchState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doDesign];
    self.searchState = YES;
    self.recentSearches = [[NSMutableArray alloc] init];
    
    // Setup the table view header
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.recentsTableView.frame.size.width, 30)];
    labelView.text = @"Recent Searches";
    labelView.textAlignment = NSTextAlignmentCenter;
    self.recentsTableView.tableHeaderView = labelView;
}

- (void)checkWeatherForInput:(NSString *)input {
    [WebManager getWeatherDataForLocationString:input completion:^(WeatherData *weatherData, BOOL success) {
        if (success) {
            self.currentData = weatherData;
            self.searchState = NO;
        } else {
            // Invalid input or network error
            NSLog(@"Uhh Houston? We have a problem.");
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [self setupSunGradients];
}

- (void)setupSunGradients {
    self.sunBackgroundView.clipsToBounds = YES;
    [self addGradientToView:self.sunBackgroundView withTopColor:wColorSunriseTop bottomColor:wColorSunriseBottom leftHalf:YES];
    [self addGradientToView:self.sunBackgroundView withTopColor:wColorSunsetTop bottomColor:wColorSunsetBottom leftHalf:NO];
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
    
    // Text indent for UITextField
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,20,1)];
    self.zipTextField.leftView = spacerView;
    self.zipTextField.leftViewMode = UITextFieldViewModeAlways;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentSearches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecentSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentSearchCell"];
    
    WeatherData *data = self.recentSearches[indexPath.row];
    [cell configureForWeatherData:data];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentData = self.recentSearches[indexPath.row];
    [self.zipTextField endEditing:YES];
    self.searchState = NO;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.zipTextField endEditing:YES];
    [self checkWeatherForInput:textField.text];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Reanimate to searching state and clear the input
    self.searchState = YES;
    textField.text = @"";
    return YES;
}

#pragma mark - Setters

- (void)setCurrentData:(WeatherData *)currentData {
    _currentData = currentData;
    [self.recentSearches addObject:currentData];
    [self.recentsTableView reloadData];
    
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

- (void)setSearchState:(BOOL)searchState {
    if (searchState && !_searchState) {
        [self animateToSearchState];
    } else if (!searchState && _searchState){
        [self animateToDisplayState];
    }
    
    _searchState = searchState;
}

#pragma mark - Animation Methods

- (void)animateToSearchState {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.7 animations:^{
        [self moveViewsToSearchState];
        [self.view layoutIfNeeded];
    }];
}

- (void)moveViewsToSearchState {
    self.zipYConstraint.constant += 100;
    self.titleYConstraint.constant += 500;
    self.recentsYConstraint.constant += 300;
}

- (void)animateToDisplayState {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.7 animations:^{
        [self moveViewsToDisplayState];
        [self.view layoutIfNeeded];
    }];
}

- (void)moveViewsToDisplayState {
    self.zipYConstraint.constant -= 100;
    self.titleYConstraint.constant -= 500;
    self.recentsYConstraint.constant -= 300;
}

@end

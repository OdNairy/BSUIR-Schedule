//
//  MainScreenViewController.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 29.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "MainScreenViewController.h"
#import "SelectCalendarViewController.h"
#import "BSModel.h"
#import <EventKit/EventKit.h>

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = self.openCalendarWindowButton;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    EKCalendar* calendar = [BSModel sharedInstance].selectedCalendar;
    [self.openCalendarWindowButton setTitle:calendar.title forState:(UIControlStateNormal)];
    UIColor* textColor = [UIColor colorWithCGColor:calendar.CGColor];
    
    [self.openCalendarWindowButton setTitleColor:textColor forState:(UIControlStateNormal)];
    [self.openCalendarWindowButton setTitleColor:textColor forState:(UIControlStateHighlighted)];


}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SelectCalendarViewController* selectCalendar = [segue destinationViewController];
    
    UINavigationController* navigationController = self.navigationController;
    selectCalendar.finishBlock = ^{
        [navigationController dismissModalViewControllerAnimated:YES];
    };
}

- (void)viewDidUnload {
    [self setAlarmTimeStepper:nil];
    [self setAlarmTimeLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Actions

- (IBAction)alarmTimeStepperChanged:(UIStepper*)sender {
    NSUInteger stepperTime = (NSUInteger)sender;
    self.alarmTimeLabel.text = [NSString stringWithFormat:@"%u",stepperTime];
}

- (IBAction)alarmsOnChanged:(UISwitch*)sender {
    
}



@end

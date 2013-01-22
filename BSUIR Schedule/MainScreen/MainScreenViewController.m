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
#import "BSSubject.h"
@interface MainScreenViewController ()
@property (nonatomic, strong) EKEventStore* store;
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
    _store = [[EKEventStore alloc] init];
    [_store requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError *error) {
    }];
//    [EKEventStore authorizationStatusForEntityType:(EKEntityTypeEvent)]
	// Do any additional setup after loading the view.
}
- (IBAction)addToCalendar:(id)sender {
    [[BSModel sharedInstance] downloadAndParseScheduleWithFinishBlock:^(BSWeek *workWeek) {
//        NSLog(@"%@",[workWeek firstWeekEvents]);
        
        for (BSSubject* bs in workWeek.firstWeekEvents) {
            [bs saveSubjectToCalendar:[BSModel sharedInstance].selectedCalendar
                        andEventStore:[BSModel sharedInstance].store];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
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
//    selectCalendar.finishBlock = ^{
//        [navigationController dismissModalViewControllerAnimated:YES];
//    };
}

- (void)viewDidUnload {
    [self setAlarmTimeStepper:nil];
    [self setAlarmTimeLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Actions

- (IBAction)alarmTimeStepperChanged:(UIStepper*)sender {
    NSUInteger stepperTime = (NSUInteger)sender.value;
    self.alarmTimeLabel.text = [NSString stringWithFormat:@"%u",stepperTime];
}

- (IBAction)alarmsOnChanged:(UISwitch*)sender {
    self.alarmTimeLabel.enabled = self.alarmTimeStepper.enabled = sender.on;

}


@end

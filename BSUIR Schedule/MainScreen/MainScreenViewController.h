//
//  MainScreenViewController.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 29.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIButton* openCalendarWindowButton;
@property (strong, nonatomic) IBOutlet UIStepper *alarmTimeStepper;
@property (strong, nonatomic) IBOutlet UILabel *alarmTimeLabel;


@end

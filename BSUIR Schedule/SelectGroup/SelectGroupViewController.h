//
//  SelectGroupViewController.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSWeek;



@interface SelectGroupViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField* groupTextField;
@property (nonatomic, strong) IBOutlet UISegmentedControl* subgroupSegment;

-(IBAction)hideKeyboard:(id)sender;
-(IBAction)requestSchedule:(id)sender;


@end


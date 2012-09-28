//
//  SelectGroupViewController.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "BSWeek.h"
#import "BSModel.h"

#define MAX_DIGITAL_COUNT 7

@interface SelectGroupViewController ()

@end

@implementation SelectGroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)hideKeyboard:(id)sender{
    [self.view endEditing:YES];
 
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return newString.length<MAX_DIGITAL_COUNT;
}



- (IBAction)requestSchedule:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [BSModel sharedInstance].groupNumber = self.groupTextField.text;
    [[BSModel sharedInstance] downloadAndParseScheduleWithFinishBlock:^(BSWeek *workWeek) {
        NSLog(@"%@",[workWeek firstWeekEvents]);
        
    }];
}

@end

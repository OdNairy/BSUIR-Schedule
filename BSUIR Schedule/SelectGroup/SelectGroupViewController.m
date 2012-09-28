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

-(void)downloadAndParseScheduleWithFinishBlock:(BSWeekBlock)block{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString* stringUrl = [@"http://www.bsuir.by/psched/schedulegroup?group=" stringByAppendingString:self.groupTextField.text];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{                                   
                                   if (data.length) {
                                       BSWeek* week = [[BSModel sharedInstance] computeWorkWeekFromData:data];
                                       block(week);
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   }
                               });
//                               if (!error) {
//                                   [self respondsToSelector:@selector(statusCode)]
//                               }
    }];
//    NSData* data = [NSData dataWithContentsOfURL:[request URL]];
//    [[BSModel sharedInstance] computeWorkWeekFromData:data];
}

- (IBAction)requestSchedule:(id)sender {
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self downloadAndParseScheduleWithFinishBlock:^(BSWeek *workWeek) {
        NSLog(@"%@",workWeek);
    }];
}

@end

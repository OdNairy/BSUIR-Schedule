//
//  SelectCalendarViewController.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 28.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "SelectCalendarViewController.h"
#import <EventKit/EventKit.h>
#import "SelectCalendarCell.h"
#import "BSModel.h"

@interface SelectCalendarViewController ()
@property (nonatomic, strong) EKEventStore* store;
@property (nonatomic, strong) NSMutableDictionary* groupedCalendars;
@end

@implementation SelectCalendarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableDictionary*)groupCalendars:(NSArray*)calendars{
    NSMutableDictionary* groups = [NSMutableDictionary dictionaryWithCapacity:calendars.count];
    
    for (EKCalendar* calendar in _store.calendars) {
        if (calendar.type == EKCalendarTypeBirthday)
            continue;
        NSMutableArray* arr = groups[calendar.source.title];
        if (!arr) {
            groups[calendar.source.title] = [NSMutableArray new];
        }
        [arr addObject:calendar];
    }
    
    return groups;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _store = [[EKEventStore alloc] init];
    _groupedCalendars = [self groupCalendars:self.store.calendars];
    
    // Uncomment the following line to preserve selection between presentations.
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){        
        if (!_store.calendars.count) {
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
            if (_cancelBlock) {
                _cancelBlock();
            }
        }
    });
}

-(EKCalendar*)calendarForIndexPath:(NSIndexPath*)indexPath
{
    NSString* key = self.groupedCalendars.allKeys[indexPath.section];
    NSArray* calendars = self.groupedCalendars[key];
    EKCalendar* calendar = calendars[indexPath.row];
    
    return calendar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.groupedCalendars.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSString* key = self.groupedCalendars.allKeys[section];
    NSArray* calendars = self.groupedCalendars[key];
    return calendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SelectCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    EKCalendar* calendar = [self calendarForIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SelectCalendarCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CellIdentifier];
        cell.linkedCalendar = calendar;
    }
    
    
    cell.textLabel.text = calendar.title;
//    cell.detailTextLabel.text = [[calendar source] performSelector:@selector(externalID)];
    cell.textLabel.textColor = [UIColor colorWithCGColor:calendar.CGColor];
    // Configure the cell...
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* key = self.groupedCalendars.allKeys[section];
    return key;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [BSModel sharedInstance].selectedCalendar = [self calendarForIndexPath:indexPath];
    NSLog(@"Selected calendar: %@ (%@)",[BSModel sharedInstance].selectedCalendar.title,[BSModel sharedInstance].selectedCalendar.source.title);
    if (_finishBlock) {
        _finishBlock();
    }
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end

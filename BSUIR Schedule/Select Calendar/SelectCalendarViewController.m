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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString* key = self.groupedCalendars.allKeys[indexPath.section];
    NSArray* calendars = self.groupedCalendars[key];
    EKCalendar* calendar = calendars[indexPath.row];
    
    if (cell == nil) {
        cell = [[SelectCalendarCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CellIdentifier];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

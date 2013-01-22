//
//  AppDelegate.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 24.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "AppDelegate.h"
#import "BSSubject.h"
#import "BSModel.h"
#import <EventKit/EventKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
#ifdef ECONOMY_TRAFFIC
    printf("Application is launched in ECONOMY mode\n");
#endif
    [[BSModel sharedInstance] downloadAndParseScheduleWithFinishBlock:^(BSWeek *workWeek) {
        EKEventStore* store = [[EKEventStore alloc]init];
        uint i = 0;
        for (EKCalendar* calendar in store.calendars) {
            printf("#%d: %s\n",i++,calendar.title.UTF8String);
        }
        for (BSSubject* subject in workWeek.firstWeekEvents) {
            [subject saveSubjectToCalendar:store.calendars[6] andEventStore:store];
        }
    }];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

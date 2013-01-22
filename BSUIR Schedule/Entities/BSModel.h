//
//  BSModel.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSWeekDay.h"
#import "BSWeek.h"

@class EKCalendar,EKEventStore;
typedef void (^BSWeekBlock)(BSWeek* workWeek);

@interface BSModel : NSObject

@property (nonatomic, strong) NSString* groupNumber;
@property (nonatomic, strong) EKCalendar* selectedCalendar;
@property (nonatomic, strong) EKEventStore* store;

@property (nonatomic, assign) BOOL alertsEnabled;

+(BSModel*)sharedInstance;

- (void)downloadAndParseScheduleWithFinishBlock:(BSWeekBlock)block;
-(BSWeek*)computeWorkWeekFromData:(NSData*)data;

@end

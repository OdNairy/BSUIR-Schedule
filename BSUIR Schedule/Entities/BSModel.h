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

typedef void (^BSWeekBlock)(BSWeek* workWeek);

@interface BSModel : NSObject
@property (nonatomic, strong) NSString* groupNumber;
+(BSModel*)sharedInstance;

- (void)downloadAndParseScheduleWithFinishBlock:(BSWeekBlock)block;
-(BSWeek*)computeWorkWeekFromData:(NSData*)data;

@end

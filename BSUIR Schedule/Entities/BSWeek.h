//
//  BSWeek.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BSWeekDay.h"
@class BSWeekDay;

@interface BSWeek : NSObject

-(void)addWeekDay:(BSWeekDay*)weekDay;

@end

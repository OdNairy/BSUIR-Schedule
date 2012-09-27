//
//  BSWeek.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "BSWeek.h"

@interface BSWeek ()
@property (nonatomic, strong) NSMutableArray* weekDays;
@end

@implementation BSWeek

- (id)init
{
    self = [super init];
    if (self) {
        _weekDays = [[NSMutableArray alloc]initWithCapacity:6];
    }
    return self;
}

-(void)addWeekDay:(BSWeekDay *)weekDay{
    [self.weekDays addObject:weekDay];
}

@end

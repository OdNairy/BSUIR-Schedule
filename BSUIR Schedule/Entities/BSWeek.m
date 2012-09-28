//
//  BSWeek.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "BSWeek.h"
#import "BSSubject.h"

@interface BSWeekDay ()
@property (nonatomic, retain) NSMutableArray* lessons;
@end

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

-(BSWeekDay *)dayByWeekDay:(NSUInteger)day{

    if (--day) {
        return _weekDays[day-1];
    }
    return nil;
}

-(NSArray *)firstWeekEvents{
    return [self eventsForWeekNumber:1];
}


-(NSArray*)eventsForWeekNumber:(NSUInteger)weekNumber
{
    NSMutableArray* array =[NSMutableArray array];
    
    for (BSWeekDay*day in self.weekDays) {
        for (BSSubject* subject in day.lessons) {
            NSRange range = [subject.week rangeOfString:[NSString stringWithFormat:@"%u",weekNumber]];
            
            if (range.length >0) {
                [array addObject:subject];
            }
        }
    }
    
    return array;
}

@end

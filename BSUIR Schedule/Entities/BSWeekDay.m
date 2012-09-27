//
//  BSDay.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "BSWeekDay.h"
//@compatibility_alias <#alias#> <#class#>
#import "BSSubject.h"
@interface BSWeekDay ()
@property (nonatomic, retain) NSMutableArray* lessons;
@end

@implementation BSWeekDay{
    NSInteger _weekDay;
}

- (id)initWithWeekDay:(NSInteger)weekDay
{
    self = [super init];
    if (self) {
        
        _weekDay = weekDay;
        _lessons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init{
    [NSException raise:@"BSSyntaxError" format:@"You should use '-initWithWeekDay:'"];
    return nil;
}

-(void)addLesson:(BSSubject *)lesson{
    if ([lesson isKindOfClass:[BSSubject class]]) {
        [self.lessons addObject:lesson];
    }
}

-(void)removeLesson:(BSSubject*)lesson{
    if ([lesson isKindOfClass:[BSSubject class]]) {
        [self.lessons removeObject:lesson];
    }
}

@end

//
//  BSDay.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSSubject;
@interface BSWeekDay : NSObject

// EKSunday, EKMonday, etc...
@property (nonatomic, assign) NSUInteger day;

-(id)initWithWeekDay:(NSInteger)weekDay;

-(void)addLesson:(BSSubject*)lesson;

@end

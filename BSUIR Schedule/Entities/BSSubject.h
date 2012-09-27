//
//  Subject.h
//  BSUIR Helper
//
//  Created by Roman Gardukevich on 24.09.12.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface BSSubject : NSObject


@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString* week;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, assign) NSInteger subgroup;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* room;
@property (nonatomic, strong) NSString* lecturer;

+(BSSubject*)subjectFromDictionary:(NSDictionary*)dictionary;

-(BOOL)saveSubjectToCalendar:(EKCalendar *)calendar andEventStore:(EKEventStore*)store;

+(void)writeDB;
@end

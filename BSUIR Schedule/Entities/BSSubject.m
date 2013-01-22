//
//  Subject.m
//  BSUIR Helper
//
//  Created by Roman Gardukevich on 24.09.12.
//
//

#import "BSSubject.h"
#import "NSDate-Utilities.h"
#import "TFHpple.h"

@implementation BSSubject
// day, week, time, subgroup, subject, type, room, lecturer

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@ [%p]: day: %d, week: %@, time: %@, subgroup: %d, subject: %@, type: %@, room: %@, lecturer: %@>",self.class,self,_day,_week,_time,_subgroup,_subject,_type,_room,_lecturer];
}

-(void)writeDB {
    // Parse
    NSURL *parseUrl = [NSURL URLWithString:@"http://www.bsuir.by/psched/schedulegroup?group=972301" ];
    NSString* responceString = [NSString stringWithContentsOfURL:parseUrl encoding:NSUTF8StringEncoding error:nil];
    
    
    NSData *parseHtmlData =  [responceString dataUsingEncoding:NSUTF8StringEncoding]; // [NSData dataWithContentsOfURL:parseUrl];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:parseHtmlData];
    NSInteger tr, div;
    NSInteger day, subgroup;
    NSString *week, *time, * subject, *type, *room, *lecturer;
    NSString *tmp = nil;
    
    NSMutableArray* subjects = [NSMutableArray array];
    
    NSInteger trCount = [[parser searchWithXPathQuery:@"//table/tr"] count];
    for (tr = 2; tr != trCount + 1; tr++) {
        NSInteger divCount = [[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[2]/div", tr]] count];
        for (div = 1; div != divCount + 1; div++) {
            day = tr - 2;
            
            tmp = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[2]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            if (tmp) {
                week = [self removeAllButDigit:tmp];
                tmp = nil;
            }
            else {
                week = @"0";
            }
            
            time = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[3]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            

            if (!time) {
                // This is martial arts
                time = @"7:30-15:00";
            }
            tmp = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[4]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            if (tmp) {
                subgroup = [tmp intValue];
                tmp = nil;
            }

            
            subject = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[5]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            
            tmp = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[6]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            if (tmp) {
                type = tmp;
                tmp = nil;
            }
            
            tmp = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[7]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            if (tmp) {
                room = tmp;
                tmp = nil;
            }
            
            tmp = [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[8]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            if (tmp) {
                lecturer = tmp;
                tmp = nil;
            }
            
            BSSubject* lesson = [[BSSubject alloc] init];
            lesson.day = day;
            lesson.week = week;
            lesson.time = time;
            lesson.subgroup = subgroup;
            lesson.subject = subject;
            lesson.type = type;
            lesson.room = room;
            lesson.lecturer = [lecturer stringByReplacingPercentEscapesUsingEncoding:NSWindowsCP1251StringEncoding];
            NSLog(@"%@",lesson);
            [subjects addObject:lesson];
            
//            NSString *updateSQL = [NSString stringWithFormat:@"insert into schedule (day, week, time, subgroup, subject, type, room, lecturer) values (%d, '%@', '%@', %d, '%@', '%@', '%@', '%@')", day, week, time, subgroup, subject, type, room, lecturer];
//            
            
            
            week = nil; time = nil; subject = nil; type = nil; room = nil; lecturer = nil;
        }
        
        
    }
    
    // Save date last update
    NSDateFormatter *dateFormatterShort = [[NSDateFormatter alloc] init];
    [dateFormatterShort setDateFormat:@"dd.MM.yyyy"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    NSString *dateShort = [dateFormatterShort stringFromDate:[NSDate date]];
    NSString *numberMonthOfYear = [NSString stringWithFormat:@"%d", [[calendar components: NSMonthCalendarUnit fromDate:date] month]];
    NSString *numberWeekOfYear = [NSString stringWithFormat:@"%d", [[calendar components: NSWeekOfYearCalendarUnit fromDate:date] weekOfYear]];
    NSString *numberDayOfYear = [NSString stringWithFormat:@"%d", [[calendar components: NSDayCalendarUnit fromDate:date] day]];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:dateShort forKey:@"lastUpdateShort"];
    [[NSUserDefaults standardUserDefaults] setObject:numberMonthOfYear forKey:@"lastUpdateMonth"];
    [[NSUserDefaults standardUserDefaults] setObject:numberWeekOfYear forKey:@"lastUpdateWeek"];
    [[NSUserDefaults standardUserDefaults] setObject:numberDayOfYear forKey:@"lastUpdateDay"];
    
//    NSLog(@"%@",subjects);
    // Print db
    
    NSArray *array = nil;//;[SQLiteAccess selectManyRowsWithSQL:@"select * from schedule"];
    for (int i = 0; i < [array count]; i++) {
        NSDictionary *dictionary = [array objectAtIndex:i];
        
        NSLog(@"id: %@", [dictionary objectForKey:@"id"]);
        NSLog(@"day: %@", [dictionary objectForKey:@"day"]);
        NSLog(@"week: %@", [dictionary objectForKey:@"week"]);
        NSLog(@"time: %@", [dictionary objectForKey:@"time"]);
        NSLog(@"subgroup: %@", [dictionary objectForKey:@"subgroup"]);
        NSLog(@"subject: %@", [dictionary objectForKey:@"subject"]);
        NSLog(@"type: %@", [dictionary objectForKey:@"type"]);
        NSLog(@"room: %@", [dictionary objectForKey:@"room"]);
        NSLog(@"lecturer: %@", [dictionary objectForKey:@"lecturer"]);
        NSLog(@"----------");
        
        BSSubject* newSub = [BSSubject subjectFromDictionary:dictionary];
        [subjects addObject:newSub];
        
        EKEventStore* store = [[EKEventStore alloc] init];
        
        [newSub saveSubjectToCalendar:store.calendars[5] andEventStore:store];
        
        
    }
    
    
    
}

+(BSSubject*)subjectFromDictionary:(NSDictionary*)dictionary{
    
    BSSubject* newSubject = [[BSSubject alloc] init];
    newSubject.day = [[dictionary objectForKey:@"day"] integerValue];
    newSubject.week = [dictionary objectForKey:@"week"];
    newSubject.time = [dictionary objectForKey:@"time"];
    newSubject.subgroup = [[dictionary objectForKey:@"subgroup"] integerValue];
    newSubject.subject = [dictionary objectForKey:@"subject"];
    newSubject.type  = [dictionary objectForKey:@"type"];
    newSubject.room = [dictionary objectForKey:@"room"];
    newSubject.lecturer = [dictionary objectForKey:@"lecturer"];
    
    return newSubject;
    
    
//    NSLog(@"id: %@", [dictionary objectForKey:@"id"]);
//    NSLog(@"day: %@", [dictionary objectForKey:@"day"]);
//    NSLog(@"week: %@", [dictionary objectForKey:@"week"]);
//    NSLog(@"time: %@", [dictionary objectForKey:@"time"]);
//    NSLog(@"subgroup: %@", [dictionary objectForKey:@"subgroup"]);
//    NSLog(@"subject: %@", [dictionary objectForKey:@"subject"]);
//    NSLog(@"type: %@", [dictionary objectForKey:@"type"]);
//    NSLog(@"room: %@", [dictionary objectForKey:@"room"]);
//    NSLog(@"lecturer: %@", [dictionary objectForKey:@"lecturer"]);
//    NSLog(@"----------");

}

typedef enum {
    TermFirst,
    TermSecond,
    TermsCount
}Term;

-(void)setTime:(NSString *)time
{
    _time = time;
    if ([time isEqualToString:@"(null)"]) {
        _time = @"07:30-15:00";
    }
}

-(BOOL)saveSubjectToCalendar:(EKCalendar *)calendar andEventStore:(EKEventStore*)store
{
    static BOOL saved = NO;
    @synchronized(self){
        if (saved) {
            return YES;
        }
        assert([calendar.title hasPrefix:@"Test"]);
        
        NSString *string = _time;
        NSString *expression = @"(\\d{1,2}):(\\d{1,2})-(\\d{1,2}):(\\d{1,2})";
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        //    NSTextCheckingResult* result = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        
        NSCalendar* calendarForDate = [NSCalendar currentCalendar];
        //    calendarForDate.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDateComponents* dateFromComp = [calendarForDate components: NSWeekOfYearCalendarUnit| NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        
        //    NSDateComponents* dateToComp = [calendarForDate components: NSWeekOfYearCalendarUnit| NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        NSDateComponents* dateToComp = [dateFromComp copy];
        
        NSInteger week = dateFromComp.weekOfYear;
        EKRecurrenceEnd* end = nil;
        
        Term term = -1;
        if (week > 30) {
            // First semester
            term = TermFirst;
            
            dateToComp.month = 12;
            dateToComp.day = 20;
        }else{
            // Second semester
            term = TermSecond;
            dateToComp.month = 6;
            dateToComp.day = 15;
        }
        
        NSDate* endDate = [calendarForDate dateFromComponents:dateToComp];
        end = [EKRecurrenceEnd recurrenceEndWithEndDate:endDate];
        
        
        NSTextCheckingResult* match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        if (match.numberOfRanges >= 5) {
            
            EKEvent* event = [self dateTimeForTerm:term week:[[_week substringToIndex:1] integerValue]
                                               day:_day+1+1 // one +1 is to move start index to [1,...,7], second +1 is to change week start from Monday (instead Sunday)
                                              hour:[[string substringWithRange:[match rangeAtIndex:1]] integerValue]
                                            minute:[[string substringWithRange:[match rangeAtIndex:2]] integerValue]
                                        finishHour:[[string substringWithRange:[match rangeAtIndex:3]] integerValue]
                                      finishMinute:[[string substringWithRange:[match rangeAtIndex:4]] integerValue] store:store];
            event.title = _subject;
            if (![_type isEqualToString:@" – "]) {
                event.title = [event.title stringByAppendingFormat:@" (%@)",_type];
            }
            event.notes = _lecturer;
            if (_subgroup) {
                event.title = [event.title stringByAppendingFormat:@"[%d]",_subgroup];
            }
            EKAlarm* alarm = [EKAlarm alarmWithRelativeOffset:-20*60];
            event.alarms = @[alarm];
            
            NSArray* rule = nil;
            if ([_week isEqualToString:@"0"]) {
                rule = @[[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:(EKRecurrenceFrequencyWeekly) interval:1 end:end]];
            }else if(_week.length == 1){
                rule = @[[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:(EKRecurrenceFrequencyWeekly) interval:4 end:end]];
            }else if (_week.length == 2){
                rule = @[[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:(EKRecurrenceFrequencyWeekly) interval:2 end:end]];
            }else if (_week.length == 3){
                // _week = '123'
                EKRecurrenceRule* firstRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:(EKRecurrenceFrequencyWeekly) interval:2 end:end];
                EKRecurrenceRule* secondRule = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:(EKRecurrenceFrequencyWeekly) interval:4 end:end];
                rule = @[firstRule];
                NSLog(@"!!! WARNING !!!: Should manually create event for 2nd week: %@ [%@]",self.subject,self.time);
            }
            event.recurrenceRules = rule;
            
            event.location = _room;
            event.calendar = calendar;
            NSError* error = nil;
            BOOL saved = [store saveEvent:event span:(EKSpanThisEvent) error:&error];
            if (!saved) {
                NSLog(@"Save error: %@",error);
            }else{
                NSLog(@"Saved event: %@",event);
            }
            
        }
        
        return saved = YES;
    }
}


-(EKEvent*)dateTimeForTerm:(Term)term week:(NSInteger)week day:(NSInteger)day
hour:(NSInteger)hour minute:(NSInteger)minute finishHour:(NSInteger)finishHour finishMinute:(NSInteger)finishMinute store:(EKEventStore*)store{
    EKEvent* event = [EKEvent eventWithEventStore:store];
    
    NSDate* now = [NSDate date];
    NSDateComponents* nowComponents = [[NSCalendar currentCalendar] components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:now];
    
    NSInteger yearOfFirstWeek = nowComponents.year;
    if (term == TermFirst && nowComponents.month < 9) {
        yearOfFirstWeek--;
    }
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    components.year = yearOfFirstWeek;
    
    
    NSInteger firstMonth;
    
    
    if (term == TermFirst) {
        firstMonth = 9;
    }else{
        firstMonth = 1;
    }
    components.month = firstMonth;
    
    NSDate* firstDay = [[NSCalendar currentCalendar] dateFromComponents:components];
    components = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit fromDate:firstDay];
    
    NSInteger weekOfYearForFirstDay = components.weekOfYear;
    
    components = [[NSDateComponents alloc] init];
    components.year = yearOfFirstWeek;
    
    components.weekOfYear = weekOfYearForFirstDay+week-(week?1:0);   // add week number to start. If
    components.weekday = day;
    components.hour = hour;
    components.minute = minute;
    
    event.startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    components.hour = finishHour;
    components.minute = finishMinute;
    event.endDate = [[NSCalendar currentCalendar]dateFromComponents:components];
    
    
    return event;
}

-(NSString *)removeAllButDigit:(NSString *)originalString{
    // Remove all but digit
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"1234"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return strippedString;
}

@end

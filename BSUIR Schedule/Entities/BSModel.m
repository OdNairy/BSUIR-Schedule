//
//  BSModel.m
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 27.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import "BSModel.h"
#import "NSDate-Utilities.h"
#import "TFHpple.h"
#import "BSSubject.h"

@interface BSModel ()
@property (nonatomic, strong) BSWeek* week;
@end

@implementation BSModel
@synthesize groupNumber=_groupNumber;

+(BSModel *)sharedInstance{
    static dispatch_once_t onceToken;
    static BSModel* sharedModel = nil;
    dispatch_once(&onceToken, ^{
        sharedModel = [[BSModel alloc] init];
    });
    
    return sharedModel;
}


static NSString* kGroupNumberKey = @"kGroupNumber";

-(NSString *)groupNumber{
    if (!_groupNumber) {
        _groupNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kGroupNumberKey];
    }
    return _groupNumber;
}

-(void)setGroupNumber:(NSString *)groupNumber{
    _groupNumber = groupNumber;
    [[NSUserDefaults standardUserDefaults] setObject:groupNumber forKey:kGroupNumberKey];
}


-(void)downloadAndParseScheduleWithFinishBlock:(BSWeekBlock)block{
    if (_week) {
        block(_week);
        return;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* stringUrl = [@"http://www.bsuir.by/psched/schedulegroup?group=" stringByAppendingString:[self groupNumber]];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringUrl]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                               
                                   if (data.length) {
                                       self.week = [self computeWorkWeekFromData:data];
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                       block(_week);
                                   }
                               });

                           }];
}


-(BSWeek*)computeWorkWeekFromData:(NSData *)data
{
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSInteger tr, div;
    NSInteger day, subgroup;
    NSString *week, *time, * subject, *type, *room, *lecturer;
    NSString *tmp = nil;
    
    NSMutableArray* subjects = [NSMutableArray array];
    
    BSWeek* workWeek = [[BSWeek alloc] init];
    
    NSInteger trCount = [[parser searchWithXPathQuery:@"//table/tr"] count];
    for (tr = 2; tr != trCount + 1; tr++) {
        NSInteger divCount = [[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[2]/div", tr]] count];
        
        BSWeekDay* workDay = [[BSWeekDay alloc] initWithWeekDay:tr];
        [workWeek addWeekDay:workDay];
        workDay.day = tr;
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

            
            
            subject =   [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[5]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
            
            tmp =       [[[[parser searchWithXPathQuery:[NSString stringWithFormat:@"//table/tr[%d]/td[6]/div[%d]", tr, div]] objectAtIndex:0] firstChild] content];
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
            [workDay addLesson:lesson];
            
            //            NSString *updateSQL = [NSString stringWithFormat:@"insert into schedule (day, week, time, subgroup, subject, type, room, lecturer) values (%d, '%@', '%@', %d, '%@', '%@', '%@', '%@')", day, week, time, subgroup, subject, type, room, lecturer];
            //
            
            
            week = nil; time = nil; subject = nil; type = nil; room = nil; lecturer = nil;
        }
        
        
    }
    
    return workWeek;
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

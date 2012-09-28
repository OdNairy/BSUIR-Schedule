//
//  SelectCalendarCell.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 28.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EKCalendar;
@interface SelectCalendarCell : UITableViewCell
@property (nonatomic, strong) EKCalendar* linkedCalendar;
@end

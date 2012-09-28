//
//  SelectCalendarViewController.h
//  BSUIR Schedule
//
//  Created by Roman Gardukevich on 28.09.12.
//  Copyright (c) 2012 Roman Gardukevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCalendarViewController : UITableViewController
@property (nonatomic, copy) dispatch_block_t finishBlock;

@end
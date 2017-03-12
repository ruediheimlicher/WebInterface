//
//  Utils.m
//  WebInterface
//
//  Created by Sysadmin on 09.03.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


@implementation Utils
- (void) logRect:(NSRect)r
{
NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}

- (id)init
{
   return [super init];
}
- (NSDateComponents*) heute
{
   NSDate *now = [[NSDate alloc] init];
   NSCalendar *kalender = [NSCalendar currentCalendar];
   [kalender setFirstWeekday:2];
   NSDateComponents *components = [kalender components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:now];
   components.weekday = components.weekday-1;
   return components;
}

@end

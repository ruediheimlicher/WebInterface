//
//  rDatum.m
//  WebInterface
//
//  Created by Ruedi Heimlicher on 02.01.2018.
//

#import "rDatum.h"

@implementation rDatum
- (int)tagdesjahresvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag
{
   // http://stackoverflow.com/questions/7664786/generate-nsdate-from-day-month-and-year
   NSCalendar *tagcalendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [[NSDateComponents alloc] init];
   [components setDay:tag];
   [components setMonth:monat];
   [components setYear:jahr];
   NSDate *tagdatum = [tagcalendar dateFromComponents:components];
   //NSLog(@"tagdatum: %@",[tagdatum description]);
   NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   int dayOfYear =(int)[gregorian ordinalityOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitYear forDate:tagdatum];
   return dayOfYear;
}

- (NSDate*)DatumvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag
{
   // http://stackoverflow.com/questions/7664786/generate-nsdate-from-day-month-and-year
   NSCalendar *tagcalendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [[NSDateComponents alloc] init];
   [components setDay:tag];
   [components setMonth:monat];
   [components setYear:jahr];
   NSDate *tagdatum = [tagcalendar dateFromComponents:components];
   //NSLog(@"tagdatum: %@",[tagdatum description]);
   NSCalendar *gregorian =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   int dayOfYear =(int)[gregorian ordinalityOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitYear forDate:tagdatum];
   return tagdatum;
}

- (NSUInteger) dayOfYearForDate:(NSDate *)dasDatum
{
   NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
   NSCalendar *calendar = [[NSCalendar alloc]
                           initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   [calendar setTimeZone:gmtTimeZone];
   
   NSUInteger day = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitYear forDate:dasDatum];
   return day;
}


@end

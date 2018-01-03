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

- (int)tagdesjahres
{
   
}

- (NSDate*)DatumvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag
{
   // http://stackoverflow.com/questions/7664786/generate-nsdate-from-day-month-and-year
   NSCalendar *tagcalendar = [NSCalendar currentCalendar];
   [tagcalendar setTimeZone:[NSTimeZone localTimeZone]];
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
   calendar.firstWeekday = 2;
   [calendar setTimeZone:gmtTimeZone];
   
   NSUInteger day = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitYear forDate:dasDatum];
   return day;
}

- (int)jahrVonDatum:(NSDate*)dasDatum
{
   NSCalendar *tagcalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   tagcalendar.firstWeekday = 2;
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:dasDatum];
   //int stunde = components.hour;
   //int minute = components.minute;
   return components.year;;
}

- (int)stundeVonDatum:(NSDate*)dasDatum
{
   NSCalendar *tagcalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   tagcalendar.firstWeekday = 2;
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:dasDatum];
   int stunde = components.hour;
   int minute = components.minute;
   return stunde;
}

- (int)minuteVonDatum:(NSDate*)dasDatum
{
   NSCalendar *tagcalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   tagcalendar.firstWeekday = 2;
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:dasDatum];
   return components.hour;
}

- (int)wochentagVonDatum:(NSDate*)dasDatum
{
   NSCalendar *tagcalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   tagcalendar.firstWeekday = 2;
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:dasDatum];
   return components.weekday;
}

- (int)tagDesJahres
{
   NSDate *now = [[NSDate alloc] init];
   NSCalendar *tagcalendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   tagcalendar.firstWeekday = 2;
   
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:now];
   //int stunde = components.hour;
   //int minute = components.minute;
   return components.day;
}


- (NSDate*)Datumvonheute
{
   // http://stackoverflow.com/questions/7664786/generate-nsdate-from-day-month-and-year
   NSDate *now = [[NSDate alloc] init];
   NSCalendar *tagcalendar = [NSCalendar currentCalendar];
   [tagcalendar setFirstWeekday:2];
   NSDateComponents *components = [tagcalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:now];
   NSDate *tagdatum = [tagcalendar dateFromComponents:components];
   NSLog(@"tagdatum: %@",[tagdatum description]);
   return tagdatum;
}

- (NSString*)datumstringVonHeute
{
   NSDate *errdate         = [NSDate date];
   NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
   [dateformat setDateFormat:@"%H:%M"];
   NSString *dateString  = [dateformat stringFromDate:errdate];
   return dateString;
}

- (NSString*)datumstringVonDatum:(NSDate*) dasDatum
{
   
   NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
   [dateformat setDateFormat:@"%H:%M"];
   NSString *dateString  = [dateformat stringFromDate:dasDatum];
   return dateString;
}

@end

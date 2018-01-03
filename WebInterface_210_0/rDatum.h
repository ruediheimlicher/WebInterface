//
//  rDatum.h
//  WebInterface
//
//  Created by Ruedi Heimlicher on 02.01.2018.
//

#import <Foundation/Foundation.h>

@interface rDatum : NSObject
- (int)tagdesjahresvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag;
- (NSUInteger) dayOfYearForDate:(NSDate *)dasDatum;
- (NSDate*)DatumvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag;
- (int)minuteVonDatum:(NSDate*)dasDatum;
- (int)stundeVonDatum:(NSDate*)dasDatum;
- (int)wochentagVonDatum:(NSDate*)dasDatum;
@end

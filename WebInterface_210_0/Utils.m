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


- (NSString*)passwortstring
{
   NSString* returnstring = [NSString string];
   NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
   //NSLog(@"ResourcenPfad: %@",ResourcenPfad);
   NSString* PasswortTabellePfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources/Passwort.txt"];
   NSString* PasswortTabelleString = [NSString stringWithContentsOfFile:PasswortTabellePfad];
   
   NSLog(@"PasswortString: \n%@",PasswortTabelleString);
   NSArray* PasswortTabelle = [PasswortTabelleString componentsSeparatedByString:@"\n"];
   //NSLog(@"PasswortArray: \n%@",PasswortTabelle  );
   //NSLog(@"PasswortArray 6: \n%@",[PasswortTabelle objectAtIndex:6] );
   //NSString* tempPW = [[[PasswortTabelle objectAtIndex:6]componentsSeparatedByString:@"\t"]objectAtIndex:3];
   //NSLog(@"tempPW: %@",tempPW);
   
   /*
    pw_array = {0x47,	0x3E,	0xD,	0x5,	0x21,	0x3D,	0x42,	0x25,
    0x22,	0x34,	0x3F,	0x4C,	0x10,	0x5,	0x3C,	0x63,
    0x50,	0x5,	0x7,	0x0,	0x3C,	0x11,	0x43,	0x4D,
    0x6,	0x5E,	0x0,	0x53,	0x34,	0x10,	0x41,	0x1F,
    0x2A,	0x5E,	0x16,	0x2B,	0x56,	0x7,	0x44,	0x62,
    0x8,	0x54,	0x18,	0x2F,	0x4D,	0x1,	0x5F,	0x4,
    0x9,	0x22,	0x5E,	0x36,	0x2C,	0x48,	0x45,	0x13,
    0x26,	0x5C,	0x4D,	0x4B,	0x32,	0x1E,	0x1D,	0x3F};
    */
   
   srand((unsigned int)time(NULL));   // should only be called once
   int randomnummer1 = rand()%63+1;
   NSLog(@"Util passwortstring randomnummer 1: *%d* reminder: %d mantisse: %d",randomnummer1 ,randomnummer1%8,randomnummer1/8);
   int randomzeile = randomnummer1%8;
   int randomkolonne = randomnummer1/8;
   NSLog(@"passwortstring randomnummer 1: *%d* randomzeile: %d randomkolonne: %d",randomnummer1 ,randomzeile,randomkolonne);
   NSString* passwort1 = [[[PasswortTabelle objectAtIndex:randomzeile]componentsSeparatedByString:@"\t"]objectAtIndex:randomkolonne];

   int randomnummer2 = rand()%64+1;
   NSLog(@"Util passwortstring randomnummer 1: *%d* reminder: %d mantisse: %d",randomnummer2 ,randomnummer2%8,randomnummer2/8);
   randomzeile = randomnummer2%8;
   randomkolonne = randomnummer2/8;
   NSString* passwort2 = [[[PasswortTabelle objectAtIndex:randomzeile]componentsSeparatedByString:@"\t"]objectAtIndex:randomkolonne];

   
   returnstring = [NSString stringWithFormat:@"%02X%02X%02X%02X",randomnummer1,[passwort1 intValue],randomnummer2,[passwort2 intValue]];
   
   
   return returnstring;
}


@end

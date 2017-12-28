//
//  rWochenplan.h
//  USBInterface
//
//  Created by Sysadmin on 05.06.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rTagplan.h"

extern NSMutableArray *daySettingStringArray;
@interface rWochenplan : NSView 
{
int Raum;
int anzAktiv;
NSButton* heuteTaste;

NSMutableArray*		aktivObjektArray;
NSMutableArray*		TagplanArray;
   NSMutableArray *   daySettingStringArray;
   
}
- (void)setTagplanVonObjekt:(int)dasObjekt;
- (NSArray*)setWochenplanForRaum:(int)derRaum mitWochenplanArray:(NSArray*)derWochenplanArray;
- (void)stundenplanzeigen:(NSArray*)stundenplan;
- (NSArray*)aktivArray;

@end

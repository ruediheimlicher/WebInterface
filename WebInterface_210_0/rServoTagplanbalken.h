//
//  rServoTagplanbalken.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rTaste.h"
#import "rTagplanbalken.h"
#import "defines.h"

@interface rServoTagplanbalken : rTagplanbalken
{

int					Raum;
int					Objekt;

int					Wochentag;

}
- (void)BalkenAnlegen;
//- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (NSArray*)StundenByteArray;
- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)drawRect:(NSRect)dasFeld;
- (void)setTitel:(NSString*)derTitel;
- (void)setObjekt:(NSNumber*)dieObjektNumber;
- (void)setRaum:(int)derRaum;
- (void)setWochentag:(int)derWochentag;
- (void)setAktiv:(int)derStatus;
- (void)setTagbalkenTyp:(int)derTyp;
- (void)AllTasteAktion:(id)sender;
- (int)Wochentag;
- (int)Raum;
- (int)Objekt;
- (NSArray*)StundenArray;
//- (NSArray*)StundenByteArray;
- (void)setStundenArrayAusByteArray:(NSArray*)derStundenByteArray;

- (NSInteger)tag;
- (NSString*)Titel;
@end

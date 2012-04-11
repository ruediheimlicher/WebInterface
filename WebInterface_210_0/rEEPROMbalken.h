//
//  rEEPROMbalken.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rTagplanbalken.h"

@interface rEEPROMbalken : rTagplanbalken 
{
}
- (void)BalkenAnlegen;
- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)AllTasteAktion:(id)sender;
- (void)drawRect:(NSRect)dasFeld;
- (void)setTitel:(NSString*)derTitel;
- (void)setObjekt:(NSNumber*)dieObjektNumber;
- (void)setRaum:(int)derRaum;
- (void)setRaumString:(NSString*)derRaumString;
- (void)setObjektString:(NSString*)derObjektString;
- (void)setWochentag:(int)derWochentag;
- (void)setWochentagString:(NSString*)derWochentagString;
- (void)setAktiv:(int)derStatus;
@end

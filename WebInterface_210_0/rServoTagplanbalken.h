//
//  rServoTagplanbalken.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rTaste.h"

@interface rServoTagplanbalken : NSView
{
NSTextField*		Titelfeld;
NSString*			Titel;
NSString*			RaumString;
NSString*			ObjektString;
NSString*			WochentagString;

int					Raum;
int					Objekt;
int					Typ;
int					Wochentag;
//int				tag;
int					mark;
int					Hoehe, Breite, Balkenbreite;
int					Elementbreite,  Elementhoehe, RandL, RandR, RandU;
int					aktiv;
int					changed;
int					TagbalkenTyp;
//int					AnzPlaene;

NSPoint						Nullpunkt;
NSMutableArray*				StundenArray;
NSMutableArray*				lastONArray;
}
- (void)BalkenAnlegen;
- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag;
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

- (int)tag;
- (NSString*)Titel;
@end
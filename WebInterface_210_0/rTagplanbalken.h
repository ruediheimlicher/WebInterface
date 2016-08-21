//
//  rTagplanbalken.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rTaste.h"

@interface rTagplanbalken : NSView 
{
NSTextField*		Titelfeld;
NSString*			Titel;
NSString*			RaumString;
NSString*			ObjektString;
NSString*			WochentagString;

int					raum;
int					objekt;
//int					tagbalkentyp;
int					wochentag;
NSInteger          tag;
int					mark;
int					Hoehe, Breite, Balkenbreite;
int					Elementbreite,  Elementhoehe, RandL, RandR, RandU;
int					aktiv;
int					changed;
//int					typ;

int					TagbalkenTyp;
//int					AnzPlaene;
   int            twistatus;
   int            local;

NSPoint				Nullpunkt;
NSMutableArray*	StundenArray;
NSArray*				StundenByteArray;
NSMutableArray*	lastONArray;
NSMutableIndexSet*  AktivtastenSet;
}
- (void)BalkenAnlegen;
- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)stundenplanzeigen;
- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (NSArray*)StundenByteArray;
- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)drawRect:(NSRect)dasFeld;
- (void)setTitel:(NSString*)derTitel;
- (void)setObjekt:(NSNumber*)dieObjektNumber;
- (void)setRaum:(int)derRaum;
- (void)setWochentag:(int)derWochentag;
- (void)setTWIStatus:(int)derStatus;
- (int)wochentag;
- (int)raum;
- (int)objekt;
- (int)tagbalkentyp;


- (void)setStundenByteArray:(NSArray*)derStundenArray;




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
- (void)setTag:(NSInteger)derTag;
- (NSString*)Titel;
@end

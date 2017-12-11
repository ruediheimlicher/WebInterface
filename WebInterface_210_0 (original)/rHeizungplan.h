//
//  rHeizungplan.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rHeizungplan : NSView 
{
NSString* Wochentag;
int							tag;
int							Hoehe, Breite, Balkenbreite;
int							Elementbreite,  Elementhoehe, RandL, RandR, RandU;
NSPoint						Nullpunkt;

NSMutableArray*				StundenArray;
//NSMutableArray*				ModeStundenArray;
//NSMutableArray*				StundenArray;

NSMutableArray*				lastONArray;
NSMutableArray*				lastModeTagArray;
NSMutableArray*				lastModeNachtArray;
}
- (void)setBrennerTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setModeTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setBrennerStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)setBrennerStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (NSArray*)BrennerStundenArrayForKey:(NSString*) derKey;
- (void)setModeStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (void)setModeStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;


- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (NSArray*)StundenArrayForKey:(NSString*) derKey;
- (void)setStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)drawRect:(NSRect)dasFeld;
@end

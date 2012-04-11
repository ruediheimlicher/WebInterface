//
//  rTagplan.h
//  
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rTagplan : NSView 
{
NSString*					Wochentag;
int							tag;
int							Hoehe, Breite, Balkenbreite;
int							Elementbreite,  Elementhoehe, RandL, RandR, RandU;
NSPoint						Nullpunkt;
NSPoint						Tagpunkt;
NSMutableArray*				StundenArray;
NSMutableArray*				ModeStundenArray;

NSMutableArray*				aktivArray;

NSMutableArray*				lastONArray;
NSMutableArray*				lastModeTagArray;
NSMutableArray*				lastModeNachtArray;


}
- (void)setWochentag:(int)derTag;
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey;
- (void)setStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (NSArray*)StundenArrayForKey:(NSString*) derKey;
- (void)drawRect:(NSRect)dasFeld;
@end

//
//  rEinschaltDiagramm.h
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rMehrkanalDiagramm.h"
#import "rLegende.h"

@interface rEinschaltDiagramm : rMehrkanalDiagramm
{
	 	int					anzBalken;
		NSMutableArray*	BalkenlageArray;
		NSMutableArray*	BalkenWerteArray;

		double				Brenndauer;
		
		rLegende*			Legende;

}
- (void)setOffsetY:(int)y;
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void) setAnzahlBalken:(int)dieAnzahl;
- (void)setLegende:(id)dieLegende;
- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
- (void)setZeitKompression:(float)dieKompression;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)waagrechteLinienZeichnen;
@end

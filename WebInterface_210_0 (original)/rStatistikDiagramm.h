//
//  rStatistikDiagramm.h
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rLegende.h"
#import "rMehrkanalDiagramm.h"
#import "defines.h"

@interface rStatistikDiagramm : rMehrkanalDiagramm
{
		NSMutableArray*	BalkenlageArray;
		double				Brenndauer;
		
		rLegende*			Legende;

}
//- (void)setOffsetY:(float)y;
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)setLegende:(id)dieLegende;
- (void)drawRect:(NSRect)rect;
- (void)waagrechteLinienZeichnen;
@end

//
//  rSolarStatistikDiagramm.h
//  WebInterface
//
//  Created by Sysadmin on 7.Maerz.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rStatistikDiagramm.h"
#import "defines.h"

@interface rSolarStatistikDiagramm : rStatistikDiagramm
{

}
//- (void)setOffsetY:(float)y;
//- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
//- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
//- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
//- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)setLegende:(id)dieLegende;
- (void)drawRect:(NSRect)rect;
- (void)waagrechteLinienZeichnen;
@end

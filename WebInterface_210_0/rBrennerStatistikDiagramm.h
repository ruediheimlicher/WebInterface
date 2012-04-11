//
//  rBrennerStatistikDiagramm.h
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rStatistikDiagramm.h"

@interface rBrennerStatistikDiagramm : rStatistikDiagramm
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

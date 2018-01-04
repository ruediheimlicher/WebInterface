//
//  rStromDiagramm.h
//  WebInterface
//
//  Created by Ruedi Heimlicher on 04.01.2018.
//
#import <Cocoa/Cocoa.h>
#import "rMehrkanalDiagramm.h"
#import "rDatenlegende.h"

@interface rStromDiagramm : rMehrkanalDiagramm
{
   
}
- (void)setOffsetY:(int)y;
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)waagrechteLinienZeichnen;

@end

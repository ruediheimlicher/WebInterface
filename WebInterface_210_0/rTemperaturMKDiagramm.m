//
//  rTemperaturMKDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rTemperaturMKDiagramm.h"


@implementation rTemperaturMKDiagramm

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		[DatenTitelArray replaceObjectAtIndex:0 withObject:@"V"]; // Vorlauf
		[DatenTitelArray replaceObjectAtIndex:1 withObject:@"R"];
		[DatenTitelArray replaceObjectAtIndex:2 withObject:@"A"];
		[DatenTitelArray replaceObjectAtIndex:7 withObject:@"I"];

        // Initialization code here.
    }
    return self;
}
- (void)setOffsetY:(int)y
{
[super setOffsetY:y];
}
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;

{

}
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
	[super setEinheitenDicY:derEinheitenDic];
}

- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal
{

}
- (void)setStartWerteArray:(NSArray*)Werte
{

}
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
[super setWerteArray:derWerteArray mitKanalArray:derKanalArray];
}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben
{

}

- (void)drawRect:(NSRect)rect
 {
   [super drawRect:rect];
}

@end

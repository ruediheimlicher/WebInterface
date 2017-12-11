//
//  rElektroStatistikDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rElektroStatistikDiagramm.h"


@implementation rElektroStatistikDiagramm

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	 {
		 
		 NSRect Diagrammfeld=frame;
		 
		 //		Diagrammfeld.size.width+=400;
		 //	Diagrammfeld.size.height-=200;
		 [self setFrame:Diagrammfeld];
		 DiagrammEcke=NSMakePoint(2.1,5.1);
		 Graph=[NSBezierPath bezierPath];
		 [Graph moveToPoint:DiagrammEcke];
		 lastPunkt=DiagrammEcke;
		 GraphFarbe=[NSColor blueColor]; 
		 OffsetY=0.0;
		 MinY=0.0;
		 ZeitKompression = 10.0;
		 StartwertX =0.0;
		 // Unterer Rand 25, oberer Rand 30
		 
		 FaktorY=MaxOrdinate/(MaxY-MinY); // Reduktion auf Feldhoehe
		 //NSLog(@"BrennerStatistikDiagramm Diagrammfeldhoehe: %2.2f FaktorY: %2.2f",(frame.size.height-55),FaktorY);
       int i=0;
		 NSMutableDictionary* StatistikEinheitenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		 [StatistikEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
		 [StatistikEinheitenDic setObject:[NSNumber numberWithInt:5]forKey:@"majorteile"];
		 [StatistikEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"nullpunkt"];
		 [StatistikEinheitenDic setObject:[NSNumber numberWithInt:50]forKey:@"maxy"];
		 [StatistikEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"miny"];
		 //[StatistikEinheitenDic setObject:[NSNumber numberWithFloat:[[ZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
		 [StatistikEinheitenDic setObject:@" °C"forKey:@"einheit"];
		 
		 //[Ordinate setAchsenDic: StatistikEinheitenDic];
		 
		 //[DatenTitelArray replaceObjectAtIndex:0 withObject:@"Mittel"]; // Mittel
		 //[DatenTitelArray replaceObjectAtIndex:1 withObject:@"R"];
		 //[DatenTitelArray replaceObjectAtIndex:2 withObject:@"A"];
		 //[DatenTitelArray replaceObjectAtIndex:7 withObject:@"I"];
		 
		 
    }
	 		//NSLog(@"BrennerStatistikDiagramm init");
		//[self logRect:[self frame]];

    return self;
}


- (int)tagDesJahres
{
NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
int dayOfYear = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]];
return dayOfYear;
}

/*
- (void)setOffsetX:(float)x
{
[super setOffsetX:x];
}
*/
/*
- (void)setOffsetY:(float)y
{
[super setOffsetY:y];
}
*/

- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;

{

}

- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
	[super setEinheitenDicY:derEinheitenDic];
	FaktorY=MaxOrdinate/(MaxY-MinY);
}

- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal
{

}
- (void)setStartWerteArray:(NSArray*)Werte
{

}


- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
   float offsetx = 4.0;
		//NSLog(@"TemperaturStatistikDiagramm setWerteArray");
		//[self logRect:[self frame]];

	//NSLog(@"BrennerStatistikDiagramm setWerteArray anz: %d WerteArray: %@ \nKanalArray: %@",[derWerteArray count],[derWerteArray description],[derKanalArray description]);
	//NSLog(@"ElektroStatistikDiagramm setWerteArray anz: %d WerteArray: %@",[derWerteArray count],[derWerteArray description]);
	
	//return;
	/*
	
	Kanal 0: tagdesjahres
	Kanal 1: pumpelaufzeit
	Kanal 2: elektrolaufzeit
    Kanal 3: ertrag
	
	 
	 NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	 
	 NSMutableDictionary* tempDictionary=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	 if ([[derWerteArray objectAtIndex:1]floatValue]==0)
	 {
	 return;
	 }
	 
	 */
	// [super setWerteArray:derWerteArray mitKanalArray:derKanalArray];
	 
	float	maxSortenwert=100.0;	// Temperatur, 100° entspricht 200
	float	SortenFaktor= 1.0;
	float	maxAnzeigewert=MaxY-MinY;
	float AnzeigeFaktor= maxSortenwert/maxAnzeigewert;
	int i=0;

   // Fusspunkt bestimmen
   NSPoint neuerPunkt=DiagrammEcke; // y ist unterer Rand
   //		NSLog(@"WertArray 0: %2.2f StartwertX: %2.2f ZeitKompression: %2.2f",[[derWerteArray objectAtIndex:0]floatValue],StartwertX,ZeitKompression);
   neuerPunkt.x=([[derWerteArray objectAtIndex:0]intValue]-StartwertX)*ZeitKompression+0.1;	//	Zeit, x-Wert, erster Wert im Array
   
   NSPoint fusspunkt=neuerPunkt;
   NSPoint pumpepunkt=neuerPunkt;
   NSPoint elektropunkt=neuerPunkt;
   NSPoint ertragpunkt=neuerPunkt;

   // pumpelaufzeit
   
   float pumpewert=[[derWerteArray objectAtIndex:1]floatValue];	// pumpelaufzeit
   
   pumpewert = (pumpewert-MinY)*FaktorY;								// Red auf reale Diagrammhoehe
   pumpepunkt.y += pumpewert;
   
   NSBezierPath* pumpeGraph=[NSBezierPath bezierPath];
   // Säulen
   [pumpeGraph setLineWidth:3.1];
   [pumpeGraph moveToPoint:fusspunkt];
   [pumpeGraph lineToPoint:pumpepunkt];
   //NSLog(@"setWerte pumpeGraph linewidth: %2.2f",[pumpeGraph lineWidth]);
   [[GraphArray objectAtIndex:1]appendBezierPath:pumpeGraph];
   
   // elektro
   fusspunkt.x += offsetx;
   elektropunkt.x += offsetx;
   
   // elektrolaufzeit
   float elektrowert=[[derWerteArray objectAtIndex:2]floatValue];	// pumpelaufzeit
   
   elektrowert = (elektrowert-MinY)*FaktorY;								// Red auf reale Diagrammhoehe
   elektropunkt.y += elektrowert;
   
   NSBezierPath* elektroGraph=[NSBezierPath bezierPath];
   // Säulen
   [elektroGraph setLineWidth:3.1];
   [elektroGraph moveToPoint:fusspunkt];
   [elektroGraph lineToPoint:elektropunkt];
   [[GraphArray objectAtIndex:2]appendBezierPath:elektroGraph];

   
   // ertrag
   fusspunkt.x += offsetx;
   ertragpunkt.x += 2*offsetx;
   
   // ertragwert
   float ertragwert=[[derWerteArray objectAtIndex:3]floatValue];	// ertrag
   
   ertragwert = (ertragwert-MinY)*FaktorY ;								// Red auf reale Diagrammhoehe
   ertragpunkt.y += ertragwert;
   
   //NSLog(@"ElektroStatistikDiagramm setWerteArray tag: %d ertragwert: %.2f",[[derWerteArray objectAtIndex:0]intValue],[[derWerteArray objectAtIndex:3]floatValue]);
   
   NSBezierPath* ertragGraph=[NSBezierPath bezierPath];
   // Säulen
   [ertragGraph setLineWidth:3.1];
   [ertragGraph moveToPoint:fusspunkt];
   [ertragGraph lineToPoint:ertragpunkt];
   [[GraphArray objectAtIndex:3]appendBezierPath:ertragGraph];

   
    [GraphKanalArray setArray:derKanalArray];

}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben
{

}

- (void)setLegende:(id)dieLegende
{
	Legende=dieLegende;
}


- (void)waagrechteLinienZeichnen
{
   [[NSGraphicsContext currentContext] setShouldAntialias:NO];
	NSRect AchsenRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	//AchsenRahmen.size.height-=14.9;
	//AchsenRahmen.origin.x+=5.1;
	//AchsenRahmen.origin.y+=5.1;
	AchsenRahmen.origin=DiagrammEcke;
	//NSLog(@"MK AchsenRahmen x: %f y: %f h: %f w: %f",AchsenRahmen.origin.x,AchsenRahmen.origin.y,AchsenRahmen.size.height,AchsenRahmen.size.width);
	
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:AchsenRahmen];
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	int i;
	NSPoint unten=DiagrammEcke;
	unten.x+=AchsenRahmen.size.width-1;
	NSPoint oben=unten;
	oben.x=unten.x;
	oben.y+=AchsenRahmen.size.height;//-10;
	//NSLog(@"Diagramm hight: %2.2f",AchsenRahmen.size.height-5.1);

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.2];
	
	//NSPoint rechts=unten;//
	//NSPoint links=unten;
	NSPoint rechts=DiagrammEcke;//
	rechts.x +=AchsenRahmen.size.width-1;
	NSPoint links=DiagrammEcke;
	
	float breiteY=AchsenRahmen.size.width-1;
	float Bereich=MaxY-MinY;
	float Schrittweite=255.0/(MajorTeileY*MinorTeileY);
	
	float delta=MaxOrdinate/255.0*Schrittweite;
	NSPoint MarkPunkt=links;
	//NSRect Zahlfeld=NSMakeRect(links.x-40,links.y-2,30,10);
	//NSLog(@"MKDiagramm	MajorTeile: %d MinorTeile: %d delta: %2.2f",MajorTeileY,MinorTeileY,delta);
	for (i=0;i<(MajorTeileY*MinorTeileY+1);i++)
	{
		MarkPunkt.x=links.x;
		//NSLog(@"i: %d rest: %d",i,i%MajorTeile);
		if (i%MinorTeileY)//Zwischenraum
		{
			//NSLog(@"i: %d ",i);
			//MarkPunkt.x-=breiteY;
			//[WaagrechteLinie moveToPoint:MarkPunkt];
		}
		
		else
		{
			MarkPunkt.x-=breiteY;
			[WaagrechteLinie moveToPoint:MarkPunkt];
			//	[NSBezierPath strokeRect: Zahlfeld];
			//NSLog(@"i: %d Zahl: %2.2f",i,Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt);
//			Zahl=[NSNumber numberWithFloat:Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt];
//			[[Zahl stringValue]drawInRect:Zahlfeld withAttributes:AchseTextDic];
		}
		[WaagrechteLinie lineToPoint:rechts];
		[WaagrechteLinie stroke];
		rechts.y+=delta;
		MarkPunkt.y+=delta;
	}
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:AchsenRahmen];
	//[NSBezierPath strokeRect:[self frame]];

}


- (void)drawRect:(NSRect)rect
{
	NSRect NetzBoxRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=10;
	NetzBoxRahmen.size.width-=15;
	NetzBoxRahmen.origin.x+=0.2;
	//NetzBoxRahmen.origin.y=2.1;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor blueColor]set];
	//[NSBezierPath strokeRect:NetzBoxRahmen];
	
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int i;
	NSPoint untenV=DiagrammEcke;
	NSPoint obenV=untenV;
	NSPoint links=untenV;
	obenV.x=untenV.x;
	obenV.y+=NetzBoxRahmen.size.height;
	NSPoint mitteH=DiagrammEcke;
	mitteH.y+=(NetzBoxRahmen.size.height)/256*NullpunktY;
	
	[SenkrechteLinie moveToPoint:untenV];
	[SenkrechteLinie lineToPoint:obenV];
	[SenkrechteLinie stroke];
	
	for (i=0;i<[NetzlinienX count];i++)
	{
		untenV.x=[[NetzlinienX objectAtIndex:i]floatValue];
		untenV.y=mitteH.y;
		obenV.x=untenV.x;
		obenV.y=[[NetzlinienY objectAtIndex:i]floatValue];
		[SenkrechteLinie moveToPoint:untenV];
		[SenkrechteLinie lineToPoint:obenV];
		[SenkrechteLinie stroke];
	}
	
	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	int k;
	NSPoint untenH=DiagrammEcke;
	NSPoint rechtsH=untenH;
	NSPoint linksH=untenH;
	rechtsH.x=untenH.x;
	rechtsH.x+=NetzBoxRahmen.size.width-5;
	/*
	 [WaagrechteLinie moveToPoint:untenH];
	 [WaagrechteLinie lineToPoint:rechtsH];
	 [WaagrechteLinie stroke];
	 */
	
	
	NSBezierPath* WaagrechteMittelLinie=[NSBezierPath bezierPath];
	
	NSPoint mitterechtsH=mitteH;
	mitterechtsH.y=mitteH.y;
	mitterechtsH.x+=NetzBoxRahmen.size.width-5;
	
	[WaagrechteMittelLinie moveToPoint:mitteH];
	[WaagrechteMittelLinie lineToPoint:mitterechtsH];
	//	[WaagrechteMittelLinie stroke];
	
	[self waagrechteLinienZeichnen];
	
	untenH.y=mitteH.y+100;
	rechtsH.y=mitterechtsH.y+100;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
	//	[WaagrechteLinie stroke];
	
	untenH.y=mitteH.y-100;
	rechtsH.y=mitterechtsH.y-100;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
	//	[WaagrechteLinie stroke];
	
	for (i=0;i<8;i++)
	{
		//NSLog(@"drawRect Farbe Kanal: %d Color: %@",i,[[GraphFarbeArray objectAtIndex:i] description]);
		if ([[GraphKanalArray objectAtIndex:i]intValue])
		{
			[(NSColor*)[GraphFarbeArray objectAtIndex:i]set];
			[[GraphArray objectAtIndex:i] setLineWidth:2.0];
			[[GraphArray objectAtIndex:i]stroke];
			//NSLog(@"linewidth: %2.2f",[[GraphArray objectAtIndex:i]lineWidth]);
			NSPoint cP=[[GraphArray objectAtIndex:i]currentPoint];
			cP.x+=2;
			cP.y-=12;
			[[DatenFeldArray objectAtIndex:i]setFrameOrigin:cP];
			//NSLog(@"drawRect: %@",[[DatenArray objectAtIndex:i]description]);
			
			NSString* AnzeigeString=[NSString stringWithFormat:@"%@: %@",[DatenTitelArray objectAtIndex:i],[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
//			[[DatenFeldArray objectAtIndex:i]setStringValue:AnzeigeString];
	//		[[DatenFeldArray objectAtIndex:i]setStringValue:[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
		}
	}
	
	
	
}
@end

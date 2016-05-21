//
//  rBrennerStatistikDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rBrennerStatistikDiagramm.h"


@implementation rBrennerStatistikDiagramm

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
		 
		 for (i=0;i<8;i++)
		 {
			 /* In super erledigt
			  
			  NSBezierPath* tempGraph=[NSBezierPath bezierPath];
			  [tempGraph retain];
			  float varRed=sin(i+(float)i/10.0)/3.0+0.6;
			  float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
			  float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
			  //NSLog(@"sinus: %2.2f",varRed);
			  NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
			  //NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
			  tempColor=[NSColor blackColor];
			  [tempColor retain];
			  //			[GraphFarbeArray addObject:tempColor];
			  //			[GraphArray addObject:tempGraph];
			  //			[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
			  [DatenArray addObject:[[NSMutableArray alloc]initWithCapacity:0]];
			  NSRect tempRect=NSMakeRect(0,0,55,18);
			  NSTextField* tempDatenFeld=[[NSTextField alloc]initWithFrame:tempRect];
			  NSFont* DatenFont=[NSFont fontWithName:@"Helvetica" size: 9];
			  
			  [tempDatenFeld setEditable:NO];
			  [tempDatenFeld setSelectable:NO];
			  [tempDatenFeld setStringValue:@""];
			  [tempDatenFeld setFont:DatenFont];
			  [tempDatenFeld setAlignment:NSLeftTextAlignment];
			  [tempDatenFeld setBordered:NO];
			  [tempDatenFeld setDrawsBackground:NO];
			  [self addSubview:tempDatenFeld];
			  [DatenFeldArray addObject:tempDatenFeld];
			  [DatenTitelArray addObject:@""];
			  */
		 }		
		 [DatenTitelArray replaceObjectAtIndex:0 withObject:@"Mittel"]; // Mittel
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
		//NSLog(@"TemperaturStatistikDiagramm setWerteArray");
		//[self logRect:[self frame]];

	//NSLog(@"BrennerStatistikDiagramm setWerteArray anz: %d WerteArray: %@ \nKanalArray: %@",[derWerteArray count],[derWerteArray description],[derKanalArray description]);
	
	//return;
	/*
	
	Kanal 0: Laufzeit (Saeulen)
	Kanal 1: 
	Kanal 2:(Vorlauf)
	
	 
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
	//StartwertX=0.0;
	//NSLog(@"MinY: %2.2f FaktorY: %2.2f SortenFaktor: %2.2f",MinY,FaktorY,SortenFaktor);
	//NSLog(@"StartwertX: %2.2f ZeitKompression: %2.2f",StartwertX,ZeitKompression);

	for (i=0;i<[derWerteArray count]-1; i++)
	{
		if ([[derKanalArray objectAtIndex:i]intValue])
		{
			
			int TagDesMonats;
			NSPoint neuerPunkt=DiagrammEcke;
			//			NSLog(@"WertArray 0: %2.2f StartwertX: %2.2f ZeitKompression: %2.2f",[[derWerteArray objectAtIndex:0]floatValue],StartwertX,ZeitKompression);
			neuerPunkt.x=([[derWerteArray objectAtIndex:0]floatValue]-StartwertX)*ZeitKompression+0.1;	//	Zeit, x-Wert, erster Wert im Array
			//			neuerPunkt.x=([[derWerteArray objectAtIndex:0]floatValue])*ZeitKompression+0.1;	//	Zeit, x-Wert, erster Wert im Array
			//neuerPunkt.x-=300;
			NSPoint neuerFusspunkt=neuerPunkt;
			//NSLog(@"BrennerstatistikDiagramm neuerPunkt %d StartwertX: %2.2f x: %2.2f",i,StartwertX,neuerPunkt.x);
			
			//float InputZahl=[[derWerteArray objectAtIndex:i+2]floatValue]/3600;	// laufzeit
// 20.1.09			
			float InputZahl=[[derWerteArray objectAtIndex:i+2]floatValue]/3600;	// laufzeit
			//NSLog(@"setWerteArray FaktorY: %2.2f",FaktorY);
			//			float graphZahl=(InputZahl-2*MinY)*FaktorY;								// Red auf reale Diagrammhoehe
			float graphZahl=(InputZahl-MinY)*FaktorY;								// Red auf reale Diagrammhoehe
			
			float rawWert=graphZahl;//*SortenFaktor;							// Wert fuer Anzeige des ganzen Bereichs
			
			/*
			 Die Anzeige wird auf den eingestellten Bereich gestreckt.
			 200 pixel fuer 10 Grad: Anzeigefaktor 2
			 
			 */
			//AnzeigeFaktor=2;
			float DiagrammWert=rawWert;//*AnzeigeFaktor;					// Anpassung an die Hoehe des Diagramms in Pixeln
			
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F",i,InputZahl,graphZahl,rawWert,DiagrammWert);
			
			neuerPunkt.y += DiagrammWert;
			NSPoint neuerEndpunkt=neuerPunkt;
			neuerEndpunkt.x +=10;
			
			//neuerPunkt.y=InputZahl;
			
			NSString* tempWertString=[NSString stringWithFormat:@"%2.2f",InputZahl];///2.0];
			
			NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:neuerPunkt.x],[NSNumber numberWithFloat:neuerPunkt.y],tempWertString,nil];
			NSDictionary* tempWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"x",@"y",@"wert",nil]];
			[[DatenArray objectAtIndex:i] addObject:tempWerteDic];
			
			NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
			
			/*
			 // Standard
			 if ([[GraphArray objectAtIndex:i]isEmpty]) // Anfang
			 {
			 neuerPunkt.x=DiagrammEcke.x;
			 [neuerGraph moveToPoint:neuerPunkt];
			 [[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			 
			 }
			 else
			 {
			 [neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
			 [neuerGraph lineToPoint:neuerPunkt];
			 [[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			 }		
			 */ 
			
			// Säulen
			[neuerGraph setLineWidth:4.0];
			[neuerGraph moveToPoint:neuerFusspunkt];
			[neuerGraph lineToPoint:neuerPunkt];
			[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			
			
			/*
			 // Waagrechte Balkenstücke
			 [neuerGraph setLineWidth:1.0];
			 [neuerGraph moveToPoint:neuerPunkt];
			 [neuerGraph lineToPoint:neuerEndpunkt];
			 [[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			 
			 */
			
			/* 
			 // Ringe
			 NSRect n=NSMakeRect(neuerPunkt.x-1, neuerPunkt.y-1, 3,3);
			 //[neuerGraph setLineWidth:1.0];
			 [neuerGraph moveToPoint:neuerPunkt];
			 [neuerGraph appendBezierPathWithOvalInRect:n];
			 [[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			 */
			
			
			//NSLog(@"setWerteArray neuerPunkt: x: %2.2f y: %2.2f",neuerPunkt.x,neuerPunkt.y);
		} // if Kanal
		
		[GraphKanalArray setArray:derKanalArray];

		
	continue;
		
		// 
		int Monat;
		int Jahr;
		int TagDesJahres;
		int TagDesMonats;
		
		if ([[derWerteArray objectAtIndex:i]objectForKey:@"calenderdatum"])
		{
			NSCalendarDate* aktDatum=[[derWerteArray objectAtIndex:i]objectForKey:@"calenderdatum"];
	//		TagDesMonats = [aktDatum dayOfMonth];
	//		Monat = [aktDatum monthOfYear];
	//		Jahr = [aktDatum yearOfCommonEra];
	//		TagDesJahres=[aktDatum dayOfYear];
	//		NSLog(@"TagDesMonats: %d Monat: %d Jahr: %d TagDesJahres: %d",TagDesMonats, Monat, Jahr,TagDesJahres);
		}// if datum
		
		continue;
		
		
	}// for i
	// Kanal 0
	
	//NSLog(@"TemperaturStatistikDiagramm GraphArray: %@",[GraphArray description]);
	
	//[super setWerteArray:derWerteArray mitKanalArray:derKanalArray];
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
			[[GraphArray objectAtIndex:i] setLineWidth:4.0];
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

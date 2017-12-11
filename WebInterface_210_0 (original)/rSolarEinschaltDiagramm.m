//
//  rSolarEinschaltDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 05.November.10.
//  Copyright 2010 Ruedi Heimlicher. All rights reserved.
//

#import "rSolarEinschaltDiagramm.h"

#define	PumpeIndex				0
#define	ElektroIndex			1

#define  WasseralarmIndex		7


@implementation rSolarEinschaltDiagramm

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
       return self;
    }
    return self;
}


- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)derVorgabenDic
{
	/*
	 derVorgabenDic enthaelt:
	 - anzahl der Balken, die darzustellen sind. key: anzbalken
	 - Index des Wertes im Werterray, der darzustellen ist
	 
	 */
	//NSLog(@"SolarEinschaltDiagramm setWerteArray WerteArray: \n%@\n KanalArray: \n%@\n VorgabenDic: %@",[derWerteArray description],[derKanalArray description],[derVorgabenDic description]);
	//NSLog(@"SolarEinschaltDiagramm setWerteArray WerteArray: \n%@\n KanalArray: \n%@\n VorgabenDic: %@",[derWerteArray description],[derKanalArray description],[derVorgabenDic description]);

	int DatenIndex = -1;
	
	if ([derVorgabenDic objectForKey:@"anzbalken"]) // Anzahl der darzustellenden Balken
	{
		anzBalken = [[derVorgabenDic objectForKey:@"anzbalken"]intValue];
	}
	//NSLog(@"setWerteArray anzBalken: %d",anzBalken);
	
	if ([derVorgabenDic objectForKey:@"datenindex"]) // Index der darzustellenden Datenstelle in Wertearray
	{
		DatenIndex = [[derVorgabenDic objectForKey:@"datenindex"]intValue];
	}
	
	if (DatenIndex <0)
	{
		return;
	}
	
	//float DatenWert = [[derWerteArray objectAtIndex:DatenIndex]floatValue];
	int balkenindex=0;
	
	NSPoint neuerPunkt=DiagrammEcke;
	
	// Abszisse;
	neuerPunkt.x=[[derWerteArray objectAtIndex:0]floatValue]*ZeitKompression;	//	aktuelle Zeit, x-Wert, erster Wert im Array
	//NSLog(@"\n\n\tneuerPunkt.x: %2.2f",neuerPunkt.x);
	//Ordinate:
	NSColor* Balkenfarbe =[NSColor blackColor];
//	for (balkenindex = 0; balkenindex <anzBalken; balkenindex++)
	for (balkenindex = 0; balkenindex <8; balkenindex++)
	{
		if ([[derKanalArray objectAtIndex:balkenindex]intValue] && [derWerteArray count] > anzBalken) // Kanal soll dargestellt werden. Erster Wert ist Abszisse
		{
			int DatenWert = [[derWerteArray objectAtIndex:DatenIndex +1]intValue]; // Wert an Stelle Balkenindex: 0 oder 1. Erster Wert ist Abszisse
			
			
			
			
			int aktuellerWert=0;
			//NSLog(@"SolarEinschaltdiagramm balkenindex: %d DatenIndex: %d DatenWert: %d",balkenindex,DatenIndex,DatenWert);
/*			
// Experiment Bit 6,7	
			if (DatenWert == 7)
			{		
			DatenWert |= 0x80;
			}
			else if (DatenWert == 15)
			{
			DatenWert |= 0x40;
			}
*/
			
			// Daten filtern
			switch (balkenindex)
			{
				case PumpeIndex:
				{
					int PumpeON = DatenWert; 
					PumpeON &= 0x08;	// Bit 3, Wert 1 fuer Pumpe ON
					//NSLog(@" Datenwert: %d PumpeON: %d ",DatenWert, PumpeON);
					PumpeON >>= 3;
					aktuellerWert=PumpeON; //
					//NSLog(@"PumpeON: %d aktuellerWert: %d",PumpeON, aktuellerWert);
				}break;
					
				case ElektroIndex:
				{
					int ElektroON = DatenWert;
					ElektroON &= 0x10;	// Bit 4: 1: Elektro ON
					//NSLog(@" Datenwert: %d ElektroON: %d ",DatenWert, ElektroON);
					ElektroON>>=4;
					aktuellerWert=ElektroON;
					//NSLog(@"ElektroON: %d aktuellerWert: %d",ElektroON, aktuellerWert);
				}break;
					
					
			} // switch
			neuerPunkt.y= aktuellerWert;
			//NSDictionary* tempWerteDic;
			NSDictionary* lastWerteDic;
			
			//	DatenArray: Speichert fuer jeden Kanal einen Array mit Dics mit Werten fuer x und y
			
			int anzDaten=[DatenArray count];
			//NSLog(@"BrennerDiagramm setWerteArray i: %d anzDaten: %d",i,anzDaten);
			//NSLog(@"BrennerDiagramm setWerteArray  anzDaten: %d",anzDaten);
			//NSLog(@"DatenArray: %@",[DatenArray description]);
			
			if (anzDaten)		// Es hat schon Daten
			{
				lastWerteDic=[DatenArray objectAtIndex:DatenIndex];	//	Dic des letzten Events
				//NSLog(@"lastWerteDic: %@",[lastWerteDic description]);
			}
			else
			{
				//	Neuen Dic anlegen
				NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:(int)neuerPunkt.x],[NSNumber numberWithInt:(int)neuerPunkt.y],nil];
				lastWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"x",@"y",nil]];
				
			}
			
			
			// GraphArray
			// Enthält fuer jeden Kanal einen Array mit den Balkenstuecken (Dics mit zeit, x, y, eventuell end, start).
			/*
			if (balkenindex==0 && [GraphArray count])
			{
				//NSLog(@"GraphArray: %@",[GraphArray description]);
				NSArray* tempArray=[GraphArray objectAtIndex:0];
				if ([tempArray count])
				{
					NSDictionary* tempDic=[tempArray objectAtIndex:0];
					if (tempDic)
					{
						NSLog(@"SolarEinschaltdiagramm balkenindex: %d tempDic y: %d",balkenindex,[[tempDic objectForKey:@"y"]intValue]);
					}
				}
				//NSLog(@"GraphArray: start: %d x: %d y: %d",[[tempDic objectForKey:@"start"]intValue],[[tempDic objectForKey:@"x"]intValue],[[tempDic objectForKey:@"y"]intValue]);
			}
			*/
			
			if ([[GraphArray objectAtIndex:balkenindex] count])	// es hat schon Balkenstücke im Array mit index balkenindex
			{
				NSMutableDictionary* lastBalkenDic;
	//			NSColor* Balkenfarbe =[NSColor grayColor];
				// Pruefen, ob lastObject vorhanden und vollstaendig
				if ([[GraphArray objectAtIndex:balkenindex] lastObject] && [[[GraphArray objectAtIndex:balkenindex] lastObject]objectForKey:@"y"] &&  [[[GraphArray objectAtIndex:balkenindex] lastObject]objectForKey:@"x"])
				{
					lastBalkenDic= (NSMutableDictionary*)[[GraphArray objectAtIndex:balkenindex] lastObject]; // Dic des letzten Stücks
					//NSLog(@"°°°					lastBalkenDic alt: %@",[lastBalkenDic description]);
					
					
					if ([[lastBalkenDic objectForKey:@"y"]intValue]) // Objekt war ON, Balkenstück ist angelegt
					{	
						// Objektdauerabschnitt addieren
						//NSLog(@"***					Wert aus lastBalkenDic: %2.2f",[[lastBalkenDic objectForKey:@"x"]doubleValue]);
						Brenndauer += ([[derWerteArray objectAtIndex:0]doubleValue]-[[lastBalkenDic objectForKey:@"zeit"]doubleValue]);
						int Balkenwert=[[lastBalkenDic objectForKey:@"y"]intValue];
						
						//NSLog(@"SolarEinschaltdiagramm Balken war schon ON, balkenindex: %d Balkenwert: %d ",balkenindex,Balkenwert);
						switch(balkenindex)	// Farbe der Balkenlage zuordnen
						{
							case 0: // Brennerbalken
								Balkenfarbe=[NSColor redColor];
								break;
								
							case 1: // Uhrbalken
								Balkenfarbe=[NSColor greenColor];
								break;
								
							case 2: // Modebalken
								switch (Balkenwert) 
							{
								case 0:
									Balkenfarbe=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:0.5];
									break;
								case 1:
									//Balkenfarbe=[NSColor colorWithCalibratedRed:1.0 green:0.0 blue:1.0 alpha:0.5];
									Balkenfarbe=[NSColor yellowColor];
									break;
								case 2:
									Balkenfarbe=[NSColor blueColor];
									break;
									
							}// switch Balkenwert
								
							break;
							case 3: // Rinnebalken
							
								Balkenfarbe=[NSColor greenColor];
								break;

						}	//	switch Balkenindex
						
						
						if (neuerPunkt.y) // Objekt ist immer noch ON, Balkenstück verlängern: aktuelle Position setzen fuer drawRect
						{
							//NSLog(@"SolarEinschaltdiagramm Balken war schon ON, verlängern balkenindex: %d Balkenwert: %d ",balkenindex,Balkenwert);
							switch(balkenindex)	// 
							{
								case 0: // Uhrbalken
									Balkenfarbe=[NSColor redColor];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];							
									[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];
									[lastBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
									break;
									
								case 1: // Brennerbalken
									Balkenfarbe=[NSColor greenColor];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];							
									[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];
									[lastBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
									break;
									
								case 2: // Modebalken
									if (Balkenwert && aktuellerWert && !(Balkenwert == aktuellerWert))// Wechsel der Farbe
									{
										NSLog(@"Farbwechsel");
										// Endpunkt setzen
										[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"x"];	// Abszisse des Endpunktes
										[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"end"];	// Abszisse des Endpunktes
										[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
										[lastBalkenDic setObject:[NSNumber numberWithInt:0] forKey:@"y"];	// Objekt ist OFF
										
										// neuen Balken anlegen
										NSMutableDictionary* neuerBalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
										[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
										[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
										[neuerBalkenDic setObject:[NSNumber numberWithInt:aktuellerWert] forKey:@"y"];
										[neuerBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
										
										// neuen Balken addieren
										[[GraphArray objectAtIndex:balkenindex]addObject:neuerBalkenDic];										
										
									}
									else 
									{
									[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];							
									[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];
									
									[lastBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
									}
									

									
									
									break;
								
								case 3: // Rinnebalken
								{
								
									Balkenfarbe=[NSColor yellowColor];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
									[lastBalkenDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];							
									[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];
									[lastBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];

								}
								break;

									
							}	//	switch Balkenindex
							
							
							//NSLog(@"***					neuer Wert: %2.2f",neuerPunkt.x);
							//[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"x"];	// Abszisse des aktuellen Punktes
						
						}
						else	// Balken ist zu Ende: Endpunkt setzen
						{
							//[lastBalkenDic setObject:[NSNumber numberWithFloat:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"x"];	// Abszisse des Endpunktes
							//[lastBalkenDic setObject:[NSNumber numberWithFloat:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"end"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"x"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"end"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
							[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];	// Objekt ist OFF
						
						}
						
						//NSLog(@"					lastBalkenDic neu: %@",[lastBalkenDic description]);
					}
					else	// Objekt war OFF
					{
						if (neuerPunkt.y) // Objekt ist neu ON, neues Balkenstück anfangen
						{
							if (balkenindex==3) // Rinne
							{
								//NSLog(@"neues Balkenstueck anlegen aktuellerWert: %d x: %2.2f",aktuellerWert, neuerPunkt.x);
							}
							
							float Brenndauerstart=[[derWerteArray objectAtIndex:0]floatValue];
							//NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:0.0],nil];
							NSMutableDictionary* neuerBalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
							[neuerBalkenDic setObject:[NSNumber numberWithDouble:Brenndauerstart] forKey:@"zeit"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:aktuellerWert] forKey:@"y"];
							[neuerBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
							//NSMutableDictionary* neuerBalkenDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
							
							[[GraphArray objectAtIndex:balkenindex]addObject:neuerBalkenDic];
						}
						else	// Objekt ist immer noch OFF: nichts tun
						{
							
						}
						
						
					}
				}	// lastObject vorhanden
			}
			else	//Start, neues Balkenstück anlegen
			{
				if (neuerPunkt.y) // Objekt ist neu ON, neues Balkenstück anfangen
				{		
					int Balkenwert=(int)(neuerPunkt.y);//[[lastBalkenDic objectForKey:@"y"]intValue];
					
					
					switch(balkenindex)	// Farbe der Balkenlage zuordnen
					{
						case 0: // Brennerbalken
							Balkenfarbe=[NSColor redColor];
							break;
							
						case 1: // Uhrbalken
							
							Balkenfarbe=[NSColor greenColor];
							break;
							
						case 2: // Modebalken
							switch (Balkenwert) 
						{
							case 0:
								Balkenfarbe=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:0.5];
								break;
							case 1:
								//Balkenfarbe=[NSColor colorWithCalibratedRed:1.0 green:0.0 blue:1.0 alpha:0.5];
								Balkenfarbe=[NSColor yellowColor];
								break;
							case 2:
								Balkenfarbe=[NSColor blueColor];
								break;
								
						}// switch Balkenwert
							
							break;
							
							
						case 3: // Rinnebalken
							
							Balkenfarbe=[NSColor yellowColor];
							break;
							
					}	//	switch Balkenindex
					
					
					
					if (balkenindex==3)// Rinne
					{
						//NSLog(@"Start: neuer Balken anlegen aktuellerWert: %d x: %2.2f",aktuellerWert, neuerPunkt.x);
					}
					//NSLog(@"BrenndauerInt: %d",BrenndauerInt);
					int Brenndauerstart=[[derWerteArray objectAtIndex:0]intValue];
					//NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:0.0],nil];
					//NSMutableDictionary* neuerBalkenDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
					NSMutableDictionary* neuerBalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
					[neuerBalkenDic setObject:[NSNumber numberWithDouble:Brenndauerstart] forKey:@"zeit"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:aktuellerWert] forKey:@"y"];
					[neuerBalkenDic setObject:Balkenfarbe forKey:@"balkenfarbe"];
					[[GraphArray objectAtIndex:balkenindex]addObject:neuerBalkenDic];
				}
				
			}
			
		} // if kanalarray
		//NSLog(@"End balkenindex %d",balkenindex);
	} // for balkenindex
	
}


- (void)drawRect:(NSRect)rect 
{
	//NSLog(@"\nEinschaltDiagramm drawRect");
	NSRect NetzBoxRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	float breite=[[[self superview]superview]frame].size.width;
	//NSLog(@"Brennerdiagramm drawRect Breite alt: %2.2f",breite);
	//NetzBoxRahmen.size.width=breite;
	
//	[self setFrame:NetzBoxRahmen];
	
//	NSLog(@"EinschaltDiagramm drawRect width neu: %2.2f",[self frame].size.width);
  	
	
	NetzBoxRahmen.size.height-=15.9;
	NetzBoxRahmen.size.width-=15;
	NetzBoxRahmen.origin.x=5.2;
	NetzBoxRahmen.origin.y=2.1;
	//[[NSBezierPath bezierPathWithRect:NetzBoxRahmen]fill];
	//NSLog(@"EinschaltDiagramm NetzBoxRahmen x: %2.2f y: %2.2f h: %2.2f w: %2.2f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
	//[NSBezierPath fillRect:NetzBoxRahmen];

	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int i;
	NSPoint untenV=DiagrammEcke;
	NSPoint obenV=untenV;
	NSPoint links=untenV;
	obenV.x=untenV.x;
	obenV.y+=NetzBoxRahmen.size.height;

	[SenkrechteLinie moveToPoint:untenV];
	[SenkrechteLinie lineToPoint:obenV];
	[SenkrechteLinie stroke];

	for (i=0;i<[NetzlinienX count];i++)
	{
		untenV.x=[[NetzlinienX objectAtIndex:i]floatValue];
		obenV.x=untenV.x;
		obenV.y=[[NetzlinienY objectAtIndex:i]floatValue];
		[SenkrechteLinie moveToPoint:untenV];
		[SenkrechteLinie lineToPoint:obenV];
		[SenkrechteLinie stroke];
	}
	float Balkenlage=0.0;
	NSColor* BalkenFarbe=[NSColor redColor];
	[self waagrechteLinienZeichnen];
	
	//NSColor* BalkenFarbe=[NSColor redColor];
	//NSLog(@"EinschaltDiagramm BalkenlageArray: %@",[BalkenlageArray description]);
	for (i=0;i<8;i++)
	{
		int k=0;
		int BalkenlageIndex=i;
		if (i<[BalkenlageArray count])
		{
			//NSLog(@"EinschaltDiagramm drawRect Balkenlage: i: %d wert: %2.2f ",i,[[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]);
		}
		if ([GraphArray objectAtIndex:i] && [[GraphArray objectAtIndex:i]count]) // GraphArray vorhanden und nicht leer
		{
			switch(i)	// Balkenlage zuordnen
			{

				case 0: // Pumpebalken
				{
				//NSLog(@"drawRect Pumpe");
					BalkenlageIndex=0;
					//BalkenFarbe=[NSColor redColor];
				}	break;

				case 1: // Elektrobalken
				{
					//NSLog(@"drawRect Elektro");
					BalkenlageIndex=1;
					//BalkenFarbe=[NSColor grayColor];
				}	break;

				case 2: // Modebalken
					BalkenlageIndex=2;
					//BalkenFarbe=[NSColor greenColor];
					break;
					
				case 3: // Rinnebalken
					BalkenlageIndex=3;
					//BalkenFarbe=[NSColor greenColor];
					break;
					
			}	//	switch i
			
			//BalkenlageIndex=i;
			//NSLog(@"SolarEinschaltDiagramm GraphArray vorhanden und nicht leer Kanal: %d count: %d",i,[GraphArray count]);
			Balkenlage= [[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]; // PumpeBalken an unterster Stelle
			//NSLog(@"SolarEinschaltDiagramm drawRect Balkenlage: i: %d k: %d wert: %2.2f ",i,k,Balkenlage);
			Balkenlage +=4.0;
			for (k=0;k<[[GraphArray objectAtIndex:i]count];k++)
			{
				//NSLog(@"SolarEinschaltDiagramm drawRect i: %d GraphArray  %@",i,[[GraphArray objectAtIndex:i] description]);
				
				//Balkenlage= [[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]; // BrennerBalken an unterster Stelle
				//NSLog(@"SolarEinschaltDiagramm drawRect Balkenlage: i: %d k: %d wert: %2.2f ",i,k,Balkenlage);
				
				if ([GraphArray objectAtIndex:i]) // Startpunkt ist da
				{
					NSDictionary* tempGraphDic=[[GraphArray objectAtIndex:i]objectAtIndex:k];
					//if (k<2)
					//if (i==0)
					{
						//NSLog(@"SolarEinschaltDiagramm drawRect Balkenlage: %d  k: %d tempGraphDic y: %d",i,k,[[tempGraphDic objectForKey:@"y"]intValue]);
						//NSLog(@"SolarEinschaltDiagramm drawRect Balkenlage: i: %d wert: %2.2f ",i,Balkenlage);
						//NSLog(@"SolarEinschaltDiagramm drawRect Balkenlage: i: %d wert: %2.2f  k: %d tempGraphDic: %@",i,Balkenlage,k,[tempGraphDic description]);
					BalkenFarbe=[NSColor redColor];
					}
					
					if ([tempGraphDic objectForKey:@"balkenfarbe"])
					{
						BalkenFarbe=[tempGraphDic objectForKey:@"balkenfarbe"];
					}
					
					if (i==0)
					{
					//BalkenFarbe=[NSColor redColor];
					}

					//NSLog(@"SolarEinschaltDiagramm drawRect i %d Obj: %@",i, [[GraphArray objectAtIndex:i] description]);					NSDictionary* d=[GraphArray objectAtIndex:i];
					
					//NSLog(@"SolarEinschaltDiagramm drawRect i: %d Obj: %@ Balkenlage: %2.2f",i, [[GraphArray objectAtIndex:i] description],Balkenlage);
					NSPoint startPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"start"]floatValue],Balkenlage);
					
					NSBezierPath* tempPath=[NSBezierPath bezierPath];
					[tempPath setLineWidth:4.0];
					[tempPath moveToPoint:startPunkt];
					//NSLog(@"startPunkt x: %2.2f y: %2.2f",startPunkt.x, startPunkt.y);
					NSPoint endPunkt;
					if ([[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"end"]) // Endpunkt ist da
					{
						
						endPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"end"]floatValue],Balkenlage);
						
						
					}	// end ist da
					else
					{
						endPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"x"]floatValue],Balkenlage);
						
					}
					//NSLog(@"endPunkt x: %2.2f y: %2.2f",endPunkt.x, endPunkt.y);
					[tempPath lineToPoint:endPunkt];
					
					
					
					[BalkenFarbe set];
					[tempPath stroke];
					
					
				}	 // start ist da
				else
				{
					NSLog(@"SolarEinschaltDiagramm drawRect start nicht da");
				}
			}	// fork
		}	// if count
	}	// for i
	



}
@end

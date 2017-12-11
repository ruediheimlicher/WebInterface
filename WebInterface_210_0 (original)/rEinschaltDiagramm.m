//
//  rEinschaltDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 11.Februar.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rEinschaltDiagramm.h"

#define	BrennerIndex	0
#define	UhrIndex			1
#define	ModeIndex		2
#define  RinneIndex		3
	
@implementation rEinschaltDiagramm

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		//NSLog(@"EinschaltDiagramm awake: h: %2.2f",frame.size.height);
		//NSLog(@"rEinschaltDiagramm awake");
		NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
		DiagrammEcke=NSMakePoint(2.1,5.1);
		Graph=[NSBezierPath bezierPath];
		[Graph moveToPoint:DiagrammEcke];
		lastPunkt=DiagrammEcke;
		GraphFarbe=[NSColor blueColor]; 
		OffsetY=0.0;
		FaktorY=(frame.size.height-15.0)/255.0; // Reduktion auf Feldhoehe
		//NSLog(@"EinschaltDiagramm Diagrammfeldhoehe: %2.2f Faktor: %2.2f",(frame.size.height-15),FaktorY);
		GraphArray=[[NSMutableArray alloc]initWithCapacity:0];
		//GraphFarbeArray=[[NSMutableArray alloc]initWithCapacity:0];
		//[GraphFarbeArray retain];

		//GraphKanalArray=[[NSMutableArray alloc]initWithCapacity:0];
		//[GraphKanalArray retain];
		//DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		//[DatenArray retain];
		
		BalkenlageArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		BalkenWerteArray=[[NSMutableArray alloc]initWithCapacity:0];


		Brenndauer=0;
		int i;
		anzBalken=8;
		
		for (i=0;i<8;i++)
		{
			NSBezierPath* tempGraph=[NSBezierPath bezierPath];
			float varRed=sin(i+(float)i/10.0)/3.0+0.6;
			float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
			float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
			//NSLog(@"sinus: %2.2f",varRed);
			NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
			//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
			tempColor=[NSColor blackColor];
			[GraphFarbeArray addObject:tempColor];
			NSMutableArray* tempGraphArray=[[NSMutableArray alloc]initWithCapacity:0];
			[GraphArray addObject:tempGraphArray];
			[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
			NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
			//[DatenArray addObject:tempDatenArray];
			
			[BalkenlageArray addObject:[NSNumber numberWithInt:i]];
			
			

		}//for i
		
		//NSLog(@"Farbe Kanal:  ColorArray: %@",[GraphFarbeArray description]);
		MinorTeileY=2;
		MajorTeileY=4;
		MaxY=0.0;
		
		MinY=0.0;
		NullpunktY=10.0;
		ZeitKompression=1.0;
		MaxOrdinate= frame.size.height-15;
		NSNotificationCenter * nc;
		nc=[NSNotificationCenter defaultCenter];
/*
	
	nc=[NSNotificationCenter defaultCenter];
		
		[nc addObserver:self
		 selector:@selector(FrameDidChangeAktion:)
			 name:@"NSViewBoundsDidChangeNotification"
		   object:nil];
*/
		[nc addObserver:self
		   selector:@selector(StartAktion:)
			   name:@"data"
			 object:nil];

    }
    return self;
}


- (void)FrameDidChangeAktion:(NSNotification*)note
	{
		float breite=[[note object]frame].size.width;
		NSLog(@"BrennerDiagramm FrameDidChangeAktion: b: %2.2f Breite: %2.2f",[self bounds].size.width,breite);
		[self setNeedsDisplay:YES];
		NSRect r=[self bounds];
		r.size.width=breite+1;
		//[self setPostsBoundsChangedNotifications:NO];
		//[self setBounds:r];
		//[self setPostsBoundsChangedNotifications:YES];

	}

- (void)StartAktion:(NSNotification*)note
{
	//NSLog(@"BrennerDiagramm StartAktion note: %@",[[note userInfo]description]);
	[super StartAktion:note];
	//NSLog(@"BrennerDiagramm DatenserieStartZeit %@",DatenserieStartZeit);

}





- (void)setOffsetY:(int)y
{
[super setOffsetY:y];
}
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;

{

}
- (void) setAnzahlBalken:(int)dieAnzahl
{
	anzBalken=dieAnzahl;
	NSRect BalkenArrayRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	//NSLog(@"setAnzahlBalken: h: %2.2f",BalkenArrayRahmen.size.height);
	BalkenArrayRahmen.size.height-=4.9;
	BalkenArrayRahmen.origin.x+=5.1;
	BalkenArrayRahmen.origin.y+=2.1;
	float delta=BalkenArrayRahmen.size.height/anzBalken;
	[BalkenlageArray removeAllObjects];
	int i=0;
	for (i=0;i<anzBalken;i++)
	{	
		//NSLog(@"setAnzahlBalken: %2.2f",i*delta + delta);
		[BalkenlageArray addObject:[NSNumber numberWithFloat:i*delta + delta]];
	}
	//NSLog(@"BalkenlageArray: %@",[BalkenlageArray description]);
//	[self setNeedsDisplay:YES];
}





- (void)setLegende:(id)dieLegende
{
	Legende=dieLegende;
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
	//NSLog(@"BrennerDiagramm setWerteArray WerteArray: %@",[derWerteArray description]);//,[derKanalArray description]);
	int i;
	
	for (i=0;i<[derWerteArray count]-1;i++) // erster Wert ist Abszisse
	{
		if ([[derKanalArray objectAtIndex:i]intValue]) // der Kanal soll gezeigt werden
		{
		
		
			//NSLog(@"***			Brenner setWerteArray: Kanal: %d	x: %d",i,[[derWerteArray objectAtIndex:0]intValue]);
			NSPoint neuerPunkt=DiagrammEcke;
			neuerPunkt.x=[[derWerteArray objectAtIndex:0]floatValue]*ZeitKompression;	//	aktuelle Zeit, x-Wert, erster Wert im Array
			
			//neuerPunkt.y=[[derWerteArray objectAtIndex:i+1]intValue]; // Bits 0,1	aktueller Brennerstatus: 0 wenn ON
			
			
			int BrennerStatus=[[derWerteArray objectAtIndex:i+1]intValue]; // Wert 2 im Array
			//NSLog(@"BrennerStatus roh: %X",BrennerStatus);
			
			//int TagWert =[[derWerteArray objectAtIndex:i+2]intValue];
			int TagWert = BrennerStatus; //	Tagwert : Wert aus EEPROM
			int Stundenteil = BrennerStatus;	// Stundenteil, fuer halbe Stunde 0,1
			int BrennerOFF = BrennerStatus;
			BrennerOFF &= 0x04;	// Bit 2 
			
			neuerPunkt.y=BrennerOFF; //[[derWerteArray objectAtIndex:i+1]intValue]; // Bits 0,1	aktueller Brennerstatus: 0 wenn ON

			//NSLog(@"BrennerOFF def: %X",BrennerOFF);
			//NSLog(@"TagWert roh: %X",TagWert);
			TagWert &= 0x03;	// Bits 0, 1
			//NSLog(@"TagWert filter 1: %X",TagWert);
			//TagWert>>=4;
			//NSLog(@"TagWert def: %X",TagWert);
			Stundenteil &= 0x08;	// Bit 4: 0: erste halbe Stunde
			Stundenteil >>=3;		// verschieben an Pos 0
			//NSLog(@"Stundenteil def: %X",Stundenteil);
			//NSLog(@"Wert 1 aus Array: %d neuerPunkt.y: %2.2f TagWert: %d",[[derWerteArray objectAtIndex:i+1]intValue],neuerPunkt.y,TagWert);
			NSDictionary* tempWerteDic;
			NSDictionary* lastWerteDic;

			//	DatenArray: Speichert Dics mit Werten fuer x und y
			
			int anzDaten=[DatenArray count];
			//NSLog(@"BrennerDiagramm setWerteArray i: %d anzDaten: %d",i,anzDaten);
			//NSLog(@"DatenArray: %@",[DatenArray description]);
			
			if (anzDaten)		// Es hat schon Daten
			{
				lastWerteDic=[DatenArray objectAtIndex:i];	//	Dic des letzten Events
				//NSLog(@"i: %d lastWerteDic: %@",i, [lastWerteDic description]);
			}
			else
			{
				//	Neuen Dic anlegen
				NSLog(@"Neuen Dic anlegen");
				NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithInt:(int)neuerPunkt.x],[NSNumber numberWithInt:(int)neuerPunkt.y],nil];
				lastWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"x",@"y",nil]];
			
			}
			
			// GraphArray
			// Enthält fuer jeden Kanal einen Array mit den Balkenstuecken.
			
			//NSLog(@"GraphArray: %@",[GraphArray description]);
			if ([[GraphArray objectAtIndex:i] count])	// es hat schon Balkenstücke im Array mit index i
			{
				NSMutableDictionary* lastBalkenDic;
				// Pruefen, ob lastObject vorhanden und vollstaendig
				if ([[GraphArray objectAtIndex:i] lastObject] && [[[GraphArray objectAtIndex:i] lastObject]objectForKey:@"y"] &&  [[[GraphArray objectAtIndex:i] lastObject]objectForKey:@"x"])
				{
					lastBalkenDic= (NSMutableDictionary*)[[GraphArray objectAtIndex:i] lastObject]; // Dic des letzten Stücks
					//NSLog(@"°°°					lastBalkenDic alt: %@",[lastBalkenDic description]);
					
					
					if ([[lastBalkenDic objectForKey:@"y"]intValue]==0) // Brenner war ON, Balkenstück ist angelegt
					{	
						// Brenndauerabschnitt addieren
						//NSLog(@"***					Wert aus lastBalkenDic: %2.2f",[[lastBalkenDic objectForKey:@"x"]doubleValue]);
						Brenndauer += ([[derWerteArray objectAtIndex:0]doubleValue]-[[lastBalkenDic objectForKey:@"zeit"]doubleValue]);
						
						if (neuerPunkt.y==0) // Brenner ist immer noch ON, Balkenstück verlängern: aktuelle Position setzen fuer drawRect
						{
							//NSLog(@"***					neuer Wert: %2.2f",neuerPunkt.x);
							//[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"x"];	// Abszisse des aktuellen Punktes
							[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
							[lastBalkenDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];
						}
						else	// Balken ist zu Ende: Endpunkt setzen
						{
							//[lastBalkenDic setObject:[NSNumber numberWithFloat:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"x"];	// Abszisse des Endpunktes
							//[lastBalkenDic setObject:[NSNumber numberWithFloat:[[derWerteArray objectAtIndex:0]floatValue]] forKey:@"end"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"x"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"end"];	// Abszisse des Endpunktes
							[lastBalkenDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
							[lastBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.y] forKey:@"y"];	// Brenner ist OFF
						}
						//NSLog(@"					lastBalkenDic neu: %@",[lastBalkenDic description]);
					}
					else	// Brenner war OFF
					{
						if (neuerPunkt.y==0) // Brenner ist neu ON, neues Balkenstück anfangen
						{
							float Brenndauerstart=[[derWerteArray objectAtIndex:0]floatValue];
							//NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:0.0],nil];
							NSMutableDictionary* neuerBalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
							[neuerBalkenDic setObject:[NSNumber numberWithDouble:Brenndauerstart] forKey:@"zeit"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
							[neuerBalkenDic setObject:[NSNumber numberWithInt:0] forKey:@"y"];
							//NSMutableDictionary* neuerBalkenDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
							
							[[GraphArray objectAtIndex:i]addObject:neuerBalkenDic];
						}
						else	// Brenner ist immer noch OFF: nichts tun
						{
							
						}
						
						
					}
				}	// lastObject vorhanden
			}
			else	//neues Balkenstück anlegen
			{
				if (neuerPunkt.y==0) // Brenner ist neu ON, neues Balkenstück anfangen
				{
					//NSLog(@"neues Balkenstueck anlegen");
					//NSLog(@"BrenndauerInt: %d",BrenndauerInt);
					int Brenndauerstart=[[derWerteArray objectAtIndex:0]intValue];
					//NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:Brenndauerstart],[NSNumber numberWithDouble:0.0],nil];
					//NSMutableDictionary* neuerBalkenDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
					NSMutableDictionary* neuerBalkenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
					[neuerBalkenDic setObject:[NSNumber numberWithDouble:Brenndauerstart] forKey:@"zeit"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
					[neuerBalkenDic setObject:[NSNumber numberWithInt:0] forKey:@"y"];
					[[GraphArray objectAtIndex:i]addObject:neuerBalkenDic];
				}
				
			}
			
			//	Array fuer die Darstellung der Einschaltzeit der Schaltuhr
			if ([[GraphArray objectAtIndex:i+1] count])	// es hat schon Balkenstücke im Array mit index i+1
			{
			
			
			}
			else
			{
			
			}
			//
			//NSLog(@"Brenndauer: %2.2f",Brenndauer);
			int BrennInt=(int)Brenndauer;
			int Brennsekunden = BrennInt % 60;
			//NSLog(@"Brennsekunden: %d",Brennsekunden);
			BrennInt/=60;
			int Brennminuten = BrennInt % 60;
			//NSLog(@"Brennminuten: %d",Brennminuten);
			int Brennstunden = BrennInt/60;
			//NSLog(@"Brennstunden: %d",Brennstunden);
			//NSLog(@"Brenndauer: %2.2f  Brennerzeit: %2d:%2d:%2d",Brenndauer, Brennstunden,Brennminuten,Brennsekunden);
			NSString* SekundenString;
			if (Brennsekunden<10)
			{
				
				SekundenString=[NSString stringWithFormat:@"0%d",Brennsekunden];
			}
			else
			{
				SekundenString=[NSString stringWithFormat:@"%d",Brennsekunden];
			}

			NSString* MinutenString;
			if (Brennminuten<10)
			{
				
				MinutenString=[NSString stringWithFormat:@"0%d",Brennminuten];
			}
			else
			{
				MinutenString=[NSString stringWithFormat:@"%d",Brennminuten];
			}

			NSString* StundenString;
			if (Brennstunden<10)
			{
				
				StundenString=[NSString stringWithFormat:@" %d",Brennstunden];
			}
			else
			{
				StundenString=[NSString stringWithFormat:@"%d",Brennstunden];
			}


			NSString* BrenndauerString=[NSString stringWithFormat:@"%@:%@:%@",StundenString,MinutenString,SekundenString];
			//NSLog(@"Brenndauer: %2.2f BrenndauerString:%@",Brenndauer, BrenndauerString);

			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[NotificationDic setObject:[NSNumber numberWithDouble:Brenndauer] forKey:@"brenndauer"];
			[NotificationDic setObject:[NSNumber numberWithInt:Brennsekunden] forKey:@"sekunden"];
			[NotificationDic setObject:[NSNumber numberWithInt:Brennminuten] forKey:@"minuten"];
			[NotificationDic setObject:[NSNumber numberWithInt:Brennstunden] forKey:@"stunden"];
			[NotificationDic setObject:BrenndauerString forKey:@"brenndauerstring"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"Brenndauer" object:self userInfo:NotificationDic];

			if ([[derWerteArray objectAtIndex:i+1]floatValue]==0) // Brenner ON
			{
				
			}
			else
			{
			
			}
			NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithDouble:neuerPunkt.x],[NSNumber numberWithDouble:neuerPunkt.y],nil];
			tempWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"x",@"y",nil]];
			[[DatenArray objectAtIndex:i] addObject:tempWerteDic];
			
	//		neuerPunkt.y+=([[derWerteArray objectAtIndex:i+1]floatValue])*FaktorY;//	Data, y-Wert
	//		NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);



		
			//	*******
			//	Tagwert-Balken
			//	*******
					/*
					Tagwert:
					0:	OFF							__
					1:	zweite halbe Stunde ON	_|
					2:	erste halbe Stunde ON	|_
					3:	ganze Stunde ON			||
					
					aktueller Stundenteil:	0	erste halbe stunde
											1	zweite halbe Stunde
					*/
		//NSLog(@"BrennerDiagramm setWerteArray		**  Tagwert-Balken Kanal: %d " ,i+1);
		// Aktuelle Einstellung der Uhr
		int aktuellerUhrWert=0;
			switch (TagWert)	// Einstellung vom EEPROM
			{
			case 0: // Uhr ist OFF
			
			break;
			
			case 1:	// Zweite halbe Stunde ist ON
			if (Stundenteil)
			{
				aktuellerUhrWert=1;
			}
			
			break;
			
			case 2: //	Erste halbe Stunde ist ON
			if (Stundenteil==0)
			{
				aktuellerUhrWert=1;
			}
			
			break;
			
			case 3:	// Ganze Stunde ON
				aktuellerUhrWert=1;
			break;
			}	// switch TagWert
				
			
			//NSLog(@"Tagwert: %d Stundenteil: %d aktuellerUhrWert: %d",TagWert, Stundenteil, aktuellerUhrWert);
			if ([[GraphArray objectAtIndex:i+1] count])	// es hat schon Balkenstücke im Array mit index i+1
			{
				//NSLog(@"GraphArray i+1 nicht leer: %@",[[GraphArray objectAtIndex:i+1] description]);
				NSMutableDictionary* lastTagwertDic;
				
				
				int UhrWarON = 0; // Uhr war bisher OFF
				// Pruefen, ob lastObject vorhanden und vollstaendig
				if ([[GraphArray objectAtIndex:i+1] lastObject] && [[[GraphArray objectAtIndex:i+1] lastObject]objectForKey:@"uhr"] &&  [[[GraphArray objectAtIndex:i+1] lastObject]objectForKey:@"x"])
				{
					lastTagwertDic= (NSMutableDictionary*)[[GraphArray objectAtIndex:i+1] lastObject]; // Dic des letzten Stücks
					//NSLog(@"°°°					lastTagwertDic: %@",[lastTagwertDic description]);
					
					int altUhrWert=[[lastTagwertDic objectForKey:@"uhr"]intValue];
					if (altUhrWert==1) // Uhr war ON, Balkenstück ist angelegt
					{
						if (aktuellerUhrWert) // Uhr ist immer noch ON, Balkenstueck verlaengern, aktuelle Position setzen fuer drawRect
						{
							[lastTagwertDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"]; // Zeit
							[lastTagwertDic setObject:[NSNumber numberWithDouble:neuerPunkt.x] forKey:@"x"];
							//NSLog(@"GraphArray i+1 Balkenstueck verlaengern: lastDic: %@",[lastTagwertDic description]);
						}
						else	// Balken ist zu Ende: Endpunkt setzen
						{
							[lastTagwertDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"x"];	// Abszisse des Endpunktes
							[lastTagwertDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"end"];	// Abszisse des Endpunktes
							[lastTagwertDic setObject:[NSNumber numberWithDouble:[[derWerteArray objectAtIndex:0]intValue]] forKey:@"zeit"];
							[lastTagwertDic setObject:[NSNumber numberWithInt:0] forKey:@"uhr"];	// Uhr ist OFF
							//NSLog(@"GraphArray i+1 Balkenstueck abschliessen: lastDic: %@",[lastTagwertDic description]);
						}
					}	// Uhr war ON
					else	// Uhr war OFF
					{
						if (aktuellerUhrWert==1)	// Uhr ist neu ON, neues Balkenstueck anfangen
						{
							NSMutableDictionary* neuerTagwertDic=[[NSMutableDictionary alloc]initWithCapacity:0];
							[neuerTagwertDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
							[neuerTagwertDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
							[neuerTagwertDic setObject:[NSNumber numberWithInt:1] forKey:@"uhr"];
							//NSLog(@"GraphArray i+1 neues Balkenstueck neuerDic: %@",[neuerTagwertDic description]);

							[[GraphArray objectAtIndex:i+1]addObject:neuerTagwertDic]; 
						
						}
						else	// Uhr ist immer noch OFF: nichts tun
						{
						
						
						}
					}
					
				}	// lastObject vorhanden
			}
			else	//neues Balkenstück anlegen
			{
				//NSLog(@"GraphArray i+1 ist leer");
				if (aktuellerUhrWert==1)	// Uhr ist neu ON, neues Balkenstueck anfangen
				{
					NSMutableDictionary* neuerTagwertDic=[[NSMutableDictionary alloc]initWithCapacity:0];
					[neuerTagwertDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
					[neuerTagwertDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"start"];
					[neuerTagwertDic setObject:[NSNumber numberWithInt:1] forKey:@"uhr"];
					//NSLog(@"GraphArray i+1 ist leer neuer Dic: %@",[neuerTagwertDic description]);
					[[GraphArray objectAtIndex:i+1]addObject:neuerTagwertDic]; 
				
				}
				else	// Uhr ist immer noch OFF: nichts tun
				{
				
				
				}
				
			}

			//	Ende Tagwert-Balken
			
		}// if Kanal
	}
	[GraphKanalArray setArray:derKanalArray];

	//[GraphKanalArray retain];
//	[self setNeedsDisplay:YES];
	//NSLog(@"BrennerDiagramm DatenArray: %@",[DatenArray description]);
}

- (void)setZeitKompression:(float)dieKompression
{
	float stretch = dieKompression/ZeitKompression;
	//NSLog(@"MKDiagramm setZeitKompression ZeitKompression: %2.2f dieKompression: %2.2f stretch: %2.2f",ZeitKompression,dieKompression,stretch);
	ZeitKompression=dieKompression;
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform scaleXBy: stretch yBy: 1.0];
	int i=0;
	if ([GraphArray count]==0)
	return;
	for (i=0;i<8;i++)
	{
		if ([GraphArray objectAtIndex:i] && [[GraphArray objectAtIndex:i] count])
		{
		//NSLog(@"i: %d GraphArray objectAtIndex:i: %@",i,[[GraphArray objectAtIndex:i] description]);
		int k=0;
		for (k=0;k<[[GraphArray objectAtIndex:i] count];k++)
		{
			if ( [[[GraphArray objectAtIndex:i]objectAtIndex:k] objectForKey:@"x"])
			{
			float x=[[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"x"]floatValue];
			x *= stretch;
			NSNumber* NumberX=[NSNumber numberWithFloat:x];
			[[[GraphArray objectAtIndex:i]objectAtIndex:k]setObject:NumberX forKey:@"x"];
			}
		
			if ( [[[GraphArray objectAtIndex:i]objectAtIndex:k] objectForKey:@"start"])
			{
			float x=[[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"start"]floatValue];
			x *= stretch;
			NSNumber* NumberX=[NSNumber numberWithFloat:x];
			[[[GraphArray objectAtIndex:i]objectAtIndex:k]setObject:NumberX forKey:@"start"];
			}
		
			if ( [[[GraphArray objectAtIndex:i]objectAtIndex:k] objectForKey:@"end"])
			{
			float x=[[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"end"]floatValue];
			x *= stretch;
			NSNumber* NumberX=[NSNumber numberWithFloat:x];
			[[[GraphArray objectAtIndex:i]objectAtIndex:k]setObject:NumberX forKey:@"end"];
			}
		
		
		
		}
		}
		
	} // for i
	
	/*	
	NSRect tempRect=[self frame];
	tempRect.size.width = tempRect.size.width * stretch;
	[self setFrame:tempRect];
	*/
	[self setNeedsDisplay:YES];
}



- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)derVorgabenDic
{
	/*
	 derVorgabenDic enthaelt:
	 - anzahl der Balken, die darzustellen sind. key: anzbalken
	 - Index des Wertes im Werterray, der darzustellen ist
	 
	 */
//NSLog(@"EinschaltDiagramm setWerteArray WerteArray: \n%@",[derWerteArray description]);
 //  NSLog(@"EinschaltDiagramm setWerteArray derKanalArray: \n%@",[derKanalArray description]);
	//NSLog(@"EinschaltDiagramm setWerteArray WerteArray: \n%@\n KanalArray: \n%@\n VorgabenDic: %@",[derWerteArray description],[derKanalArray description],[derVorgabenDic description]);

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
			//NSLog(@"Einschaltdiagramm balkenindex: %d DatenIndex: %d DatenWert: %d",balkenindex,DatenIndex,DatenWert);
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
				case BrennerIndex:
				{
					int BrennerOFF = DatenWert; 
					BrennerOFF &= 0x04;	// Bit 2, Wert 1 fuer Brenner OFF
					BrennerOFF >>=2;
					aktuellerWert=abs(BrennerOFF-1); // Wert invertiert
				}break;
					
				case UhrIndex:
				{
					int Stundenteil = DatenWert;
					int TagWert = DatenWert;
					TagWert &= 0x03;	// Bits 0, 1
					Stundenteil &= 0x08;	// Bit 3: 0: erste halbe Stunde
					Stundenteil >>=3;		// verschieben an Pos 0
					// Aktuelle Einstellung der Uhr
					aktuellerWert=0;
					switch (TagWert)	// Einstellung vom EEPROM
					{
						case 0: // Uhr ist OFF
							
							break;
							
						case 1:	// Zweite halbe Stunde ist ON
							if (Stundenteil)
							{
								aktuellerWert=1;
							}
							
							break;
							
						case 2: //	Erste halbe Stunde ist ON
							if (Stundenteil==0)
							{
								aktuellerWert=1;
							}
							break;
							
						case 3:	// Ganze Stunde ON
							aktuellerWert=1;
							break;
					}	// switch TagWert
					
					
					
				}break;
					
				case ModeIndex:
				{//
					int Mode = DatenWert;
					Mode &= 0x30; // Bit 5,4
					Mode >>=4;
					//NSLog(@"DatenWert: %d Mode: %d",DatenWert,Mode);
					aktuellerWert=Mode;
					//aktuellerWert=1;
				}break;
					
				case RinneIndex:
				{
					int Rinne=DatenWert;
					Rinne &= 0xC0; // Bit 6,7
					//NSLog(@"DatenWert: %d Rinne: %d",DatenWert,Rinne);
					//Rinne &= 0x0c; // Bit 6,7
					Rinne >>=6;
					//NSLog(@"DatenWert: %d  Rinne: %d",DatenWert,Rinne);
					aktuellerWert = Rinne;
					if (Rinne)
					{
					aktuellerWert=1;
					}
				
				}break;
					
			} // switch
			neuerPunkt.y= aktuellerWert;
			if (balkenindex==RinneIndex)
			{
				//NSLog(@"Einschaltdiagramm balkenindex: %d DatenWert: %d  **  aktuellerWert: %d, neuerPunkt.y: %2.2f",balkenindex,DatenWert,aktuellerWert,neuerPunkt.y);
			}
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
						NSLog(@"Einschaltdiagramm balkenindex: %d tempDic y: %d",balkenindex,[[tempDic objectForKey:@"y"]intValue]);
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
						
						//NSLog(@"Einschaltdiagramm Balken war schon ON, balkenindex: %d Balkenwert: %d ",balkenindex,Balkenwert);
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
							//NSLog(@"Einschaltdiagramm Balken war schon ON, verlängern balkenindex: %d Balkenwert: %d ",balkenindex,Balkenwert);
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

- (void)waagrechteLinienZeichnen
{
	float breite=[[[self superview]superview]bounds].size.width;
	//NSLog(@"Brennerdiagramm drawRect Breite: %2.2f",breite);
	NSRect BalkenArrayRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	
	//NSLog(@"waagrechteLinienZeichnen: h: %2.2f",BalkenArrayRahmen.size.height);

//BalkenArrayRahmen.size.width=breite;
	//[self setBounds:BalkenArrayRahmen];
	//BalkenArrayRahmen.size.height-=15.9;
	
//	BalkenArrayRahmen.size.height-=4.9;
	
	BalkenArrayRahmen.origin.x+=5.1;
	BalkenArrayRahmen.origin.y+=2.1;
	//NSLog(@"MK AchsenRahmen x: %f y: %f h: %f w: %f",BalkenArrayRahmen.origin.x,BalkenArrayRahmen.origin.y,BalkenArrayRahmen.size.height,BalkenArrayRahmen.size.width);
	
	[[NSColor blackColor]set];
	//[NSBezierPath fillRect:BalkenArrayRahmen];
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	float breiteY=BalkenArrayRahmen.size.width-1;
	NSPoint rechtsunten=DiagrammEcke; // Punkt am rechten Rand unten
	rechtsunten.x+=breiteY;
	
	NSPoint rechtsoben=rechtsunten;// Punkt am rechten Rand oben
	
	rechtsoben.y+=BalkenArrayRahmen.size.height-10.0;//anzBalken;//-10;
	//NSLog(@"Diagramm Hight: %2.2f",BalkenArrayRahmen.size.height);

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.1];
	//unten=DiagrammEcke;
	NSPoint linksunten=DiagrammEcke;//
	NSPoint linksoben=linksunten;
	linksoben.y=rechtsoben.y;
	
	//NSLog(@"waagrechteLinienZeichnen anzBalken: %d count: %d",anzBalken,[BalkenlageArray count]);
	
	float delta=BalkenArrayRahmen.size.height/anzBalken;
	NSPoint MarkPunkt=linksunten;
	NSPoint ZielPunkt=rechtsunten;
	[WaagrechteLinie moveToPoint:MarkPunkt];
	[WaagrechteLinie lineToPoint:ZielPunkt];
//	[WaagrechteLinie stroke];

	//NSRect Zahlfeld=NSMakeRect(links.x-40,links.y-2,30,10);
	//NSLog(@"BrennerDiagramm	delta: %2.2f",delta);
	float Balkenlage;
	int BalkenlageIndex;
	for (BalkenlageIndex=0;BalkenlageIndex<[BalkenlageArray count];BalkenlageIndex++)
	{
		//MarkPunkt.x=links.x;
		//NSLog(@"i: %d rest: %d",i,i%MajorTeile);
		Balkenlage= [[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]; // BrennerBalken an unterster Stelle
		
		//NSLog(@"waagrechteLinienZeichnen BalkenlageIndex: %d Balkenlage: %2.2f",BalkenlageIndex,Balkenlage);
		
		ZielPunkt.y=Balkenlage;
		MarkPunkt.y=Balkenlage;

		[WaagrechteLinie moveToPoint:MarkPunkt];
		[WaagrechteLinie lineToPoint:ZielPunkt];
		[WaagrechteLinie stroke];
		//rechts.y+=delta;
		//MarkPunkt.y+=delta;
	}
//	MarkPunkt=linksoben;
//	ZielPunkt=rechtsoben;
	//NSLog(@"waagrechteLinienZeichnen last y: %2.2f",rechtsoben.y);
	[WaagrechteLinie moveToPoint:MarkPunkt];
	[WaagrechteLinie lineToPoint:ZielPunkt];
	[WaagrechteLinie stroke];

	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:BalkenArrayRahmen];
	//[NSBezierPath strokeRect:[self bounds]];

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

				case 0: // Uhrbalken
					BalkenlageIndex=0;
					//BalkenFarbe=[NSColor redColor];
					break;

				case 1: // Brennerbalken
					BalkenlageIndex=1;
					//BalkenFarbe=[NSColor grayColor];
					break;

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
			//NSLog(@"EinschaltDiagramm GraphArray vorhanden und nicht leer Kanal: %d",i);
			Balkenlage= [[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]; // BrennerBalken an unterster Stelle
			//NSLog(@"BrennerDiagramm drawRect Balkenlage: i: %d k: %d wert: %2.2f ",i,k,Balkenlage);
			Balkenlage +=4.0;
			for (k=0;k<[[GraphArray objectAtIndex:i]count];k++)
			{
				//NSLog(@"BrennerDiagramm drawRect i: %d GraphArray  %@",i,[[GraphArray objectAtIndex:i] description]);
				
				//Balkenlage= [[BalkenlageArray objectAtIndex:BalkenlageIndex]floatValue]; // BrennerBalken an unterster Stelle
				//NSLog(@"BrennerDiagramm drawRect Balkenlage: i: %d k: %d wert: %2.2f ",i,k,Balkenlage);
				
				if ([GraphArray objectAtIndex:i]) // Startpunkt ist da
				{
					NSDictionary* tempGraphDic=[[GraphArray objectAtIndex:i]objectAtIndex:k];
					//if (k<2)
					//if (i==0)
					{
						//NSLog(@"BrennerDiagramm drawRect Balkenlage: %d  k: %d tempGraphDic y: %d",i,k,[[tempGraphDic objectForKey:@"y"]intValue]);
						//NSLog(@"BrennerDiagramm drawRect Balkenlage: i: %d wert: %2.2f ",i,Balkenlage);
						//NSLog(@"BrennerDiagramm drawRect Balkenlage: i: %d wert: %2.2f  k: %d tempGraphDic: %@",i,Balkenlage,k,[tempGraphDic description]);
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

					//NSLog(@"BrennerDiagramm drawRect i %d Obj: %@",i, [[GraphArray objectAtIndex:i] description]);					NSDictionary* d=[GraphArray objectAtIndex:i];
					
					//NSLog(@"BrennerDiagramm drawRect i %d Obj: %@ Balkenlage: %2.2f",i, [[GraphArray objectAtIndex:i] description],Balkenlage);
					NSPoint startPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"start"]floatValue],Balkenlage);
					NSBezierPath* tempPath=[NSBezierPath bezierPath];
					[tempPath setLineWidth:4.0];
					[tempPath moveToPoint:startPunkt];
					NSPoint endPunkt;
					if ([[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"end"]) // Endpunkt ist da
					{
						
						endPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"end"]floatValue],Balkenlage);
						
					}	// end ist da
					else
					{
						endPunkt=NSMakePoint([[[[GraphArray objectAtIndex:i]objectAtIndex:k]objectForKey:@"x"]floatValue],Balkenlage);
						
					}
					
					[tempPath lineToPoint:endPunkt];
					
					
					
					[BalkenFarbe set];
					[tempPath stroke];
					
					
				}	 // start ist da
				else
				{
					NSLog(@"BrennerDiagramm drawRect start nicht da");
				}
			}	// fork
		}	// if count
	}	// for i
	



}

- (void)clean
{
	//NSLog(@"clean start");
	
	
	if (GraphArray &&[GraphArray count])
	{
		[GraphArray removeAllObjects];
	}
	if (GraphFarbeArray && [GraphFarbeArray count])
	{
		[GraphFarbeArray removeAllObjects];
	}
	
	if (GraphKanalArray &&[GraphKanalArray count])
	{
		[GraphKanalArray removeAllObjects];
	}
	//NSLog(@"DatenArray: retainCount: %d",[DatenArray retainCount]);
	if (DatenArray &&[DatenArray count])
	{
		
		//NSLog(@"DatenArray: %@",[DatenArray description]);
		//[DatenArray removeAllObjects];
	}
	if (BalkenlageArray &&[BalkenlageArray count])
	{
		[BalkenlageArray removeAllObjects];
	}
	
	int i;
	anzBalken=8;
	DiagrammEcke=NSMakePoint(2.1,5.1);
	lastPunkt=DiagrammEcke;
	
	for (i=0;i<8;i++)
	{
		//NSLog(@"clean i: %d",i);	
		//NSBezierPath* tempGraph=[NSBezierPath bezierPath];
		//[tempGraph retain];
		float varRed=sin(i+(float)i/10.0)/3.0+0.6;
		float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
		float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
		//NSLog(@"sinus: %2.2f",varRed);
		NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
		//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
		tempColor=[NSColor blackColor];
		[GraphFarbeArray addObject:tempColor];
		NSMutableArray* tempGraphArray=[[NSMutableArray alloc]initWithCapacity:0];
		[GraphArray addObject:tempGraphArray];
		[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
		NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		[DatenArray addObject:tempDatenArray];
		
		[BalkenlageArray addObject:[NSNumber numberWithInt:i]];
		
		
		
	}//for i
	[self setAnzahlBalken:4];
	//NSLog(@"clean end");
	
}
@end

//
//  rTagGitterlinien.m
//  WebInterface
//
//  Created by Sysadmin on 1.Januar.10.
//  Copyright 2010 Ruedi Heimlicher. All rights reserved.
//

#import "rTagGitterlinien.h"


@implementation rTagGitterlinien

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		//NSLog(@"rDiagrammGitterlinien awake");
		NSRect Diagrammfeld=frame;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
		DiagrammEcke=NSMakePoint(2.1,5.1);
		Graph=[NSBezierPath bezierPath];
		[Graph moveToPoint:DiagrammEcke];
		lastPunkt=DiagrammEcke;
		GraphFarbe=[NSColor blueColor]; 
		OffsetY=0.0;
		//NSLog(@"rDiagrammGitterlinien Diagrammfeldhoehe: %2.2f ",(frame.size.height-15));
		GraphArray=[[NSMutableArray alloc]initWithCapacity:0];
		GraphFarbeArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		GraphKanalArray=[[NSMutableArray alloc]initWithCapacity:0];
		//DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		//[DatenArray retain];
		
		NetzlinienY=[[NSMutableArray alloc]initWithCapacity:0];
		
		int i=0;
		
		NSBezierPath* tempGraph=[NSBezierPath bezierPath];
		float varRed=sin(i+(float)i/10.0)/3.0+0.6;
		float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
		float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
		//NSLog(@"sinus: %2.2f",varRed);
		NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
		//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
		tempColor=[NSColor grayColor];
		[GraphFarbeArray addObject:tempColor];
		//NSMutableDictionary* tempGraphDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		//[GraphArray addObject:tempGraphDic];
		[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
		NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		[DatenArray addObject:tempDatenArray];
		//NSMutableArray* NetzlinienY=[[NSMutableArray alloc]initWithCapacity:0];
		
		
		
		
		
		
		NullpunktY=10.1;
		ZeitKompression=10.0;
		MaxOrdinate= frame.size.height-15;
		Intervall = 1;
		Teile = 2;
		LinieOK=0; // keine Linie zeichnen
		
		DatenserieStartZeit=[[NSCalendarDate alloc]init];
		
		NSNotificationCenter * nc;
		nc=[NSNotificationCenter defaultCenter];
		
		
		[nc addObserver:self
			   selector:@selector(StartAktion:)
				   name:@"data"
				 object:nil];
		
		
    }
    return self;
}



- (void)StartAktion:(NSNotification*)note
{
	[super StartAktion:note];
	//NSLog(@"DiagrammGitterlinien StartAktion note: %@",[[note userInfo]description]);
	StartStunde=[DatenserieStartZeit hourOfDay];
	StartMinute=[DatenserieStartZeit minuteOfHour];
	//NSLog(@"DiagrammGitterlinien StartStunde: %d StartMinute: %d",StartStunde, StartMinute);
	
	
	
}





- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
	[super setEinheitenDicY:derEinheitenDic];
	if ([derEinheitenDic objectForKey:@"intervall"])
	{
		Intervall=[[derEinheitenDic objectForKey:@"intervall"]intValue];
	}
NSLog(@"TagGitterlinien setEinheitenDicY: Intervall: %d  ",Intervall );
}



- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
	{
		//NSLog(@"rTagGitterlinien setWerteArray WerteArray: %@ derKanalArray: %@",[derWerteArray description],[derKanalArray description]);
		int i;
		/*
		0:	TagDesJahres, Abszisse
		1: Datum dd.mm.jj
		
		2: TagDerWoche
		3: Monat
		4: Jahr
		*/
		for (i=0;i<[derWerteArray count]-1;i++) // erster Wert ist Abszisse
		{
			if ([[derKanalArray objectAtIndex:i]intValue]) // der Kanal soll gezeigt werden
			{
				
				
				//NSLog(@"***			Gitterlinien setWerteArray:	tagdesjahres: %d",[[derWerteArray objectAtIndex:0]intValue]);
				NSPoint neuerPunkt=DiagrammEcke;
				int TagDesJahres=[[derWerteArray objectAtIndex:0]intValue]; //tagdesjahres, Abszisse
				int Minute=0;
				NSCalendarDate* Calenderdatum=(NSCalendarDate*)[derWerteArray objectAtIndex:1];
				int TagDesMonats=[Calenderdatum dayOfMonth];
				int TagDerWoche=[Calenderdatum dayOfWeek];
				int Monat=[Calenderdatum monthOfYear];
				//NSLog(@"TagDesMonats: %d TagDerWoche: %d Monat: %d",TagDesMonats,TagDerWoche,Monat);
				int Art=0;	// Linie fuer Intervall
				LinieOK=0;
											neuerPunkt.x=([[derWerteArray objectAtIndex:0]floatValue]-StartwertX)*ZeitKompression+0.1;	//	aktueller Tag, x-Wert, erster Wert im Array

				
				if (Intervall < 60)
				{
					if (TagDesJahres % Intervall==0) // Rest ist null
					{	
						if (LinieOK==0) // Linie zeichnen
						{
							LinieOK=1;
							//NSLog(@"Gitterlinien  Intervall: %d  TagDesJahres: %d TagDerWoche: %d",Intervall, TagDesJahres,TagDerWoche);
							// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
							
							//NSLog(@"Gitterlinien neuerPunkt %d raw: %2.2f x: %2.2f",i,[[derWerteArray objectAtIndex:0]floatValue],neuerPunkt.x);							
							NSString* TagString=[NSString stringWithFormat:@"%d",TagDesMonats];
							Art=0;
							if (TagDerWoche==0) // Montag
							{
								Art = 1; // Taglinie
							}
							
							//NSLog(@"Gitterlinien TagString: %@ Art: %d",TagString,Art);
							
							//NSLog(@"GraphArray: %@",[GraphArray description]);
							NSMutableDictionary* tempLinienDic=[[NSMutableDictionary alloc]initWithCapacity:0];
							[tempLinienDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"x"];
							[tempLinienDic setObject:[NSNumber numberWithInt:Art] forKey:@"art"];
							
							[tempLinienDic setObject:TagString forKey:@"tagstring"];
							//NSMutableDictionary* tempLinienDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
							//NSLog(@"Gitterlinien tempLinienDic: %@",[tempLinienDic description]);				
							
							
							
							
							[GraphArray addObject:tempLinienDic];
							
							
							
							
							
						}// LinieOK
					} // %60
					else
					{
						LinieOK = 1;
					}
					
					
				// Monatsband zeichnen
				
				if (TagDesMonats==1) // erster Tag, senkrechte Linie zeichen, Monat angeben
				{
					Art=3;
					NSMutableDictionary* tempMonatDic=[[NSMutableDictionary alloc]initWithCapacity:0];
					[tempMonatDic setObject:[NSNumber numberWithFloat:neuerPunkt.x] forKey:@"m"];
					[tempMonatDic setObject:[NSNumber numberWithInt:Art] forKey:@"art"];
					NSArray* MonatArray=[NSArray arrayWithObjects:@"Januar",@"Februar",@"März",@"April",@"Mai",@"Juni",@"Juli",@"August",@"September",@"Oktober",@"November",@"Dezember",NULL];		
					[tempMonatDic setObject:[MonatArray objectAtIndex:Monat-1]forKey:@"monatstring"];
					[GraphArray addObject:tempMonatDic];
					
					
				}// erster Tag
					
					
				}// Intervall<60
				else
				{
				LinieOK=1;
					if (TagDesJahres == 0) // ganze Stunde ?????????
					{	
						//						int geradeStunde= (Stunde%2)==0;
						
						//						if ((Intervall == 120)&& ((Stunde%2)==1)) // Nur in geraden  Stunden zeichnen
						{
							LinieOK=1;
						}
						
						if (LinieOK==0) // Linie zeichnen
						{
							LinieOK=1;
							//NSLog(@"Gitterlinien  Intervall: %d  AnzeigeMinute: %d",Intervall, AnzeigeMinute);
							neuerPunkt.x=(TagDesJahres-StartwertX)*ZeitKompression;	//	aktuelle Zeit, x-Wert, erster Wert im Array
							// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
							
							NSString* ZeitString = @"00";
							NSString* tempStundenString;
							
							{
								Art = 1; // Stundenlinie
							}
							
							//NSLog(@"Gitterlinien ZeitString: %@",ZeitString);
							
							//NSLog(@"GraphArray: %@",[GraphArray description]);
							NSMutableDictionary* tempLinienDic=[[NSMutableDictionary alloc]initWithCapacity:0];
							[tempLinienDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
							[tempLinienDic setObject:[NSNumber numberWithInt:Art] forKey:@"art"];
							
							[tempLinienDic setObject:ZeitString forKey:@"zeitstring"];
							//NSMutableDictionary* tempLinienDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
							//NSLog(@"Gitterlinien tempLinienDic: %@",tempLinienDic);				
							[GraphArray addObject:tempLinienDic];
							
							
							
							
							
						}// LinieOK
					} // %60
					else
					{
						LinieOK = 0;
					}				
					
				}// Intervall>=60
				
				
				
				
				
				// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
				
				//NSLog(@"GraphArray: %@",[GraphArray description]);
				
				
				
				
				//		neuerPunkt.y+=([[derWerteArray objectAtIndex:i+1]floatValue])*FaktorY;//	Data, y-Wert
				//		NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);
				
				
			}// if Kanal
		}	// for i
		
		[GraphKanalArray setArray:derKanalArray];
		
		//[GraphKanalArray retain];
		//		[self setNeedsDisplay:YES];
		//NSLog(@"rDiagrammGitterlinien DatenArray: %@",[DatenArray description]);
	}
	
}

- (void)setZeitKompression:(float)dieKompression  mitAbszissenArray:(NSArray*)derArray
{
	//NSLog(@"Gitterlinien AbszissenArray: %@",[derArray description]);
	
	// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
	if ([GraphArray count])
	{
		[GraphArray removeAllObjects];
	}
	
	
	float stretch = dieKompression/ZeitKompression;
	//NSLog(@"Gitterlinien setZeitKompression ZeitKompression: %2.2f dieKompression: %2.2f stretch: %2.2f",ZeitKompression,dieKompression,stretch);
	ZeitKompression=dieKompression;
	
	int i;
	
	for (i=0;i<[derArray count];i++)
	{
		
		//NSLog(@"***			Gitterlinien setWerteArray:	x: %d",[[derArray objectAtIndex:i]intValue]);
		NSPoint neuerPunkt=DiagrammEcke;
		int Zeitwert=[[derArray objectAtIndex:i]intValue];
		int Minute=0;
		int AnzeigeMinute=0;
		//int laufendeMinute=(Zeitwert / 60); // Zeit ab Start
		
		if (StartMinute + Zeitwert / 60 >= 60) // erste Stunde voll
		{
			//StartMinute=0;
			//LinieOK=0;
		}
		
		Minute = StartMinute  + (Zeitwert / 60);
		AnzeigeMinute = (StartMinute  + (Zeitwert / 60))%60;
		
		//NSLog(@"***	  Gitterlinien Zeitwert (min): %d AnzeigeMinute: %d StartMinute: %d Minute: %d LinieOK: %d zeichnen: %d",Zeitwert/60,AnzeigeMinute,StartMinute,Minute,LinieOK,Minute % Intervall);
		int Art=0;	// Linie fuer Intervall
		if (AnzeigeMinute % Intervall==0) 
		{	
			if (LinieOK==0) // Linie zeichnen
			{
				LinieOK=1;
				//NSLog(@"Gitterlinien  Intervall: %d  AnzeigeMinute: %d",Intervall, AnzeigeMinute);
				neuerPunkt.x=Zeitwert*ZeitKompression;	//	aktuelle Zeit, x-Wert, erster Wert im Array
				// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
				
				
				
				NSString* ZeitString;
				
				if (StartStunde+ Minute / 60 >= 24) // Tag fertig
				{
					//StartStunde=0;
				}
				int Stunde = (StartStunde+ Minute / 60) % 24;
				//int AnzeigeStunde=
				
				if (AnzeigeMinute<10)
				{
					
					ZeitString=[NSString stringWithFormat:@"0%d",AnzeigeMinute];
				}
				else
				{
					ZeitString=[NSString stringWithFormat:@"%d",AnzeigeMinute];
				}
				NSString* tempStundenString;
				
				if (Stunde<10)
				{
					
					tempStundenString=[NSString stringWithFormat:@"0%d",Stunde];
				}
				else
				{
					tempStundenString=[NSString stringWithFormat:@"%d",Stunde];
				}
				
				ZeitString = [NSString stringWithFormat:@"%@:%@",tempStundenString,ZeitString];
				
				if (Minute % 60 ==0)	// neue Stunde
				{
					Art = 1; // Stundenlinie
				}
				
				//NSLog(@"Gitterlinien ZeitString: %@",ZeitString);
				
				//NSLog(@"GraphArray: %@",[GraphArray description]);
				NSMutableDictionary* tempLinienDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[tempLinienDic setObject:[NSNumber numberWithInt:neuerPunkt.x] forKey:@"x"];
				[tempLinienDic setObject:[NSNumber numberWithInt:Art] forKey:@"art"];
				
				[tempLinienDic setObject:ZeitString forKey:@"zeitstring"];
				//NSMutableDictionary* tempLinienDic=[NSMutableDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"start",@"x",@"y",nil]];
				//NSLog(@"Gitterlinien tempLinienDic: %@",tempLinienDic);				
				[GraphArray addObject:tempLinienDic];
				
				
				
				
				
			}// LinieOK
		} // %60
		else
		{
			LinieOK = 0;
		}
		
		// GraphArray	Array mit Dics fuer die senkrechten Zeitlinien
		
		//NSLog(@"GraphArray: %@",[GraphArray description]);
		
		
		
		
		//		neuerPunkt.y+=([[derWerteArray objectAtIndex:i+1]floatValue])*FaktorY;//	Data, y-Wert
		//		NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);
		
		
	}
	
	/*
	NSRect tempRect=[self frame];
	tempRect.size.width = tempRect.size.width * stretch;
	[self setFrame:tempRect];
	[self setNeedsDisplay:YES];
	*/
}

- (void)drawRect:(NSRect)rect
{
 	NSMutableDictionary* ZeitAttrs=[[NSMutableDictionary alloc]initWithCapacity:0];
	
 	NSMutableParagraphStyle* ZeitPar=[[NSMutableParagraphStyle alloc]init];
	[ZeitPar setAlignment:NSRightTextAlignment];
	[ZeitAttrs setObject:ZeitPar forKey:NSParagraphStyleAttributeName];
	NSFont* ZeitFont=[NSFont fontWithName:@"Helvetica" size: 9];
	
	[ZeitAttrs setObject:ZeitFont forKey:NSFontAttributeName];
	
	//NSLog(@"rTagGitterlinien drawRect");
	NSRect NetzBoxRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	float breite=[[[self superview]superview]frame].size.width;
	//NSLog(@"rDiagrammGitterlinien drawRect Breite alt: %2.2f",breite);
	//NetzBoxRahmen.size.width=breite;
	
	//	[self setFrame:NetzBoxRahmen];
	
	//NSLog(@"rTagGitterlinien drawRect width neu: %2.2f height: %2.2f",[self frame].size.width,[self frame].size.height);
  	
	
	NetzBoxRahmen.size.height-=16;
	NetzBoxRahmen.size.width-=15;
	NetzBoxRahmen.origin.x=0.2;
	NetzBoxRahmen.origin.y=4.1;
	//NSLog(@"rDiagrammGitterlinien NetzBoxRahmen x: %2.2f y: %2.2f h: %2.2f w: %2.2f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor yellowColor]set];
//	[NSBezierPath strokeRect:NetzBoxRahmen];
	
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int i;
	NSPoint TaguntenV=DiagrammEcke;
	NSPoint TagobenV=TaguntenV;
	NSPoint links=TaguntenV;
	
	TagobenV.x=TaguntenV.x;
	TagobenV.y+=NetzBoxRahmen.size.height-20;
	NSPoint TagSchriftPunkt=TagobenV;
	
	
	NSPoint MonatobenV=TaguntenV;
	//NSPoint Mlinks=TaguntenV;
	NSPoint MonatuntenV=DiagrammEcke;
				
	MonatobenV=MonatuntenV;
	

	NSPoint MonatSchriftPunkt=MonatobenV;
	MonatSchriftPunkt=TagobenV;
	//MonatSchriftPunkt.y -=10;
	TagSchriftPunkt.x -=5;
	//TagSchriftPunkt.y +=2;
	TagSchriftPunkt.y -=12;
	TagobenV.y -=15;
	[SenkrechteLinie setLineWidth:1.0];
	[SenkrechteLinie moveToPoint:TaguntenV];
	[SenkrechteLinie lineToPoint:TagobenV];
	[SenkrechteLinie stroke];
	
	//NSLog(@"Gitterlinien [GraphArray count]: %d",[GraphArray count]);
	for (i=0;i<[GraphArray count];i++)
	{
		
		if ([GraphArray objectAtIndex:i] ) // Dic vorhanden
		{
		
			int art=0;
			if ([[GraphArray objectAtIndex:i]objectForKey:@"art"])
			{
				art=[[[GraphArray objectAtIndex:i]objectForKey:@"art"]intValue];
			}
			
			if ([[GraphArray objectAtIndex:i]objectForKey:@"x"])
			{
				//NSLog(@"Gitterlinien [GraphArray objectAtIndex:i]: %@",[[GraphArray objectAtIndex:i] description]);
				
				TaguntenV.x=[[[GraphArray objectAtIndex:i]objectForKey:@"x"]floatValue];
				TagobenV.x=TaguntenV.x;
				TagSchriftPunkt.x = TaguntenV.x-4;
				[SenkrechteLinie setLineWidth:0.0];
				//			[SenkrechteLinie moveToPoint:TaguntenV];
				//			[SenkrechteLinie lineToPoint:TagobenV];
				//NSLog(@"Gitterlinien i: %d Art: %d",i,art);
				if (art==1)
				{
					//NSLog(@"Gitterlinien drucken",i,art);
					[[NSColor lightGrayColor]set];
					[SenkrechteLinie moveToPoint:TaguntenV];
					[SenkrechteLinie lineToPoint:TagobenV];
					
					[SenkrechteLinie stroke];
					if ([[GraphArray objectAtIndex:i]objectForKey:@"tagstring"]) // ZeitString
					{
						[[[GraphArray objectAtIndex:i]objectForKey:@"tagstring"]drawAtPoint:TagSchriftPunkt withAttributes:ZeitAttrs];
					}
					
				}
				else
				{
					//NSLog(@"Gitterlinien  nicht drucken",i,art);
					[[NSColor blueColor]set];
				}
				
			}//if x
			
			if ([[GraphArray objectAtIndex:i]objectForKey:@"m"])// Monat schreiben
			{
				MonatuntenV.x=[[[GraphArray objectAtIndex:i]objectForKey:@"m"]floatValue];
				MonatobenV.x=MonatuntenV.x;
				
				MonatSchriftPunkt.x = MonatuntenV.x;
				if (art==3)
				{
					//NSLog(@"Gitterlinien drucken",i,art);
					//[[NSColor lightGrayColor]set];
					//[SenkrechteLinie moveToPoint:TaguntenV];
					//[SenkrechteLinie lineToPoint:TagobenV];
					
					//[SenkrechteLinie stroke];
					if ([[GraphArray objectAtIndex:i]objectForKey:@"monatstring"]) // ZeitString
					{
						[[[GraphArray objectAtIndex:i]objectForKey:@"monatstring"]drawAtPoint:MonatSchriftPunkt withAttributes:ZeitAttrs];
					}
				}
				
				
			}// if m
			
		}
		
		
	}
	
	
	
	
}

- (void)clean
{
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
	
	if (DatenArray &&[DatenArray count])
	{
		[DatenArray removeAllObjects];
	}
	int i=0;
	NSBezierPath* tempGraph=[NSBezierPath bezierPath];
	float varRed=sin(i+(float)i/10.0)/3.0+0.6;
	float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
	float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
	//NSLog(@"sinus: %2.2f",varRed);
	NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
	//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
	tempColor=[NSColor blackColor];
	[GraphFarbeArray addObject:tempColor];
	NSMutableDictionary* tempGraphDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	//[GraphArray addObject:tempGraphDic];
	[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
	NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
	[DatenArray addObject:tempDatenArray];
	NSMutableArray* NetzlinienY=[[NSMutableArray alloc]initWithCapacity:0];
	
}



@end

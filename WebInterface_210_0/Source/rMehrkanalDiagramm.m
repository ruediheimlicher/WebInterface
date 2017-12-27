#import "rMehrkanalDiagramm.h"

/*
 
Funktion zur Umwandlung einer vorzeichenbehafteten 32 Bit Zahl in einen String
 
*/
 
void r_itoa(int32_t zahl, char* string) 
{
  uint8_t i;
 
  string[11]='\0';                  // String Terminator
  if( zahl < 0 ) {                  // ist die Zahl negativ?
    string[0] = '-';              
    zahl = -zahl;
  }
  else string[0] = ' ';             // Zahl ist positiv
 
  for(i=10; i>=1; i--) {
    string[i]=(zahl % 10) +'0';     // Modulo rechnen, dann den ASCII-Code von '0' addieren
    zahl /= 10;
  }
}

@implementation rMehrkanalDiagramm
- (void) logRect:(NSRect)r
{
	NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}


- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
      Util = [[Utils alloc ]init];
      //DatenserieStartZeit= [Util heute];
      DatenserieStartZeit= [NSDate date];
      
		// Add initialization code here
		NSRect Diagrammfeld=frameRect;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
		DiagrammEcke=NSMakePoint(2.1,5.1);
		Graph=[NSBezierPath bezierPath];
		[Graph moveToPoint:DiagrammEcke];
		lastPunkt=DiagrammEcke;
		GraphFarbe=[NSColor blueColor]; 
		OffsetY=0.0;
		StartwertX=1.0;
		FaktorY=(frameRect.size.height-15.0)/255.0; // Reduktion auf Feldhoehe
		//NSLog(@"MKDiagramm Diagrammfeldhoehe: %2.2f Faktor: %2.2f",(frameRect.size.height-15),FaktorY);
		GraphArray=[[NSMutableArray alloc]initWithCapacity:0];
		GraphFarbeArray=[[NSMutableArray alloc]initWithCapacity:0];
		GraphKanalArray=[[NSMutableArray alloc]initWithCapacity:0];
		GraphKanalOptionenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
		DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		// Feld fuer die Wertangabe am Ende der Datenlinie
		DatenFeldArray=[[NSMutableArray alloc]initWithCapacity:0];
		DatenWertArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		// Bezeichnung der Daten des Kanals
		DatenTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
		int i;
		
		
		for (i=0;i<8;i++)
		{
			NSBezierPath* tempGraph=[NSBezierPath bezierPath];
         
         [tempGraph setLineWidth:1.5];
			float varRed=sin(i+(float)i/10.0)/3.0+0.6;
			float varGreen=sin(2*i+(float)i/10.0)/3.0+0.6;
			float varBlue=sin(3*i+(float)i/10.0)/3.0+0.6;
			//NSLog(@"sinus: %2.2f",varRed);
			NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
			//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
			tempColor=[NSColor blackColor];
			[GraphFarbeArray addObject:tempColor];
			[GraphArray addObject:tempGraph];
			//[GraphKanalArray addObject:[NSMutableDictionary alloc]initWithCapacity:0]];
			[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
			[DatenArray addObject:[[NSMutableArray alloc]initWithCapacity:0]];
			NSRect tempRect=NSMakeRect(0,0,25,16);
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
         
         tempRect.origin.x += 1;
 			NSTextField* tempWertFeld=[[NSTextField alloc]initWithFrame:tempRect];
         
			[tempWertFeld setEditable:NO];
			[tempWertFeld setSelectable:NO];
			[tempWertFeld setStringValue:@""];
			[tempWertFeld setFont:DatenFont];
			[tempWertFeld setAlignment:NSRightTextAlignment];
			[tempWertFeld setBordered:NO];
			[tempWertFeld setDrawsBackground:NO];
			[self addSubview:tempWertFeld];
			[DatenWertArray addObject:tempWertFeld];
        
         
         
         
         
			[DatenTitelArray addObject:@""];
			// Bezeichnungen in Subklasse aendern
		}//for i
		
		//NSLog(@"Farbe Kanal:  ColorArray: %@",[GraphFarbeArray description]);
		MinorTeileY=2;
		MajorTeileY=4;
		MaxY=40.0;
		
		MinY=0.0;
		NullpunktY=10.0;
		ZeitKompression=1.0;
		MaxOrdinate= frameRect.size.height-15;
		
		NSNotificationCenter * nc;
		nc=[NSNotificationCenter defaultCenter];
		[nc addObserver:self
		   selector:@selector(StartAktion:)
			   name:@"data"
			 object:nil];

	}
	return self;
}

- (void)setTag:(int)derTag
{
	Tag= derTag;
}

- (void)setOrdinate:(id)dieOrdinate
{
	Ordinate=dieOrdinate;
}

- (void)setGraphFarbe:(NSColor*) dieFarbe forKanal:(int) derKanal
{
	[GraphFarbeArray replaceObjectAtIndex:derKanal withObject:dieFarbe];
}

- (void)setStartZeit:(NSCalendar*)dasDatum
{
DatenserieStartZeit = dasDatum;

}


- (void)StartAktion:(NSNotification*)note
{
	//NSLog(@"StartAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"datenseriestartzeit"])
	{
		DatenserieStartZeit= (NSCalendarDate*)[[note userInfo]objectForKey:@"datenseriestartzeit"];
		//NSLog(@"MehrkanalDiagramm DatenserieStartZeit %@",DatenserieStartZeit);
		
	}

}

- (void)setDiagrammlageY:(float)DiagrammlageY
{
	float x=[self frame].origin.x;
	[self setFrameOrigin:NSMakePoint(x,DiagrammlageY)];
	
}

- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
	//NSLog(@"setEinheitenDicY: %@",[derEinheitenDic description]);
	if ([derEinheitenDic objectForKey:@"einheit"])
	{
		Einheit=[derEinheitenDic objectForKey:@"einheit"];
	}
   

	
	if ([derEinheitenDic objectForKey:@"majorteile"])
	{
		MajorTeileY=[[derEinheitenDic objectForKey:@"majorteile"]intValue];
	}
	if ([derEinheitenDic objectForKey:@"minorteile"])
	{
		MinorTeileY=[[derEinheitenDic objectForKey:@"minorteile"]intValue];
	}
	if ([derEinheitenDic objectForKey:@"maxy"])
	{
		MaxY=[[derEinheitenDic objectForKey:@"maxy"]floatValue];
	}
	if ([derEinheitenDic objectForKey:@"miny"])
	{
		MinY=[[derEinheitenDic objectForKey:@"miny"]floatValue];
	}
	if ([derEinheitenDic objectForKey:@"nullpunkt"])
	{
		NullpunktY=[[derEinheitenDic objectForKey:@"nullpunkt"]intValue];
		
		//NSLog(@"EinheitenDicY %d  NullpunktY: %d",[[derEinheitenDic objectForKey:@"nullpunkt"]intValue],NullpunktY);
		
	}
	
	if ([derEinheitenDic objectForKey:@"zeitkompression"])
	{
		ZeitKompression=[[derEinheitenDic objectForKey:@"zeitkompression"]floatValue];
	//	[self setZeitKompression:[[derEinheitenDic objectForKey:@"zeitkompression"]floatValue]];
	
	}
	
	//if ([[[NSApp mainWindow] contentView] viewWithTag:Tag+1]) // Ordinate
	if (Ordinate)
	{
		//NSLog(@"Ordinate da");
		[Ordinate setAchsenDic:derEinheitenDic];
		//[[[[NSApp window] contentView] viewWithTag:Tag+1]setAchsenDic:derEinheitenDic];
	}
	else
	{
		//NSLog(@"Ordinate nicht da");
	}
	
	
	
	[self setNeedsDisplay:YES];
	
}

- (void)setOffsetX:(float)x
{
StartwertX=x;
//NSLog(@"setOffsetX: %2.2f",x);
}


- (void)setOffsetY:(int)y
{


}

- (float)GrundlinienOffset
{
	return GrundlinienOffset;
}

- (void)setGrundlinienOffset:(float)offset
{
	//NSLog(@"setGrundlinienOffset: %2.2f",offset);
	GrundlinienOffset=offset;
	DiagrammEcke.y = offset; 
	lastPunkt=DiagrammEcke;
	/*
		NSRect r=[self frame];
	r.size.height+=offset;
	[self setFrame:r];
	*/

}

- (void)setMaxOrdinate:(int)laenge
{

	MaxOrdinate=laenge;
	//NSLog(@"***   MKDigramm setMaxOrdinate: %d",MaxOrdinate);

}

- (int)MaxOrdinate
{
return MaxOrdinate;
}

- (void)setMaxEingangswert:(int)maxEingang
{
	MaxEingangsWert=maxEingang;

}


- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal
{
NSLog(@"setWert Kanal: %d  x: %2.2f y: %2.2f ",derKanal, derWert.x, derWert.y);


}

- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal
{


}

- (void)setStartWerteArray:(NSArray*)Werte
{
	NSLog(@"setStartWerteArray: %@ ",[Werte description]);
	float x=DiagrammEcke.x;
	int i;
	for (i=0;i<[Werte count];i++)
	{
		float y=[[Werte objectAtIndex:i]floatValue];
		[[GraphArray objectAtIndex:i]moveToPoint:NSMakePoint(x,y)];
		
	}
}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
	//NSLog(@"setWerteArray WerteArray: %@",[derWerteArray description]);//,[derKanalArray description]);
	int i;
	
	float	maxSortenwert=127.5;	// Temperatur, 100¡ entspricht 200
	float	SortenFaktor= 1.0;
	float	maxAnzeigewert=MaxY-MinY;
	float AnzeigeFaktor= maxSortenwert/maxAnzeigewert;
	//NSLog(@"setWerteArray: FaktorY: %2.2f MaxY; %2.2F MinY: %2.2F maxAnzeigewert: %2.2F AnzeigeFaktor: %2.2F",FaktorY,MaxY,MinY,maxAnzeigewert, AnzeigeFaktor);
	//NSLog(@"setWerteArray:SortenFaktor: %2.2f",SortenFaktor);

	for (i=0;i<[derWerteArray count]-1;i++) // erster Wert ist Abszisse
	{
		if ([[derKanalArray objectAtIndex:i]intValue])
		{
			//NSLog(@"+++			Temperatur  setWerteArray: Kanal: %d	x: %2.2f",i,[[derWerteArray objectAtIndex:0]floatValue]);
			NSPoint neuerPunkt=DiagrammEcke;
			neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue]*ZeitKompression;	//	Zeit, x-Wert, erster Wert im Array
			float InputZahl=[[derWerteArray objectAtIndex:i+1]floatValue];	// Input vom IOW, 0-255
			
			// Korrektur bei i=2: Aussentemperatur um 16 reduzieren
			if (i==2)
			{
				InputZahl -= 32;
            
			}
			if (i==6)
			{
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F",i,InputZahl);
	//		InputZahl=80;
			}
			
			float graphZahl=(InputZahl-2*MinY)*FaktorY;								// Red auf reale Diagrammhoehe
			
			float rawWert=graphZahl*SortenFaktor;							// Wert fuer Anzeige des ganzen Bereichs
			
			float DiagrammWert=(rawWert)*AnzeigeFaktor;
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F",i,InputZahl,graphZahl,rawWert,DiagrammWert);

			neuerPunkt.y += DiagrammWert;
			//neuerPunkt.y=InputZahl;
			//NSLog(@"setWerteArray: Kanal: %d MinY: %2.2F FaktorY: %2.2f",i,MinY, FaktorY);

			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F FaktorY: %2.2f graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F ",i,InputZahl,FaktorY, graphZahl,rawWert,DiagrammWert);

			NSString* tempWertString=[NSString stringWithFormat:@"%2.1f",InputZahl/2.0];
			//NSLog(@"neuerPunkt.y: %2.2f tempWertString: %@",neuerPunkt.y,tempWertString);

			NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:neuerPunkt.x],[NSNumber numberWithFloat:neuerPunkt.y],tempWertString,nil];
			NSDictionary* tempWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"x",@"y",@"wert",nil]];
			[[DatenArray objectAtIndex:i] addObject:tempWerteDic];
			
			NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
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
		}// if Kanal
	} // for i
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray retain];
//	[self setNeedsDisplay:YES];
}

- (void)setZeitKompression:(float)dieKompression
{
   if (dieKompression)
   {
      float stretch = dieKompression/ZeitKompression;
      //NSLog(@"MKDiagramm setZeitKompression ZeitKompression: %2.2f dieKompression: %2.2f stretch: %2.2f",ZeitKompression,dieKompression,stretch);
      ZeitKompression=dieKompression;
      NSAffineTransform *transform = [NSAffineTransform transform];
      //NSLog(@"MKDiagramm setZeitKompression a1");
      [transform scaleXBy:stretch  yBy: 1.0];
      //NSLog(@"MKDiagramm setZeitKompression a2");
      int i=0;
      if ([GraphArray count]==0)
      {
         //NSLog(@"MKDiagramm setZeitKompression a3");
         return;
      }
      for (i=0;i<8;i++)
      {
         
         if ([GraphArray objectAtIndex:i])// && ![[GraphArray objectAtIndex:i] isEmpty])
         {
            //NSLog(@"MKDiagramm setZeitKompression a11  i: %d",i);
            //NSLog(@"i: %d GraphArray objectAtIndex:i: %@",i,[[GraphArray objectAtIndex:i] description]);
            if ( ![[GraphArray objectAtIndex:i] isEmpty])
            {
               //NSLog(@"MKDiagramm setZeitKompression a12");
               [[GraphArray objectAtIndex:i] transformUsingAffineTransform: transform];
               //NSLog(@"MKDiagramm setZeitKompression a13");
               [[GraphArray objectAtIndex:i]stroke];
            }
         }
         //NSLog(@"MKDiagramm setZeitKompression a14 i: %d",i);
      } // for i
      //NSLog(@"MKDiagramm setZeitKompression a4");
      /*
       NSRect tempRect=[self frame];
       tempRect.size.width = tempRect.size.width * stretch;
       [self setFrame:tempRect];
       */
      
      [self setNeedsDisplay:YES];
      //NSLog(@"MKDiagramm setZeitKompression a5");
   }
}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben
{
//	NSLog(@"setWerteArray: %@ KanalArray: %@ dieVorgaben: %@",[derWerteArray description],[derKanalArray description],[dieVorgaben description] );
   NSLog(@"setWerteArray  KanalArray: %@ dieVorgaben: %@",[derKanalArray description],[dieVorgaben description] );

	int i;
	float faktorX=1.0;
	if ([dieVorgaben objectForKey:@"faktorx"])
	{
		faktorX=[[dieVorgaben objectForKey:@"faktorx"]floatValue];
	}
	float faktorY=1.0;
	if ([dieVorgaben objectForKey:@"faktory"])
	{
		faktorY=[[dieVorgaben objectForKey:@"faktory"]floatValue];
	}
	float offsetY=0.0;
	if ([dieVorgaben objectForKey:@"offsety"])
	{
		offsetY=[[dieVorgaben objectForKey:@"offsety"]floatValue];
	}
//	NSLog(@"setWerteArray: faktorX: %2.2f faktorY: %2.2f ",faktorX,faktorY);
	for (i=0;i<8;i++)
	{
		//NSLog(@"setWerteArray: Kanal: %d",i);
		NSPoint neuerPunkt=DiagrammEcke;
		neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue]*faktorX;
		neuerPunkt.y+=([[derWerteArray objectAtIndex:i+1]floatValue]*faktorY)+offsetY;
		//NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);

		NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
      
		[neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
		[neuerGraph lineToPoint:neuerPunkt];
		[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
	}
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray release];
	[self setNeedsDisplay:YES];
}

- (void)clear8Kanal
{
	//NSLog(@"MehrkanalDiagramm clear8Kanal");
	[Graph moveToPoint:DiagrammEcke];
	int i;
	for (i=0;i<8;i++)
	{
	
	[[GraphArray objectAtIndex:i]removeAllPoints];
	[[GraphArray objectAtIndex:i]moveToPoint:DiagrammEcke];
	}
	
	[NetzlinienX setArray:[NSArray array]];
	[NetzlinienY setArray:[NSArray array]];
	lastPunkt=DiagrammEcke;
	[self setNeedsDisplay:YES];
}


- (void)waagrechteLinienZeichnen
{
	NSRect AchsenRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	//AchsenRahmen.size.height-=14.9;

	AchsenRahmen.origin.x+=5.1;
	AchsenRahmen.origin.y+=5.1;
	//NSLog(@"MK AchsenRahmen x: %f y: %f h: %f w: %f",AchsenRahmen.origin.x,AchsenRahmen.origin.y,AchsenRahmen.size.height,AchsenRahmen.size.width);
	
	[[NSColor greenColor]set];
//	[NSBezierPath strokeRect:AchsenRahmen];
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	int i;
	NSPoint unten=DiagrammEcke;
	unten.x+=AchsenRahmen.size.width-1;
	NSPoint oben=unten;
	oben.x=unten.x;
	oben.y+=AchsenRahmen.size.height;//-10;
	//NSLog(@"Diagramm hight: %2.2f",AchsenRahmen.size.height);

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.2];
	
	NSPoint rechts=unten;//
	NSPoint links=unten;
	
	//MaxOrdinate=205.0;
	
	float breiteY=AchsenRahmen.size.width-1;
	float Bereich=MaxY-MinY;
	float Schrittweite=255.0/(MajorTeileY*MinorTeileY);
	float delta=MaxOrdinate/255.0*Schrittweite;
	NSPoint MarkPunkt=links;
	//NSRect Zahlfeld=NSMakeRect(links.x-40,links.y-2,30,10);
	//NSLog(@"MaxOrdinate: %2.2f",MaxOrdinate);
	
	//NSLog(@"MKDiagramm 	MajorTeile: %d MinorTeile: %d delta: %2.2f",MajorTeileY,MinorTeileY,delta);
	
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
	//NSLog(@"MKDiagramm drawRect");
	NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=10;
	NetzBoxRahmen.size.width-=15;
	//NetzBoxRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
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
         //[[GraphArray objectAtIndex:i]setLineWidth:4.5];
			[[GraphArray objectAtIndex:i]stroke];
			NSPoint cP=[[GraphArray objectAtIndex:i]currentPoint];
			//cP.x+=2;
			cP.y-=12;
			[[DatenFeldArray objectAtIndex:i]setFrameOrigin:cP];
			//NSLog(@"drawRect: %@",[[DatenArray objectAtIndex:i]description]);
			
         cP.x += 20;
 			[[DatenWertArray objectAtIndex:i]setFrameOrigin:cP];
       
         // in SolarDiagramm und SolarStatistikDiagramm verwendet
         [[DatenFeldArray objectAtIndex:i]setStringValue:[NSString stringWithFormat:@"%@:",[DatenTitelArray objectAtIndex:i]]];
         [[DatenWertArray objectAtIndex:i]setStringValue:[NSString stringWithFormat:@"%@",[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]]];
         
         
			//NSString* AnzeigeString=[NSString stringWithFormat:@"%@: %@",[DatenTitelArray objectAtIndex:i],[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
			//[[DatenFeldArray objectAtIndex:i]setStringValue:AnzeigeString];
			//		[[DatenFeldArray objectAtIndex:i]setStringValue:[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
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
	[GraphArray addObject:tempGraph];
	[GraphKanalArray addObject:[NSNumber numberWithInt:0]];
	[GraphKanalOptionenArray addObject:[[NSMutableDictionary alloc]initWithCapacity:0]];
	[DatenArray addObject:[[NSMutableArray alloc]initWithCapacity:0]];
	/*
	NSRect tempRect=NSMakeRect(0,0,25,18);
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
	*/
	[[DatenFeldArray objectAtIndex:i]setStringValue:@""];
}//for i

[self setNeedsDisplay:YES];
}
@end

//
//  rServoTagplanbalken.m
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rServoTagplanbalken.h"

@implementation rServoTagplanbalken

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
      TagbalkenTyp=2;
		RandL=60;
		RandR=20;
		RandU=2;
		aktiv=1;
		changed=0;
		TagbalkenTyp=9;
		if (StundenArray==NULL)
		{
			StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
		}
		
	}
    return self;
	
	
   
}

- (void)BalkenAnlegen
{
	
	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"Tagbalken init  Nullpunkt: x: %2.2f y: %2.2f", Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
	NSPoint Ecke=NSMakePoint(8.0,4.0);
	//NSLog(@"Tagbalken init: frame.height: %2.2f",[self frame].size.height);
	
	// Taste zum Schreiben des Plans anlegen
	NSRect WriteFeld=NSMakeRect(6,5.5,24,12);
	rTaste* WriteTaste=[[rTaste alloc]initWithFrame:WriteFeld];
	[WriteTaste setButtonType:NSMomentaryLight];
	[WriteTaste setTarget:self];
	[WriteTaste setBordered:YES];
	[[WriteTaste cell]setBackgroundColor:[NSColor yellowColor]];
	[[WriteTaste cell]setShowsStateBy:NSPushInCellMask];
   [WriteTaste setFont:[NSFont fontWithName:@"Helvetica" size:8]];
	[WriteTaste setTitle:@"E"];
	[WriteTaste setTag:Objekt];
	[WriteTaste setAction:@selector(WriteTasteAktion:)]; // Auszufuehrende Funktion
	[self addSubview:WriteTaste];
   
 	// Taste zum temporaerenSchreiben des Plans anlegen
	NSRect HeuteFeld=NSMakeRect(36,5.5,18,12);
	rTaste* HeuteTaste=[[rTaste alloc]initWithFrame:HeuteFeld];
	[HeuteTaste setButtonType:NSMomentaryLight];
	[HeuteTaste setTarget:self];
	[HeuteTaste setBordered:YES];
	[[HeuteTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[HeuteTaste cell]setShowsStateBy:NSPushInCellMask];
   [HeuteTaste setFont:[NSFont fontWithName:@"Helvetica" size:8]];
	[HeuteTaste setTitle:@"H"];
	[HeuteTaste setTag:Objekt];
	[HeuteTaste setAction:@selector(reportHeuteTaste:)]; // Auszufuehrende Funktion
	[self addSubview:HeuteTaste];
   
   
   

	//		Titelfeld=[[NSTextField alloc]initWithFrame:Titelrect];
	
	//[self addSubview:Titelfeld];
	//		[Titelfeld setAttributedStringValue:[[[NSAttributedString alloc] initWithString:@"" attributes:TitelAttrs] autorelease]];
	
	//Titel=[[NSAttributedString alloc]initWithString:@"Tagplan" attributes:TitelAttrs];
	
	Titel=@"ServoTagplan";
	//		[Titelfeld setAttributedStringValue:Titel];
	
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=5;
	//	Elementhoehe: Block mit Halbstundenfeldern und AllTaste
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	Elementhoehe=[self frame].size.height-5;
	//Elementhoehe=35;
	//NSLog(@"Servo Elementbreite: %d Elementhoehe: %d ",Elementbreite, Elementhoehe);
	for (i=0;i<24;i++)
	{
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"WS SetTagplanbalken i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		[ElementView setAutoresizesSubviews:NO];
		[self addSubview:ElementView];
		//		NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
//		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"code"];
		[StundenArray addObject:tempElementDic];
		//	NSLog(@"ServoTagplanbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
		/*
		NSRect StdFeldU=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
		StdFeldU.size.height = 6;
		//StdFeldU.origin.y+=8;
		rTaste* StundenTaste=[[[rTaste alloc]initWithFrame:StdFeldU]retain];
		[StundenTaste setButtonType:NSMomentaryLight];
		[StundenTaste setTag:i];

		[StundenTaste setTarget:self];
		[StundenTaste setBordered:YES];
		[[StundenTaste cell]setBackgroundColor:[NSColor grayColor]];
		[[StundenTaste cell]setShowsStateBy:NSPushInCellMask];
		[StundenTaste setTitle:@""];
		[StundenTaste setAction:@selector(StundenTasteAktion:)];
//		[self addSubview:StundenTaste];
		*/
	}//for i
	
	NSRect AllFeldO=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeldO.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeldO.size.height=9;
	AllFeldO.size.width/=1.8;
   AllFeldO.origin.y+=10;
	rTaste* AllTasteO=[[rTaste alloc]initWithFrame:AllFeldO];
	//	[AllTaste setButtonType:NSMomentaryLightButton];
	[AllTasteO setButtonType:NSMomentaryLight];
	[AllTasteO setTarget:self];
	[AllTasteO setBordered:YES];
   [AllTasteO setTag:1];
	[[AllTasteO cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[AllTasteO cell]setShowsStateBy:NSPushInCellMask];
	[AllTasteO setTitle:@""];
	[AllTasteO setAction:@selector(AllTasteAktion:)];
	[self addSubview:AllTasteO];
   
   NSRect AllFeldU=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeldU.origin.x+=Elementbreite+2;
	//AllFeldU+=8;
	AllFeldU.size.height=9;
	AllFeldU.size.width/=1.8;
   
	rTaste* AllTasteU=[[rTaste alloc]initWithFrame:AllFeldU];
	//	[AllTaste setButtonType:NSMomentaryLightButton];
	[AllTasteU setButtonType:NSMomentaryLight];
	[AllTasteU setTarget:self];
	[AllTasteU setBordered:YES];
   [AllTasteU setTag:0];
	[[AllTasteU cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[AllTasteU cell]setShowsStateBy:NSPushInCellMask];
	[AllTasteU setTitle:@""];
	[AllTasteU setAction:@selector(AllTasteAktion:)];
	[self addSubview:AllTasteU];

   
	//NSLog(@"ServoTagplanbalken end init");


}

- (void)setTag:(NSInteger)tagwert
{
//tag=tagwert;
mark=tagwert;
}



- (void)setTitel:(NSString*)derTitel
{
	//NSLog(@"Titel: %@ derTitel: %@",Titel, derTitel);

	Titel=[derTitel copy];
		//[derTitel release];
	//[Titelfeld setStringValue:Titel];
	
}


- (void)setObjekt:(NSNumber*)dieObjektNumber
{
	Objekt=[dieObjektNumber intValue];	
}


- (void)setRaum:(int)derRaum
{
	Raum=derRaum;
	
}

- (void)setTagbalkenTyp:(int)derTyp
{
	TagbalkenTyp=derTyp;
	
}


- (void)setWochentag:(int)derWochentag
{
	//tag=derWochentag;
	Wochentag=derWochentag;
	
}

- (void)setAktiv:(int)derStatus
{
aktiv=derStatus;
}

- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag
{
	if (StundenArray==NULL)
	{
		StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	}
		//tag=derTag;
		Wochentag=derTag;
	
		//NSLog(@"ServoTagplanbalken setTagplan Tag: %d StundenArray: %@",derTag, [derStundenArray description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		//if (derTag==0)
		{
		//NSLog(@"setTagplan index: %d: code: %d",i,[[[derStundenArray objectAtIndex:i]objectForKey:@"code"]intValue]);
		}

		if ([StundenArray objectAtIndex:i])
		{
			NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
			//NSLog(@"Dic schon da fuer index: %d",i);
			
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"code"] forKey:@"code"];
		}
		else
		{
			NSLog(@"setTagplan neuer Dic index: %d",i);
			NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"code"] forKey:@"code"];
			[StundenArray addObject:tempElementDic];
				
		}
	}//for i
	lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setBrennerTagplan end: Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	[self setNeedsDisplay:YES];
}




- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	NSDictionary* tempDic=[StundenArray objectAtIndex:dieStunde];
	if (tempDic && [tempDic objectForKey:derKey])
	{
		return [[tempDic objectForKey:derKey]intValue];
	}
	else
	{
		return -1;
	}
}

- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
NSLog(@"setStundenarraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
NSLog(@"Stundenarray vor : %@",[StundenArray description]);
NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];
//NSLog(@"Stundenarray nach : %@",[StundenArray description]);
//lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];
[self setNeedsDisplay:YES];

}

- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
	//NSLog(@"setStundenArray StundenArray: %@", [derStundenArray description]);
	
	int i;
	for (i=0;i<[derStundenArray count];i++)
	{
		int w=[[derStundenArray objectAtIndex:i]intValue];
		[self setStundenarraywert:w vonStunde:i forKey:derKey];
	}
		//NSDictionary* tempDic=[StundenArray objectAtIndex:i];			
		//NSLog(@"StundenArray:  %@",[[StundenArray valueForKey:@"kessel"]description]);
		
	
}

- (void)setStundenArrayAusByteArray:(NSArray*)derStundenByteArray
{
	//NSLog(@"setStundenArrayAusByteArray derStundenByteArray: %@",[derStundenByteArray description]);
	
	NSMutableArray* tempStundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];

	int i,k;
	for (i=0;i<6;i++)
	{
		
		//NSString* tempString=[[derStundenByteArray objectAtIndex:0]objectForKey:[bitnummerArray objectAtIndex:i]];
		NSString* tempString=[derStundenByteArray objectAtIndex:i];
		unsigned int tempByte=0;
		NSScanner *scanner;
		scanner = [NSScanner scannerWithString:tempString];
		[scanner scanHexInt:&tempByte];
      NSString* dezString = [NSString stringWithFormat:@"%d",tempByte];
		
		
		//NSLog(@"i: %d tempString: %@ tempByte hex: %2.2X dez: %d dezString: %@",i,tempString,tempByte,tempByte,dezString);
		NSMutableArray* tempStundenCodeArray=[[NSMutableArray alloc]initWithCapacity:4];
		for (k=0;k<4;k++)
		{
			uint8_t tempStundencode = tempByte & 0x03;
			//NSLog(@"k: %d tempStundencode hex: %2.2X dez: %d",k,tempStundencode,tempStundencode);
			[tempStundenCodeArray insertObject:[NSNumber numberWithInt:tempStundencode]atIndex:0];
			//[tempStundenArray addObject:[NSNumber numberWithInt:tempStundencode]];
			tempByte>>=2;
		
		}
		[tempStundenArray addObjectsFromArray:tempStundenCodeArray];
	}//for i
	//NSLog(@"setStundenArrayAusByteArray tempStundenArray: %@",[tempStundenArray description]);
	[self setStundenArray:tempStundenArray forKey:@"code"];
}


- (void)setNullpunkt:(NSPoint)derPunkt;
{
//Nullpunkt=derPunkt;
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		NSLog(@"setNullpunkt: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);

}

- (void)AllTasteAktion:(NSButton*)sender
{
//	NSLog(@"Servotagplanbalken AllTasteAktion tag: %d",[sender tag]);
	//NSLog(@"AllTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"AllTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"AllTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"AllTasteAktion: %@", [(rServoTagplanbalken*)[sender superview]Titel]);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	[NotificationDic setObject:[NSNumber numberWithInt:Raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:Objekt] forKey:@"objekt"];
	int modKey=0;
	int all=-1;
	if(([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)  != 0)
	{
		NSLog(@"AllTasteAktion alt"); // Alle Tage synchronisieren
		modKey=2;
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
			[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			//NSLog(@"ServoTagplanbalken AllTasteAktion modifier AllFeld");
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];

	}
	else if(([[NSApp currentEvent] modifierFlags] & NSControlKeyMask)  != 0)
   {
      NSLog(@"AllTasteAktion ctrl");
      modKey=3;

      if(([[NSApp currentEvent] modifierFlags] & NSCommandKeyMask)  != 0)
      {
         NSLog(@"AllTasteAktion ctrl und cmd");
      }
      [NotificationDic setObject:@"ctrl" forKey:@"mod"];
      [NotificationDic setObject:lastONArray forKey:@"lastonarray"];
      [NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
      [NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
      [NotificationDic setObject:[NSNumber numberWithInt:98] forKey:@"stunde"];
      //NSLog(@"StundenArray vor: %@",[[StundenArray valueForKey:@"code"]description]);

      for (int i=0;i<24;i++)
		{
			int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
         //NSLog(@"i: %d tag: %d ON: %d",i,[sender tag],ON);
         if ([sender tag])// obere Taste
         {
            if (ON<3)
            {
               ON++;
            }
         }
         else
         {
            if (ON>1)
            {
               ON--;
            }

         }
         //NSLog(@"i: %d tag: %d ON: %d",i,[sender tag],ON);
         [[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];
		}
      
      //NSLog(@"StundenArray nach: %@",[[StundenArray valueForKey:@"code"]description]);
      [NotificationDic setObject:[StundenArray  valueForKey:@"code"] forKey:@"stundenplanarray"];
      lastONArray=[[StundenArray valueForKey:@"code"]copy];
      [NotificationDic setObject:lastONArray forKey:@"lastonarray"];
      
      [NotificationDic setObject:[NSNumber numberWithInt:9] forKey:@"on"];	// code fuer All

      
      NSLog(@"lastONArray ctrl: %@",[lastONArray description]);
      //lastONArray = [StundenArray  valueForKey:@"code"];
      //NSLog(@"ServoTagplanbalken AllTasteAktion modifier AllFeld"); -> 
  //    [nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic]; -> AVR TagplancodeAktion
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];

      [self setNeedsDisplay:YES];

      //return;
   }
   else
	{
		//NSLog(@"AllTasteAktion Standard");
		modKey=0;
		int lastsum=0;
		int sum=0;
		int i;
		for (i=0;i<24;i++)
		{
			sum+=[[[StundenArray valueForKey:@"code"] objectAtIndex:i]intValue];
			lastsum+=[[lastONArray  objectAtIndex:i]intValue];
		}
		//NSLog(@"sum: %d lastsum: %d",sum, lastsum);
		if (sum==0)//alle sind off: IST wiederherstellen
		{
			if (lastsum) // lastOnArray enthält code
			{
				//NSLog(@"IST wiederherstellen");
				all=9;
			}
			else
			{
				all=3; // lastOnArray enthält noch keinen code, alle ON
			}
			
		}
		
		else if (sum==72)//alle sind ON,
		{
			//NSLog(@"Alle OFF");
			all=0;
		}
		else if (sum && sum<72)//mehrere on: alle ON
		{
			//NSLog(@"IST speichern");
			lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
			all=3;
		}
		//NSLog(@"sum: %d lastsum: %d all: %d",sum, lastsum,all);
		
		for (i=0;i<24;i++)
		{
			int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
			switch (all)
			{
					
					
				case 0://alle OFF schalten
				case 1://alle ON schalten
				case 2://alle ON schalten
				case 3://alle ON schalten
					ON=all;
					break;
				case 9://Wiederherstellen
					//NSLog(@"IST: lastONArray: %@",[lastONArray description]);
					ON=[[lastONArray objectAtIndex:i]intValue];
					break;
			}//switch all		
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];

		}
		
		
		[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];// All-Feld
		[NotificationDic setObject:[NSNumber numberWithInt:all] forKey:@"on"];	// code fuer All
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"]; // All-Feld
		[NotificationDic setObject:lastONArray forKey:@"lastonarray"]; //lastONArray uebergeben

		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
		//NSLog(@"all: %d code: %@",all, [[StundenArray valueForKey:@"code"]description]);
		if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
		{
			lastONArray=[[StundenArray valueForKey:@"code"]copy];
		}
		[self setNeedsDisplay:YES];
		
	}// Standard
	
}


- (void)StundenTasteAktion:(NSButton*)sender
{
	NSLog(@"Servo StundenTasteAktion tag: %d",[sender tag]);
	//NSLog(@"StundenTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"StundenTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"StundenTasteAktion: %d", [(rServoTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"StundenTasteAktion: %@", [(rServoTagplanbalken*)[sender superview]Titel]);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	
	[NotificationDic setObject:[NSNumber numberWithInt:Raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:Objekt] forKey:@"objekt"];
	//NSLog(@"StundentastenAktion start lastONArray: %@",[lastONArray description]);
	int modKey=0;
	int all=-1;
	if(([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)  != 0)
	{
		NSLog(@"StundenTasteAktion Alt");
		modKey=2;
			[NotificationDic setObject:@"alt" forKey:@"mod"];
		[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"stunde"];
		//[NotificationDic setObject:[NSNumber numberWithInt:3] forKey:@"on"];
		[NotificationDic setObject:[NSNumber numberWithInt:3] forKey:@"feld"];// Feld U

			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			NSLog(@"StundenTasteAktion Tagplan modifier");
//			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
//			modKey=0;
		
		
	}
//	else
	{
		//NSLog(@"StundenTasteAktion Standard");
		
		int ON=[[[StundenArray objectAtIndex:[sender tag]]objectForKey:@"code"]intValue];
		
		//NSLog(@"mouse in Stundentaste:	in Stunde: %d 		ON: %d",[sender tag], ON);
		switch (ON)
		{
			case 0://	ganze Stunde ON setzen
			case 1://	Kessel in der ersten halben Stunde schon ON
			case 2://	Kessel in der zweiten halben Stunde schon ON
				ON=3;//ganze Stunde ON
				break;
				
			case 3:// Kessel in der ganzen Stunde schon ON
				ON=0;//ganze Stunde OFF
				break;
				
		}
		[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"stunde"];
		[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
		[NotificationDic setObject:[NSNumber numberWithInt:3] forKey:@"feld"];// Feld U
		
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			//NSLog(@"Tagplan mofdifier StdFeldU");
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			modKey=0;
			
			//return;
		}
		
		//NSLog(@"ServoTagplanbalken mouseDow: Stunde: %d code: %d",i,ON);
		[[StundenArray objectAtIndex:[sender tag]]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];
		//NSLog(@"StundenArray: %@",[StundenArray description]);
		//[self setNeedsDisplay:YES];
		
		//NSLog(@"all: %d code: %@",all, [[StundenArray valueForKey:@"code"]description]);
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
		
		
		if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
		{
			lastONArray=[[StundenArray valueForKey:@"code"]copy];
		}
		//NSLog(@"StundentastenAktion end  lastONArray: %@",[lastONArray description]);
		
		[self setNeedsDisplay:YES];
		
	}//kein Alt
	
}// 



- (void)WriteTasteAktion:(id)sender
{
	//NSLog(@"WriteTasteAktion tag: %d",[sender tag]);
	//NSLog(@"Wochentag: %d", [(rServoTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"Raum: %d", [(rServoTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"Objekt: %d", [(rServoTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"Titel: %@", [(rServoTagplanbalken*)[sender superview]Titel]);
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:Raum] forKey:@"raum"];
	[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:[NSNumber numberWithInt:Objekt] forKey:@"objekt"];// 
	[NotificationDic setObject:[(rServoTagplanbalken*)[sender superview]Titel] forKey:@"titel"];//
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];//
   [NotificationDic setObject:[NSNumber numberWithInt:TagbalkenTyp] forKey:@"tagbalkentyp"];//
	//NSLog(@"rServoTagplanbalken WriteTasteAktion Typ: %d",tagbalkentyp);
	int modKey=0;
	//int all=-1;
	if(([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)  != 0)
	{
		//NSLog(@"WriteTasteAktion Alt-Taste");
		modKey=2;
		[NotificationDic setObject:[NSNumber numberWithInt:modKey] forKey:@"mod"];
		//[NotificationDic setObject:[NSArray array] forKey:@"stundenarray"];

		//NSLog(@"WriteTasteAktion  WriteModifier: %@",[NotificationDic description]);
		
		// Notific an Wochenplan schicken, um Stundenarrays der ganzen Woche fuer das Objekt zu laden
		// Von dort aus anschliessend an WriteModifieraktion in AVRClient schicken schicken
		
		[nc postNotificationName:@"WriteWochenplanModifier" object:self userInfo:NotificationDic];
		modKey=0;
		
		
	}
		else
	{
		
		[NotificationDic setObject:[NSNumber numberWithInt:modKey] forKey:@"mod"];
		[NotificationDic setObject:[StundenArray valueForKey:@"code"] forKey:@"stundenarray"];
		[NotificationDic setObject:[self StundenByteArray] forKey:@"stundenbytearray"];
		
		//NSLog(@"WriteTasteAktion  Standard: %@",[NotificationDic description]);
			
		// Notific an Wochenplan  und von dort an WriteStandardaktion in AVRClient schicken
		[nc postNotificationName:@"WriteStandard" object:self userInfo:NotificationDic];
	
	}//WriteTasteAktion Standard
	
}

- (IBAction)reportHeuteTaste:(id)sender
{
   NSLog(@"reportHeuteTaste  Raum: %d Wochentag: %d",Raum, Wochentag);
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:Raum] forKey:@"raum"];
	[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:[NSNumber numberWithInt:Objekt] forKey:@"objekt"];//
	[NotificationDic setObject:[(rServoTagplanbalken*)[sender superview]Titel] forKey:@"titel"];//
   [NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"permanent"];//

   int modKey=0;
	//int all=-1;
	if(([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)  != 0)
	{
		//NSLog(@"WriteTasteAktion Alt-Taste");
		modKey=2;
		[NotificationDic setObject:[NSNumber numberWithInt:modKey] forKey:@"mod"];
		//[NotificationDic setObject:[NSArray array] forKey:@"stundenarray"];
      
		//NSLog(@"WriteTasteAktion  WriteModifier: %@",[NotificationDic description]);
		
		// Notific an Wochenplan schicken, um Stundenarrays der ganzen Woche fuer das Objekt zu laden
		// Von dort aus anschliessend an WriteModifieraktion in AVRClient schicken schicken
		
		[nc postNotificationName:@"WriteWochenplanModifier" object:self userInfo:NotificationDic];
		modKey=0;
				
	}
   else
	{
		
		[NotificationDic setObject:[NSNumber numberWithInt:modKey] forKey:@"mod"];
		[NotificationDic setObject:[StundenArray valueForKey:@"code"] forKey:@"stundenarray"];
		[NotificationDic setObject:[self StundenByteArray] forKey:@"stundenbytearray"];
		
		//NSLog(@"WriteTasteAktion  Standard: %@",[NotificationDic description]);
      
		// Notific an Wochenplan  und von dort an WriteStandardaktion in AVRClient schicken
		[nc postNotificationName:@"WriteStandard" object:self userInfo:NotificationDic];
      
	}//WriteTasteAktion Standard


}



- (int)Wochentag
{
return Wochentag;
}

- (int)Raum
{
return Raum;
}

- (int)Objekt
{
return Objekt;
}

- (int)TagbalkenTyp
{
return TagbalkenTyp;
}



-(NSString*)Titel
{
return Titel;
}

- (NSArray*)StundenArray
{
return StundenArray;
}

- (NSArray*)StundenByteArray
{
	NSMutableArray* tempByteArray=[[NSMutableArray alloc]initWithCapacity:0];
	int i, k=3;
	uint8_t Stundenbyte=0;
	NSString* StundenbyteString=[NSString string];
	for (i=0;i<[StundenArray count];i++)
	{	
		uint8_t Stundencode=[[[StundenArray objectAtIndex:i] objectForKey:@"code"]intValue];
		//NSLog(@"StundenByteArray Tag: %d Objekt: %d Stundencode: %02X",Wochentag, Objekt, Stundencode);
		Stundencode=(Stundencode << 2*k);
		//NSLog(@"Stundencode <<: %02X",Stundencode);
		Stundenbyte |=Stundencode;
		//NSLog(@"i: %d      Stundenbyte: %02X",i,Stundenbyte);
		if (k==0)
		{
			
			NSString* ByteString=[NSString stringWithFormat:@"%02X ",Stundenbyte];
			//NSLog(@"      Stundenbyte: %02X ByteString: %@",Stundenbyte , ByteString);
			StundenbyteString=[StundenbyteString stringByAppendingString:ByteString] ;
			[tempByteArray addObject:[NSNumber numberWithInt:Stundenbyte]];
			Stundenbyte=0;
			k=3;
		}
		else
		{
			k--;
		}
		
	}// for i
	//NSLog(@"raum: %d Tag: %d objekt: %d StundenbyteString: %@ tempByteArray: %@",Raum,Wochentag, Objekt,StundenbyteString,[tempByteArray description]);
	return tempByteArray;
}

- (NSInteger)tag
{
//NSLog(@"rServoTagplanbalken tag: %d",mark);
return mark;
}
- (void)drawRect:(NSRect)dasFeld 
{

 //   NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:dasFeld];
	
	float vargray=0.8;
	//NSLog(@"sinus: %2.2f",varRed);
	NSColor* tempGrayColor=[NSColor colorWithCalibratedRed:vargray green: vargray blue: vargray alpha:0.8];
	[tempGrayColor set];
	[NSBezierPath fillRect:dasFeld];
	NSFont* StundenFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* StundenAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
	NSFont* TagFont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSDictionary* TagAttrs=[NSDictionary dictionaryWithObject:TagFont forKey:NSFontAttributeName];
	NSPoint TagPunkt=NSMakePoint(0.0,0.0);
	NSFont* TitelFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* TitelAttrs=[NSDictionary dictionaryWithObject:TitelFont forKey:NSFontAttributeName];

	//
	TagPunkt.x+=5;
	TagPunkt.y+=Elementhoehe*0.72;
	//NSLog(@"rServoTagplanbalken drawRect: Titel: %@",Titel);
	[Titel drawAtPoint:TagPunkt withAttributes:TitelAttrs];
   
   
	//NSLog(@"Tag: %d Tagpunkt x: %2.2f  y: %2.2f",tag, TagPunkt.x, TagPunkt.y);
//	[[Wochentage objectAtIndex:tag] drawAtPoint:TagPunkt withAttributes:TagAttrs];
	
   NSColor* hellGrau=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue: 0.0 alpha:0.1];
	NSColor* lightGreen=[NSColor colorWithCalibratedRed:0.0 green:1.0 blue: 0.1 alpha:0.3];
	NSColor* darkGreen=[NSColor colorWithCalibratedRed:0.0 green:0.8 blue: 0.2 alpha:1.0];

   
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=1.8;
	[[NSColor grayColor]set];
//	[NSBezierPath fillRect:AllFeld];
//	[NSBezierPath strokeRect:AllFeld];
	int i;
	for (i=0;i<24;i++)
	{
		//NSLog(@"drawRect: %2.2f",[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame].origin.x);
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		NSString* Stunde=[[NSNumber numberWithInt:i]stringValue];
		NSPoint p=StdFeld.origin;
		StdFeld.size.height-=10;
		p.y+=StdFeld.size.height;
		p.x-=4;
		if (i>9)
			p.x-=4;
		[Stunde drawAtPoint:p withAttributes:StundenAttrs];
		if (i==23)
		{
			Stunde=[[NSNumber numberWithInt:24]stringValue];
			p.x+=Elementbreite;
			[Stunde drawAtPoint:p withAttributes:StundenAttrs];
		}
      NSRect StdFeldU=StdFeld;
		StdFeldU.size.height /= 2;
      
		//StdFeldU.size.width-=2;
		//StdFeldU.origin.x+=5;
		NSRect StdFeldO=StdFeld;
		StdFeldO.origin.y+=(StdFeld.size.height/2);
		StdFeldO.size.height/=2;
      StdFeldO.origin.y=13;
      StdFeldO.size.height=8;

		//StdFeldO.size.width-=2;
		
		[[NSColor whiteColor]set];
		StdFeld.size.height-=1;
		StdFeld.origin.y+=1;
		NSBezierPath* Feldrand=[NSBezierPath bezierPathWithRect:StdFeld];
		[Feldrand fill];
		[[NSColor darkGrayColor]set];
		//[Feldrand setLineWidth:0.8];
//		[Feldrand stroke];
		NSRect StdFeldT=StdFeld;//Servo
		StdFeldT.size.height-=1;
		StdFeldT.size.width-=1;
		StdFeldT.origin.x+=0.5;
		StdFeldT.origin.y+=0.5;
		//		StdFeldT.origin.y+=StdFeldT.size.height;
		//		NSRect StdFeldN=StdFeld;
		//		StdFeldN.size.height/=2;
		//		StdFeldN.size.height-=1;
		//if (i==0)
		{
			//		NSLog(@"drawRect:ModeStundenArray:ON: %d",[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue]);
			//		NSLog(@"drawRect:StundenArray:ON: %d",[[[StundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue]);
		}
		//		int ON=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue];
		float ON=(float)[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
      
      StdFeldT.size.height*=ON/3.0;
      //NSLog(@"ON: %.2f h: %.2f",ON,StdFeldT.size.height);
      [darkGreen set];
      [[NSColor redColor]set];
      [NSBezierPath fillRect:StdFeldT];
      
      /*
		switch (ON)
		{
			case 0:// OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldT];
				break;
			case 1:// red
				//[[NSColor greenColor]set];
				//[lightGreen set];
				//[NSBezierPath fillRect:StdFeldT];
				
				//break;
				
				
			case 2:// voll
				//[[NSColor redColor]set];
				[darkGreen set];
				[NSBezierPath fillRect:StdFeldT];
		}
		*/
		//[NSBezierPath strokeRect:StdFeldO];
      //[NSBezierPath strokeRect:StdFeldU];
      [NSBezierPath strokeRect:StdFeld];
	}//for i
}

- (void)mouseDown:(NSEvent *)theEvent
{
	//	NSLog(@"rServoTagplanbalken mouseDown: event: x: %2.2f y: %2.2f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
	//NSLog(@"mouseDown: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	//NSLog(@"Bounds: x: %2.2f y: %2.2f h: %2.2f w: %2.2f ",[self frame].origin.x,[self frame].origin.y,[self frame].size.height,[self frame].size.width);
	//NSLog(@"mouseDown: modifierFlags: %",[theEvent modifierFlags]);
	//		NSLog(@"mouseDown Stundenarray: %@",[[StundenArray valueForKey:@"werkstatt"] description]);
	// NSLog(@"mouseDown: objekt: %d",Raum );
	int MausIN=0;
	unsigned int Mods=[theEvent modifierFlags];
   //NSLog(@"Mods: %d",Mods );
	int modKey=0;
	if (Mods & NSCommandKeyMask)
	{
		NSLog(@"mouseDown: Command");
		modKey=1;
	}
	else if (Mods & NSControlKeyMask)
	{
		NSLog(@"mouseDown: Control");
		modKey=3;
	}
	
	else if (Mods & NSAlternateKeyMask)
	{
		NSLog(@"mouseDown: Alt");
		modKey=2;
		
	}
	
   
	NSPoint globMaus=[theEvent locationInWindow];
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	//NSLog(@"rServoTagplanbalken mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;
	int all=-1;
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	[NotificationDic setObject:[NSNumber numberWithInt:Raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:Objekt] forKey:@"objekt"];
	
   NSRect AllFeldO=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeldO.origin.x+=Elementbreite+2;
   AllFeldO.origin.y += AllFeldO.size.height/4;
	AllFeldO.size.height/=4;
	//AllFeldO.size.height-=2;
	AllFeldO.size.width*=0.6;

   NSRect AllFeldU=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeldU.origin.x+=Elementbreite+2;
	AllFeldU.size.height/=4;
	//AllFeldU.size.height-=2;
	AllFeldU.size.width*=0.6;

	/*
	if ([self mouse:localMaus inRect:AllFeldU])
	{
      NSLog(@"AllFeldO-Taste");
		if (modKey==2)//alt
		{
			//NSLog(@"ALL-Taste mit alt");
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			
			[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
			[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			NSLog(@"rServoTagplanbalken modifier AllFeld");
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			
			return;
		}
		int lastsum=0;
		int sum=0;
		for (i=0;i<24;i++)
		{
			sum+=[[[StundenArray valueForKey:@"code"] objectAtIndex:i]intValue];
			lastsum+=[[lastONArray  objectAtIndex:i]intValue];
		}
		//NSLog(@"sum: %d lastsum: %d",sum, lastsum);
		if (sum==0)//alle sind off: IST wiederherstellen
		{
			if (lastsum) // lastOnArray enthält code
			{
				NSLog(@"IST wiederherstellen");
				all=2;
			}
			else
			{
				all=3; // lastOnArray enthält noch keinen code
			}
			
		}
		
		else if (sum==72)//alle sind ON,
		{
			NSLog(@"Alle OFF");
			all=0;
		}
		else if (sum && sum<72)//mehrere on: alle ON
		{
			NSLog(@"IST speichern");
			lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
			all=3;
		}
		
		[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];// All-Feld
		[NotificationDic setObject:[NSNumber numberWithInt:all] forKey:@"on"];	// code fuer All
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"]; // All-Feld
		
	
	}
	*/
	
	
	for (i=0;i<24;i++) // alle Tastenfelder abfragen
	{
		
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
		NSRect StdFeldU=StdFeld;
		NSRect StdFeldO=StdFeld;
      
      StdFeldU.size.height/=2;
      StdFeldU.size.height=8;
		//StdFeldU.size.width-=2;
		//StdFeldU.origin.x+=1;
      
		
		StdFeldO.origin.y +=(StdFeld.size.height/2.0);
		StdFeldO.size.height/=2.0;
      //NSLog(@"Std y: %.2f h: %.2f",StdFeldO.origin.y,StdFeldO.size.height);
      StdFeldO.origin.y=13;
      StdFeldO.size.height=8;
		//StdFeldO.size.width-=2;
		
      if (i==0)
      {
         //NSLog(@"i: %d",i);
         //NSLog(@"Std y: %.2f h: %.2f",StdFeld.origin.y,StdFeld.size.height);

         //NSLog(@"yu: %.2f hu: %.2f yo: %.2f ho: %.2f mausy: %.2f",StdFeldU.origin.y,StdFeldU.size.height,StdFeldO.origin.y,StdFeldO.size.height,localMaus.y);
      }
		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			//[NotificationDic setObject:Raum forKey:@"quelle"];
			[NotificationDic setObject:[NSNumber numberWithInt:Wochentag] forKey:@"tag"];
		}
      
		if ([self mouse:localMaus inRect:StdFeldU])
		{
			//NSLog(@"Servo mouse in Stunde: %d in Feld unten ON vor: %d",i, ON);
			if (ON)
         {
            ON --;
         }
         NSLog(@"Servo mouse in Stunde: %d in Feld unten ON nach: %d",i, ON);
			[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
			[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
			[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"feld"];
			
			if (modKey==2)//alt
			{
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"rServoTagplanbalken mofdifier StdFeldU");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				//return;
				
			}
			
		MausIN=1;	
		}
		else if ([self mouse:localMaus inRect:StdFeldO])
		{
			//NSLog(@"Servo mouse in Stunde: %d in Feld oben ON vor: %d",i,ON);
         if (ON<3)
         {
            ON++;
         }
         NSLog(@"Servo mouse in Stunde: %d in Feld oben ON nach: %d",i,ON);
			[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
			[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
			[NotificationDic setObject:[NSNumber numberWithInt:2] forKey:@"feld"];
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:@"alt" forKey:@"mod"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"Tagplan modifier StdFeldO");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				//return;
			}
			MausIN=1;
		}
		
		
		switch (all)
		{
			case 0://alle OFF schalten
			case 3://alle ON schalten
				ON=all;
				break;
			case 2://Wiederherstellen
				//NSLog(@"IST: lastONArray: %@",[lastONArray description]);
				ON=[[lastONArray objectAtIndex:i]intValue];
				break;
		}//switch all		
		
		//NSLog(@"rServoTagplanbalken mouseDow: Stunde: %d code: %d",i,ON);
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];
		//NSLog(@"StundenArray: %@",[StundenArray description]);
		//[self setNeedsDisplay:YES];
		
		
		
	}//for i
	
	if (MausIN)
	{
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
	
   }
	//NSLog(@"all: %d code: %@",all, [[StundenArray valueForKey:@"code"]description]);
	if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
		lastONArray=[[StundenArray valueForKey:@"code"]copy];
	}
	[self setNeedsDisplay:YES];
}


@end

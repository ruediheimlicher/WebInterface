//
//  rDatenbalken.m
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rDatenbalken.h"

@implementation rDatenbalken

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
      //typ=9;
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
		AktivtastenSet = [NSMutableIndexSet indexSet];
      edit=0;
	}
    return self;
	
	
   
}

- (void)BalkenAnlegen
{
	
	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"Tagbalken init  Nullpunkt: x: %2.2f y: %2.2f", Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
	NSPoint Ecke=NSMakePoint(8.0,4.0);
	//NSLog(@"Datenbalken init: frame.height: %2.2f",[self frame].size.height);
	
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
	[WriteTaste setTag:objekt];
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
	[HeuteTaste setTitle:@"ed"];
	[HeuteTaste setTag:objekt];
	[HeuteTaste setAction:@selector(reportHeuteTaste:)]; // Auszufuehrende Funktion
	[self addSubview:HeuteTaste];
   
   
   

	//		Titelfeld=[[NSTextField alloc]initWithFrame:Titelrect];
	
	//[self addSubview:Titelfeld];
	//		[Titelfeld setAttributedStringValue:[[[NSAttributedString alloc] initWithString:@"" attributes:TitelAttrs] autorelease]];
	
	//Titel=[[NSAttributedString alloc]initWithString:@"Tagplan" attributes:TitelAttrs];
	
	Titel=@"Tagplan";
	//		[Titelfeld setAttributedStringValue:Titel];
	
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=0;
	//	Elementhoehe: Block mit Halbstundenfeldern und AllTaste
	Elementbreite=([self frame].size.width-RandL-RandR)/8;
	Elementhoehe=[self frame].size.height-5;
	//Elementhoehe=35;
	//NSLog(@"Tag Elementbreite: %d Elementhoehe: %d ",Elementbreite, Elementhoehe);
   //NSLog(@"Balkenanlegen superview: %d",(long)[[self superview]tagbalkentyp]);
	for (i=0;i<24;i++)
   {
      if (i<8)
      {
         NSRect Nummerfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y+Elementhoehe-2,8, 10);
         NSTextField* NummerTextFeld=[[NSTextField alloc] initWithFrame:Nummerfeld];
         [NummerTextFeld setBordered:NO];
         [NummerTextFeld setEditable:NO];
         [NummerTextFeld setDrawsBackground:NO];
         //[NummerTextFeld setAlignment:NSCenterTextAlignment];
         [NummerTextFeld setFont:[NSFont fontWithName:@"Helvetica" size:8]];
         
         [NummerTextFeld setStringValue:[NSString stringWithFormat:@"%d",i]];
         //	NSLog(@"Datenbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
         [self addSubview:NummerTextFeld];
         
         NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-4);
         NSTextField* ElementTextFeld=[[NSTextField alloc] initWithFrame:Elementfeld];
         [ElementTextFeld setDelegate:self];
         [ElementTextFeld setTag:100+i];
         [ElementTextFeld setEditable:NO];
         [tempElementDic setObject:ElementTextFeld forKey:@"elementrahmen"];
         [tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
         [tempElementDic setObject:[NSNumber numberWithInt:0] forKey:@"code"];
         [ElementTextFeld setAlignment:NSCenterTextAlignment];
         [StundenArray addObject:tempElementDic];
         
         //[StundenArray addObject:tempElementDic];
         //	NSLog(@"Datenbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
         [self addSubview:ElementTextFeld];
      }
      else
      {
         NSView* ElementView=[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
         NSDictionary* tempElementDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         ElementView,@"elementrahmen",
                                         [NSNumber numberWithInt:i],@"elementnummer",
                                         [NSNumber numberWithInt:0],@"code",
                                         nil];
         [StundenArray addObject:tempElementDic];
         
         [self addSubview:ElementView];
      }
   }//for i
	
   NSRect AllFeld=[[[StundenArray objectAtIndex:7]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+1;
	//AllFeld.origin.y+=8;
	//AllFeld.size.height-=8;
	AllFeld.size.width=14;
	rTaste* AllTaste=[[rTaste alloc]initWithFrame:AllFeld];
	//	[AllTaste setButtonType:NSMomentaryLightButton];
	[AllTaste setButtonType:NSMomentaryLight];
	[AllTaste setTarget:self];
	[AllTaste setBordered:YES];
	[[AllTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[AllTaste cell]setShowsStateBy:NSPushInCellMask];
	[AllTaste setTitle:@"e"];
	[AllTaste setAction:@selector(AllTasteAktion:)];
   [AllTaste setTag:99];
	[self addSubview:AllTaste];
//NSLog(@"Tagplanbalken StundenArray: %@", [StundenArray description]);
	//NSLog(@"Datenbalken end init");
}

/*
- (void)setTag:(NSInteger)tagwert
{
//tag=tagwert;
mark=tagwert;
}
*/


- (void)setTitel:(NSString*)derTitel
{
	

	Titel=derTitel;
   
		//[derTitel release];
	//[Titelfeld setStringValue:Titel];
   //NSLog(@"Titel: %@ derTitel: %@",Titel, derTitel);
	
}


- (void)setObjekt:(NSNumber*)dieObjektNumber
{
	objekt=[dieObjektNumber intValue];
}


- (void)setRaum:(int)derRaum
{
	raum=derRaum;
	
}

- (void)setTagbalkenTyp:(int)derTyp
{
	TagbalkenTyp=derTyp;
	//typ = derTyp;
}


- (void)setWochentag:(int)derWochentag
{
	//tag=derWochentag;
	wochentag=derWochentag;
	
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
		wochentag=derTag;
	
		//NSLog(@"Tagplanbalken setTagplan Tag: %d StundenArray: %@",derTag, [derStundenArray description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		//if (derTag==0)
		{
		//NSLog(@"setTagplan index: %d: code: %d",i,[[[derStundenArray objectAtIndex:i]objectForKey:@"code"]intValue]);
		}
      
      if (i<8)
      {
         
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
         [[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]setIntValue:[[[derStundenArray objectAtIndex:i]objectForKey:@"code"]intValue]];
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
//NSLog(@"setStundenarraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
//NSLog(@"Stundenarray vor : %@",[StundenArray description]);
NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];
//NSLog(@"Stundenarray nach : %@",[StundenArray description]);
//lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];
[self setNeedsDisplay:YES];

}

- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
	NSLog(@"Datenbalken setStundenArray StundenArray: %@", [derStundenArray description]);
	
	int i;
	for (i=0;i<24;i++)
	{
      
      if (i<8)
      {
		int w=[[derStundenArray objectAtIndex:i]intValue];
		[self setStundenarraywert:w vonStunde:i forKey:derKey];
      }
	}
		//NSDictionary* tempDic=[StundenArray objectAtIndex:i];			
		//NSLog(@"StundenArray:  %@",[[StundenArray valueForKey:@"kessel"]description]);
		
	
}

- (void)setStundenArrayAusByteArray:(NSArray*)derStundenByteArray
{
	//NSLog(@"Datenbalken setStundenArrayAusByteArray derStundenByteArray: %@",[derStundenByteArray description]);
	
	NSMutableArray* tempStundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	//NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];

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
	//NSLog(@"Tagplanbalken setStundenArrayAusByteArray tempStundenArray: %@",[tempStundenArray description]);
	[self setStundenArray:tempStundenArray forKey:@"code"];
}


- (void)setNullpunkt:(NSPoint)derPunkt;
{
//Nullpunkt=derPunkt;
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		NSLog(@"setNullpunkt: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);

}

- (void)AllTasteAktion:(id)sender
{
   NSLog(@"AllTasteAktion edit: %d %d",edit,!edit);
  // edit = !edit; // editable toggeln
   NSLog(@"Balkenanlegen superview: %ld",(long)[self viewWithTag:99]);

   for (int i=0;i<[StundenArray count];i++)
   {
      //NSLog(@"AllTasteAktion i: %d",i);
      if (i<8)
      {
         [[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]setEditable:edit];
         if (edit==0)// && ([[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]isSelected]))
         {
            NSText* Feldeditor =[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]currentEditor];
            [Feldeditor setSelectedRange:NSMakeRange([[Feldeditor string]
                                                      length],0)];
            [Feldeditor setNeedsDisplay:YES];
            [[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]validateEditing];
            int wert =[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]intValue];
            [[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:wert] forKey:@"code"];
         }
      }
   }
   
   if (edit==0) // Eingabe sichern
   {
      //Textfeld verlassen
      NSDictionary* EditNotificationDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:edit] forKey:@"edit"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      NSLog(@"Datenbalken AllTasteAktion edit: %d",edit);
      
      
      
      [nc postNotificationName:@"edit" object:self userInfo:EditNotificationDic];
      
      
      
      lastONArray = [NSMutableArray arrayWithArray:[StundenArray valueForKey:@"code"]];
      
      //NSLog(@"AllTasteAktion");
      //NSLog(@"AllTasteAktion: %d", [(rTagplanbalken*)[sender superview]Wochentag]);
      //NSLog(@"AllTasteAktion Wochentag: %d", [(rTagplanbalken*)[sender superview]Raum]);
      //NSLog(@"AllTasteAktion: %d", [(rTagplanbalken*)[sender superview]Objekt]);
      //NSLog(@"AllTasteAktion: %@", [(rTagplanbalken*)[sender superview]Titel]);
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
      [NotificationDic setObject:lastONArray forKey:@"lastonarray"];
      [NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
      [NotificationDic setObject:Titel forKey:@"titel"];
      [NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
      [NotificationDic setObject:[NSNumber numberWithInt:TagbalkenTyp] forKey:@"tagbalkentyp"];
      //NSLog(@"lastONArray: %@",[lastONArray description]);

      int modKey=0;
      int all=-1;
      if(([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)  != 0)
      {
         //NSLog(@"AllTasteAktion Alt");
         modKey=2;
         [NotificationDic setObject:@"alt" forKey:@"mod"];
         [NotificationDic setObject:lastONArray forKey:@"lastonarray"];
         [NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
         [NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
         [NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         //NSLog(@"Tagplanbalken AllTasteAktion modifier AllFeld");
         [nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
         
      }
      else
      {
         //NSLog(@"AllTasteAktion Standard");
         modKey=0;
         
         //NSLog(@"all: %d code: %@",all, [[StundenArray valueForKey:@"code"]description]);
         
         [NotificationDic setObject:[NSNumber numberWithInt:97] forKey:@"stunde"];// All-Feld
         [NotificationDic setObject:[NSNumber numberWithInt:all] forKey:@"on"];	// code fuer All
         [NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"]; // All-Feld
         [NotificationDic setObject:lastONArray forKey:@"lastonarray"]; //lastONArray uebergeben
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
         
         [self setNeedsDisplay:YES];
         
      }// Standard
	}// if edit==0
}


- (void)StundenTasteAktion:(NSButton*)sender
{
	//NSLog(@"StundenTasteAktion tag: %d",[sender tag]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"StundenTasteAktion: %@", [(rTagplanbalken*)[sender superview]Titel]);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	
	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
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
		
      [NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"stunde"];
		[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"feld"];// Feld U
		
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			//NSLog(@"Tagplan mofdifier StdFeldU");
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			modKey=0;
			
			//return;
		}
		
		//NSLog(@"Tagplanbalken mouseDow: Stunde: %d code: %d",i,ON);
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
   if (edit)
   {
      [[NSSound soundNamed:@"Basso"] play];
      return;
   }
	//NSLog(@"WriteTasteAktion tag: %d",[sender tag]);
	//NSLog(@"Wochentag: %d", [(rTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"Raum: %d", [(rTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"Objekt: %d", [(rTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"Titel: %@", [(rTagplanbalken*)[sender superview]Titel]);
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];//
	[NotificationDic setObject:[(rDatenbalken*)[sender superview]Titel] forKey:@"titel"];//
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];//
   //[NotificationDic setObject:[NSNumber numberWithInt:typ] forKey:@"typ"];//
   [NotificationDic setObject:[NSNumber numberWithInt:TagbalkenTyp] forKey:@"tagbalkentyp"];//
	//NSLog(@"Tagplanbalken WriteTasteAktion Typ: %d",typ);
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
   NSLog(@"Datenbalken reportHeuteTaste  Raum: %d wochentag: %d",raum, wochentag);
   NSLog(@"reportHeuteTaste views: %@",[self subviews]);
   
    edit = !edit; // editable toggeln
   int index=0;
   for (int i=0;i<[[self subviews]count];i++)
   {
      int tempTag = ([[self subviews]objectAtIndex:i]).tag;
      //NSLog(@"i: %d view: %@ tag: %d",i,[[self subviews]objectAtIndex:i],tempTag);
      
      if ((tempTag >=100) && (tempTag < 108))
      {
         NSLog(@"i: %d wert: %@ tag: %d edit: %d index: %d",i,[[[self subviews]objectAtIndex:i]stringValue],tempTag,edit,index);

         //NSLog(@"i: %d tag: %d edit: %d index: %d",i,tempTag,edit,index);
         
         [[self viewWithTag:100+index]setEditable:edit];
         
         [[self viewWithTag:100+index]setSelectable:edit];
         if (edit == 0)
         {
           //[[self viewWithTag:100+index]deselectAll:nil];
         }

         index++;
         
      }
      
   
   }
   /*
   if (edit)
   {
      NSLog(@"reportHeuteTaste edit = 1");
      [sender setTitle:@"fix"];
      [[self viewWithTag:99]setTitle:@"AA"];
      for (int i=0;i<8;i++)
      {
         [[self viewWithTag:100+i]setEditable:NO];
      }

   }
   else
   {
      [sender setTitle:@"ed"];
      [[self viewWithTag:99]setTitle:@"BB"];
      for (int i=0;i<8;i++)
      {
         if ([self viewWithTag:100+i])
         {
            [[self viewWithTag:100+i]setEditable:YES];
         }
      }
         
   }
   */
   return;
   
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];//
	[NotificationDic setObject:[(rDatenbalken*)[sender superview]Titel] forKey:@"titel"];//
   
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
return wochentag;
}

- (int)Raum
{
return raum;
}

- (int)Objekt
{
return objekt;
}

- (int)TagbalkenTyp
{
return TagbalkenTyp;
}

- (int)wochentag
{
   return wochentag;
}

- (int)raum
{
   return raum;
}
- (int)objekt
{
   return objekt;
}

- (int)typ
{
   return TagbalkenTyp;
}


-(NSString*)Titel
{
   //NSLog(@"return Titel: %@",Titel);

return Titel;
}

- (NSArray*)StundenArray
{
   NSLog(@"Datenbalken StundenArray: %@",[StundenArray description]);
return StundenArray;
}



- (NSArray*)StundenByteArray
{
   //NSLog(@"Datenbalken typ: %d StundenArray: %@",typ,[[StundenArray valueForKey:@"code"]description]);
   //NSLog(@"Datenbalken typ: %d StundenArray: %@",typ,[StundenArray description]);
	NSMutableArray* tempByteArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	NSString* StundenbyteString=[NSString string];
	for (int i=0;i<[StundenArray count];i++)
	{
      if (i<8)
      {
		uint8_t Stundencode=[[[StundenArray objectAtIndex:i] objectForKey:@"code"]intValue];
		//NSLog(@"StundenByteArray i: %d Tag: %d Objekt: %d Stundencode: %02X",i,Wochentag, Objekt, Stundencode);
      NSString* ByteString=[NSString stringWithFormat:@"%02X ",Stundencode];
			//NSLog(@"      Stundenbyte: %02X ByteString: %@",Stundenbyte , ByteString);
      StundenbyteString=[StundenbyteString stringByAppendingString:ByteString] ;
      [tempByteArray addObject:[NSNumber numberWithInt:Stundencode]];
		}
	}// for i
	//NSLog(@"StundenbyteString: %@ tempByteArray: %@",StundenbyteString,[tempByteArray description]);
	//NSLog(@"StundenByteArray ByteArray: %@",[tempByteArray description]);
	
   return tempByteArray;
}


- (NSInteger)tag
{
//NSLog(@"Tagplanbalken tag: %d",mark);
return tag;
}


- (void)setTag:(NSInteger)derTag
{
  // NSLog(@"Tagplanbalken setTag: %d",derTag);
   tag = derTag;
 //  NSLog(@"Tagplanbalken tag: %d",[self tag]);

}

- (void)drawRect:(NSRect)dasFeld 
{
   return;
    NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
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
	TagPunkt.x+=6;
	TagPunkt.y+=Elementhoehe*0.72;
	//NSLog(@"Tagplanbalken drawRect: Titel: %@",Titel);
	[Titel drawAtPoint:TagPunkt withAttributes:TitelAttrs];
   
   
	//NSLog(@"Tag: %d Tagpunkt x: %2.2f  y: %2.2f",tag, TagPunkt.x, TagPunkt.y);
//	[[Wochentage objectAtIndex:tag] drawAtPoint:TagPunkt withAttributes:TagAttrs];
	
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
		//NSLog(@"WS drawRect: y %2.2f",[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame].origin.y);
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
		[[NSColor blueColor]set];
		StdFeld.size.height-=8;
		StdFeld.origin.y+=8;
		//NSLog(@"i: %d Eckex: %2.2f h: %2.2f b: %2.2f",i,StdFeld.origin.x,StdFeld.size.height,StdFeld.size.width);
		[NSBezierPath fillRect:StdFeld];
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		
		[[NSColor blueColor]set];
		[NSBezierPath strokeRect:StdFeldL];

		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		[[NSColor blueColor]set];
		[NSBezierPath strokeRect:StdFeldR];
		
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=5;
		StdFeldU.origin.y-=8;
		[[NSColor grayColor]set];
//		[NSBezierPath fillRect:StdFeldU];
		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
		switch (ON)
		{
			case 0://ganze Stunde OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[NSBezierPath fillRect:StdFeldR];
				
				break;
			case 2://erste halbe Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldR];
				
				
				break;
			case 1://zweite halbe Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldR];
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldL];
				
				break;
			case 3://ganze Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[NSBezierPath fillRect:StdFeldR];
				
				break;
		}
	}//for i
}

- (void)mouseDown:(NSEvent *)theEvent
{
   return;
	//	NSLog(@"Tagplanbalken mouseDown: event: x: %2.2f y: %2.2f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
	//NSLog(@"mouseDown: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	//NSLog(@"Bounds: x: %2.2f y: %2.2f h: %2.2f w: %2.2f ",[self frame].origin.x,[self frame].origin.y,[self frame].size.height,[self frame].size.width);
	//NSLog(@"mouseDown: modifierFlags: %",[theEvent modifierFlags]);
	//		NSLog(@"mouseDown Stundenarray: %@",[[StundenArray valueForKey:@"werkstatt"] description]);
	// NSLog(@"mouseDown: objekt: %d",Raum );
	int MausIN=0;
	unsigned int Mods=[theEvent modifierFlags];
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
	
	
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=2;
	
	NSPoint globMaus=[theEvent locationInWindow];
	//NSPoint Ecke=[self bounds].origin;
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	//NSLog(@"rTagplanbalken mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;
	int all=-1;
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
	
	
	if ([self mouse:localMaus inRect:AllFeld])
	{
      NSLog(@"ALL-Taste");
		if (modKey==2)//alt
		{
			//NSLog(@"ALL-Taste mit alt");
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			
			[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
			[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];
			
//			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			NSLog(@"Tagplanbalken mofdifier AllFeld");
			//[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			
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
	
	
	
	for (i=0;i<24;i++) // alle Tastenfelder abfragen
	{
		
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
      NSRect StdFeldorig=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];

		StdFeld.size.height-=10;
		StdFeld.size.height-=8;
		StdFeld.origin.y+=8;
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=5;
		StdFeldU.origin.y-=8;
      
      if (i==0)
      {
         //NSLog(@" ");
         //NSLog(@"Std y: %.2f h: %.2f h orig: %.2f",StdFeld.origin.y,StdFeld.size.height,StdFeldorig.size.height);
         
         //NSLog(@"yu: %.2f hu: %.2f yo: %.2f ho: %.2f mausy: %.2f",StdFeldL.origin.y,StdFeldL.size.height,StdFeldR.origin.y,StdFeldR.size.height,localMaus.y);
      }

		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			//[NotificationDic setObject:Raum forKey:@"quelle"];
			[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"tag"];
		}
      
		if ([self mouse:localMaus inRect:StdFeldL])
		{
			
			
			//NSLog(@"mouse in Stunde: %d in Feld links ON: %d",i, ON);
			
			switch (ON)
			{
				case 0:// werkstatt in der ersten halben Stunde neu einschalten __ > |_
					ON=2;//Bit 2
					break;
					
				case 1:// Kessel in der ersten halbe Stunde neu einschalten _| > ||
					ON=3;
					break;
					
				case 2:// Kessel in der ersten halben Stunde neu ausschalten || > _|
					ON=0;
					break;
					
				case 3: // Kessel in der ersten halben Stunde neu ausschalten || > _|
					ON=1;
					break;
			}//switch ON
			[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
			[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
			[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"feld"];
			
			if (modKey==2)//alt
			{
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"Tagplanbalken mofdifier StdFeldL");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				//return;
				
			}
			
		MausIN=1;	
		}
		else if ([self mouse:localMaus inRect:StdFeldR])
		{
			//NSLog(@"mouse in Stunde: %d in Feld rechts ON: %d",i,ON);
			switch (ON)
			{
				case 0:// Kessel in der zweiten halben Stunde neu einschalten
					ON=1;
					break;
				case 1://	Kessel in der zweiten halben Stunde neu ausschalten
					ON=0;
					break;
				case 2:// Kessel in der zweiten halben Stunde neu einschalten
					ON=3;
					break;
				case 3:// Kessel in der zweiten halben Stunde neu ausschalten
					ON=2;
					break;
					
			}
			[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
			[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
			[NotificationDic setObject:[NSNumber numberWithInt:2] forKey:@"feld"];
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:@"alt" forKey:@"mod"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"Tagplan mofdifier StdFeldR");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				//return;
			}
			MausIN=1;
		}
		else if ([self mouse:localMaus inRect:StdFeldU])
		{
			//NSLog(@"mouse in Stunde: %d in Feld Unten ON: %d",i, ON);
			switch (ON)
			{
				case 0://ganze Stunde ON
				case 1://	Kessel in der ersten halben Stunde schon ON
				case 2://	Kessel in der zweiten halben Stunde schon ON
					ON=3;//ganze Stunde ON
					break;
					
				case 3:// Kessel in der ganzen Stunde schon ON
					ON=0;//ganze Stunde OFF
					break;
					
			}
			[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
			[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
			[NotificationDic setObject:[NSNumber numberWithInt:3] forKey:@"feld"];// Feld U
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:@"alt" forKey:@"mod"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				//NSLog(@"mousedown Tagplan mofdifier StdFeldU");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				
				//return;
			}
			
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
		
		//NSLog(@"Tagplanbalken mouseDow: Stunde: %d code: %d",i,ON);
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

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
   //NSLog(@"Datenbalken: controlTextDidEndEditing raum: %d objekt: %d wochentag: %d",raum,objekt,wochentag);
  // NSLog(@"Datenbalken: controlTextDidEndEditing aNotification tag: %d Inhalt: %@",[[aNotification object]tag],[[aNotification object]stringValue]);
   
   int temptag = [(NSTextField*)[aNotification object]tag]-100;
   
   NSLog(@"Datenbalken: controlTextDidEndEditing raum: %d objekt: %d wochentag: %d temptag: %d",raum,objekt,wochentag,temptag);
   NSString* errString = [[aNotification object]stringValue];
   //NSLog(@"errString: %@",errString);
   int tempwert = [[aNotification object]intValue];
   if (tempwert>0xFF)
   {
      [[NSSound soundNamed:@"Frog"] play];
      [[aNotification object]setIntValue:0];
      return;
   }
   
   //controlTextDidEndEditing StundenArray:
   
   
   
   //NSLog(@"[controlTextDidEndEditing StundenArray: %@",[StundenArray description]);
   NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:[StundenArray objectAtIndex:temptag]];
   //NSLog(@"tempDic vor: %@",[tempDic description]);
   [tempDic setObject:[NSNumber numberWithInt:tempwert]forKey:@"code" ];
   //NSLog(@"tempDic nach: %@",[tempDic description]);
   [StundenArray replaceObjectAtIndex:temptag withObject:tempDic];

   NSLog(@"controlTextDidEndEditing StundenArray neu: %@",[StundenArray description]);
   
}


@end

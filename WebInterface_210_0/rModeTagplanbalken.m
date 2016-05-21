//
//  rModeTagplanbalken.m
//  
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rModeTagplanbalken.h"

@implementation rModeTagplanbalken

- (id)initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
      //typ=1;
		RandL=60;
		RandR=20;
		RandU=2;
		aktiv=1;
      TagbalkenTyp=1;
		if (StundenArray==NULL)
		{
			StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
		}
		
	}
return self;
	{
		[StundenArray removeAllObjects];
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		//NSLog(@"Tagbalken init  Nullpunkt: x: %2.2f y: %2.2f", Nullpunkt.x,Nullpunkt.y);
		int i=0;
		NSLog(@"ModeTagbalken init");
		NSPoint Ecke=NSMakePoint(4.0,4.0);
		//NSLog(@"Tagbalken init: frame.height: %2.2f",[self frame].size.height);
		NSRect Titelrect=NSMakeRect(4,4,50,16);
		
		//		Titelfeld=[[NSTextField alloc]initWithFrame:Titelrect];
		
		[self addSubview:Titelfeld];
		//		[Titelfeld setAttributedStringValue:[[[NSAttributedString alloc] initWithString:@"" attributes:TitelAttrs] autorelease]];
		
		//Titel=[[NSAttributedString alloc]initWithString:@"Tagplan" attributes:TitelAttrs];
		
		Titel=@"Tagplan";
		//		[Titelfeld setAttributedStringValue:Titel];
		
		Ecke.x+=RandL;
		//Ecke.y+=RandU;
		Ecke.y=5;
		//	Elementhoehe: Block mit Halbstundenfeldern und AllTaste
		Elementbreite=([self frame].size.width-RandL-RandR)/24;
		Elementhoehe=[self frame].size.height-5;
		//Elementhoehe=35;
		//NSLog(@"Elementbreite: %d Elementhoehe: %d ",Elementbreite, Elementhoehe);
		for (i=0;i<24;i++)
		{
			NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
			//NSLog(@"WS SetTagPlan i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
			//		[NSBezierPath strokeRect:Elementfeld];
			NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
			[ElementView setAutoresizesSubviews:NO];
			[self addSubview:ElementView];
			//		NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
			//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
			[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
			[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
			
			[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"code"];
			[StundenArray addObject:tempElementDic];
			//	NSLog(@"Tagplanbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
		}//for i
		
		//NSLog(@"ModeTagplanbalken end init: StundenArray count: %d",[StundenArray count]);
    }
    return self;
}

- (void)BalkenAnlegen
{
	
	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"Tagbalken init  Nullpunkt: x: %2.2f y: %2.2f", Nullpunkt.x,Nullpunkt.y);
	int i=0;
	//NSLog(@"ModeTagbalken BalkenAnlegen");
	NSPoint Ecke=NSMakePoint(8.0,4.0);
		NSRect WriteFeld=NSMakeRect(6,5.5,24,12);
	rTaste* WriteTaste=[[rTaste alloc]initWithFrame:WriteFeld];
	//	[WriteTaste setButtonType:NSMomentaryLightButton];
	[WriteTaste setButtonType:NSMomentaryPushInButton];
	[WriteTaste setTarget:self];
	[WriteTaste setBordered:YES];
	[[WriteTaste cell]setBackgroundColor:[NSColor yellowColor]];
	[[WriteTaste cell]setShowsStateBy:NSPushInCellMask];
   [WriteTaste setFont:[NSFont fontWithName:@"Helvetica" size:8]];
	[WriteTaste setTitle:@"E"];
	[WriteTaste setTag:objekt];
	[WriteTaste setAction:@selector(WriteTasteAktion:)];
	[self addSubview:WriteTaste];
  
   // Taste zum temporaerenSchreiben des Plans anlegen
	NSRect HeuteFeld=NSMakeRect(36,5.5,18,12);
	rTaste* HeuteTaste=[[rTaste alloc]initWithFrame:HeuteFeld];
	[HeuteTaste setButtonType:NSMomentaryPushInButton];
	[HeuteTaste setTarget:self];
	[HeuteTaste setBordered:YES];
	[[HeuteTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[HeuteTaste cell]setShowsStateBy:NSPushInCellMask];
   [HeuteTaste setFont:[NSFont fontWithName:@"Helvetica" size:8]];
	[HeuteTaste setTitle:@"H"];
	[HeuteTaste setTag:objekt];
	[HeuteTaste setAction:@selector(reportHeuteTaste:)]; // Auszufuehrende Funktion
	[self addSubview:HeuteTaste];


	//NSLog(@"Tagbalken init: frame.height: %2.2f",[self frame].size.height);
	//NSRect Titelrect=NSMakeRect(4,4,50,16);
	
	//		Titelfeld=[[NSTextField alloc]initWithFrame:Titelrect];
	
	//[self addSubview:Titelfeld];
	//		[Titelfeld setAttributedStringValue:[[[NSAttributedString alloc] initWithString:@"" attributes:TitelAttrs] autorelease]];
	//		Titel=[[NSAttributedString alloc]initWithString:@"Tagplan" attributes:TitelAttrs];
	//		[Titelfeld setAttributedStringValue:Titel];
	
	Titel=@"ModeTagplan";
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=5;
	//	Elementhoehe: Block mit Halbstundenfeldern und AllTaste
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	Elementhoehe=[self frame].size.height-5;
	//Elementhoehe=35;
	//NSLog(@"Elementbreite: %d Elementhoehe: %d ",Elementbreite, Elementhoehe);
	for (i=0;i<24;i++)
	{
      /*
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"WS SetTagPlan i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		//		[NSBezierPath strokeRect:Elementfeld];
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		[ElementView setAutoresizesSubviews:NO];
		[self addSubview:ElementView];
		//		NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"code"];
		[StundenArray addObject:tempElementDic];
		//	NSLog(@"Tagplanbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
	*/
      NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"WS SetTagPlan i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		//		[NSBezierPath strokeRect:Elementfeld];
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		[ElementView setAutoresizesSubviews:NO];
		[self addSubview:ElementView];
		//		NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
      //		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"code"];
		[StundenArray addObject:tempElementDic];
		//	NSLog(@"Tagplanbalken init i: %d ElementDic: %@",i,[tempElementDic description]);
		
		NSRect StdFeldU=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
		StdFeldU.size.height = 6;
		//StdFeldU.origin.y+=8;
		rTaste* StundenTaste=[[rTaste alloc]initWithFrame:StdFeldU];
		[StundenTaste setButtonType:NSMomentaryPushInButton];
		[StundenTaste setTag:i];
      
		[StundenTaste setTarget:self];
		[StundenTaste setBordered:YES];
		[[StundenTaste cell]setBackgroundColor:[NSColor grayColor]];
		[[StundenTaste cell]setShowsStateBy:NSPushInCellMask];
		[StundenTaste setTitle:@""];
		[StundenTaste setAction:@selector(StundenTasteAktion:)];
		[self addSubview:StundenTaste];

   
   }//for i
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=1.8;
	rTaste* AllTaste=[[rTaste alloc]initWithFrame:AllFeld];
	//	[AllTaste setButtonType:NSMomentaryLightButton];
	[AllTaste setButtonType:NSMomentaryPushInButton];
	[AllTaste setTarget:self];
	[AllTaste setBordered:YES];
	[[AllTaste cell]setBackgroundColor:[NSColor lightGrayColor]];
	[[AllTaste cell]setShowsStateBy:NSPushInCellMask];
	[AllTaste setTitle:@""];
	[AllTaste setAction:@selector(AllTasteAktion:)];
	[self addSubview:AllTaste];
	
	//NSLog(@"ModeTagplanbalken end init: StundenArray count: %d",[StundenArray count]);
	
	
	
}//Balkenanlegen

- (void)setTitel:(NSString*)derTitel
{
	Titel=derTitel;
	//[derTitel release];
	//[Titelfeld setStringValue:Titel];
	
}


- (void)setObjekt:(NSNumber*)dieObjektNumber
{
	objekt=[dieObjektNumber intValue];
}


- (void)setRaum:(int)derRaum
{
	raum = derRaum;
	
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
		
	wochentag=derTag;
	//NSLog(@"ModeTagplanbalken setTagplan Tag: %d StundenArray: %@",derTag, [[StundenArray valueForKey:@"code"] description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		//NSLog(@"setTagplan index: %d: code: %d",i,[[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"]intValue]);
		if ([StundenArray objectAtIndex:i])
		{
			NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
			//NSLog(@"Dic schon da fuer index: %d",i);
			int tempCode=[[[derStundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
			if (tempCode ==1 || tempCode == 2)
			{
			//NSLog(@"setTagplan: code: %d  red",tempCode);

			//tempCode--; // auskomm 8.3.13: Wert ist 0 oder 3
            tempCode = 3;
			}
			[tempElementDic setObject:[NSNumber numberWithInt:tempCode] forKey:@"code"];
			
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
	//NSLog(@"ModeTagplanbalken end setTagplan: StundenArray count: %d",[StundenArray count]);
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setTagplan end: Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	[self setNeedsDisplay:YES];
}




- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey
{
   NSLog(@"StundenarraywertVonStunde: %d",dieStunde);
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


- (void)StundenTasteAktion:(NSButton*)sender
{
   {
      NSLog(@"StundenTasteAktion tag: %ld",(long)[sender tag]);
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
         
         NSLog(@"mouse in Stundentaste:	in Stunde: %ld 		ON vor: %d",(long)[sender tag], ON);
         switch (ON)
         {
            case 0://	ganze Stunde ON setzen
               ON=3;//ganze Stunde ON
               break;
               
               
            case 1://	Kessel in der ersten halben Stunde schon ON
            case 2://	Kessel in der zweiten halben Stunde schon ON
            case 3:// Kessel in der ganzen Stunde schon ON
               ON=0;//ganze Stunde OFF
               break;
               
         }
         NSLog(@"mouse in Stundentaste:	in Stunde: %ld 		ON nach: %d",(long)[sender tag], ON);
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
      
   }
   /*
	//NSLog(@"StundenTasteAktion tag: %d",[sender tag]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"StundenTasteAktion: %d", [(rTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"StundenTasteAktion: %@", [(rTagplanbalken*)[sender superview]Titel]);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
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
		switch (ON)
		{
			case 0://	ganze Stunde ON setzen
//			case 1://	Kessel in der ersten halben Stunde schon ON
//			case 2://	Kessel in der zweiten halben Stunde schon ON
				ON=2;//ganze Stunde ON
				break;
            
// 19.1.2013: nur noch zwei Werte 
            
			case 1://	Kessel in der ersten halben Stunde schon ON
			case 2://	Kessel in der zweiten halben Stunde schon ON

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
	*/
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
	NSLog(@"Mode setStundenArray Key: %@ StundenArray: %@",derKey, [derStundenArray description]);
	
	int i;
	for (i=0;i<[derStundenArray count];i++)
	{
		int w=[[derStundenArray objectAtIndex:i]intValue];
		[self setStundenarraywert:w vonStunde:i forKey:derKey];
	}
		//NSDictionary* tempDic=[StundenArray objectAtIndex:i];			
		//NSLog(@"StundenArray:  %@",[[StundenArray valueForKey:@"kessel"]description]);
		
	
}



- (void)setNullpunkt:(NSPoint)derPunkt;
{
//Nullpunkt=derPunkt;
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		NSLog(@"setNullpunkt: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);

}


- (void)AllTasteAktion:(id)sender
{
	//NSLog(@"AllTasteAktion");
	//NSLog(@"AllTasteAktion: %d", [(rTagplanbalken*)[sender superview]Wochentag]);
	//NSLog(@"AllTasteAktion: %d", [(rTagplanbalken*)[sender superview]Raum]);
	//NSLog(@"AllTasteAktion: %d", [(rTagplanbalken*)[sender superview]Objekt]);
	//NSLog(@"AllTasteAktion: %@", [(rTagplanbalken*)[sender superview]Titel]);
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
   [NotificationDic setObject:[NSNumber numberWithInt:TagbalkenTyp] forKey:@"tagbalkentyp"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
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
			NSLog(@"Alle sind off: IST wiederherstellen");
			if (lastsum) // lastOnArray enthält code
			{
				NSLog(@"lastOnArray enthält code: IST wiederherstellen");
				all=9;
			}
			else
			{
				// lastOnArray enthält noch keinen code
				NSLog(@"lastOnArray enthält noch keinen code: alle auf red");
            // neu: alle auf ON
				all=2;
			}
			
		}
		
		
		else if (sum==72)//alle sind voll,
		{
			NSLog(@"alle sind auf voll: Alle OFF");
			all=0;
		}
		else if (sum && sum<72)//mehrere on: alle voll
		{
			NSLog(@"mehrere on: alle red oder voll: IST speichern, alle auf voll");
			
			lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
			all=2;
		}
		
		//NSLog(@"ModeTagplanbalken All-Taste: sum: %d lastsum: %d all: %d",sum, lastsum,all);
		int ON=0;
		
		//	StundenArray anpassen, abhaengig von all
		for (i=0;i<24;i++)
		{
			ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
			switch (all)
			{
				case 0://alle OFF schalten
               ON=0;
               break;
               
				
				case 2://alle voll schalten
            
					ON=3;
               
					break;
				case 9://Wiederherstellen
				{
					ON=[[lastONArray objectAtIndex:i]intValue];
               //NSLog(@"h: %d ON: %d",i,ON);
					if (ON==1)
               {
                  ON=2;
               }
               //NSLog(@"nach korr: h: %d ON: %d",i,ON);
				}break;
			}//switch all
         
         [[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];
		
      }
		
      if ((all==9)||(all<0))
      {
         //NSLog(@"lastONArray speichern");
         lastONArray=[[StundenArray valueForKey:@"code"]copy];
      }
 		[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];// All-Feld
		[NotificationDic setObject:[NSNumber numberWithInt:all] forKey:@"on"];	// code fuer All
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"]; // All-Feld
		[NotificationDic setObject:lastONArray forKey:@"lastonarray"]; //lastONArray uebergeben
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
		//NSLog(@"all: %d code: %@",all, [[StundenArray valueForKey:@"code"]description]);
		
		[self setNeedsDisplay:YES];
		
	}// Standard
	
}

- (void)drawRect:(NSRect)dasFeld 
{
   {
      
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
         if (i>9) // zweistellig
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
    //     [NSBezierPath fillRect:StdFeld];
         
         NSRect StdFeldL=StdFeld;
         //StdFeldL.size.width/=2;
         StdFeldL.size.width-=2;
         StdFeldL.origin.x+=1;
         
         [[NSColor blueColor]set];
         [NSBezierPath strokeRect:StdFeldL];
         
         NSRect StdFeldR=StdFeld;
         StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
         StdFeldR.size.width/=2;
         StdFeldR.size.width-=2;
         
         [[NSColor blueColor]set];
         //[NSBezierPath strokeRect:StdFeldR];
         
         
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
              // [NSBezierPath fillRect:StdFeldR];
               
               break;
            case 2://erste halbe Stunde ON
               [[NSColor redColor]set];
               [NSBezierPath fillRect:StdFeldL];
             //  [[NSColor whiteColor]set];
             //  [NSBezierPath fillRect:StdFeldR];
               
               
               break;
            case 1://zweite halbe Stunde ON
              // [[NSColor redColor]set];
              // [NSBezierPath fillRect:StdFeldR];
               [[NSColor whiteColor]set];
               [NSBezierPath fillRect:StdFeldL];
               
               break;
            case 3://ganze Stunde ON
               [[NSColor redColor]set];
               [NSBezierPath fillRect:StdFeldL];
             //  [NSBezierPath fillRect:StdFeldR];
               
               break;
         }
      }//for i
   }
	/*
   // NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:dasFeld];
	
	float vargray=0.8;
	//NSLog(@"sinus: %2.2f",varRed);
	NSColor* tempGrayColor=[NSColor colorWithCalibratedRed:vargray-0. green: vargray blue: vargray+0.1 alpha:0.8];
	[tempGrayColor set];
	[NSBezierPath fillRect:dasFeld];
	NSFont* StundenFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* StundenAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
	NSFont* TagFont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSDictionary* TagAttrs=[NSDictionary dictionaryWithObject:TagFont forKey:NSFontAttributeName];
	NSPoint TagPunkt=NSMakePoint(0.0,0.0);
	NSFont* TitelFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* TitelAttrs=[NSDictionary dictionaryWithObject:TitelFont forKey:NSFontAttributeName];
	TagPunkt.x+=5;
	TagPunkt.y+=Elementhoehe*0.72;
	//NSLog(@"ModeTagplanbalken drawRect:  Titel: %@",Titel);
	[Titel drawAtPoint:TagPunkt withAttributes:TitelAttrs];

	
	NSColor* hellGrau=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue: 0.0 alpha:0.1];
	NSColor* lightGreen=[NSColor colorWithCalibratedRed:0.0 green:1.0 blue: 0.1 alpha:0.3];
	NSColor* darkGreen=[NSColor colorWithCalibratedRed:0.0 green:0.8 blue: 0.2 alpha:1.0];
	
	
	
	//Mode zeichnen		
	//NSLog(@"drawRect:ModeStundenArray: %@",[[ModeStundenArray objectAtIndex:0]description]);
	//NSLog(@"drawRect:StundenArray: %@",[[StundenArray objectAtIndex:0]description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		//NSLog(@"drawRect: %2.2f",[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame].origin.x);
		//		NSRect StdFeld=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		//		StdFeld.size.height-=10;
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
		
		[[NSColor whiteColor]set];
		StdFeld.size.height*=0.6;
		StdFeld.origin.y+=1;
		NSBezierPath* Feldrand=[NSBezierPath bezierPathWithRect:StdFeld];
		[Feldrand fill];
		[[NSColor darkGrayColor]set];
		[Feldrand setLineWidth:0.8];
		[Feldrand stroke];
		NSRect StdFeldT=StdFeld;//Mode Tag
		StdFeldT.size.height-=2;
		StdFeldT.size.width-=2;
		StdFeldT.origin.x+=1;
		StdFeldT.origin.y+=1;
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
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
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
		
		
	}//for i Mode
	//AllFeld fuer Tag
	//	NSRect AllFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	
	AllFeld.origin.x+=Elementbreite+2;
	AllFeld.origin.y+=1;
	AllFeld.size.height*=0.4;
	//	AllFeld.size.height-=2;
	AllFeld.size.width*=0.6;
	
	[[NSColor darkGrayColor] set];
//	[NSBezierPath fillRect:AllFeld];
	*/
}

- (void)mouseDown:(NSEvent *)theEvent
{
   return;
/*
StundenArray:
key "kessel"	Einschaltzeiten Kessel			2: erste halbe Stunde on	1:zweite halbe Stunde on	3:ganze Stunde on
key "modetag"	Einschaltzeiten Mode Tag		0: off						1: reduziert				2: voll
key "modenacht"	Einschaltzeiten Mode Nacht		0: off						1: reduziert				2: voll


*/
	//NSLog(@"mouseDown: event: x: %2.2f y: %2.2f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
	//NSLog(@"mouseDown: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	//NSLog(@"Bounds: x: %2.2f y: %2.2f h: %2.2f w: %2.2f ",[self frame].origin.x,[self frame].origin.y,[self frame].size.height,[self frame].size.width);
	//NSLog(@"mouseDown: modifierFlags: %",[theEvent modifierFlags]);
	
	int MausIN=0;
	unsigned int Mods=[theEvent modifierFlags];
	int modKey=0;
	if (Mods & NSCommandKeyMask)
	{
		NSLog(@"mouseDown: Command");
		modKey+=1;
	}
	else if (Mods & NSControlKeyMask)
	{
		NSLog(@"mouseDown: Control");
		modKey+=4;
	}
	
	else if (Mods & NSAlternateKeyMask)
	{
		NSLog(@"mouseDown: Alt");
		modKey+=2;
		
	}
	else if (Mods & NSShiftKeyMask)
	{
		NSLog(@"mouseDown: shift");
		modKey+=8;
		
	}
	
	//NSLog(@"modifiers: modKey: %d",modKey);
	
		
	NSPoint globMaus=[theEvent locationInWindow];
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	//NSLog(@"mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;
//	int all=-1;
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	//[NotificationDic setObject:Raum forKey:@"raum"];
	[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"wochentag"];
	[NotificationDic setObject:lastONArray forKey:@"lastonarray"];

	[NotificationDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
	[NotificationDic setObject:Titel forKey:@"titel"];
	[NotificationDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];

	
	

	//AllFeld fuer Tag
//	NSRect AllFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	AllFeld.size.height/=2;
	AllFeld.size.height-=2;
	AllFeld.size.width*=0.6;
	
	int all=-1;
	if ([self mouse:localMaus inRect:AllFeld])
	{
		if (modKey==2)//alt
		{
			//NSLog(@"ALL-Taste mit alt");
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			
			[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
			[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			NSLog(@"ModeTagplanbalken modifier AllFeld");
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
		NSLog(@"sum: %d lastsum: %d",sum, lastsum);
		if (sum==0)//alle sind off: IST wiederherstellen
		{
			if (lastsum) // lastOnArray enthält code
			{
				NSLog(@"IST wiederherstellen");
				all=2;
			}
			else
			{
				// lastOnArray enthält noch keinen code
				all=2;
			}
			
		}

		else if (sum==24)//alle sind red,
		{
			NSLog(@"Alle auf voll");
			all=2;
		}
		
		else if (sum==48)//alle sind ON,
		{
			NSLog(@"Alle OFF");
			all=0;
		}
		else if (sum && sum<48)//mehrere on: alle ON
		{
			NSLog(@"IST speichern");
			lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
			all=2;
		}
		
		[NotificationDic setObject:[NSNumber numberWithInt:99] forKey:@"stunde"];// All-Feld
		[NotificationDic setObject:[NSNumber numberWithInt:all] forKey:@"on"];	// code fuer All
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"]; // All-Feld
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	}
	
	
	for (i=0;i<24;i++)	// alle Tastenfelder abfragen
	{

		//Mode abfragen
		NSRect StdFeld;
//		StdFeld=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
//		StdFeld.size.height-=10;
		
		StdFeld.size.height-=12;
		StdFeld.origin.y+=1;
		
      NSRect StdFeldT=StdFeld;//Mode Tag
      StdFeldT.size.height-=2;
      StdFeldT.origin.y+=1;
		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"code"]intValue];
		if (ON==3)
		{
		NSLog(@"ON reduzieren");
		//ON=0;
		}
		
		if ([self mouse:localMaus inRect:StdFeldT])
		{
			//NSLog(@"mouse in Stunde: %d in Feld Tag ON: %d",i, ON);
			switch (ON)
			{
				case 0:// Mode auf red stellen
					ON=2;//
					break;
					
				case 1:// Mode auf Voll stellen
					ON=0;
					break;
					
				case 2:// zuruecksetzen
				case 3:// 
					ON=0;
					break;
					
			}//switch ON

				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"feld"];				
			
			
			if (modKey==2)//alt
			{
				NSLog(@"mouse mit ALT in Stunde: %d in Feld Tag ON: %d",i, ON);
				[NotificationDic setObject:@"alt" forKey:@"mod"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"ModeTagplanbalken modifier StdFeldT");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				return;

			}
			MausIN=1;
		}
	
	//NSLog(@"i: %d all: %d ",i,all);
	
	switch (all)//Klick auf ALL Tag Taste registrieren
		{
			case 0://alle OFF schalten
			case 1://alle red schalten
			//case 2://alle voll schalten
				ON=all;
				break;
			case 2://Wiederherstellen
				{
				//if (i==1)
				   //NSLog(@"all: ISTwiederherstellen: lastModeTagArray: %@",[lastONArray description]);
				
				ON=[[lastONArray objectAtIndex:i]intValue];
				if (ON>=2)
				{
					NSLog(@"All: ON reduzieren");
					ON=0;
				}

				}break;
		}//switch all	
		
		//Einstellung fuer Tag fixieren
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"code"];

	

	}//for i
	if (MausIN)
	{
      //NSLog(@"ModeTagplanBalken m.down h: %d ON: %d",[[NotificationDic objectForKey:@"stunde" ] intValue], [[NotificationDic objectForKey:@"on" ] intValue]);
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Tagplancode" object:self userInfo:NotificationDic];
	}


	
	if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
		lastONArray=[[StundenArray valueForKey:@"code"]copy];//Speicherung IST-Zustand
	
	}

	
	
	
	
	
		[self setNeedsDisplay:YES];
}


@end

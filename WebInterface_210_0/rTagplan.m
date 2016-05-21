//
//  rTagplan.m
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rTagplan.h"

@implementation rTagplan

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code here.
		RandL=30;
		RandR=5;
		RandU=2;
		
		aktivArray=[[NSMutableArray alloc]initWithCapacity:0];
		StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
			Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	Tagpunkt.x=5;
	Tagpunkt.y=frame.size.height-20;

	//NSLog(@"Tagplan Init: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	int i=0;
	wochentag=0;
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	
	Ecke.x+=RandL;
	Ecke.y+=RandU;

      NSRect heuteTasteFeld;
      heuteTasteFeld.origin = Tagpunkt;
      heuteTasteFeld.origin.x += 50;
      heuteTasteFeld.origin.y -= 2;
      heuteTasteFeld.size.height = 16;
      heuteTasteFeld.size.width = 60;
      //rTaste* WriteTaste=[[[rTaste alloc]initWithFrame:WriteFeld]retain];
      heuteTaste = [[rTaste alloc]initWithFrame:heuteTasteFeld];
      [heuteTaste setTitle:@"Heute"];
      [heuteTaste setAction:@selector(reportHeuteTaste:)];
      [heuteTaste setTarget:self];
      [heuteTaste setButtonType: NSToggleButton];
      [heuteTaste setBordered:YES];
      [heuteTaste setState:YES];
      //[heuteTaste setBezelStyle:NSRegularSquareBezelStyle];
      
      
  //    [self addSubview:heuteTaste];



	}//if self
    return self;
	
}
- (IBAction)reportHeuteTaste:(id)sender
{
   NSLog(@"reportHeuteTaste Tag: %d Raum: %d",wochentag,raum);

}

- (void)setWochentag:(int)derTag
{
	NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	Wochentag=[Wochentage objectAtIndex:derTag];
	wochentag = derTag;
}

- (void)setRaum:(int)derRaum
{
   raum = derRaum;
}

- (int)Wochentag
{
   return wochentag;
}

- (int)Raum
{
   return raum;
}

- (NSString*)Titel
{
   return Wochentag;
}


- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag // nicht verwendet
{
	//NSLog(@"Tagplan setTagplan");
	NSLog(@"Tagplan setTagplan Tag: %d StundenArray: %@",derTag, [[StundenArray valueForKey:@"code"]description]);
	if (StundenArray==NULL)
	{
	StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	}

	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"awakeFromNib: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
   
   NSRect heuteTastenfeld;
   heuteTastenfeld.origin = Nullpunkt;
   heuteTastenfeld.origin.x = 15;
   heuteTastenfeld.origin.y = [self frame].size.height-20; //erster Plan oben
   heuteTastenfeld.size.width=20;
	heuteTastenfeld.size.height=10;
   
   heuteTaste = [[rTaste alloc]initWithFrame:heuteTastenfeld];
 
   //  [self addSubview:heuteTaste];

   
   
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=25;
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	//Elementhoehe=[self frame].size.height-2*RandU;
	Elementhoehe=35;
	//NSLog(@"Elementbreite: %d",Elementbreite);
	for (i=0;i<24;i++)
	{
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		//NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"kessel"];
		[StundenArray addObject:tempElementDic];
	}//for i

	
	
	//***
	wochentag=derTag;
	
	if (wochentag==0)
   {
      //NSLog(@"setTagplan Tag: %d StundenArray: %@",derTag, [StundenArray description]);
   }
	//NSLog(@"setTagplan Tag: %d derStundenArray: %@",derTag, [derStundenArray description]);
	for (i=0;i<24;i++)
	{
		//NSLog(@"setTagplan index: %d: kessel: %d",i,[[[derStundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue]);
		if ([StundenArray objectAtIndex:i])
		{
		NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
		//NSLog(@"
		[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"kessel"] forKey:@"kessel"];
		}
		else
		{
			//NSLog(@"setTagplan neuer Dic index: %d",i);
			NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"kessel"] forKey:@"kessel"];
			[StundenArray addObject:tempElementDic];
		
		
		}
	}//for i
	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];//Speicherung IST-Zustand
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setTagplan end: Tag: %d StundenArray: %@",derTag, [[StundenArray valueForKey:@"code"]description]);
	[self setNeedsDisplay:YES];
}


- (int)StundenArraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	NSLog(@"Tagplan StundenArraywertVonStunde");
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

- (NSArray*)StundenArrayForKey:(NSString*) derKey
{


return StundenArray;
}


- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
	//NSLog(@"setTagplan StundenArray: %@", [derStundenArray description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		int w=[[derStundenArray objectAtIndex:i]intValue];
		[self setStundenArraywert:w vonStunde:i forKey:derKey];
	}
		//NSDictionary* tempDic=[StundenArray objectAtIndex:i];			
		//NSLog(@"StundenArray:  %@",[[StundenArray valueForKey:@"kessel"]description]);
		
	
}

- (NSArray*)StundenByteArray
{
   return StundenByteArray;
}
- (void)setStundenByteArray:(NSArray*)derStundenArray
{
   StundenByteArray = derStundenArray;
  
}



- (void)setStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	NSLog(@"Tagplan setStundenArraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
	NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
	[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];

//	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];
	lastONArray=[[StundenArray valueForKey:derKey]copy];

	[self setNeedsDisplay:YES];
}



- (void)setNullpunkt:(NSPoint)derPunkt;
{
//Nullpunkt=derPunkt;
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		NSLog(@"setNullpunkt: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);

}

- (void)drawRect:(NSRect)dasFeld 
{
   
	[[NSColor blackColor]set];
	NSColor* hellGrau=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue: 0.0 alpha:0.1];
	NSColor* lightGreen=[NSColor colorWithCalibratedRed:0.0 green:0.9 blue: 0.1 alpha:0.2];
	NSColor* darkGreen=[NSColor colorWithCalibratedRed:0.0 green:0.8 blue: 0.2 alpha:1.0];
	//[NSBezierPath strokeRect:dasFeld];
	[lightGreen set];
	[NSBezierPath fillRect:dasFeld];
   
	NSFont* StundenFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* StundenAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
	NSFont* TagFont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSDictionary* TagAttrs=[NSDictionary dictionaryWithObject:TagFont forKey:NSFontAttributeName];
	//Wochentag=@"Hallo";
	//NSLog(@"Tagplan drawRect:  Wochentag: %d",Wochentag);
	[Wochentag drawAtPoint:Tagpunkt withAttributes:TagAttrs];
//	[self setNeedsDisplay:YES];
	
	

}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSLog(@"Tagplan mouseDown: event: x: %2.2f y: %2.2f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
   return;
	//NSLog(@"mouseDown: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	//NSLog(@"Bounds: x: %2.2f y: %2.2f h: %2.2f w: %2.2f ",[self frame].origin.x,[self frame].origin.y,[self frame].size.height,[self frame].size.width);
	NSLog(@"mouseDown: modifierFlags: %",[theEvent modifierFlags]);
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
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	NSLog(@"modifiers: modKey: %d",modKey);
   
   
   NSPoint globMaus=[theEvent locationInWindow];
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	NSLog(@"mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);

   
   	int all=-1;
   
   
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=2;
	
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;

	
	
	if ([self mouse:localMaus inRect:AllFeld])
	{
      NSLog(@"ALL-Taste");

	if (modKey==2)//alt
	{
		//NSLog(@"ALL-Taste mit alt");
		[NotificationDic setObject:@"alt" forKey:@"mod"];
		[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
		[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
		[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		NSLog(@"Tagplan mofdifier AllFeld");
		[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];

		return;
	}
      
		int sum=0;
		for (i=0;i<24;i++)
		{
			sum+=[[[StundenArray valueForKey:@"kessel"] objectAtIndex:i]intValue];
		}
      //NSLog(@"C");
		if (sum==0)//alle sind off: IST wiederherstellen
		{
			NSLog(@"IST wiederherstellen");
			all=2;
		}
		else if (sum==72)//alle sind ON,
		{
			NSLog(@"Alle OFF");
			all=0;
		}
		else if (sum && sum<72)//mehrere on: alle ON
		{
			NSLog(@"IST speichern");
			lastONArray=[[StundenArray valueForKey:@"kessel"]copy];//Speicherung IST-Zustand
			all=3;
		}
		
	}
   
	
	
	for (int i=0;i<24;i++)
	{
		[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
		
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
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
		
		//	if ((glob.x>r.origin.x)&&(glob.x<r.origin.x+r.size.width))
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue];
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
			[NotificationDic setObject:[NSNumber numberWithInt:wochentag] forKey:@"tag"];
		}
		
		if ([self mouse:localMaus inRect:StdFeldL])
		{
			
			//NSLog(@"mouse in Stunde: %d in Feld links ON: %d",i, ON);
			
			switch (ON)
			{
				case 0:// Kessel in der ersten halben Stunde neu einschalten __ > |_
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
			}
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"feld"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"Tagplan mofdifier StdFeldL");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				
				
			}
			
			
		}
		else if ([self mouse:localMaus inRect:StdFeldR])
		{
			//NSLog(@"mouse in Stunde: %d in Feld rechts ON: %d",i,ON);
			switch (ON)
			{
				case 0://	Kessel in der zweiten halben Stunde neu einschalten __ > _|
					ON=1;
					break;
				case 1://	Kessel in der zweiten halben Stunde neu ausschalten _| > __
					ON=0;
					break;
				case 2://	Kessel in der zweiten halben Stunde neu einschalten |_ > ||
					ON=3;
					break;
				case 3://	Kessel in der zweiten halben Stunde neu ausschalten	|| > |_
					ON=2;
					break;
					
			}
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:2] forKey:@"feld"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				NSLog(@"Tagplan mofdifier StdFeldR");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				
			}
			
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
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:3] forKey:@"feld"];				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				//NSLog(@"mouseDown Tagplan mofdifier StdFeldU");
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				
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
		
//		if (all < 0)//kein Klick auf ALL
		{
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"kessel"];
		}
		
		//[self setNeedsDisplay:YES];
		

	}//for i
			
	
	
	
	
	
	if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];
	}
	[self setNeedsDisplay:YES];
}


@end

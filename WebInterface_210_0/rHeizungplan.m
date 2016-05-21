//
//  rHeizungplan.m
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "rHeizungplan.h"

@implementation rHeizungplan

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		
	RandL=30;
	RandR=5;
	RandU=2;
	
    }
    return self;
}



- (void)awakeFromNib
{
/*
	StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	[StundenArray retain];
	lastONArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	

	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	NSLog(@"awakeFromNib: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	int i=0;
	tag=0;
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	
	Ecke.x+=RandL;
	Ecke.y+=RandU;
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	Elementhoehe=[self frame].size.height-2*RandU;

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
	//NSLog(@"Tagplan awake StundenArray: %@",[StundenArray description]);
*/
}

- (void)setModeTagplan:(NSArray*)derModeStundenArray forTag:(int)derTag
{
	/*
	if (ModeStundenArray==NULL)
	{
		ModeStundenArray=[[NSMutableArray alloc]initWithCapacity:0];
		[ModeStundenArray retain];
	}
	*/
	
	if (StundenArray==NULL)
	{
		StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	}
	
	int i=0;
	
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=2;
	//Elementbreite=([self frame].size.width-RandL-RandR)/24;
	//Elementhoehe=[self frame].size.height-2*RandU;
	int ModeElementhoehe=35;
	//NSLog(@"Elementbreite: %d",Elementbreite);
	
	for (i=0;i<24;i++)
	{
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, ModeElementhoehe-2);
		//NSLog(@"i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		//NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		[tempElementDic setObject:ElementView forKey:@"modeelementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"modetag"];
//		[ModeStundenArray addObject:tempElementDic];
//		[StundenArray addObject:tempElementDic];
	
	
	
	}//for i
	
	tag=derTag;
	
	for (i=0;i<24;i++)
	{
		//NSLog(@"setBrennerTagplan index: %d: kessel: %d",i,[[[derBrennerStundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue]);
		
		if ([StundenArray objectAtIndex:i])
		{
			NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
			//NSLog(@"Mode einsetzen in vorhandenem Objekt");
			//[tempElementDic setObject:[[derModeStundenArray objectAtIndex:i]objectForKey:@"modetag"] forKey:@"modetag"];
			//[tempElementDic setObject:[[derModeStundenArray objectAtIndex:i]objectForKey:@"modenacht"] forKey:@"modenacht"];
			NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, ModeElementhoehe-2);
			//NSLog(@"i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
			NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
			//NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
			[tempElementDic setObject:ElementView forKey:@"modeelementrahmen"];
			[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
			[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"modetag"];
			[tempElementDic setObject:[NSNumber numberWithInt:(i+1)%4] forKey:@"modenacht"];
		
		}
		
	}//for i
	//NSLog(@"setModeTagplan: ModeStundenArray: %@",[ModeStundenArray description]);
//	lastModeTagArray=[[[ModeStundenArray valueForKey:@"modetag"]copy]retain];//Speicherung IST-Zustand
	lastModeTagArray=[[StundenArray valueForKey:@"modetag"]copy];//Speicherung IST-Zustand
	
//	lastModeNachtArray=[[ModeStundenArray valueForKey:@"modenacht"]copy];//Speicherung IST-Zustand
	lastModeNachtArray=[[StundenArray valueForKey:@"modenacht"]copy];//Speicherung IST-Zustand
	
	//NSLog(@"setModeTagplan: lastModeTagArray: %@",[lastModeTagArray description]);
	[self setNeedsDisplay:YES];
		
		
}



- (void)setBrennerTagplan:(NSArray*)derBrennerStundenArray forTag:(int)derTag
{
	if (StundenArray==NULL)
	{
	StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	}

	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"awakeFromNib: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
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
//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:ElementView forKey:@"brennerelementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"kessel"];
		[StundenArray addObject:tempElementDic];
	}//for i

	
	
	//***
	tag=derTag;
	
	//NSLog(@"setBrennerTagplan Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	//NSLog(@"setBrennerTagplan Tag: %d derBrennerStundenArray: %@",derTag, [derBrennerStundenArray description]);
	for (i=0;i<24;i++)
	{
		//NSLog(@"setBrennerTagplan index: %d: kessel: %d",i,[[[derBrennerStundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue]);
		if ([StundenArray objectAtIndex:i])
		{
		NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
		//NSLog(@"
		[tempElementDic setObject:[[derBrennerStundenArray objectAtIndex:i]objectForKey:@"kessel"] forKey:@"kessel"];
		}
		else
		{
			//NSLog(@"setBrennerTagplan neuer Dic index: %d",i);
			NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempElementDic setObject:[[derBrennerStundenArray objectAtIndex:i]objectForKey:@"kessel"] forKey:@"kessel"];
			[StundenArray addObject:tempElementDic];
		
		
		}
	}//for i
	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];//Speicherung IST-Zustand
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setBrennerTagplan end: Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	[self setNeedsDisplay:YES];
}


- (int)BrennerStundenArraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey
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

- (NSArray*)BrennerStundenArrayForKey:(NSString*) derKey
{

NSArray* tempStundenArray= [StundenArray valueForKey:derKey];

return tempStundenArray;
}


- (void)setBrennerStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
	//NSLog(@"setBrennerTagplan StundenArray: %@", [derStundenArray description]);
	
	int i;
	for (i=0;i<24;i++)
	{
		int w=[[derStundenArray objectAtIndex:i]intValue];
		[self setBrennerStundenArraywert:w vonStunde:i forKey:derKey];
	}
		//NSDictionary* tempDic=[StundenArray objectAtIndex:i];			
		//NSLog(@"StundenArray:  %@",[[StundenArray valueForKey:@"kessel"]description]);
		
	
}


- (void)setBrennerStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	//NSLog(@"setBrennerStundenArraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
	NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
	[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];

//	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];
	lastONArray=[[StundenArray valueForKey:derKey]copy];

	[self setNeedsDisplay:YES];
}




- (void)setModeStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
int i;
for (i=0;i<24;i++)
{
	int w=[[derStundenArray objectAtIndex:i]intValue];
//	[self setModeStundenArraywert:w vonStunde:i forKey:derKey];
	[self setStundenArraywert:w vonStunde:i forKey:derKey];

}

}

- (void)setModeStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
NSLog(@"setModeStundenArraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
//NSMutableDictionary* tempDic=(NSMutableDictionary*)[ModeStundenArray objectAtIndex:dieStunde];
NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];
if ([derKey isEqualToString:@"modetag"])
{
	//lastModeTagArray=[[ModeStundenArray valueForKey:@"modetag"]copy];
	lastModeTagArray=[[StundenArray valueForKey:@"modetag"]copy];
}

if ([derKey isEqualToString:@"modenacht"])
{
//	lastModeTagArray=[[ModeStundenArray valueForKey:@"modenacht"]copy];
	lastModeTagArray=[[StundenArray valueForKey:@"modenacht"]copy];
}
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

- (NSArray*)StundenArrayForKey:(NSString*) derKey
{
NSArray* tempStundenArray= [StundenArray valueForKey:derKey];

return tempStundenArray;
}

- (void)setStundenArraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	//NSLog(@"setModeStundenArraywert: %d Stunde: %d Key: %@",derWert, dieStunde, derKey);
	NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
	[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];
	if ([derKey isEqualToString:@"modetag"])
	{
		lastModeTagArray=[[StundenArray valueForKey:@"modetag"]copy];
	}
	
	if ([derKey isEqualToString:@"modenacht"])
	{
		lastModeTagArray=[[StundenArray valueForKey:@"modenacht"]copy];
	}
	[self setNeedsDisplay:YES];
}

- (void)setStundenArray:(NSArray*)derStundenArray forKey:(NSString*)derKey
{
int i;
NSLog(@"setStundenArray: %@  Key: %@",[derStundenArray description],derKey);
for (i=0;i<24;i++)
{
	int w=[[derStundenArray objectAtIndex:i]intValue];
	[self setStundenArraywert:w vonStunde:i forKey:derKey];

}
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
    NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	[[NSColor blackColor]set];
	NSColor* hellGrau=[NSColor colorWithCalibratedRed:0.0 green:0.0 blue: 0.0 alpha:0.1];
	NSColor* lightGreen=[NSColor colorWithCalibratedRed:0.0 green:1.0 blue: 0.1 alpha:0.3];
	NSColor* darkGreen=[NSColor colorWithCalibratedRed:0.0 green:0.8 blue: 0.2 alpha:1.0];
	//[NSBezierPath strokeRect:dasFeld];
	[hellGrau set];
	[NSBezierPath fillRect:dasFeld];
	NSFont* StundenFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* StundenAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
	NSFont* TagFont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSDictionary* TagAttrs=[NSDictionary dictionaryWithObject:TagFont forKey:NSFontAttributeName];
	NSPoint TagPunkt=NSMakePoint(0.0,0.0);
	TagPunkt.x+=5;
	TagPunkt.y+=Elementhoehe/2+3;
	[[Wochentage objectAtIndex:tag] drawAtPoint:TagPunkt withAttributes:TagAttrs];
	
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"brennerelementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	AllFeld.origin.y+=4;
	AllFeld.size.height-=16;
	AllFeld.size.width*= 0.6;
	[[NSColor darkGrayColor]set];
	[NSBezierPath fillRect:AllFeld];
	int i;
	
	//Brenner zeichnen
	for (i=0;i<24;i++)
	{
		//NSLog(@"drawRect: %2.2f",[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame].origin.x);
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"brennerelementrahmen"]frame];
		NSString* Stunde=[[NSNumber numberWithInt:i]stringValue];
		NSPoint p=StdFeld.origin;
		StdFeld.size.height-=12;
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
		StdFeld.size.height-=6;
		StdFeld.origin.y+=6;
		[NSBezierPath fillRect:StdFeld];
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=6;
		StdFeldU.origin.y-=8;
		[[NSColor grayColor]set];
		[NSBezierPath fillRect:StdFeldU];
		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue];
		switch (ON)
		{
			case 0://ganze Stunde OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[NSBezierPath fillRect:StdFeldR];
				
				break;
			
			case 2://	bit0, erste halbe Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldR];
				
				
				break;
			
			case 1://	bit1, zweite halbe Stunde ON
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
	}
	
	
	//Mode zeichnen		
	//NSLog(@"drawRect:ModeStundenArray: %@",[[ModeStundenArray objectAtIndex:0]description]);
	//NSLog(@"drawRect:StundenArray: %@",[[StundenArray objectAtIndex:0]description]);
	
	
	for (i=0;i<24;i++)
	{
		//NSLog(@"drawRect: %2.2f",[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame].origin.x);
//		NSRect StdFeld=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		StdFeld.size.height-=10;

		[[NSColor whiteColor]set];
		StdFeld.size.height-=10;
		StdFeld.origin.y+=1;
		[NSBezierPath fillRect:StdFeld];
		
		NSRect StdFeldT=StdFeld;//Mode Tag
		StdFeldT.size.height/=2;
		StdFeldT.origin.y+=1;
		StdFeldT.origin.y+=StdFeldT.size.height;
		NSRect StdFeldN=StdFeld;
		StdFeldN.size.height/=2;
		StdFeldN.size.height-=1;
		//if (i==0)
		{
//		NSLog(@"drawRect:ModeStundenArray:ONT: %d",[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue]);
//		NSLog(@"drawRect:StundenArray:ONT: %d",[[[StundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue]);
		}
//		int ONT=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue];
		int ONT=[[[StundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue];
		switch (ONT)
		{
			case 0:// OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldT];
				break;
			case 1:// red
				//[[NSColor greenColor]set];
				[lightGreen set];
				[NSBezierPath fillRect:StdFeldT];
				
				break;
			case 2:// voll
				//[[NSColor redColor]set];
				[darkGreen set];
				[NSBezierPath fillRect:StdFeldT];
		}
		
//		int ONN=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modenacht"]intValue];
		int ONN=[[[StundenArray objectAtIndex:i]objectForKey:@"modenacht"]intValue];
		switch (ONN)
		{
			case 0:// OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldN];
				break;
			case 1:// red
				//[[NSColor greenColor]set];
				[lightGreen set];

				[NSBezierPath fillRect:StdFeldN];
				
				break;
			case 2:// voll
				//[[NSColor redColor]set];
				[darkGreen set];

				[NSBezierPath fillRect:StdFeldN];
		}
		
	}//for i Mode
	//AllFeld fuer Tag
//	NSRect AllTFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllTFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	
	AllTFeld.origin.x+=Elementbreite+2;
	AllTFeld.origin.y+=AllTFeld.size.height/4;
	AllTFeld.size.height/=4;
	AllTFeld.size.height-=2;
	AllTFeld.size.width*=0.6;

	[[NSColor darkGrayColor] set];
	[NSBezierPath fillRect:AllTFeld];
	
	//Allfeld fuer Nacht
//	NSRect AllNFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllNFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	AllNFeld.origin.x+=Elementbreite+2;
	AllNFeld.size.height/=4;
	AllNFeld.size.height-=2;
	AllNFeld.size.width*=0.6;

	[[NSColor darkGrayColor] set];
	[NSBezierPath fillRect:AllNFeld];

}

- (void)mouseDown:(NSEvent *)theEvent
{
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
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"brennerelementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	AllFeld.origin.y+=4;
	AllFeld.size.height-=16;
	AllFeld.size.width*= 0.6;
	
	NSPoint globMaus=[theEvent locationInWindow];
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	//NSLog(@"mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;
	int all=-1;
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	
	if ([self mouse:localMaus inRect:AllFeld])
	{
	if (modKey==2)//alt
	{
		//NSLog(@"ALL-Taste mit alt");
		[NotificationDic setObject:@"alt" forKey:@"mod"];
		[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
		[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
		[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];

		return;
	}
		int sum=0;
		for (i=0;i<24;i++)
		{
			sum+=[[[StundenArray valueForKey:@"kessel"] objectAtIndex:i]intValue];
		}
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

	//AllFeld fuer Tag
//	NSRect AllTFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllTFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	AllTFeld.origin.x+=Elementbreite+2;
	AllTFeld.origin.y+=AllTFeld.size.height/4;
	AllTFeld.size.height/=4;
	AllTFeld.size.height-=2;
	AllTFeld.size.width*=0.6;
	
	int modealltag=-1;
	if ([self mouse:localMaus inRect:AllTFeld])
	{
		NSLog(@"AllTFeld");
		if (modKey==2)//alt
		{
			NSLog(@"ALL-Taste mit alt: lastModeTagArray: %@",[lastModeTagArray description]);
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
			[NotificationDic setObject:lastModeTagArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:11] forKey:@"feld"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			
			return;
		}

		int sumred=0;
		int sumvoll=0;
		for (i=0;i<24;i++)
		{
//			int m=[[[ModeStundenArray valueForKey:@"modetag"] objectAtIndex:i]intValue];
			int m=[[[StundenArray valueForKey:@"modetag"] objectAtIndex:i]intValue];
			if (m==1)
			{
			sumred+=1;
			}
			if (m==2)
			{
			sumvoll+=2;
			}

		}
		
		if (sumred+sumvoll==0)//alle sind off: IST wiederherstellen
		{
			NSLog(@"Alle sind OFF: IST wiederherstellen");
			modealltag=3;
		}
		else if (sumred==24)//alle sind red, alle werden voll
		{
			NSLog(@"Alle sind red");
			modealltag=2;
		}
		else if (sumvoll==48)//alle sind voll, alle werden OFF
		{
			NSLog(@"Alle sind ON");
			modealltag=0;
		}
		else if ((sumred+sumvoll) && (sumred+sumvoll)<48)//mehrere on: alle red
		{
			NSLog(@"gemischt, IST speichern");
//			lastModeTagArray=[[ModeStundenArray valueForKey:@"modetag"]copy];//Speicherung IST-Zustand
			lastModeTagArray=[[StundenArray valueForKey:@"modetag"]copy];//Speicherung IST-Zustand
			modealltag=1;
		}
		
	}
	

	//Allfeld fuer Nacht
//	NSRect AllNFeld=[[[ModeStundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	NSRect AllNFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"modeelementrahmen"]frame];
	AllNFeld.origin.x+=Elementbreite+2;
	AllNFeld.size.height/=4;
	AllNFeld.size.height-=2;
	AllNFeld.size.width*=0.6;

	int modeallnacht=-1;
	if ([self mouse:localMaus inRect:AllNFeld])
	{
		//NSLog(@"AllNFeld");
		if (modKey==2)//alt
		{
			//NSLog(@"ALL-Taste mit alt: lastModeNachtArray: %@",[lastModeNachtArray description]);
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
			[NotificationDic setObject:lastModeNachtArray forKey:@"lastonarray"];
			[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
			[NotificationDic setObject:[NSNumber numberWithInt:13] forKey:@"feld"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
			
			return;
		}

		
		int sumred=0;
		int sumvoll=0;
		for (i=0;i<24;i++)
		{
//			int m=[[[ModeStundenArray valueForKey:@"modenacht"] objectAtIndex:i]intValue];
			int m=[[[StundenArray valueForKey:@"modenacht"] objectAtIndex:i]intValue];
			if (m==1)
			{
			sumred+=1;
			}
			if (m==2)
			{
			sumvoll+=2;
			}

		}
		
		if (sumred+sumvoll==0)//alle sind off: IST wiederherstellen
		{
			NSLog(@"Alle sind OFF: IST wiederherstellen");
			modeallnacht=3;
		}
		else if (sumred==24)//alle sind red, alle werden voll
		{
			NSLog(@"Alle sind red");
			modeallnacht=2;
		}
		else if (sumvoll==48)//alle sind voll, alle werden OFF
		{
			NSLog(@"Alle sind ON");
			modeallnacht=0;
		}
		else if ((sumred+sumvoll) && (sumred+sumvoll)<48)//mehrere on: alle red
		{
			NSLog(@"gemischt");
			modeallnacht=1;
		}
		
	}

	
	for (i=0;i<24;i++)
	{
		[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
		
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"brennerelementrahmen"]frame];
		
		StdFeld.size.height-=18;
		StdFeld.origin.y+=6;
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=6;
		StdFeldU.origin.y-=8;
		
		//	if ((glob.x>r.origin.x)&&(glob.x<r.origin.x+r.size.width))
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"kessel"]intValue];
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
			[NotificationDic setObject:[NSNumber numberWithInt:tag] forKey:@"tag"];
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
		


		//Mode abfragen

//		StdFeld=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"modeelementrahmen"]frame];
		StdFeld.size.height-=10;
		
		StdFeld.size.height-=10;
		StdFeld.origin.y+=1;
		
		NSRect StdFeldT=StdFeld;//Mode Tag
		StdFeldT.size.height/=2;
		StdFeldT.origin.y+=StdFeldT.size.height+1;
		NSRect StdFeldN=StdFeld;
		StdFeldN.size.height/=2;
		StdFeldN.size.height-=1;
		
//		int modeONT=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue];
		int modeONT=[[[StundenArray objectAtIndex:i]objectForKey:@"modetag"]intValue];
		
		if ([self mouse:localMaus inRect:StdFeldT])
		{
			//NSLog(@"mouse in Stunde: %d in Feld Tag ON: %d",i, modeONT);
			if (modeONT<2)
			{
				modeONT++;
			}
			else
			{
				modeONT=0;
			}
			
			if (modKey==2)//alt
			{
				NSLog(@"mouse mit ALT in Stunde: %d in Feld Tag ON: %d",i, modeONT);
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:modeONT] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:10] forKey:@"feld"];				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;

			}
		}
//		int modeONN=[[[ModeStundenArray objectAtIndex:i]objectForKey:@"modenacht"]intValue];
		int modeONN=[[[StundenArray objectAtIndex:i]objectForKey:@"modenacht"]intValue];
				
		if ([self mouse:localMaus inRect:StdFeldN])
		{
			//NSLog(@"mouse in Stunde: %d in Feld Nacht ON: %d",i, modeONN);
			if (modeONN<2)
			{
				modeONN++;
			}
			else
			{
				modeONN=0;
			}
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:modeONN] forKey:@"on"];
				[NotificationDic setObject:[NSNumber numberWithInt:12] forKey:@"feld"];				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;

		}
			
		}

	switch (modealltag)//Klick auf ALL Tag Taste registrieren
		{
			case 0://alle OFF schalten
			case 1://alle red schalten
			case 2://alle voll schalten
				modeONT=modealltag;
				break;
			case 3://Wiederherstellen
				   //NSLog(@"IST: lastModeTagArray: %@",[lastModeTagArray description]);
				modeONT=[[lastModeTagArray objectAtIndex:i]intValue];
				break;
		}//switch all	
		
		//Einstellung fuer Tag fixieren
//		[[ModeStundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:modeONT]forKey:@"modetag"];
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:modeONT]forKey:@"modetag"];

	switch (modeallnacht)//Klick auf ALL Nacht Taste registrieren
		{
			case 0://alle OFF schalten
			case 1://alle red schalten
			case 2://alle voll schalten
				modeONN=modeallnacht;
				break;
			case 3://Wiederherstellen
				   //NSLog(@"IST: lastModeTagArray: %@",[lastModeTagArray description]);
				modeONN=[[lastModeNachtArray objectAtIndex:i]intValue];
				break;
		}//switch all	

		//Einstellung fuer Nacht fixieren
		
//		[[ModeStundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:modeONN]forKey:@"modenacht"];
		[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:modeONN]forKey:@"modenacht"];

	}//for i
			
	if (modealltag<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
//		lastModeTagArray=[[ModeStundenArray valueForKey:@"modetag"]copy];//Speicherung IST-Zustand
		lastModeTagArray=[[StundenArray valueForKey:@"modetag"]copy];//Speicherung IST-Zustand
	
	}

	
	NSMutableDictionary* ModeNotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	if (modeallnacht<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
//		lastModeNachtArray=[[ModeStundenArray valueForKey:@"modenacht"]copy];//Speicherung IST-Zustand
		lastModeNachtArray=[[StundenArray valueForKey:@"modenacht"]copy];//Speicherung IST-Zustand
	}
	
	
	
	
	if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
	lastONArray=[[StundenArray valueForKey:@"kessel"]copy];
	}
	[self setNeedsDisplay:YES];
}


@end

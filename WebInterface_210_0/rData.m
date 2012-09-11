//
//  rData.m
//  WebInterface
//
//  Created by Sysadmin on 05.02.09.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rData.h"
#import "rHeizungplan.h"

#define MO 0
#define DI 1



extern NSMutableArray* DatenplanTabelle;
@implementation rData
- (void) logRect:(NSRect)r
{
	NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}

- (void)Alert:(NSString*)derFehler
{
	
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
										 defaultButton:NULL 
									   alternateButton:NULL 
										   otherButton:NULL 
							 informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
	[DebugAlert runModal];
	
}

- (NSString*)IntToBin:(int)dieZahl
{
	int rest=0;
	int zahl=dieZahl;
	NSString* BinString=[NSString string];;
	while (zahl)
	{
		rest=zahl%2;
		if (rest)
		{
			BinString=[@"1" stringByAppendingString:BinString];
		}
		else
		{
			BinString=[@"0" stringByAppendingString:BinString];
		}
		zahl/=2;
		//NSLog(@"BinString: %@",BinString);
	}
	return BinString;
}

- (int)HexStringZuInt:(NSString*) derHexString
{
	int returnInt=-1;
	NSScanner* theScanner = [NSScanner scannerWithString:derHexString];
	
	if ([theScanner scanHexInt:&returnInt])
	{
		//NSLog(@"HexStringZuInt string: %@ int: %d	",derHexString,returnInt);
		return returnInt;
	}
	
	return returnInt;
}

- (id) init
{
    //if ((self = [super init]))
	//[self Alert:@"Data init vor super"];
	
	self = [super initWithWindowNibName:@"Data"];
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
		   selector:@selector(ReadAktion:)
			   name:@"read"
			 object:nil];
	
	
	[nc addObserver:self
		   selector:@selector(IOWAktion:)
			   name:@"iow"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(BrenndauerAktion:)
			   name:@"Brenndauer"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(ReadStartAktion:)
			   name:@"ReadStart"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(ExterneDatenAktion:)
			   name:@"externedaten"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(LastDatenAktion:)
			   name:@"lasthomedata"
			 object:nil];
	
	[nc addObserver:self
		   selector:@selector(ErrStringAktion:)
			   name:@"errstring"
			 object:nil];
	
	[nc addObserver:self
			 selector:@selector(HomeDataDownloadAktion:) // Loadmark aktivieren
				  name:@"HomeDataDownload"
				object:nil];

	[nc addObserver:self
		   selector:@selector(LastSolarDatenAktion:)
			   name:@"lastsolardata"
			 object:nil];


	[nc addObserver:self
			 selector:@selector(SolarDataDownloadAktion:) // Loadmark aktivieren
				  name:@"SolarDataDownload"
				object:nil];

	[nc addObserver:self
		   selector:@selector(ExterneSolarDatenAktion:)
			   name:@"externesolardaten"
			 object:nil];
	

	
	Raumnamen=[NSArray arrayWithObjects:@"Heizung", @"Werkstatt",@"WoZi",@"Buero",@"Labor",@"OG 1",@"OG 2",@"Estrich",NULL];
	[Raumnamen retain];
	Eingangsdaten=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	TemperaturDaten=[[NSMutableDictionary alloc]initWithCapacity:0];
	TemperaturZeilenString=[[NSMutableString alloc]init];
	DumpArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];

	HeizungKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[HeizungKanalArray setArray:[NSArray arrayWithObjects:@"1",@"1",@"1",@"0" ,@"0",@"0",@"0",@"1",nil]];


	BrennerKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[BrennerKanalArray setArray:[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]];

	BrennerStatistikKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[BrennerStatistikKanalArray setArray:[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]];

	BrennerStatistikTemperaturKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[BrennerStatistikTemperaturKanalArray setArray:[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]];
	

	SolarKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[SolarKanalArray setArray:[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]];
	
/*
	SolarKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	[SolarKanalArray setArray:[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]];
*/	
	
	n=0;
	aktuellerTag=0;
	IOW_busy=0;
	AnzReports=0;
	ReportErrIndex=-1;
	ErrZuLang=0;
	ErrZuKurz=0;
	TemperaturNullpunkt=0;
	SimRun=0;
	simDaySaved=0;
	SerieSize=8;
	par=0; // Paritaet
	Quelle=0; // Herkunft der Daten. 0: IOW		1: Datei
	//if (self)
	//NSLog(@"Data OK");
	NSRect DruckViewRect=NSMakeRect(0,0,200,800);
	DruckDatenView=[[NSTextView alloc]initWithFrame:DruckViewRect];
	Scrollermass=0;
	Kalenderblocker=0;
	SolarKalenderblocker=0;
	Heuteblocker=0;
	SolarHeuteblocker=0;
	return self;
}	//init

- (void)awakeFromNib
{
	[SolaranlageBild setImage: [NSImage imageNamed: @"Solar.jpg"]];
	//oldHour=[[NSCalendarDate date]hourOfDay];
	Data_DS=[[rData_DS alloc]init];
	[DatenplanTable setDelegate:Data_DS];
	[DatenplanTable setDataSource:Data_DS];
	//	[[[self window]contentView] addSubview:DatenplanTable];
	//NSSegmentedCell* StdCell=[[NSSegmentedCell alloc]init];
	
	[DatenplanTab setDelegate:self];
	int anzTabs=[DatenplanTab numberOfTabViewItems];
	int tabindex=0;
	for (tabindex=0;tabindex<anzTabs;tabindex++)
	{
		[[DatenplanTab tabViewItemAtIndex:tabindex]setIdentifier:[NSNumber numberWithInt:tabindex]];
	}
	
	NSRect scRect=NSMakeRect(0,0,10,10);
	NSSegmentedControl* SC=[[NSSegmentedControl alloc]initWithFrame:scRect];
	[[SC cell]setSegmentCount:2];
	
	//[StdCell selectSegmentWithTag:1];
	//NSRect r=[[StdCell contentView] frame];
	DatenserieStartZeit=[NSCalendarDate calendarDate];
	[DatenserieStartZeit retain];
	SimDatenserieStartZeit=[NSCalendarDate calendarDate];
	[SimDatenserieStartZeit retain];
	
	[Kalender setCalendar:[NSCalendar currentCalendar]];
	[Kalender setDateValue: [NSDate date]];

	[SolarKalender setCalendar:[NSCalendar currentCalendar]];
	[SolarKalender setDateValue: [NSDate date]];
	
	
	//NSString* PickDate=[[Kalender dateValue]description];
	//NSLog(@"PickDate: %@",PickDate);
	//NSDate* KalenderDatum=[Kalender dateValue];
	//NSLog(@"Kalenderdatum: %@",KalenderDatum);
	//NSArray* DatumStringArray=[PickDate componentsSeparatedByString:@" "];
	//NSLog(@"DatumStringArray: %@",[DatumStringArray description]);
	
	//NSArray* DatumArray=[[DatumStringArray objectAtIndex:0] componentsSeparatedByString:@"-"];
	//NSString* SuffixString=[NSString stringWithFormat:@"/HomeDaten/HomeDaten%@%@%@",[[DatumArray objectAtIndex:0]substringFromIndex:2],[DatumArray objectAtIndex:1],[DatumArray objectAtIndex:2]];
	//NSLog(@"DatumArray: %@",[DatumArray description]);
	//NSLog(@"SuffixString: %@",SuffixString);
	//NSLog(@"tag: %d jahr: %d",tag,jahr);
	
	
	[TemperaturDaten setObject:[NSCalendarDate calendarDate] forKey:@"datenseriestartzeit"];
	
	NSMutableArray* tempStartWerteArray=[[NSMutableArray alloc]initWithCapacity:8];
	int i;
	for (i=0;i<8;i++)
	{
		//float y=(float)random() / RAND_MAX * (255);
		float starty=127.0;
		[tempStartWerteArray addObject:[NSNumber numberWithInt:(int)starty]];
	}
	//		[TemperaturMKDiagramm setStartWerteArray:tempStartWerteArray];
	
	
	
	GesamtDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	
	Datenplan=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	
	//	NSRect DatenplanTabRect=[DatenplanTab bounds];
	//NSLog(@"Data awake: x: %2.2f y: %2.2f",[DatenplanTab bounds].size.height,[DatenplanTab bounds].size.width);
	ZeitKompression=[[ZeitKompressionTaste titleOfSelectedItem]floatValue];
	
	//int k;
	//for (k=0;k<25; k++)
	//{
		//NSLog(@"Zahl: %d BinString: %@",k, [self IntToBin:k]); 
	//}
	
#pragma mark awake TemperaturDiagrammScroller
	[TemperaturDiagrammScroller setHasHorizontalScroller:YES];
	[TemperaturDiagrammScroller setDrawsBackground:YES];
	[TemperaturDiagrammScroller setAutoresizingMask:NSViewWidthSizable];
	//[TemperaturDiagrammScroller setBackgroundColor:[NSColor blueColor]];
	[TemperaturDiagrammScroller setHorizontalLineScroll:1.0];
	//[TemperaturDiagrammScroller setAutohidesScrollers:NO];
	//[TemperaturDiagrammScroller setBorderType:NSLineBorder];
	//[[TemperaturDiagrammScroller horizontalScroller]setFloatValue:1.0];
	//[[TemperaturDiagrammScroller documentView] setFlipped:YES];
	
	NSRect TemperaturScrollerRect=[[TemperaturDiagrammScroller contentView]frame];
	
	NSView* ScrollerView=[[NSView alloc]initWithFrame:TemperaturScrollerRect];
	
	[ScrollerView setAutoresizesSubviews:YES];
	[TemperaturDiagrammScroller setDocumentView:ScrollerView];
	[TemperaturDiagrammScroller setAutoresizesSubviews:YES];
	//NSRect TestRect=[[TemperaturDiagrammScroller documentView]frame];
	//[self logRect:TestRect];
	
	float Brennerlage=236; // Abstand des Brennerdiagramms mit den Einschaltbalken von unteren Rand des Temperaturdiagrammes
	
	NSRect MKDiagrammFeld=TemperaturScrollerRect;
	MKDiagrammFeld.origin.x += 0.1;
	MKDiagrammFeld.size.width -= 2;
	
	//MKDiagrammFeld.origin.y +=16;
	MKDiagrammFeld.size.height=220;
	TemperaturMKDiagramm= [[rTemperaturMKDiagramm alloc]initWithFrame:MKDiagrammFeld];
	[TemperaturMKDiagramm  setPostsFrameChangedNotifications:YES];
	[TemperaturMKDiagramm setTag:100];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[[TemperaturDiagrammScroller documentView]addSubview:TemperaturMKDiagramm];
	[TemperaturDiagrammScroller  setPostsFrameChangedNotifications:YES];
/*
	NSRect EKDiagrammFeld=MKDiagrammFeld;
	EKDiagrammFeld.origin.y+=220;
	EKDiagrammFeld.size.height=20;
	NSTextView* EKDiagrammView =[[NSTextView alloc] initWithFrame: EKDiagrammFeld];
	[EKDiagrammView setDrawsBackground:YES];
	[EKDiagrammView setBackgroundColor:[NSColor redColor]];
	//	[[TemperaturDiagrammScroller documentView]addSubview:EKDiagrammView];
*/	
	
	NSRect BrennerDiagrammFeld=MKDiagrammFeld;
	BrennerDiagrammFeld.origin.y+=Brennerlage;
	BrennerDiagrammFeld.size.height=50;
	BrennerDiagramm =[[rEinschaltDiagramm alloc] initWithFrame: BrennerDiagrammFeld];
	[BrennerDiagramm setAnzahlBalken:5];
	[[TemperaturDiagrammScroller documentView]addSubview:BrennerDiagramm];
	
	
	NSRect GitterlinienFeld=TemperaturScrollerRect;
	GitterlinienFeld.origin.x += 0.1;
	
	
	Gitterlinien =[[rDiagrammGitterlinien alloc] initWithFrame: GitterlinienFeld];
	[[TemperaturDiagrammScroller documentView]addSubview:Gitterlinien positioned:NSWindowBelow relativeTo:BrennerDiagramm];
	
	
	// History
	/*
	[HistoryScroller setHasHorizontalScroller:YES];
	[HistoryScroller setDrawsBackground:YES];
	[HistoryScroller setAutoresizingMask:NSViewWidthSizable];
	//[HistoryScroller setBackgroundColor:[NSColor blueColor]];
	[HistoryScroller setHorizontalLineScroll:1.0];
	//[HistoryScroller setAutohidesScrollers:NO];
	//[HistoryScroller setBorderType:NSLineBorder];
	//[[HistoryScroller horizontalScroller]setFloatValue:1.0];
	//[[HistoryScroller documentView] setFlipped:YES];
	
	NSRect HistoryScrollerRect=[[HistoryScroller contentView]frame];
	
	NSView* HistoryScrollerView=[[NSView alloc]initWithFrame:HistoryScrollerRect];
	
	[HistoryScroller setAutoresizesSubviews:YES];
	[HistoryScroller setDocumentView:ScrollerView];
	[HistoryScroller setAutoresizesSubviews:YES];
	//NSRect TestRect=[[TemperaturDiagrammScroller documentView]frame];
	//[self logRect:TestRect];
	
	float HistoryBrennerlage=220;
	
	NSRect HistoryDiagrammFeld=HistoryScrollerRect;
	HistoryDiagrammFeld.origin.x += 0.1;
	HistoryDiagrammFeld.size.width -= 2;
	
	//MKDiagrammFeld.origin.y +=16;
	HistoryDiagrammFeld.size.height=220;
	HistoryTemperaturMKDiagramm= [[rTemperaturMKDiagramm alloc]initWithFrame:HistoryDiagrammFeld];
	[HistoryTemperaturMKDiagramm  setPostsFrameChangedNotifications:YES];
	[HistoryTemperaturMKDiagramm setTag:100];
	[HistoryTemperaturMKDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[HistoryTemperaturMKDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[HistoryTemperaturMKDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[HistoryTemperaturMKDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[[HistoryScroller documentView]addSubview:HistoryTemperaturMKDiagramm];
	[HistoryScroller  setPostsFrameChangedNotifications:YES];
	NSRect EKHistoryDiagrammFeld=HistoryDiagrammFeld;
	EKHistoryDiagrammFeld.origin.y+=220;
	EKHistoryDiagrammFeld.size.height=20;
	NSTextView* EKHistoryDiagrammView =[[NSTextView alloc] initWithFrame: EKHistoryDiagrammFeld];
	[EKHistoryDiagrammView setDrawsBackground:YES];
	[EKHistoryDiagrammView setBackgroundColor:[NSColor redColor]];
	//	[[TemperaturDiagrammScroller documentView]addSubview:EKDiagrammView];
	
	
	NSRect BrennerHistoryDiagrammFeld=HistoryDiagrammFeld;
	BrennerHistoryDiagrammFeld.origin.y+=HistoryBrennerlage;
	BrennerHistoryDiagrammFeld.size.height=50;
	HistoryBrennerDiagramm =[[rEinschaltDiagramm alloc] initWithFrame: BrennerHistoryDiagrammFeld];
	[HistoryBrennerDiagramm setAnzahlBalken:4];
	[[HistoryScroller documentView]addSubview:HistoryBrennerDiagramm];
	
	
	NSRect HistoryGitterlinienFeld=HistoryScrollerRect;
	HistoryGitterlinienFeld.origin.x += 0.1;
	
	
	HistoryGitterlinien =[[rDiagrammGitterlinien alloc] initWithFrame: HistoryGitterlinienFeld];
	[[HistoryScroller documentView]addSubview:HistoryGitterlinien positioned:NSWindowBelow relativeTo:HistoryBrennerDiagramm];
	
	
	
	
	// end History
	*/
	
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
			 selector:@selector(FrameDidChangeAktion:)
				  name:@"NSWindowDidResizeNotification"
				object:nil];
	
		
	//[TemperaturDiagrammScroller addSubview:ScrollerView];
	//NSLog(@"Data awake GesamtDatenArray: %@",[GesamtDatenArray description]);
	NSPoint DiagrammEcke=[TemperaturMKDiagramm frame].origin;
	
	//DiagrammEcke.x+=100;
	[TemperaturMKDiagramm setFrameOrigin:DiagrammEcke];
	
	float wert1tab=60;
	float wert2tab=100;
	int Textschnitt=12;
	
	NSFont* TextFont;
	TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
	
	NSMutableParagraphStyle* TabellenKopfStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[TabellenKopfStil setTabStops:[NSArray array]];
	NSTextTab* TabellenkopfWert1Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert1tab]autorelease];
	[TabellenKopfStil addTabStop:TabellenkopfWert1Tab];
	NSTextTab* TabellenkopfWert2Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert2tab]autorelease];
	[TabellenKopfStil addTabStop:TabellenkopfWert2Tab];
	NSMutableParagraphStyle* TabelleStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[TabelleStil setTabStops:[NSArray array]];
	//	[self Alert:@"ADWandler awake: nach TabelleStil setTabStops"];
	NSMutableString* TabellenkopfString=[NSMutableString stringWithCapacity:0];
	[TabellenkopfString retain];
	NSArray* TabellenkopfArray=[[NSArray arrayWithObjects:@"Zeit",@"Wert",nil]retain];
	int index;
	for (index=0;index<[TabellenkopfArray count];index++)
	{
		NSString* tempKopfString=[TabellenkopfArray objectAtIndex:index];
		//NSLog(@"tempKopfString: %@",tempKopfString);
		//Kommentar als Array von Zeilen
		[TabellenkopfString appendFormat:@"\t%@",tempKopfString];
		//NSLog(@"KommentarString: %@  index:%d",KommentarString,index);
		
	}
	//	[self Alert:@"ADWandler awake: vor TabellenkopfString appendStrin"];
	//[TabellenkopfString appendString:@"\n"];
	
	NSMutableAttributedString* attrKopfString=[[[NSMutableAttributedString alloc] initWithString:TabellenkopfString] autorelease]; 
	[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
	[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
	//[[TemperaturDatenFeld textStorage]appendAttributedString:attrKopfString];
	//[TemperaturDatenFeld setString:TabellenkopfString];
	
	float zeittab=50;
	float werttab=30;
	
	int MKTextschnitt=12;
	NSFont* MKTextFont;
	MKTextFont=[NSFont fontWithName:@"Helvetica" size: MKTextschnitt];
	NSMutableString* MKTabellenkopfString=[NSMutableString stringWithCapacity:0];
	[MKTabellenkopfString retain];
	NSMutableParagraphStyle* MKTabellenKopfStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[MKTabellenKopfStil setTabStops:[NSArray array]];
	NSTextTab* TabellenkopfZeitTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab]autorelease];
	[MKTabellenKopfStil addTabStop:TabellenkopfZeitTab];
	
	[MKTabellenkopfString appendFormat:@"\t%@",@"Zeit"];// Zusätzlicher Tab fuer erste Zahl
	for (i=0;i<8;i++) 
	{
		NSTextTab* TabellenkopfWertTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab+(i+1)*werttab]autorelease];
		[MKTabellenKopfStil addTabStop:TabellenkopfWertTab];
		[MKTabellenkopfString appendFormat:@"\t%@",[[NSNumber numberWithInt:i]stringValue]];
	}
	NSMutableParagraphStyle* MKTabelleStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[MKTabelleStil setTabStops:[NSArray array]];
	
	[MKTabellenkopfString appendString:@"\n"];
	NSMutableAttributedString* MKTabellenKopfString=[[[NSMutableAttributedString alloc] initWithString:MKTabellenkopfString] autorelease]; 
	
	[MKTabellenKopfString addAttribute:NSParagraphStyleAttributeName value:MKTabellenKopfStil range:NSMakeRange(0,[MKTabellenkopfString length])];
	[MKTabellenKopfString addAttribute:NSFontAttributeName value:MKTextFont range:NSMakeRange(0,[MKTabellenkopfString length])];
	
	[[TemperaturWertFeld textStorage]appendAttributedString:MKTabellenKopfString];
	
	
	//
	NSMutableString* MKTabellenString=[NSMutableString stringWithCapacity:0];
	[MKTabellenString retain];
	NSMutableParagraphStyle* MKTabellenStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[MKTabellenStil setTabStops:[NSArray array]];
	//NSTextTab* TabellenZeitTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab]autorelease];
	[MKTabellenStil addTabStop:TabellenkopfZeitTab];
	
	[MKTabellenString appendFormat:@"\t"];// Zusätzlicher Tab fuer erste Zahl
	for (i=0;i<8;i++) 
	{
		NSTextTab* TabellenWertTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab+(i+1)*werttab]autorelease];
		[MKTabellenStil addTabStop:TabellenWertTab];
		[MKTabellenString appendFormat:@"\t"];
	}
	[MKTabelleStil setTabStops:[NSArray array]];
	
	//[MKTabellenString appendString:@"\n"];
	NSMutableAttributedString* MKattrString=[[[NSMutableAttributedString alloc] initWithString:MKTabellenString] autorelease]; 
	
	[MKattrString addAttribute:NSParagraphStyleAttributeName value:MKTabellenStil range:NSMakeRange(0,[MKTabellenString length])];
	[MKattrString addAttribute:NSFontAttributeName value:MKTextFont range:NSMakeRange(0,[MKTabellenString length])];

	[[TemperaturDatenFeld textStorage]appendAttributedString:MKattrString];
	//	[TemperaturDatenFeld setString:MKTabellenkopfString];
	//	[TemperaturWertFeld setString:MKTabellenkopfString];
	
	NSRect TemperaturOrdinatenFeld=[TemperaturDiagrammScroller frame];
	TemperaturOrdinatenFeld.size.width=30;
	TemperaturOrdinatenFeld.size.height=[TemperaturMKDiagramm frame].size.height;
	
	TemperaturOrdinatenFeld.origin.x-=30;
	TemperaturOrdinatenFeld.origin.y+=Scrollermass;
	TemperaturOrdinate=[[rOrdinate alloc]initWithFrame:TemperaturOrdinatenFeld];
	[TemperaturOrdinate setTag:101];
	[TemperaturOrdinate setGrundlinienOffset:4.1];
	//int MehrkanalTabIndex=[DatenplanTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
	//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	[[[DatenplanTab tabViewItemAtIndex:0]view]addSubview:TemperaturOrdinate];
	[TemperaturMKDiagramm setOrdinate:TemperaturOrdinate];
	
	NSRect BrennerLegendeFeld=[TemperaturDiagrammScroller frame];
	BrennerLegendeFeld.size.width=60;
	BrennerLegendeFeld.size.height=[BrennerDiagramm frame].size.height;
	BrennerLegendeFeld.origin.x-=60;
	BrennerLegendeFeld.origin.y+=Brennerlage;
	BrennerLegendeFeld.origin.y+=Scrollermass;
	//[self logRect:BrennerLegendeFeld];
	
	BrennerLegende=[[rLegende alloc]initWithFrame:BrennerLegendeFeld];
	[[[DatenplanTab tabViewItemAtIndex:0]view]addSubview:BrennerLegende];
	[BrennerLegende setAnzahlBalken:5];
	NSArray* BrennerInhaltArray=[NSArray arrayWithObjects:@"Brenner",@"Uhr",@"Mode", @"Rinne", @"",nil];
	[BrennerLegende setInhaltArray:BrennerInhaltArray];
	[BrennerDiagramm setLegende:BrennerLegende];
	
	
	NSMutableDictionary* TemperaturEinheitenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithInt:6]forKey:@"majorteile"];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithInt:10]forKey:@"nullpunkt"];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithInt:50]forKey:@"maxy"];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithInt:-10]forKey:@"miny"];
	[TemperaturEinheitenDic setObject:[NSNumber numberWithFloat:[[ZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
	[TemperaturEinheitenDic setObject:@" C"forKey:@"einheit"];
	
	[TemperaturMKDiagramm setEinheitenDicY: TemperaturEinheitenDic];
	[BrennerDiagramm setEinheitenDicY: TemperaturEinheitenDic];
	[Gitterlinien setEinheitenDicY: TemperaturEinheitenDic];
	[self setZeitKompression];
	
	
	errString= [[NSString string]retain];
	errPfad= [[NSString string]retain];
	
	NSCalendarDate* StartZeit=[NSCalendarDate calendarDate];
	[StartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
	// Pfad fuer Logfile einrichten
	BOOL FileOK=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* TempDatenPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/HomeData"]retain];
	FileOK= ([Filemanager fileExistsAtPath:TempDatenPfad isDirectory:&istOrdner]&&istOrdner);
	if (FileOK)
	{
		errPfad=[TempDatenPfad stringByAppendingPathComponent:@"Logs"]; // Ordner fuer LogFiles
		if (![Filemanager fileExistsAtPath:[TempDatenPfad stringByAppendingPathComponent:@"Logs"] isDirectory:&istOrdner]&&istOrdner)
		{
         FileOK=[Filemanager createDirectoryAtPath:[TempDatenPfad stringByAppendingPathComponent:@"Logs"] withIntermediateDirectories:NO attributes:NULL error:NULL];

			//FileOK=[Filemanager createDirectoryAtPath:[TempDatenPfad stringByAppendingPathComponent:@"Logs"] attributes:NULL];
			
		}
		
	}
	if (FileOK)
	{
		[StartZeit setCalendarFormat:@"%d.%m.%y"];
		
		errPfad=[NSString stringWithFormat:@"%@/errString %@.txt",[TempDatenPfad stringByAppendingPathComponent:@"Logs"],StartZeit];
		
		[errPfad retain];
		//NSLog(@"reportStart errPfad: %@",errPfad);
		if ([Filemanager fileExistsAtPath:errPfad])
		{
			errString = [NSString stringWithContentsOfFile:errPfad encoding:NSMacOSRomanStringEncoding error:NULL];
			//NSLog(@"reportStart errString da: %@",errString);
			[errString retain];
		}
		else
		{
			errString=[NSString stringWithFormat:@"Logfile vom: %@\r",[StartZeit description]];
			[errString retain];
			//NSLog(@"reportStart neurer errString: %@",errString);
		}
		
	}
	//	[[LoadMark cell] setControlSize:NSMiniControlSize];
	[LoadMark setEnabled:YES];
	
	
	// BrennerTab einrichten
	int BrennerTabIndex=1;
	[[DatenplanTab tabViewItemAtIndex:BrennerTabIndex] setLabel:@"Brenner"];
		
	float StatistikDiagrammLage=20.0;
#pragma mark awake StatistikDiagrammScroller

	[StatistikDiagrammScroller setHasHorizontalScroller:YES];
	[StatistikDiagrammScroller setHasVerticalScroller:NO];
	[StatistikDiagrammScroller setDrawsBackground:YES];
	[StatistikDiagrammScroller setAutoresizingMask:NSViewWidthSizable];
	//[StatistikDiagrammScroller setBackgroundColor:[NSColor blueColor]];
	[StatistikDiagrammScroller setHorizontalLineScroll:1.0];
	//[StatistikDiagrammScroller setAutohidesScrollers:NO];
	//[StatistikDiagrammScroller setBorderType:NSLineBorder];
	[[StatistikDiagrammScroller horizontalScroller]setFloatValue:1.0];
	//[[StatistikDiagrammScroller documentView] setFlipped:YES];
	
	NSRect StatistikScrollerRect=[[StatistikDiagrammScroller contentView]frame];
//	StatistikScrollerRect.size.width += 4000;
	NSView* StatistikScrollerView=[[NSView alloc]initWithFrame:StatistikScrollerRect];
	
	
	[StatistikScrollerView setAutoresizesSubviews:YES];
	[StatistikDiagrammScroller setDocumentView:StatistikScrollerView];
	[StatistikDiagrammScroller setAutoresizesSubviews:YES];
	
	
	//NSLog(@"[StatistikDiagrammScroller documentView]: w: %2.2f",[[StatistikDiagrammScroller documentView]frame].size.width);
	//NSRect BalkenRahmen=[[StatistikDiagrammScroller documentView]frame];
	//BalkenRahmen.size.width += 2000;
	//[self logRect:[StatistikDiagrammScroller frame]];
	//NSLog(@"[BalkenRahmen: w: %2.2f",BalkenRahmen.size.width);
	//[[StatistikDiagrammScroller documentView]setFrame:BalkenRahmen];
	
	NSRect StatistikFeld=StatistikScrollerRect;
	StatistikFeld.origin.x += 0.1;
	StatistikFeld.origin.y += 0.1;
	StatistikFeld.size.width -= 2;
	StatistikFeld.size.height=250;
	TemperaturStatistikDiagramm= [[rStatistikDiagramm alloc]initWithFrame:StatistikFeld];
	[TemperaturStatistikDiagramm setGrundlinienOffset:10.0];					// Abstand der 
	[TemperaturStatistikDiagramm setDiagrammlageY:StatistikDiagrammLage];	// Abstand vom unteren Rand des Scrollviews
	[TemperaturStatistikDiagramm setMaxOrdinate:200];
	//[TemperaturStatistikDiagramm setMaxEingangswert:40];
	[TemperaturStatistikDiagramm  setPostsFrameChangedNotifications:YES];
	[TemperaturStatistikDiagramm setTag:200];
	[TemperaturStatistikDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[TemperaturStatistikDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[TemperaturStatistikDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[TemperaturStatistikDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[[StatistikDiagrammScroller documentView]addSubview:TemperaturStatistikDiagramm];
	
	NSRect StatGitterlinienFeld=StatistikScrollerRect;
	StatGitterlinienFeld.origin.x += 0.1;
	
	rDiagrammGitterlinien* StatGitterlinien =[[rDiagrammGitterlinien alloc] initWithFrame: StatGitterlinienFeld];
	[StatGitterlinien setDiagrammlageY:StatistikDiagrammLage];
	[StatGitterlinien setGrundlinienOffset:10.0];
	
	[[StatistikDiagrammScroller documentView]addSubview:StatGitterlinien];
	
	NSRect TagGitterlinienFeld=StatistikScrollerRect;
	TagGitterlinienFeld.origin.x += 0.1;
	
	TagGitterlinien =[[rTagGitterlinien alloc] initWithFrame: TagGitterlinienFeld];
	[[StatistikDiagrammScroller documentView]addSubview:TagGitterlinien positioned:NSWindowBelow relativeTo:TemperaturStatistikDiagramm];
	
	
	NSRect TemperaturStatistikOrdinatenFeld=[StatistikDiagrammScroller frame];								// Feld des ScrollViews
	TemperaturStatistikOrdinatenFeld.size.width=40;																	// Breite setzen
	TemperaturStatistikOrdinatenFeld.size.height=[TemperaturStatistikDiagramm frame].size.height;	// Hoehe gleich wie StatisikDiagramm
	//TemperaturStatistikOrdinatenFeld.size.height=240;
	TemperaturStatistikOrdinatenFeld.origin.x-=42;																	// Verschiebung nach links
	TemperaturStatistikOrdinatenFeld.origin.y += Scrollermass;													// Ecke um Scrollerbreite nach oben verschieben
	//NSLog(@"Data TemperaturStatistikOrdinatenFeld");
	//[self logRect:TemperaturStatistikOrdinatenFeld];
	TemperaturStatistikOrdinate=[[rOrdinate alloc]initWithFrame:TemperaturStatistikOrdinatenFeld];
	
	[TemperaturStatistikOrdinate setOrdinatenlageY:StatistikDiagrammLage];
	[TemperaturStatistikOrdinate setGrundlinienOffset:10.0];
	[TemperaturStatistikOrdinate setMaxOrdinate:200];
	[TemperaturStatistikOrdinate setTag:201];
	//int MehrkanalTabIndex=[DatenplanTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
	//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	[[[DatenplanTab tabViewItemAtIndex:1]view]addSubview:TemperaturStatistikOrdinate];
	
	[TemperaturStatistikDiagramm setOrdinate:TemperaturStatistikOrdinate];
	
	
	NSMutableDictionary* TempStatistikEinheitenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[TempStatistikEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[TempStatistikEinheitenDic setObject:[NSNumber numberWithInt:4]forKey:@"majorteile"];
	[TempStatistikEinheitenDic setObject:[NSNumber numberWithInt:10]forKey:@"nullpunkt"];
	[TempStatistikEinheitenDic setObject:[NSNumber numberWithInt:30]forKey:@"maxy"];
	[TempStatistikEinheitenDic setObject:[NSNumber numberWithInt:-10]forKey:@"miny"];
	//[TempStatistikEinheitenDic setObject:[NSNumber numberWithFloat:[[ZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
	[TempStatistikEinheitenDic setObject:@" °C"forKey:@"einheit"];
	
	[TemperaturStatistikDiagramm setEinheitenDicY: TempStatistikEinheitenDic];
	
	//	[StatGitterlinien setEinheitenDicY: StatistikEinheitenDic];
	
	
	
	float StatistikDiagrammlage=0;
	NSRect StatistikLegendeFeld=[StatistikDiagrammScroller frame];
	StatistikLegendeFeld.size.width=60;
	StatistikLegendeFeld.size.height=[TemperaturStatistikDiagramm frame].size.height;
	StatistikLegendeFeld.origin.x-=60;
	StatistikLegendeFeld.origin.y+=StatistikDiagrammlage;
	StatistikLegendeFeld.origin.y+=16;
	//[self logRect:StatistikLegendeFeld];
	
	
	//	[TemperaturStatistikDiagramm setLegende:StatistikLegende];
	
	float BrennerStatistikDiagrammlage=280;
	
	
	NSRect BrennerStatistikFeld=StatistikScrollerRect;
	BrennerStatistikFeld.origin.x += 0.1;
	BrennerStatistikFeld.origin.y += 0.1;
	BrennerStatistikFeld.size.width -= 2;
	BrennerStatistikFeld.size.height=140;
	BrennerStatistikDiagramm= [[rBrennerStatistikDiagramm alloc]initWithFrame:BrennerStatistikFeld];
	[BrennerStatistikDiagramm setGrundlinienOffset:5.0];					// Abstand der 
	[BrennerStatistikDiagramm setDiagrammlageY:BrennerStatistikDiagrammlage];	// Abstand vom unteren Rand des Scrollviews
	[BrennerStatistikDiagramm setMaxOrdinate:100]; // Maximale Ordinate in Pixel
	//[TemperaturStatistikDiagramm setMaxEingangswert:40];
	[BrennerStatistikDiagramm  setPostsFrameChangedNotifications:YES];
	[BrennerStatistikDiagramm setTag:300];
	[BrennerStatistikDiagramm setGraphFarbe:[NSColor lightGrayColor] forKanal:0];
	[BrennerStatistikDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[BrennerStatistikDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[BrennerStatistikDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[[StatistikDiagrammScroller documentView]addSubview:BrennerStatistikDiagramm];
	
	
	NSMutableDictionary* BrennerStatistikEinheitenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[BrennerStatistikEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[BrennerStatistikEinheitenDic setObject:[NSNumber numberWithInt:5]forKey:@"majorteile"];
	[BrennerStatistikEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"nullpunkt"];
	[BrennerStatistikEinheitenDic setObject:[NSNumber numberWithInt:10]forKey:@"maxy"];
	[BrennerStatistikEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"miny"];
	//[StatistikEinheitenDic setObject:[NSNumber numberWithFloat:[[ZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
	[BrennerStatistikEinheitenDic setObject:@" h"forKey:@"einheit"];
	
	[BrennerStatistikDiagramm setEinheitenDicY: BrennerStatistikEinheitenDic];
	
	
	
	NSRect BrennerStatistikOrdinatenFeld=[StatistikDiagrammScroller frame];	// Feld des ScrollViews
	BrennerStatistikOrdinatenFeld.size.width=40;													// Breite setzen
	BrennerStatistikOrdinatenFeld.size.height=[BrennerStatistikDiagramm frame].size.height;	// Hoehe gleich wie StatisikDiagramm
	//BrennerStatistikOrdinatenFeld.size.height=240;
	BrennerStatistikOrdinatenFeld.origin.x-=42;													// Verschiebung nach links
	BrennerStatistikOrdinatenFeld.origin.y += Scrollermass;									// Ecke um Scrollerbreite nach oben verschieben
	//NSLog(@"Data TemperaturStatistikOrdinatenFeld");
	//[self logRect:TemperaturStatistikOrdinatenFeld];
	BrennerStatistikOrdinate=[[rOrdinate alloc]initWithFrame:BrennerStatistikOrdinatenFeld];
	
	[BrennerStatistikOrdinate setOrdinatenlageY:BrennerStatistikDiagrammlage];
	[BrennerStatistikOrdinate setGrundlinienOffset:5.0];
	[BrennerStatistikOrdinate setMaxOrdinate:100];
	[BrennerStatistikOrdinate setAchsenDic:BrennerStatistikEinheitenDic];
	[BrennerStatistikOrdinate setTag:201];
	//int MehrkanalTabIndex=[DatenplanTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
	//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	[[[DatenplanTab tabViewItemAtIndex:1]view]addSubview:BrennerStatistikOrdinate];
	
	[BrennerStatistikDiagramm setOrdinate:BrennerStatistikOrdinate];
	
	/*
	 NSRect BrennerStatistikLegendeFeld=[StatistikDiagrammScroller frame];
	 BrennerStatistikLegendeFeld.size.width=60;
	 BrennerStatistikLegendeFeld.size.height=[TemperaturStatistikDiagramm frame].size.height;
	 BrennerStatistikLegendeFeld.origin.x-=60;
	 BrennerStatistikLegendeFeld.origin.y+=BrennerStatistikDiagrammlage;
	 BrennerStatistikLegendeFeld.origin.y+=16;
	 [self logRect:StatistikLegendeFeld];
	 BrennerStatistikLegende=[[rLegende alloc]initWithFrame:BrennerStatistikLegendeFeld];
	 
	 [[[DatenplanTab tabViewItemAtIndex:1]view]addSubview:BrennerStatistikLegende];
	 [BrennerStatistikLegende setAnzahlBalken:4];
	 
	 NSArray* BrennerStatistikInhaltArray=[NSArray arrayWithObjects:@"Mittel",@"Tag",@"Nacht", @"",nil];
	 [BrennerStatistikLegende setInhaltArray:BrennerStatistikInhaltArray];
	 */	
	
	//NSLog(@"[StatistikDiagrammScroller documentView]: w: %2.2f",[[StatistikDiagrammScroller documentView]frame].size.width);
	
	
	// Solartab einrichten
	
#pragma mark awake SolarDiagrammScroller

	int SolarTabIndex=2;
	[[DatenplanTab tabViewItemAtIndex:SolarTabIndex] setLabel:@"Solar"];
	SolarZeitKompression=[[SolarZeitKompressionTaste titleOfSelectedItem]floatValue];
	float SolarDiagrammLage=10.0;
	
	[SolarDiagrammScroller setHasHorizontalScroller:YES];
	[SolarDiagrammScroller setHasVerticalScroller:NO];
	[SolarDiagrammScroller setDrawsBackground:YES];
	[SolarDiagrammScroller setAutoresizingMask:NSViewWidthSizable];
	//[SolarDiagrammScroller setBackgroundColor:[NSColor blueColor]];
	[SolarDiagrammScroller setHorizontalLineScroll:1.0];
	//[SolarDiagrammScroller setAutohidesScrollers:NO];
	//[SolarDiagrammScroller setBorderType:NSLineBorder];
	[[SolarDiagrammScroller horizontalScroller]setFloatValue:1.0];
	//[[SolarDiagrammScroller documentView] setFlipped:YES];
	
	NSRect SolarScrollerRect=[[SolarDiagrammScroller contentView]frame];
//	SolarScrollerRect.size.width += 4000;
	NSView* SolarScrollerView=[[NSView alloc]initWithFrame:SolarScrollerRect];
	
	
	[SolarScrollerView setAutoresizesSubviews:YES];
	[SolarDiagrammScroller setDocumentView:SolarScrollerView];
	[SolarDiagrammScroller setAutoresizesSubviews:YES];
	
	
	//NSLog(@"[SolarDiagrammScroller documentView]: w: %2.2f",[[SolarDiagrammScroller documentView]frame].size.width);
	//NSRect SolarBalkenRahmen=[[SolarDiagrammScroller documentView]frame];
	//SolarBalkenRahmen.size.width += 2000;
	//[self logRect:[SolarDiagrammScroller frame]];
	//NSLog(@"[SolarBalkenRahmen: w: %2.2f",SolarBalkenRahmen.size.width);
	//[[SolarDiagrammScroller documentView]setFrame:SolarBalkenRahmen];
	
	NSRect SolarFeld=SolarScrollerRect;
	SolarFeld.origin.x += 0.1;
	SolarFeld.origin.y += 0.1;
	SolarFeld.size.width -= 2;
	SolarFeld.size.height=220;
	SolarDiagramm= [[rSolarDiagramm alloc]initWithFrame:SolarFeld];
	[SolarDiagramm setGrundlinienOffset:4.1];					// Abstand der 
	[SolarDiagramm setDiagrammlageY:SolarDiagrammLage];	// Abstand vom unteren Rand des Scrollviews
	[SolarDiagramm setMaxOrdinate:200];
	//[SolarDiagramm setMaxEingangswert:40];
	[SolarDiagramm  setPostsFrameChangedNotifications:YES];
	[SolarDiagramm setTag:400];
	[SolarDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[SolarDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[SolarDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[SolarDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[SolarDiagramm setZeitKompression:[[SolarZeitKompressionTaste titleOfSelectedItem]floatValue]];
	
	[[SolarDiagrammScroller documentView]addSubview:SolarDiagramm];


	NSMutableDictionary* SolarEinheitenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[SolarEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[SolarEinheitenDic setObject:[NSNumber numberWithInt:6]forKey:@"majorteile"];
	[SolarEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"nullpunkt"];
	[SolarEinheitenDic setObject:[NSNumber numberWithInt:120]forKey:@"maxy"];
	//[SolarEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"miny"];
	//[SolarEinheitenDic setObject:[NSNumber numberWithFloat:[[SolarZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
	[SolarEinheitenDic setObject:@" C"forKey:@"einheit"];
	
	[SolarDiagramm setEinheitenDicY:SolarEinheitenDic];




	NSRect SolarGitterlinienFeld=SolarScrollerRect;
	SolarGitterlinienFeld.origin.x += 0.1;
	
	
	SolarGitterlinien =[[rDiagrammGitterlinien alloc] initWithFrame: SolarGitterlinienFeld];
	[SolarGitterlinien setZeitKompression:[[SolarZeitKompressionTaste titleOfSelectedItem]floatValue]];
	
	[SolarGitterlinien setEinheitenDicY:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:20] forKey:@"intervall"]];
	[SolarGitterlinien setNeedsDisplay:YES];

	[[SolarDiagrammScroller documentView]addSubview:SolarGitterlinien positioned:NSWindowBelow relativeTo:SolarDiagramm];
	
	// Ordinate
		
	NSRect SolarOrdinatenFeld=[SolarDiagrammScroller frame];
	SolarOrdinatenFeld.size.width=36;
	SolarOrdinatenFeld.size.height=[SolarDiagramm frame].size.height;
	
	SolarOrdinatenFeld.origin.x-=38;
	SolarOrdinatenFeld.origin.y+=Scrollermass;
	SolarOrdinate=[[rOrdinate alloc]initWithFrame:SolarOrdinatenFeld];
	[SolarOrdinate setTag:102];
	
	[SolarOrdinate setGrundlinienOffset:4.1];
	[SolarOrdinate setOrdinatenlageY:SolarDiagrammLage];
	//int MehrkanalTabIndex=[DatenplanTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
	//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	
	[SolarOrdinate setAchsenDic:SolarEinheitenDic];
	[[[DatenplanTab tabViewItemAtIndex:2]view]addSubview:SolarOrdinate];
	int maxord=[SolarDiagramm MaxOrdinate];
	NSLog(@"Solar maxord: %d",maxord);
	[SolarOrdinate setMaxOrdinate:maxord];

	int GLOffset=[SolarDiagramm GrundlinienOffset];
	NSLog(@"Solar GLOffset: %d",GLOffset);
	[SolarOrdinate setGrundlinienOffset:GLOffset];
	
	[SolarDiagramm setOrdinate:SolarOrdinate];
	

	
	// end Ordinate
	
	// Beginn SolarEinschaltDiagramm
	float SolarEinschaltlage=SolarFeld.size.height;
	NSRect SolarEinschaltFeld=SolarFeld;
	SolarEinschaltFeld.origin.y+=SolarEinschaltlage+20;
	SolarEinschaltFeld.size.height=50;
	SolarEinschaltDiagramm =[[rSolarEinschaltDiagramm alloc] initWithFrame: SolarEinschaltFeld];
	[SolarEinschaltDiagramm setAnzahlBalken:5];
	[SolarEinschaltDiagramm setZeitKompression:[[SolarZeitKompressionTaste titleOfSelectedItem]floatValue]];
	
	[[SolarDiagrammScroller documentView]addSubview:SolarEinschaltDiagramm];

	// Beginn Einschlaltlegende
	
	NSRect EinschaltLegendeFeld=[SolarDiagrammScroller frame];
	EinschaltLegendeFeld.size.width=60;
	EinschaltLegendeFeld.size.height=[BrennerDiagramm frame].size.height;
	EinschaltLegendeFeld.origin.x-=60;
	EinschaltLegendeFeld.origin.y+=SolarEinschaltlage+20;
	EinschaltLegendeFeld.origin.y+=Scrollermass;
	//[self logRect:EinschaltLegendeFeld];
	
	EinschaltLegende=[[rLegende alloc]initWithFrame:EinschaltLegendeFeld];
	[[[DatenplanTab tabViewItemAtIndex:2]view]addSubview:EinschaltLegende];
	[EinschaltLegende setAnzahlBalken:5];
	NSArray* EinschaltInhaltArray=[NSArray arrayWithObjects:@"Pumpe",@"Elektro",@"", @"", @"",nil];
	[EinschaltLegende setInhaltArray:EinschaltInhaltArray];
	[SolarEinschaltDiagramm setLegende:EinschaltLegende];
	// End Einschaltlegende

	// End Solar

#pragma mark awake Solarstatistik
	// Beginn Solarstatisktik
	[SolarStatistikDiagrammScroller setHasHorizontalScroller:YES];
	[SolarStatistikDiagrammScroller setHasVerticalScroller:NO];
	[SolarStatistikDiagrammScroller setDrawsBackground:YES];
	[SolarStatistikDiagrammScroller setAutoresizingMask:NSViewWidthSizable];
	//[SolarStatistikDiagrammScroller setBackgroundColor:[NSColor blueColor]];
	[SolarStatistikDiagrammScroller setHorizontalLineScroll:1.0];
	//[SolarStatistikDiagrammScroller setAutohidesScrollers:NO];
	//[SolarStatistikDiagrammScroller setBorderType:NSLineBorder];
	[[SolarStatistikDiagrammScroller horizontalScroller]setFloatValue:1.0];
	//[[SolarStatistikDiagrammScroller documentView] setFlipped:YES];
	
	NSRect SolarStatistikScrollerRect=[[SolarStatistikDiagrammScroller contentView]frame];
//	SolarStatistikScrollerRect.size.width += 4000;
	NSView* SolarStatistikScrollerView=[[NSView alloc]initWithFrame:SolarStatistikScrollerRect];
	
	[SolarStatistikDiagrammScroller setDocumentView:SolarStatistikScrollerView];
	[SolarStatistikDiagrammScroller setAutoresizesSubviews:YES];

	NSRect SolarStatistikFeld = SolarStatistikScrollerRect;
	SolarStatistikFeld.origin.x += 0.1;
	SolarStatistikFeld.origin.y += 0.1;
	SolarStatistikFeld.size.width -= 2;
	SolarStatistikFeld.size.height=250;

	SolarStatistikDiagramm= [[rStatistikDiagramm alloc]initWithFrame:StatistikFeld];
	[SolarStatistikDiagramm setGrundlinienOffset:10.0];					// Abstand der 
	[SolarStatistikDiagramm setDiagrammlageY:StatistikDiagrammLage];	// Abstand vom unteren Rand des Scrollviews
	[SolarStatistikDiagramm setMaxOrdinate:200];
	//[TemperaturStatistikDiagramm setMaxEingangswert:40];
	[SolarStatistikDiagramm  setPostsFrameChangedNotifications:YES];
	[SolarStatistikDiagramm setTag:200];
	[SolarStatistikDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[SolarStatistikDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[SolarStatistikDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[SolarStatistikDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[[SolarStatistikDiagrammScroller documentView]addSubview:SolarStatistikDiagramm];

	NSRect SolarStatGitterlinienFeld=SolarStatistikScrollerRect;
	SolarStatGitterlinienFeld.origin.x += 0.1;
	
	rDiagrammGitterlinien* SolarStatGitterlinien =[[rDiagrammGitterlinien alloc] initWithFrame: SolarStatGitterlinienFeld];
	[SolarStatGitterlinien setDiagrammlageY:StatistikDiagrammLage];
	[SolarStatGitterlinien setGrundlinienOffset:10.0];
	
	[[SolarStatistikDiagrammScroller documentView]addSubview:SolarStatGitterlinien];
	
	NSRect SolarTagGitterlinienFeld=SolarStatistikScrollerRect;
	SolarTagGitterlinienFeld.origin.x += 0.1;
	
	SolarTagGitterlinien =[[rTagGitterlinien alloc] initWithFrame: SolarTagGitterlinienFeld];
	[[SolarStatistikDiagrammScroller documentView]addSubview:SolarTagGitterlinien positioned:NSWindowBelow relativeTo:TemperaturStatistikDiagramm];
	
	
	NSRect SolarStatistikOrdinatenFeld=[SolarStatistikDiagrammScroller frame];								// Feld des ScrollViews
	SolarStatistikOrdinatenFeld.size.width=40;																	// Breite setzen
	SolarStatistikOrdinatenFeld.size.height=[TemperaturStatistikDiagramm frame].size.height;	// Hoehe gleich wie StatisikDiagramm
	//SolarStatistikOrdinatenFeld.size.height=240;
	SolarStatistikOrdinatenFeld.origin.x-=42;																	// Verschiebung nach links
	SolarStatistikOrdinatenFeld.origin.y += Scrollermass;													// Ecke um Scrollerbreite nach oben verschieben
	//NSLog(@"Data SolarStatistikOrdinatenFeld");
	//[self logRect:SolarStatistikOrdinatenFeld];
	SolarStatistikOrdinate=[[rOrdinate alloc]initWithFrame:SolarStatistikOrdinatenFeld];
	
	[SolarStatistikOrdinate setOrdinatenlageY:StatistikDiagrammLage];
	[SolarStatistikOrdinate setGrundlinienOffset:10.0];
	[SolarStatistikOrdinate setMaxOrdinate:200];
	[SolarStatistikOrdinate setTag:201];
	//int MehrkanalTabIndex=[DatenplanTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
	//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	[[[DatenplanTab tabViewItemAtIndex:3]view]addSubview:SolarStatistikOrdinate];
	
	[SolarStatistikDiagramm setOrdinate:SolarStatistikOrdinate];
	
	
	NSMutableDictionary* SolarStatistikEinheitenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[SolarStatistikEinheitenDic setObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[SolarStatistikEinheitenDic setObject:[NSNumber numberWithInt:6]forKey:@"majorteile"];
	[SolarStatistikEinheitenDic setObject:[NSNumber numberWithInt:10]forKey:@"nullpunkt"];
	[SolarStatistikEinheitenDic setObject:[NSNumber numberWithInt:120]forKey:@"maxy"];
	[SolarStatistikEinheitenDic setObject:[NSNumber numberWithInt:0]forKey:@"miny"];
	//[SolarStatistikEinheitenDic setObject:[NSNumber numberWithFloat:[[ZeitKompressionTaste titleOfSelectedItem]floatValue]]forKey:@"zeitkompression"];
	[SolarStatistikEinheitenDic setObject:@" °C"forKey:@"einheit"];
	
	[SolarStatistikDiagramm setEinheitenDicY: SolarStatistikEinheitenDic];

	[SolarStatistikKalender setDateValue: [NSDate date]];
	// end Solarstatistik
	
	// Diagrammzeichnen veranlassen
	NSMutableDictionary* BalkendatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[BalkendatenDic setObject:[NSNumber numberWithInt:1]forKey:@"statistikdaten"];
	[BalkendatenDic setObject:[NSNumber numberWithInt:1]forKey:@"aktion"];
	
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:BalkendatenDic];

	
	NSString* DatumString = [NSString stringWithFormat:@"RH %@",DATUM];
	[DatumFeld setStringValue:DatumString];
	NSString* VersionString = [NSString stringWithFormat:@"Version %@",VERSION];
	[VersionFeld setStringValue:VersionString];
	
}




- (void)FrameDidChangeAktion:(NSNotification*)note
{
	
	//float breite=[[note object]frame].size.width;
	//NSLog(@"Data FrameDidChangeAktion: objekt Breite: %2.2f",breite);
	
	
	return; // Rest abgeschnitten 31.7.09
	
	
	
	NSRect ScrollerRect=[TemperaturDiagrammScroller frame];
	
	float Scrollerbreite =ScrollerRect.size.width;
	
	NSRect SuperViewRect=[[BrennerDiagramm superview]frame];
	SuperViewRect.size.width=Scrollerbreite;
	[[BrennerDiagramm superview]setFrame:SuperViewRect];
	
	//[self logRect:[BrennerDiagramm frame]];
	NSRect BrennerDiagrammRect=[BrennerDiagramm frame];
	//float BrennerDiagrammBreite=BrennerDiagrammRect.size.width;
	
	
	//NSLog(@"Scrollerbreite:%2.2f  BrennerDiagrammBreite: %2.2f",Scrollerbreite,BrennerDiagrammBreite);
	BrennerDiagrammRect.size.width=Scrollerbreite;
	
	[BrennerDiagramm setFrame:BrennerDiagrammRect];
	//[self logRect:[BrennerDiagramm frame]];
	[BrennerDiagramm setNeedsDisplay:YES];
	
	NSRect TemperaturMKDiagrammRect=[TemperaturMKDiagramm frame];
	TemperaturMKDiagrammRect.size.width=Scrollerbreite;
	[TemperaturMKDiagramm setFrame:TemperaturMKDiagrammRect];
	[TemperaturMKDiagramm setNeedsDisplay:YES];
	
	NSRect GitterlinienRect=[Gitterlinien frame];
	GitterlinienRect.size.width=Scrollerbreite;
	[Gitterlinien setFrame:GitterlinienRect];
	[Gitterlinien setNeedsDisplay:YES];
	
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	//NSLog(@"FrameDidChangeAktion tempOrigin: x: %2.2f y: %2.2f",tempOrigin.x, tempOrigin.y);
	NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
	//NSLog(@"FrameDidChangeAktion tempFrame width: x: %2.2f y: %2.2f",tempFrame.size.width);
	NSLog(@"FrameDidChangeAktion  tempOrigin: x: %2.2f  *   tempFrame width: %2.2f",tempOrigin.x,tempFrame.size.width);

	

	//[TemperaturWertFeld setNeedsDisplay:YES];
	
	
}

-(void)HomeDataDownloadAktion:(NSNotification*)note
{
/*
Aufgerufen von rHomeData.
Setzt Feldwerte im Fenster Data.

*/
	//NSLog(@"rData HomeDataDownloadAktion");
	[LoadMark performClick:NULL];
	
	if ([[note userInfo]objectForKey:@"err"])
	{
	[LastDataFeld setStringValue:[[note userInfo]objectForKey:@"err"]];
	}
/*
	if ([[note userInfo]objectForKey:@"erfolg"])
	{
	[LastDataFeld setStringValue:[[note userInfo]objectForKey:@"erfolg"]];
	}
*/	
if ([[note userInfo]objectForKey:@"lasttimestring"])
	{
		[LastDatazeitFeld setStringValue:[[note userInfo]objectForKey:@"lasttimestring"]];
	}
	else
	{
		[LastDatazeitFeld setStringValue:@"keine Zeitangabe"];
	}

	anzLoads++;
	[ZaehlerFeld setIntValue:anzLoads];
	if (anzLoads > 8)
	{
		//NSBeep();
		[self reload:NULL];
	}

	//NSLog(@"anzLoads: %d",anzLoads);
	[LastDataFeld setStringValue:@"***"];

	if ([[note userInfo]objectForKey:@"datastring"])
	{
	NSString* tempString = [[note userInfo]objectForKey:@"datastring"];
	//tempString= [[[[NSNumber numberWithInt:anzLoads]stringValue]stringByAppendingString:@": "]stringByAppendingString:tempString];

	[LastDataFeld setStringValue:tempString];
	}
	else
	{
	[LastDataFeld setStringValue:@"-"];
	[LastDataFeld setStringValue:@"--"];
	[LastDataFeld setStringValue:@"---"];
	[LastDataFeld setStringValue:@"----"];
	[LastDataFeld setStringValue:@"-----"];
	}

/*
	if ([[note userInfo]objectForKey:@"lastdatazeit"])
	{
	int tempLastdataZeit=[[[note userInfo]objectForKey:@"lastdatazeit"] intValue];
	NSLog(@"lastdatazeit: %d * LastLoadzeit: %d",tempLastdataZeit,LastLoadzeit );
	
	int	tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];		
	//[LastDatazeitFeld setStringValue:[[note userInfo]objectForKey:@"lastdatazeit"]];
	[LastDatazeitFeld setIntValue:tempLastdataZeit-LastLoadzeit];
	}
*/
	if ([[note userInfo]objectForKey:@"delta"])
	{
	NSString* deltaString=[NSString stringWithFormat:@"%2.4F",[[[note userInfo]objectForKey:@"delta"]floatValue]];
	[LoadtimeFeld setStringValue:deltaString];
	}

}


- (void)ExterneDatenAktion:(NSNotification*)note
{
	Quelle=1;
	if ([[note userInfo]objectForKey:@"startzeit"])
	{
		//NSString* StartzeitString = [[note userInfo]objectForKey:@"startzeit"];
		//NSLog(@"ExterneDatenAktion: Startzeit: *%@* StartzeitString: *%@*",[[note userInfo]objectForKey:@"startzeit"],StartzeitString);
		
		NSString* Kalenderformat=[[NSCalendarDate calendarDate]calendarFormat];
		DatenserieStartZeit=[[NSCalendarDate dateWithString:[[note userInfo]objectForKey:@"startzeit"] calendarFormat:Kalenderformat]retain];
		//int tag=[DatenserieStartZeit dayOfMonth];
		
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[NotificationDic setObject:@"datastart"forKey:@"data"];
		[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
		
		NSCalendarDate* AnzeigeDatum= [DatenserieStartZeit copy];
		[AnzeigeDatum setCalendarFormat:@"%d.%m.%y %H:%M"];
		[StartzeitFeld setStringValue:[AnzeigeDatum description]];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
		
		//NSLog(@"ExterneDatenAktion DatenserieStartZeit: %@ tag: %d",  [DatenserieStartZeit description], tag);
	}
	
	if ([[note userInfo]objectForKey:@"datumtag"])
	{
		
	}
	
	if ([[note userInfo]objectForKey:@"datenarray"])
	{
		
		NSArray* TemperaturKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"1",@"0" ,@"0",@"0",@"0",@"1",nil];
//		NSArray* BrennerKanalArray=		[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		
		NSArray* tempDatenArray = [[note userInfo]objectForKey:@"datenarray"];
		//NSLog(@"ExterneDatenAktion tempDatenArray last Data:%@",[[tempDatenArray lastObject]description]);
		
		// Zeit des ersten Datensatzes
		int firstZeit = [[[[tempDatenArray objectAtIndex:0] componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
		NSLog(@"firstZeit: %d",firstZeit);
		
		// Zeit des letzten Datensatzes
		int lastZeit = [[[[tempDatenArray lastObject] componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
		NSLog(@"lastZeit: %d",lastZeit);
		[LaufzeitFeld setStringValue:[self stringAusZeit:lastZeit]]; 
		
		// Breite des DocumentViews bestimmen
		lastZeit -= firstZeit;
		lastZeit *= ZeitKompression;
		//NSLog(@"ExterneDatenaktion Zeitkompression: %2f2",ZeitKompression);
		//	Origin des vorhandenen DocumentViews
		NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
		//NSLog(@"ExterneDatenaktion tempOrigin: x: %2.2f y: %2.2f",tempOrigin.x, tempOrigin.y);
		//28.7.09
		tempOrigin.x=0;
		[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
		
		
		//	Frame des vorhandenen DocumentViews
		NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
		//NSLog(@"ExterneDatenaktion  tempOrigin: x: %2.2f  tempFrame width: x: %2.2f y: %2.2f",tempOrigin.x,tempFrame.size.width);
		
		//	Verschiebedistanz des angezeigten Fensters
		
		if (tempFrame.size.width < lastZeit)
		{
			//NSLog(@"tempFrame.size.width < lastZeit width: %2.2f lastZeit: %5d",tempFrame.size.width,lastZeit);
			//float delta=[[TemperaturDiagrammScroller contentView]frame].size.width-150;
			int PlatzRechts = 50;
			float delta=lastZeit- [[TemperaturDiagrammScroller documentView]bounds].size.width+PlatzRechts; // Abstand vom rechten Rand, Platz fuer Datentitel und Wert
			NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
			//NSLog(@"delta: %2.2f",delta);
			//	DocumentView vergroessern
			tempFrame.size.width+=delta;
			
			//	Origin des DocumentView verschieben
			//NSLog(@"tempOrigin.x vor: %2.2f",tempOrigin.x);
			tempOrigin.x-=delta;
			//NSLog(@"tempOrigin.x nach: %2.2f",tempOrigin.x);
			
			//	Origin der Bounds verschieben
			//NSLog(@"scrollPoint.x vor: %2.2f",scrollPoint.x);
			scrollPoint.x += delta;
			//NSLog(@"scrollPoint.x nach: %2.2f",scrollPoint.x);
			
			//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			//NSLog(@"tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			
			NSRect MKDiagrammRect=[TemperaturMKDiagramm frame];
			MKDiagrammRect.size.width=tempFrame.size.width;
			//NSLog(@"MKDiagrammRect.size.width: %2.2f",MKDiagrammRect.size.width);
			[TemperaturMKDiagramm setFrame:MKDiagrammRect];
			
			NSRect BrennerRect=[BrennerDiagramm frame];
			BrennerRect.size.width=tempFrame.size.width;
			//NSLog(@"BrennerRect.size.width: %2.2f",BrennerRect.size.width);
			
			[BrennerDiagramm setFrame:BrennerRect];
			
			NSRect GitterlinienRect=[Gitterlinien frame];
			GitterlinienRect.size.width=tempFrame.size.width;
			//NSLog(@"GitterlinienRect.size.width: %2.2f",GitterlinienRect.size.width);
			
			[Gitterlinien setFrame:GitterlinienRect];
			
			NSRect DocRect=[[TemperaturDiagrammScroller documentView]frame];
			//NSLog(@"DocRect.size.width vor: %2.2f",DocRect.size.width);
			DocRect.size.width=tempFrame.size.width;
			//NSLog(@"DocRect.size.width nach: %2.2f",DocRect.size.width);
			
			[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
			//NSLog(@"tempOrigin end  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			
			//NSLog(@"ExterneDatenaktion  tempOrigin: x: %2.2f  *   DocRect width: %2.2f",tempOrigin.x,DocRect.size.width);
			
			//NSLog(@"scrollPoint end  x: %2.2f y: %2.2f",scrollPoint.x,scrollPoint.y);
			[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
			[TemperaturDiagrammScroller setNeedsDisplay:YES];
			
		}
		
		NSString* TemperaturDatenString= [NSString string];
		NSEnumerator* DatenEnum = [tempDatenArray objectEnumerator];
		id einDatenString;
		
		while (einDatenString = [DatenEnum nextObject])
		{
			//NSString* tempDatenString=(NSString*)[einDatenString substringWithRange:NSMakeRange(0,[einDatenString length]-1)];
			
			//NSMutableArray* tempZeilenArray= (NSMutableArray*)[einDatenString componentsSeparatedByString:@"\t"];
			// Datenstring aufteilen in Komponenten
			NSMutableArray* tempZeilenArray= (NSMutableArray*)[einDatenString componentsSeparatedByString:@"\r"];
			
			//NSLog(@"ExterneDatenAktion einDatenString: %@\n tempZeilenArray:%@\n", einDatenString,[tempZeilenArray description]);
			//NSLog(@"ExterneDatenAktion einDatenString: %@ count: %d", einDatenString, [tempZeilenArray count]);
			if ([tempZeilenArray count]== 9) // Daten vollständig
			{
				//NSLog(@"ExterneDatenAktion tempZeilenArray:%@",[tempZeilenArray description]);
				// Datenserie auf Startzeit synchronisieren
				int tempZeit=[[tempZeilenArray objectAtIndex:0]intValue];
				
				tempZeit -= firstZeit;
				[tempZeilenArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:tempZeit]];
				
				[TemperaturMKDiagramm setWerteArray:tempZeilenArray mitKanalArray:TemperaturKanalArray];
				
				
				[TemperaturMKDiagramm setNeedsDisplay:YES];
				NSMutableDictionary* tempVorgabenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
				[tempVorgabenDic setObject:[NSNumber numberWithInt:5]forKey:@"anzbalken"];
				[tempVorgabenDic setObject:[NSNumber numberWithInt:3]forKey:@"datenindex"];
				

				[BrennerDiagramm setWerteArray:tempZeilenArray mitKanalArray:BrennerKanalArray mitVorgabenDic:tempVorgabenDic];
				
		//		[BrennerDiagramm setWerteArray:tempZeilenArray mitKanalArray:BrennerKanalArray];
				[BrennerDiagramm setNeedsDisplay:YES];
				[Gitterlinien setWerteArray:tempZeilenArray mitKanalArray:BrennerKanalArray];
				[Gitterlinien setNeedsDisplay:YES];
				//TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t%@",TemperaturDatenString,tempDatenString];
				
				// Aus TempZeilenarray einen tab-getrennten String bilden
				NSString* tempZeilenString=[tempZeilenArray componentsJoinedByString:@"\t"];
				//				NSLog(@"tempZeilenString: %@", tempZeilenString);
				TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t%@",TemperaturDatenString,tempZeilenString];
				//				TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t%@",TemperaturDatenString,einDatenString];
				
			}
			
		}	// while
		AnzDaten=[tempDatenArray count];
		//NSLog(@"ExterneDatenAktion AnzDaten: %d",AnzDaten);
		[AnzahlDatenFeld setIntValue:[tempDatenArray count]];
		
		[TemperaturDatenFeld setString:TemperaturDatenString];
		NSRange insertAtEnd=NSMakeRange([[TemperaturDatenFeld textStorage] length],0);
		[TemperaturDatenFeld scrollRangeToVisible:insertAtEnd];

		[ClearTaste setEnabled:YES];
		
// 14.4.10 Doppeltes Laden verhindern.
		NSTimer* KalenderTimer=[[NSTimer scheduledTimerWithTimeInterval:1
																			  target:self 
																			selector:@selector(KalenderFunktion:) 
																			userInfo:nil 
																			 repeats:NO]retain];
		
		NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:KalenderTimer forMode:NSDefaultRunLoopMode];
		
		[KalenderTimer release];

		//Kalenderblocker=0;
	}
	//NSBeep();
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"loaddataok"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"LoadData" object:self userInfo:NotificationDic];
	[Kalender setEnabled:YES];
	
	NSMutableDictionary* BalkendatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[BalkendatenDic setObject:[NSNumber numberWithInt:1]forKey:@"aktion"];
	
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:BalkendatenDic];
	[TemperaturStatistikDiagramm setNeedsDisplay:YES];
	[TagGitterlinien setNeedsDisplay:YES];
	//NSLog(@"ExterneDatenAktion end");
	
}


- (void)ReadStartAktion:(NSNotification*)note
{
	if ([[note userInfo]objectForKey:@"iowbusy"])
	{
		IOW_busy=[[[note userInfo]objectForKey:@"iowbusy"]intValue];
		
	}
	else
	{
		IOW_busy=0;
	}
}

- (void)KalenderFunktion:(NSTimer*)derTimer
{
	Kalenderblocker=0;
}

- (void)ReadAktion:(NSNotification*)note
{
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	// specify just positive format
	[numberFormatter setFormat:@"##0.00"];
	
	
	//NSLog(@"ReadAktion note: %@",[[note userInfo]description]);
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
	
	NSArray* DataArray=[[note userInfo]objectForKey:@"datenarray"];
	int Raum=0, Stunde=0,Minuten=0;
	
	//float tempZeit=0;
	int tempZeit=0;
	BOOL Messbeginn=NO;
	
	//NSString* tabSeparator=@"\t";
	//NSString* crSeparator=@"\r";
	
	NSMutableString* tempWertString=(NSMutableString*)[TemperaturWertFeld string];//Vorhandene Daten im Wertfeld
	//NSLog(@"TemperaturZeilenString: %@",TemperaturZeilenString);
	
	if ([[TemperaturDaten objectForKey:@"datenarray"]count]==0 && Messbeginn==NO && [DatenpaketArray count]==0) // Messbeginn
	{
		//NSLog(@"								*** Messbeginn");
		Messbeginn=YES;
		//NSLog(@"TemperaturDaten: %@",[TemperaturDaten description]);
		//DatenserieStartZeit=[NSDate date];
		//[TemperaturDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
	}
	if (DataArray && ([DataArray count]==4) ) // Es gibt korrekte Daten vom IOW, letztes El ist immer 00
	{
		/*
		Aufbau des Pakets:
		4 Bytes pro Report
		Byte 0:		Mark (Maske 0x03), sonstige Steuerungen
		Byte 1,2:	Data
		Byte 3:			
		
		
		
		
		
		
		*/
		NSMutableArray* tempWerteArray=[[NSMutableArray alloc]initWithCapacity:0];
		
//		NSArray* TemperaturKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"1",@"0" ,@"0",@"0",@"0",@"0",nil];
//		NSArray* BrennerKanalArray=		[NSArray arrayWithObjects:@"0",@"0",@"0",@"1" ,@"0",@"0",@"0",@"0",nil];
		
		// Mark des Datenpaketes:	0: Schluss, Null-Werte	1: Gueltige Daten
		int mark=([self HexStringZuInt:[DataArray objectAtIndex:0]] & 0x03);			// von PORTC
		//NSLog(@"mark: %d",mark);
		
		Raum= ([self HexStringZuInt:[DataArray objectAtIndex:1]] & 0xE0);				// Bits 5-7	 von PORTB
		
		if (DatenpaketArray==NULL)// Sammelarray fuer Daten eines Pakets
		{
			DatenpaketArray=[[NSMutableArray alloc]initWithCapacity:0];
			
		}
		
		switch (mark)
		{
			case 0: // Pakete der Serie sind fertig gelesen
			{
				IOW_busy=0; 
				//NSLog(@"Paket Ende: mark: %d DataArray: %@",mark,[DataArray description]);
				
				//	Letztes Byte des Terminator-Reports ist immer 0
				if (!([[DataArray objectAtIndex:2]intValue]==0))// && [[DataArray objectAtIndex:1]intValue]==0))
				{
					
					break;
				}
				
				//NSLog(@"Paket Ende: DatenpaketArray: %@",[DatenpaketArray description]);
				if (Messbeginn) // Messbeginn, Erstes Paket empfangen
				{
					NSLog(@"Messbeginn");
					Messbeginn=NO;
					//NSRange r=NSMakeRange(1,[DatenpaketArray count]-1);
					if ([DatenpaketArray count]==7)
					{
						//				[TemperaturMKDiagramm setStartWerteArray:[DatenpaketArray subarrayWithRange:r]];
					}
					// Startzeit bestimmen
					tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
					
				}
				else
				{
					Messbeginn=NO;
					//	Anzahl Datenpakete kontrollieren
					if ([DatenpaketArray count]>7)// Fehler
					{
						NSLog(@"ErrZuLang: %d",ErrZuLang);
						NSLog(@"ErrZuLang: %d DatenpaketArray: %@",ErrZuLang,[DatenpaketArray description] );
						errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d ErrZuLang: %d DatenpaketArray: %@",errString,AnzDaten,ErrZuLang,[DatenpaketArray componentsJoinedByString:@"\t"]];
						[errString retain];
						[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
						
						/*
						 if (ReportErrIndex>=0)// Pakete mit 2x 0xFF sind vorgekommen
						 {
						 
						 NSLog(@"Korrektur: ReportErrIndex: %d Data: %@",ReportErrIndex,[DatenpaketArray objectAtIndex:2*ReportErrIndex +1]);
						 [DatenpaketArray removeObjectAtIndex:2*ReportErrIndex +1]; //	Erster Wert des fehlerhaften Reports
						 [DatenpaketArray removeObjectAtIndex:2*ReportErrIndex +1]; //	Zweiter Wert des fehlerhaften Reports (Nachrutschen)
						 }
						 
						 while ([DatenpaketArray count]>7)
						 {
						 NSLog(@"Korrektur: red Anz: %d",[DatenpaketArray count]);
						 [DatenpaketArray removeObjectAtIndex:[DatenpaketArray count]-1];
						 }
						 //NSLog(@"Korrektur: DatenpaketArray: %@",[DatenpaketArray description]);
						 
						 
						 if ([DatenpaketArray count])
						 {
						 [DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
						 }
						 */
						
						ErrZuLang++;
						
						[ErrZuLangFeld setIntValue:ErrZuLang];
						par=0;
						break;
					}
					
					if ([DatenpaketArray count]<7)
					{
						ErrZuKurz++;
						//NSLog(@"ErrZuKurz: %d",ErrZuKurz);
						NSLog(@"ErrZuKurz: %d DatenpaketArray: %@ ",ErrZuKurz,[DatenpaketArray description] );
						errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d ErrZuKurz: %d DatenpaketArray: %@",errString,AnzDaten,ErrZuKurz,[DatenpaketArray  componentsJoinedByString:@"\t"]];
						[errString retain];
						[ErrZuKurzFeld setIntValue:ErrZuKurz];
						if ([DatenpaketArray count])
						{
							[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
						}
						par=0;
						break;
					}
					//NSLog(@"[DatenpaketArray count]: %d",[DatenpaketArray count]);
					
					
					if ([DatenpaketArray count]==9)
					{
						
						AnzDaten++;
						//errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d AllOK DatenpaketArray: %@",errString,AnzDaten,[DatenpaketArray description]];
						//[errString retain];
						int iowPar=[[DataArray objectAtIndex:1]intValue];
						//NSLog(@"														***			Last:    par: %X iowPar: %X",par, iowPar);
						if (!(iowPar==par))
						{
							
							int tempPar=[ParFeld intValue];
							tempPar++;
							NSLog(@"ParFehler: %d DatenpaketArray: %@",tempPar, [DatenpaketArray description]);
							[ParFeld setIntValue:tempPar];
							errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d ParFehler: %d DatenpaketArray: %@",errString,AnzDaten,ErrZuLang,[DatenpaketArray  componentsJoinedByString:@"\t"]];
							[errString retain];
							if ([DatenpaketArray count])
							{
	//	22.3.09					[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
							}
							par=0;
	// 22.3.09				break;
						}
						else
						{
							//NSLog(@"par OK");
							par=0;
						}
						
						
						[AnzahlDatenFeld setIntValue:AnzDaten];
						//NSLog(@"DatenpaketArray: %@" ,[DatenpaketArray description]);
						//NSLog(@"TemperaturKanalArray: %@" ,[TemperaturKanalArray description]);
						[TemperaturMKDiagramm setWerteArray:DatenpaketArray mitKanalArray:HeizungKanalArray];
						[TemperaturMKDiagramm setNeedsDisplay:YES];
						
						[BrennerDiagramm setWerteArray:DatenpaketArray mitKanalArray:BrennerKanalArray];
						[BrennerDiagramm setNeedsDisplay:YES];
						[Gitterlinien setWerteArray:DatenpaketArray mitKanalArray:BrennerKanalArray];
						[Gitterlinien setNeedsDisplay:YES];
						//NSLog(@"DatenpaketArray: %@",[DatenpaketArray description]);
						
						/*
						 int i;
						 UInt8*	buffer;
						 buffer = malloc ([DatenpaketArray count]);
						 buffer[0]=[[DatenpaketArray objectAtIndex:0]intValue];
						 int min=[[DatenpaketArray objectAtIndex:0]floatValue]*100;
						 buffer[1]= min%100;
						 for (i=2;i<[DatenpaketArray count];i++)
						 {
						 buffer[i]=[[DatenpaketArray objectAtIndex:i]intValue];
						 }
						 NSData* SerieData=[NSData dataWithBytes:buffer length:SerieSize];
						 
						 //NSLog(@"Data aus buffer: %@",[SerieData description]);
						 free (buffer);
						 
						 UInt8*	controlbuffer;
						 controlbuffer = malloc ([DatenpaketArray count]);
						 [SerieData getBytes:controlbuffer];
						 for (i=0;i<[DatenpaketArray count];i++)
						 {
						 //NSLog(@"controlbuffer i: %d Data: %d",i,controlbuffer[i]);
						 }
						 free(controlbuffer);
						 */
						
						AnzReports=0;
						ReportErrIndex=-1;
						//						[TemperaturDaten setObject: [DatenpaketArray copy] forKey:@"datenarray"]; // Dic mit Daten
						NSRange r=NSMakeRange(1,[DatenpaketArray count]-1);
						NSString* TemperaturwerteString=[[DatenpaketArray subarrayWithRange:r] componentsJoinedByString:@"\t"];
						tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
						
						[LaufzeitFeld setStringValue:[self stringAusZeit:tempZeit]]; 
						//NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%2.2f\t%@",tempZeit,TemperaturwerteString];
						NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%d\t%@",tempZeit,TemperaturwerteString];
						//[TemperaturWertFeld setString:tempWertFeldString];
						
						NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@\r%@",[TemperaturDatenFeld string],tempWertFeldString];
						
						[TemperaturDatenFeld setString:TemperaturDatenString];
						
						
						//[DruckDatenView setString:TemperaturDatenString];
						NSRange insertAtEnd=NSMakeRange([[TemperaturDatenFeld textStorage] length],0);
						[TemperaturDatenFeld scrollRangeToVisible:insertAtEnd];
						
						//[TemperaturWertFeld setStringValue:[TemperaturZeilenString copy]];
						//NSLog(@"TemperaturDatenString: %@",TemperaturDatenString);
						[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
						//					Origin des vorhandenen DocumentViews
						//					NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
						
						//					Frame des vorhandenen DocumentViews
						//					NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
						
						//					Abszisse der Anzeige
						tempZeit*= ZeitKompression; // fuer Anzeige
						
						//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
						//NSLog(@"tempFrame.size.width: %2.2f tempZeit: %2.2f",tempFrame.size.width,tempZeit);
						
						float rest=tempFrame.size.width-(float)tempZeit;//*ZeitKompression);
						
						
						if ((rest<100)&& (!IOW_busy))
						{
							//NSLog(@"rest zu klein: %2.2f",rest);
							//NSLog(@"tempOrigin alt  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
							//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
							
							//						Verschiebedistanz des angezeigten Fensters
							float delta=[[TemperaturDiagrammScroller contentView]frame].size.width-150;
							NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
							
							//						DocumentView vergroessern
							tempFrame.size.width+=delta;
							
							//						Origin des DocumentView verschieben
							tempOrigin.x-=delta;
							
							//						Origin der Bounds verschieben
							scrollPoint.x += delta;
							
							//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
							//NSLog(@"tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
							
							NSRect MKDiagrammRect=[TemperaturMKDiagramm frame];
							MKDiagrammRect.size.width=tempFrame.size.width;
							[TemperaturMKDiagramm setFrame:MKDiagrammRect];
							
							NSRect BrennerRect=[BrennerDiagramm frame];
							BrennerRect.size.width=tempFrame.size.width;
							[BrennerDiagramm setFrame:BrennerRect];
							
							NSRect GitterlinienRect=[Gitterlinien frame];
							GitterlinienRect.size.width=tempFrame.size.width;
							[Gitterlinien setFrame:GitterlinienRect];
							
							NSRect DocRect=	[[TemperaturDiagrammScroller documentView]frame];
							DocRect.size.width=tempFrame.size.width;
							
							[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
							[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
							
							
							[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
							[TemperaturDiagrammScroller setNeedsDisplay:YES];
							
							Messbeginn=NO;
						}
					}// 7 Daten
					else
					{
						//NSLog(@"Aufraeumen 7 Daten: %@",[DatenpaketArray description]);
						if ([DatenpaketArray count])
						{
							[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
						}
						
					}
				}// Daten fertig
				
			}	break;
				
			case 1:	// Raum und Stunde, Minuten, Daten
			{
				
				if ([DatenpaketArray count]==0)
				{
					/*
					Erstes Paket schickt Zeit-Daten
					Byte 1:	Stunde, Maske 0x1F, Bits 0-4 von PORTB
					Byte 2:	Minute, Maske 0x3F, Bits 0-5 von PORTD
					*/
					//NSLog(@"\n\n"); // Leerzeile
					//NSLog(@"Paket Start");
					par=0;
					Raum=0;
					//NSLog(@"Paket Start: %X		%X",[[DataArray objectAtIndex:1]intValue] ,[[DataArray objectAtIndex:2]intValue]);
					//NSLog(@"Paket Start: %@		%@",[DataArray objectAtIndex:1] ,[DataArray objectAtIndex:2]);
					tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];//;
					NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];
					//NSLog(@"abgelaufene Zeit: tempZeit:  %2.2f	tempZeitString: %@",tempZeit,tempZeitString);
					tempWertString=[tempWertString stringByAppendingString:tempZeitString];
					
					if (([self HexStringZuInt:[DataArray objectAtIndex:1]] + [self HexStringZuInt:[DataArray objectAtIndex:2]])%2) //Ungerade
					{
						par |= (1<<0);
						
						//NSLog(@"Zeit Data: %X  %X					par ungerade: %d",[self HexStringZuInt:[DataArray objectAtIndex:1]] ,[self HexStringZuInt:[DataArray objectAtIndex:2]],par);
					}
					else
					{
						//NSLog(@"Zeit Data: %X  %X					par gerade: %d",[self HexStringZuInt:[DataArray objectAtIndex:1]] ,[self HexStringZuInt:[DataArray objectAtIndex:2]],par);
					}
					
					Stunde=([self HexStringZuInt:[DataArray objectAtIndex:1]] & 0x1F);	// Bits 0-4 von PORTB
					Minuten=([self HexStringZuInt:[DataArray objectAtIndex:2]] & 0x3F);			// von PORTD
					//	NSLog(@"Raum: %@ Zeit: %d:%d tempZeit: %d Kompression: %2.2f",[Raumnamen objectAtIndex:Raum],Stunde,Minuten, tempZeit,ZeitKompression);
					[tempWerteArray addObject:[DataArray objectAtIndex:2]];
					
					[DatenpaketArray addObject:[NSNumber numberWithFloat:tempZeit]]; // Zeitstempel
					//[TemperaturWertFeld setStringValue:tempWertString];
				}
				else
				{
				
					/*
					Pakete 2, 3:	Data
					
					*/
					
					//NSLog(@"Report: (Null-basiert): %d		Data: %X	%X",AnzReports,[[DataArray objectAtIndex:1]intValue] ,[[DataArray objectAtIndex:2]intValue]);
					if ([DataArray objectAtIndex:1]==0xFF && [DataArray objectAtIndex:2]==0xFF)	// Wahrscheinlich Fehler
					{
						ReportErrIndex=AnzReports;
						NSLog(@"Fehler: ReportErrIndex: %d",ReportErrIndex);
					}
					else	// 6.3.09
					{
						//NSLog(@"Report: %d D1: %d D2: %d",AnzReports,[self HexStringZuInt:[DataArray objectAtIndex:1]],[self HexStringZuInt:[DataArray objectAtIndex:2]]);
						[tempWerteArray addObject:[DataArray objectAtIndex:1]];			// von PORTB
						
						// Experimente
						NSString* tempWertStringB=[NSString stringWithFormat:@"%2.1f",[self HexStringZuInt:[DataArray objectAtIndex:1]]];
						//NSString* tempWertStringB=[NSString stringWithFormat:@"%d",[self HexStringZuInt:[DataArray objectAtIndex:1]]];
						//NSLog(@"***  tempWertStringB: %@",tempWertStringB);
						tempWertString=[tempWertString stringByAppendingString:tempWertStringB];
						
						//NSString* tempWertStringBB=[NSString stringWithFormat:@"%d",[self HexStringZuInt:[DataArray objectAtIndex:1]]];
						//NSLog(@"++  tempWertStringBB: %@",tempWertStringBB);
						//[TemperaturZeilenString appendFormat:@"\t%@",tempWertStringB];			
						
						[tempWerteArray addObject:[DataArray objectAtIndex:2]];			// von PORTD
						NSString* tempWertStringD=[NSString stringWithFormat:@"%2.1f",[self HexStringZuInt:[DataArray objectAtIndex:2]]];
						//NSLog(@"tempWertStringD: %@",tempWertStringD);
						tempWertString=[tempWertString stringByAppendingString:tempWertStringD];
						//[TemperaturZeilenString appendFormat:@"\t%@",tempWertStringD];				
						
						// end Experimente
						
						// Daten in DatenpaketArray einsetzen
						[DatenpaketArray addObject:[NSNumber numberWithInt:[self HexStringZuInt:[DataArray objectAtIndex:1]]]];
						[DatenpaketArray addObject:[NSNumber numberWithInt:[self HexStringZuInt:[DataArray objectAtIndex:2]]]];
						
						//[TemperaturWertFeld setStringValue:tempWertString];
						//NSLog(@"\n								Data: %X  %X   AnzReports: %d",[[DataArray objectAtIndex:1]intValue],[[DataArray objectAtIndex:2]intValue],AnzReports);
						//NSLog(@"par vor: %x	anzReports: %d",par, AnzReports);
						
						// Paritaet
						if  (AnzReports<3)
						{
							if (([self HexStringZuInt:[DataArray objectAtIndex:1]] + [self HexStringZuInt:[DataArray objectAtIndex:2]])%2) //Ungerade
							{
								par |= (1<<(AnzReports+1));
								//NSLog(@"AnzReports: %d    Data: %X  %X					par ungerade: %d",AnzReports,[self HexStringZuInt:[DataArray objectAtIndex:1]] ,[self HexStringZuInt:[DataArray objectAtIndex:2]],par);
								
								//NSLog(@"AnzReports: %d				par ungerade: %X",AnzReports,par);
							}
							else
							{
								//NSLog(@"AnzReports: %d    Data: %X  %X				par gerade: %d",AnzReports,[self HexStringZuInt:[DataArray objectAtIndex:1]] ,[self HexStringZuInt:[DataArray objectAtIndex:2]],par);
								//NSLog(@"AnzReports: %d				par gerade: %X",AnzReports,par);
							}
							
							
						}
						
						
						
						AnzReports++; // Anzahl Reports ohne Schlussreport darf nicht groesser sein als 4
					}	// 0xFF	6.3.09
				} 				
				
			}break;// case 2
				
				
			case 3: // neue Stunde: Datum
			{
				
			}break;
				
		} // switch mark
		
		
	} // if count
}

- (void)LastDatenAktion:(NSNotification*)note
{
	if (Kalenderblocker)
	{
		NSLog(@"LastDatenAktion	Kalenderblocker");
		return;
	}
	NSString* StartDatenString=[[[TemperaturDatenFeld string]componentsSeparatedByString:@"\r"]objectAtIndex:0];
	//NSLog(@"LastDatenAktion StartDatenString: %@",StartDatenString);
	NSString* Kalenderformat=[[NSCalendarDate calendarDate]calendarFormat];
	//NSLog(@"LastDatenaktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"startzeit"])
	{
		DatenserieStartZeit=[[NSCalendarDate dateWithString:[[note userInfo]objectForKey:@"startzeit"] calendarFormat:Kalenderformat]retain];
	}
	//int firsttag=[DatenserieStartZeit dayOfMonth];
	int firstZeit=0;
	if (StartDatenString && [StartDatenString length])
	{
		// Zeit des ersten Datensatzes
		firstZeit = [[[StartDatenString componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
		NSLog(@"LastDatenAktion firstZeit: %d",firstZeit);
	}
	
	if ([[note userInfo]objectForKey:@"lastdatazeit"])
	{
		//	[LastDataFeld setStringValue:[[note userInfo]objectForKey:@"lastdatazeit"]];
	}
	anzLoads=0;
	[ZaehlerFeld setIntValue:anzLoads];
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	// specify just positive format
	[numberFormatter setFormat:@"##0.00"];
	
	//	[LoadMark  performClick:NULL];
	
	//NSLog(@"LastDatenAktion note: %@",[[note userInfo]description]);
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
	if ([[note userInfo]objectForKey:@"lastdatenarray"])
	{
		NSMutableArray* HomeDatenArray=(NSMutableArray*)[[note userInfo]objectForKey:@"lastdatenarray"];
		//NSLog(@"LastDatenAktion HomeDatenArray: %@",[HomeDatenArray description]);
		//		int Raum=0, Stunde=0,Minuten=0;
		/*
		48476,	Laufzeit
		74,		Vorlauf
		74,		Ruecklauf
		57,		
		7,
		13,
		91,
		0,
		38
		*/
		//float tempZeit=0;
		int tempZeit=0;
		
		//NSString* tabSeparator=@"\t";
		//NSString* crSeparator=@"\r";
		
		//		NSMutableString* tempWertString=(NSMutableString*)[TemperaturWertFeld string];//Vorhandene Daten im Wertfeld
		//NSLog(@"TemperaturZeilenString: %@",TemperaturZeilenString);
		
		//		NSArray* TemperaturKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"1",@"0" ,@"0",@"0",@"0",@"1",nil];
		//		NSArray* BrennerKanalArray=		[NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"0",@"0",@"0",@"0",nil];
		
		// Mark des Datenpaketes:	0: Schluss, Null-Werte	1: Gueltige Daten
		//NSLog(@"mark: %d",mark);
		
		
		
		//tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
		
		// 6.2.10	
		
		tempZeit=[[HomeDatenArray objectAtIndex:0]intValue]- firstZeit;
		LastLoadzeit=tempZeit;
		[LastDataFeld setStringValue:[HomeDatenArray objectAtIndex:0]];
		
		//NSLog(@"LastDatenaktion tempZeit: %d ",tempZeit);
		
		
		if ([HomeDatenArray count]==9)
		{
			
			AnzDaten++;
			//errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d AllOK DatenpaketArray: %@",errString,AnzDaten,[DatenpaketArray description]];
			//[errString retain];
			
			
			[AnzahlDatenFeld setIntValue:AnzDaten];
			//NSLog(@"DatenpaketArray: %@" ,[DatenpaketArray description]);
			//NSLog(@"HeizungKanalArray: %@" ,[HeizungKanalArray description]);
			[TemperaturMKDiagramm setWerteArray:HomeDatenArray mitKanalArray:HeizungKanalArray];
			[TemperaturMKDiagramm setNeedsDisplay:YES];
			
			NSMutableDictionary* tempVorgabenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			
			[tempVorgabenDic setObject:[NSNumber numberWithInt:5]forKey:@"anzbalken"];
			[tempVorgabenDic setObject:[NSNumber numberWithInt:3]forKey:@"datenindex"];
			
			
			[BrennerDiagramm setWerteArray:HomeDatenArray mitKanalArray:BrennerKanalArray mitVorgabenDic:tempVorgabenDic];
			
			//			[BrennerDiagramm setWerteArray:HomeDatenArray mitKanalArray:BrennerKanalArray];
			[BrennerDiagramm setNeedsDisplay:YES];
			[Gitterlinien setWerteArray:HomeDatenArray mitKanalArray:BrennerKanalArray];
			[Gitterlinien setNeedsDisplay:YES];
			//NSLog(@"LastDatenAktion HomeDatenArray: %@",[HomeDatenArray description]);
			
			/*
			 int i;
			 UInt8*	buffer;
			 buffer = malloc ([DatenpaketArray count]);
			 buffer[0]=[[DatenpaketArray objectAtIndex:0]intValue];
			 int min=[[DatenpaketArray objectAtIndex:0]floatValue]*100;
			 buffer[1]= min%100;
			 for (i=2;i<[DatenpaketArray count];i++)
			 {
			 buffer[i]=[[DatenpaketArray objectAtIndex:i]intValue];
			 }
			 NSData* SerieData=[NSData dataWithBytes:buffer length:SerieSize];
			 
			 //NSLog(@"Data aus buffer: %@",[SerieData description]);
			 free (buffer);
			 
			 UInt8*	controlbuffer;
			 controlbuffer = malloc ([DatenpaketArray count]);
			 [SerieData getBytes:controlbuffer];
			 for (i=0;i<[DatenpaketArray count];i++)
			 {
			 //NSLog(@"controlbuffer i: %d Data: %d",i,controlbuffer[i]);
			 }
			 free(controlbuffer);
			 */
			
			AnzReports=0;
			ReportErrIndex=-1;
			NSRange r=NSMakeRange(1,[HomeDatenArray count]-1); // Erster Wert ist Abszisse
			NSString* TemperaturwerteString=[[HomeDatenArray subarrayWithRange:r] componentsJoinedByString:@"\t"];
			
			[LaufzeitFeld setStringValue:[self stringAusZeit:tempZeit]]; 
			//NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%2.2f\t%@",tempZeit,TemperaturwerteString];
			NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%d\t%@",tempZeit,TemperaturwerteString];
			//[TemperaturWertFeld setString:tempWertFeldString];
			
			NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@\r%@",[TemperaturDatenFeld string],tempWertFeldString];
			
			[TemperaturDatenFeld setString:TemperaturDatenString];
			
			//[DruckDatenView setString:TemperaturDatenString];
			NSRange insertAtEnd=NSMakeRange([[TemperaturDatenFeld textStorage] length],0);
			[TemperaturDatenFeld scrollRangeToVisible:insertAtEnd];
			
			//[TemperaturWertFeld setStringValue:[TemperaturZeilenString copy]];
			//NSLog(@"TemperaturDatenString: %@",TemperaturDatenString);
			//					Origin des vorhandenen DocumentViews
			//					NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
			
			//					Frame des vorhandenen DocumentViews
			//					NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
			
			//					Abszisse der Anzeige
			tempZeit*= ZeitKompression; // fuer Anzeige
			
			//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			//NSLog(@"HomeDatenAktion tempFrame.size.width: %2.2f tempZeit: %2.2f",tempFrame.size.width,tempZeit);
			
			float rest=tempFrame.size.width-(float)tempZeit;
			
			
			if ((rest<120)&& (!IOW_busy))
			{
				//NSLog(@"rest zu klein: %2.2f",rest);
				//NSLog(@"tempOrigin alt  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				
				//						Verschiebedistanz des angezeigten Fensters
				float delta=[[TemperaturDiagrammScroller contentView]frame].size.width-150;
				NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
				
				//						DocumentView vergroessern
				tempFrame.size.width+=delta;
				
				//						Origin des DocumentView verschieben
				tempOrigin.x-=delta;
				
				//						Origin der Bounds verschieben
				scrollPoint.x += delta;
				
				//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				//NSLog(@"tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				
				NSRect MKDiagrammRect=[TemperaturMKDiagramm frame];
				MKDiagrammRect.size.width=tempFrame.size.width;
				[TemperaturMKDiagramm setFrame:MKDiagrammRect];
				
				NSRect BrennerRect=[BrennerDiagramm frame];
				BrennerRect.size.width=tempFrame.size.width;
				[BrennerDiagramm setFrame:BrennerRect];
				
				NSRect GitterlinienRect=[Gitterlinien frame];
				GitterlinienRect.size.width=tempFrame.size.width;
				[Gitterlinien setFrame:GitterlinienRect];
				
				NSRect DocRect=	[[TemperaturDiagrammScroller documentView]frame];
				DocRect.size.width=tempFrame.size.width;
				
				[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
				[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
				
				[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
				[TemperaturDiagrammScroller setNeedsDisplay:YES];
				
			}
		}// 7 Daten
		
		
	}// if dataenarray
	
}//

#pragma mark solar


-(void)SolarDataDownloadAktion:(NSNotification*)note
{
/*
Aufgerufen von rHomeData.
Setzt Feldwerte im Fenster Data.

*/

	//NSLog(@"rData SolarDataDownloadAktion");
	[SolarLoadMark performClick:NULL];
	
	if ([[note userInfo]objectForKey:@"err"])
	{
	[LastSolarDataFeld setStringValue:[[note userInfo]objectForKey:@"err"]];
	}
/*
	if ([[note userInfo]objectForKey:@"erfolg"])
	{
	[LastSolarDataFeld setStringValue:[[note userInfo]objectForKey:@"erfolg"]];
	}
*/	
if ([[note userInfo]objectForKey:@"lasttimestring"])
	{
		[LastSolarDatazeitFeld setStringValue:[[note userInfo]objectForKey:@"lasttimestring"]];
	}
	else
	{
		[LastSolarDatazeitFeld setStringValue:@"--"];
	}

	anzSolarLoads++;
	[SolarZaehlerFeld setIntValue:anzSolarLoads];
	if (anzSolarLoads > 8)
	{
		NSBeep();
		[self reload:NULL];
		
	}

	//NSLog(@"anzSolarLoads: %d",anzSolarLoads);
	[LastSolarDataFeld setStringValue:@"***"];

	if ([[note userInfo]objectForKey:@"datastring"])
	{
	NSString* tempString = [[note userInfo]objectForKey:@"datastring"];
	//tempString= [[[[NSNumber numberWithInt:anzSolarLoads]stringValue]stringByAppendingString:@": "]stringByAppendingString:tempString];

	[LastSolarDataFeld setStringValue:tempString];
	}
	else
	{
	[LastSolarDataFeld setStringValue:@"-"];
	[LastSolarDataFeld setStringValue:@"--"];
	[LastSolarDataFeld setStringValue:@"---"];
	[LastSolarDataFeld setStringValue:@"----"];
	[LastSolarDataFeld setStringValue:@"-----"];
	}

/*
	if ([[note userInfo]objectForKey:@"lastdatazeit"])
	{
	int tempLastdataZeit=[[[note userInfo]objectForKey:@"lastdatazeit"] intValue];
	NSLog(@"lastdatazeit: %d * LastLoadzeit: %d",tempLastdataZeit,LastLoadzeit );
	
	int	tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];		
	//[LastDatazeitFeld setStringValue:[[note userInfo]objectForKey:@"lastdatazeit"]];
	[LastDatazeitFeld setIntValue:tempLastdataZeit-LastLoadzeit];
	}
*/
	if ([[note userInfo]objectForKey:@"delta"])
	{
	NSString* deltaString=[NSString stringWithFormat:@"%2.4F",[[[note userInfo]objectForKey:@"delta"]floatValue]];
	[SolarLoadtimeFeld setStringValue:deltaString];
	}

}

- (IBAction)reportSolarClear:(id)sender
{
	NSLog(@"reportSolarClear");
// TODO


	[self clearSolarData];
	NSCalendarDate* StartZeit=[NSCalendarDate calendarDate];
	[StartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
//	[StartzeitFeld setStringValue:[StartZeit description]];

	[SolarStartzeitFeld setStringValue:@""];

	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"clear"forKey:@"data"];
	SolarDatenserieStartZeit=[[NSCalendarDate calendarDate]retain];
	[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
//	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
//	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	[StopTaste setEnabled:NO];
	[StartTaste setEnabled:YES];

}

- (void)reportSolarUpdate:(id)sender
{
	NSLog(@"reportSolarUpdate");
	
	[self clearSolarData];
	[SolarStartzeitFeld setStringValue:@""];
	[SolarKalender setDateValue: [NSDate date]];

	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"clear"forKey:@"data"];
	//DatenserieStartZeit=[[NSCalendarDate calendarDate]retain];
	//[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"solardatenvonheute" object:NULL userInfo:NotificationDic];
	//[StopTaste setEnabled:NO];
	//[StartTaste setEnabled:YES];
	
}


- (void)ExterneSolarDatenAktion:(NSNotification*)note
{
	Quelle=1;
	if ([[note userInfo]objectForKey:@"startzeit"])
	{
		//NSString* StartzeitString = [[note userInfo]objectForKey:@"startzeit"];
		//NSLog(@"ExterneSolarDatenAktion: Startzeit: *%@* StartzeitString: *%@*",[[note userInfo]objectForKey:@"startzeit"],StartzeitString);
		
		NSString* Kalenderformat=[[NSCalendarDate calendarDate]calendarFormat];
		SolarDatenserieStartZeit=[[NSCalendarDate dateWithString:[[note userInfo]objectForKey:@"startzeit"] calendarFormat:Kalenderformat]retain];
		int tag=[SolarDatenserieStartZeit dayOfMonth];
		
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[NotificationDic setObject:@"datastart"forKey:@"data"];
		[NotificationDic setObject:SolarDatenserieStartZeit forKey:@"datenseriestartzeit"];
		
		NSCalendarDate* AnzeigeDatum= [SolarDatenserieStartZeit copy];
		[AnzeigeDatum setCalendarFormat:@"%d.%m.%y %H:%M"];
		[SolarStartzeitFeld setStringValue:[AnzeigeDatum description]];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		
		[nc postNotificationName:@"data" object:NotificationDic userInfo:NotificationDic];
		
		//NSLog(@"ExterneSolarDatenAktion DatenserieStartZeit: %@ tag: %d",  [SolarDatenserieStartZeit description], tag);
	}
	
	if ([[note userInfo]objectForKey:@"datumtag"])
	{
		
	}
	
	
	if ([[note userInfo]objectForKey:@"datenarray"])
	{
		
		NSArray* SolarTemperaturKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"1",@"1",@"0",@"0",nil];
		NSArray* EinschaltKanalArray=		[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		
		NSArray* tempDatenArray = [[note userInfo]objectForKey:@"datenarray"];
		//NSLog(@"ExterneSolarDatenAktion tempDatenArray last Data:%@",[[tempDatenArray lastObject]description]);
		
		NSArray* tempZeilenArray= (NSArray*)[[tempDatenArray lastObject] componentsSeparatedByString:@"\r"];
	NSLog(@"tempZeilenArray: %@",[tempZeilenArray description]);
		NSString* tempWertString;
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:1]intValue]/2.0];
		[KollektorVorlaufFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:2]intValue]/2.0];
		[KollektorRuecklaufFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:3]intValue]/2.0];
		[BoileruntenFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:4]intValue]/2.0];
		[BoilermitteFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:5]intValue]/2.0];
		[BoilerobenFeld setStringValue:tempWertString];
		
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[tempZeilenArray objectAtIndex:6]intValue]/2.0];
		[KollektorTemperaturFeld setStringValue:tempWertString];

		// Zeit des ersten Datensatzes
		//int firstZeit = [[[[tempDatenArray objectAtIndex:0] componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
		//NSLog(@"ExterneSolarDatenAktion firstZeit: %d",firstZeit);
		
		// Zeit des letzten Datensatzes
		int lastZeit = [[[[tempDatenArray lastObject] componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
		NSLog(@"ExterneSolarDatenAktion lastZeit: %d",lastZeit);
		[SolarLaufzeitFeld setStringValue:[self stringAusZeit:lastZeit]]; 
		
		// Breite des DocumentViews bestimmen
		//		lastZeit -= firstZeit;
		lastZeit *= SolarZeitKompression;
		//NSLog(@"ExterneSolarDatenAktion Zeitkompression: %2f2",SolarZeitKompression);
		//	Origin des vorhandenen DocumentViews
		NSPoint tempOrigin=[[SolarDiagrammScroller documentView] frame].origin;
		//NSLog(@"ExterneSolarDatenAktion tempOrigin: x: %2.2f y: %2.2f",tempOrigin.x, tempOrigin.y);
		//28.7.09
		tempOrigin.x=0;
		[[SolarDiagrammScroller documentView] setFrameOrigin:tempOrigin];
		
		
		//	Frame des vorhandenen DocumentViews
		NSRect tempFrame=[[SolarDiagrammScroller documentView] frame];
		//NSLog(@"ExterneSolarDatenAktion  tempOrigin: x: %2.2f  tempFrame width: x: %2.2f lastZeit: %d",tempOrigin.x,tempFrame.size.width, lastZeit);
		
		//	Verschiebedistanz des angezeigten Fensters
		
		if (tempFrame.size.width < lastZeit) // Anzeige hat nicht Platz
		{
			//NSLog(@"Anzeige hat nicht Platz:  width: %2.2f lastZeit: %d",tempFrame.size.width,lastZeit);
			//float delta=[[TemperaturDiagrammScroller contentView]frame].size.width-150;
			int PlatzRechts = 50;
			float delta=lastZeit- [[SolarDiagrammScroller documentView]bounds].size.width+PlatzRechts; // Abstand vom rechten Rand, Platz fuer Datentitel und Wert
			NSPoint scrollPoint=[[SolarDiagrammScroller documentView]bounds].origin;
			//NSLog(@"delta: %2.2f",delta);
			//	DocumentView vergroessern
			tempFrame.size.width+=delta;
			
			//	Origin des DocumentView verschieben
			//NSLog(@"tempOrigin.x vor: %2.2f",tempOrigin.x);
			tempOrigin.x-=delta;
			//NSLog(@"tempOrigin.x nach: %2.2f",tempOrigin.x);
			
			//	Origin der Bounds verschieben
			//NSLog(@"scrollPoint.x vor: %2.2f",scrollPoint.x);
			scrollPoint.x += delta;
			//NSLog(@"scrollPoint.x nach: %2.2f",scrollPoint.x);
			
			//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			//NSLog(@"tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			
			
			NSRect MKDiagrammRect=[SolarDiagramm frame];
			MKDiagrammRect.size.width=tempFrame.size.width;
			
			//NSLog(@"MKDiagrammRect.size.width: %2.2f",MKDiagrammRect.size.width);
			[SolarDiagramm setFrame:MKDiagrammRect];
			
			
			NSRect EinschaltRect=[SolarEinschaltDiagramm frame];
			EinschaltRect.size.width=tempFrame.size.width;
			//NSLog(@"EinschaltRect.size.width: %2.2f",EinschaltRect.size.width);
			
			[SolarEinschaltDiagramm setFrame:EinschaltRect];
			
			
			NSRect GitterlinienRect=[SolarGitterlinien frame];
			GitterlinienRect.size.width=tempFrame.size.width;
			//NSLog(@"GitterlinienRect.size.width: %2.2f",GitterlinienRect.size.width);
			
			[SolarGitterlinien setFrame:GitterlinienRect];
			
			NSRect DocRect=[[SolarDiagrammScroller documentView]frame];
			//NSLog(@"DocRect.size.width vor: %2.2f",DocRect.size.width);
			DocRect.size.width=tempFrame.size.width;
			//NSLog(@"DocRect.size.width nach: %2.2f",DocRect.size.width);
			
			[[SolarDiagrammScroller documentView] setFrame:DocRect];
			//NSLog(@"tempOrigin end  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			[[SolarDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			
			//NSLog(@"ExterneSolarDatenAktion  tempOrigin: x: %2.2f  *   DocRect width: %2.2f",tempOrigin.x,DocRect.size.width);
			
			//NSLog(@"scrollPoint end  x: %2.2f y: %2.2f",scrollPoint.x,scrollPoint.y);
			[[SolarDiagrammScroller contentView] scrollPoint:scrollPoint];
			[SolarDiagrammScroller setNeedsDisplay:YES];
		}
		
		NSMutableDictionary* tempVorgabenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		
		/*
		 derVorgabenDic enthaelt:
		 - anzahl der Balken, die darzustellen sind. key: anzbalken
		 - Index des Wertes im Werterray, der darzustellen ist (nur Daten, erster Wert ist Abszisse. Zaheler beginnt bei Obj 1 mit Index 0)
		 */
		
		[tempVorgabenDic setObject:[NSNumber numberWithInt:4]forKey:@"anzbalken"];
		[tempVorgabenDic setObject:[NSNumber numberWithInt:6]forKey:@"datenindex"];
		
		
		NSString* TemperaturDatenString= [NSString string];
		NSEnumerator* DatenEnum = [tempDatenArray objectEnumerator];
		id einDatenString;
		//NSLog(@"ExterneSolarDatenAktion begin while");
		long lastzeit=0;
		while (einDatenString = [DatenEnum nextObject])
		{
			//NSMutableArray* tempZeilenArray= (NSMutableArray*)[einDatenString componentsSeparatedByString:@"\t"];
			// Datenstring aufteilen in Komponenten
			NSMutableArray* tempZeilenArray= (NSMutableArray*)[einDatenString componentsSeparatedByString:@"\r"];
			
			//NSLog(@"ExterneSolarDatenAktion einDatenString: %@\n tempZeilenArray:%@\n", einDatenString,[tempZeilenArray description]);
			//NSLog(@"ExterneSolarDatenAktion einDatenString: %@ count: %d", einDatenString, [tempZeilenArray count]);
			if ([tempZeilenArray count]== 9) // Daten vollständig
			{
				//NSLog(@"ExterneSolarDatenAktion tempZeilenArray:%@",[tempZeilenArray description]);
				// Datenserie auf Startzeit synchronisieren
				int tempZeit=[[tempZeilenArray objectAtIndex:0]intValue];
				
				if (tempZeit-lastzeit >30) // nicht alle Daten laden
				{
					lastzeit=tempZeit;
					//tempZeit*= SolarZeitKompression;
					//tempZeit -= firstZeit;
					[tempZeilenArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:tempZeit]];
					
					[SolarDiagramm setWerteArray:tempZeilenArray mitKanalArray:SolarTemperaturKanalArray ];
					
					
					/*
					 NSMutableDictionary* tempVorgabenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
					 [tempVorgabenDic setObject:[NSNumber numberWithInt:5]forKey:@"anzbalken"];
					 [tempVorgabenDic setObject:[NSNumber numberWithInt:3]forKey:@"datenindex"];
					 */		
					[SolarGitterlinien setWerteArray:tempZeilenArray mitKanalArray:EinschaltKanalArray];
					
					[SolarEinschaltDiagramm setWerteArray:tempZeilenArray mitKanalArray:EinschaltKanalArray  mitVorgabenDic:tempVorgabenDic];
					
					// Aus TempZeilenarray einen tab-getrennten String bilden
					NSString* tempZeilenString=[tempZeilenArray componentsJoinedByString:@"\t"];
					//				NSLog(@"tempZeilenString: %@", tempZeilenString);
					TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t%@",TemperaturDatenString,tempZeilenString];
					//				TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t%@",TemperaturDatenString,einDatenString];
				}	// if Zeitabstand genuegend gross
			}// Daten vollständig
			
		}	// while
		//NSLog(@"ExterneSolarDatenAktion end while");
		
		[SolarDiagramm setNeedsDisplay:YES];
		[SolarGitterlinien setNeedsDisplay:YES];
		[SolarEinschaltDiagramm setNeedsDisplay:YES];
		
		AnzSolarDaten=[tempDatenArray count];
		//NSLog(@"ExterneSolardatenaktion AnzSolarDaten: %d",AnzSolarDaten);
		[AnzahlSolarDatenFeld setIntValue:[tempDatenArray count]];
		
		[SolarDatenFeld setString:TemperaturDatenString];
		NSRange insertAtEnd=NSMakeRange([[SolarDatenFeld textStorage] length],0);
		[SolarDatenFeld scrollRangeToVisible:insertAtEnd];
		
		[ClearTaste setEnabled:YES];
		
		// 14.4.10 Doppeltes Laden verhindern.
		NSTimer* SolarKalenderTimer=[[NSTimer scheduledTimerWithTimeInterval:1
																			  target:self 
																			selector:@selector(SolarKalenderFunktion:) 
																			userInfo:nil 
																			 repeats:NO]retain];
		
		NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:SolarKalenderTimer forMode:NSDefaultRunLoopMode];
		
		[SolarKalenderTimer release];
		//SolarKalenderblocker=0;
		
	}
	//NSBeep();
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"loadsolardataok"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
//	[nc postNotificationName:@"LoadData" object:self userInfo:NotificationDic];
	[SolarKalender setEnabled:YES];
	
	NSMutableDictionary* BalkendatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[BalkendatenDic setObject:[NSNumber numberWithInt:1]forKey:@"aktion"];
	
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//	[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:BalkendatenDic];
	//[TemperaturStatistikDiagramm setNeedsDisplay:YES];
	[TagGitterlinien setNeedsDisplay:YES];
	//NSLog(@"ExterneDatenAktion end");
	
	
}

- (void)SolarKalenderFunktion:(NSTimer*)derTimer
{
	SolarKalenderblocker=0;
}

- (void)setSolarKalenderBlocker:(int)derStatus
{
	SolarKalenderblocker=derStatus;
}


- (void)LastSolarDatenAktion:(NSNotification*)note
{
	
	if (Kalenderblocker)
	{
		NSLog(@"LastSolarDatenAktion	Kalenderblocker");
		return;
	}
	
	NSMutableArray* StartDatenArray=(NSMutableArray*)[[SolarDatenFeld string]componentsSeparatedByString:@"\r"];
	if ([[StartDatenArray objectAtIndex:0]length]==0)
	{
	[StartDatenArray removeObjectAtIndex:0];
	}
	//NSString* StartDatenString=[[[SolarDatenFeld string]componentsSeparatedByString:@"\r"]objectAtIndex:1];
	NSString* StartDatenString=[StartDatenArray objectAtIndex:0];
//	NSLog(@"LastSolarDatenAktion StartDatenString: %@",StartDatenString);
	NSString* Kalenderformat=[[NSCalendarDate calendarDate]calendarFormat];
	NSLog(@"LastSolarDatenaktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"startzeit"])
	{
		SolarDatenserieStartZeit=[[NSCalendarDate dateWithString:[[note userInfo]objectForKey:@"startzeit"] calendarFormat:Kalenderformat]retain];
	}
	//int firsttag=[SolarDatenserieStartZeit dayOfMonth];
	int firstZeit=0;
	if (StartDatenString && [StartDatenString length])
	{
		// Zeit des ersten Datensatzes
		
		firstZeit = [[[StartDatenString componentsSeparatedByString:@"\t"]objectAtIndex:0]intValue];
//		NSLog(@"LastSolarDatenAktion firstZeit: %d",firstZeit);
	}
	
	if ([[note userInfo]objectForKey:@"lastdatazeit"])
	{
		//	[LastDataFeld setStringValue:[[note userInfo]objectForKey:@"lastdatazeit"]];
	}
	anzSolarLoads=0;
	[SolarZaehlerFeld setIntValue:anzSolarLoads];
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	// specify just positive format
	[numberFormatter setFormat:@"##0.00"];
	
	//	[LoadMark  performClick:NULL];
	
	//NSLog(@"LastSolarDatenAktion note: %@",[[note userInfo]description]);
	   /*
		 lastdatenarray =     (
        48849,	Laufzeit
        47,		Kollektor Vorlauf
        46,		Kollektor Ruecklauf
        40,		Boiler unten
        128,	Boiler mitte
        136,	Boiler oben
        82,		Kollektortemperatur
        0,
        255
			);
			Alle Temperaturerte doppelt
	 */
	NSString* tempWertString;
	
	
	
	NSPoint tempOrigin=[[SolarDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[[SolarDiagrammScroller documentView] frame];
	
	if ([[note userInfo]objectForKey:@"lastdatenarray"])
	{
		NSMutableArray* lastDatenArray=(NSMutableArray*)[[note userInfo]objectForKey:@"lastdatenarray"];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:1]intValue]/2.0];
		[KollektorVorlaufFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:2]intValue]/2.0];
		[KollektorRuecklaufFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:3]intValue]/2.0];
		[BoileruntenFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:4]intValue]/2.0];
		[BoilermitteFeld setStringValue:tempWertString];
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:5]intValue]/2.0];
		[BoilerobenFeld setStringValue:tempWertString];
		
		tempWertString=[NSString stringWithFormat:@"%2.1f",[[lastDatenArray objectAtIndex:6]intValue]/2.0];
		[KollektorTemperaturFeld setStringValue:tempWertString];
		
		//		int Raum=0, Stunde=0,Minuten=0;
		
		//float tempZeit=0;
		int tempZeit=0;
		
		//NSString* tabSeparator=@"\t";
		//NSString* crSeparator=@"\r";
		
		//		NSMutableString* tempWertString=(NSMutableString*)[TemperaturWertFeld string];//Vorhandene Daten im Wertfeld
		//NSLog(@"TemperaturZeilenString: %@",TemperaturZeilenString);
		
		
		NSArray* TemperaturKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"1",@"1",@"0",@"1",nil];
		NSArray* StatusKanalArray=		[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		
		// Mark des Datenpaketes:	0: Schluss, Null-Werte	1: Gueltige Daten
		//NSLog(@"mark: %d",mark);
		
		
		
		//tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
		
		// 6.2.10	
		
		tempZeit=[[lastDatenArray objectAtIndex:0]intValue];//- firstZeit;
		//tempZeit-= firstZeit;
		LastSolarLoadzeit=tempZeit;
		[LastSolarDataFeld setStringValue:[lastDatenArray objectAtIndex:0]];
		
		//NSLog(@"LastSolarDatenaktion tempZeit: %d ",tempZeit);
		
		
		if ([lastDatenArray count]==9) // richtige Anzahl Daten
		{
			
			AnzSolarDaten++;
			//errString =[NSString stringWithFormat:@"%@\rAnzDaten: %d AllOK DatenpaketArray: %@",errString,AnzSolarDaten,[DatenpaketArray description]];
			//[errString retain];
			
			
			[AnzahlSolarDatenFeld setIntValue:AnzSolarDaten];
			//NSLog(@"DatenpaketArray: %@" ,[DatenpaketArray description]);
			//NSLog(@"LastSolarDatenAktion lastDatenArray: %@" ,[lastDatenArray description]);
			
			[SolarDiagramm setWerteArray:lastDatenArray mitKanalArray:TemperaturKanalArray];
			[SolarDiagramm setNeedsDisplay:YES];
			
			NSMutableDictionary* tempVorgabenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			
			/*
			derVorgabenDic enthaelt:
			- anzahl der Balken, die darzustellen sind. key: anzbalken
			- Index des Wertes im Werterray, der darzustellen ist (nur Daten, erster Wert ist Abszisse. Zaheler beginnt bei Obj 1 mit Index 0)
			*/

			[tempVorgabenDic setObject:[NSNumber numberWithInt:4]forKey:@"anzbalken"];
			[tempVorgabenDic setObject:[NSNumber numberWithInt:6]forKey:@"datenindex"];

#pragma mark Simulation			
// Simulation
/*
			NSNumber* filler=[NSNumber numberWithInt:1];
			NSNumber* ON=[NSNumber numberWithInt:24];
			NSNumber* OFF=[NSNumber numberWithInt:0];
			NSArray* tempArray;
			//NSArray* tempArray=[NSArray arrayWithObjects:[lastDatenArray objectAtIndex:0], [lastDatenArray objectAtIndex:1],[lastDatenArray objectAtIndex:2],filler,filler,,filler,filler,ON,filler,NULL];
			
			if (([[lastDatenArray objectAtIndex:0]intValue]%100)<50)
			{
			tempArray=[NSArray arrayWithObjects:[lastDatenArray objectAtIndex:0],[lastDatenArray objectAtIndex:1],[lastDatenArray objectAtIndex:2],filler,filler,filler,filler,ON,[lastDatenArray lastObject],NULL];
			}
			else 
			{
			tempArray=[NSArray arrayWithObjects:[lastDatenArray objectAtIndex:0],[lastDatenArray objectAtIndex:1],[lastDatenArray objectAtIndex:2],filler,filler,filler,filler,OFF,[lastDatenArray lastObject],NULL];
			}

			
			//NSLog(@"Sim tempArray: %@",[tempArray description]);
			[SolarEinschaltDiagramm setWerteArray:tempArray mitKanalArray:StatusKanalArray mitVorgabenDic:tempVorgabenDic];
*/			
			
			[SolarEinschaltDiagramm setWerteArray:lastDatenArray mitKanalArray:StatusKanalArray mitVorgabenDic:tempVorgabenDic];
			[SolarEinschaltDiagramm setNeedsDisplay:YES];
			
			
			//			[BrennerDiagramm setWerteArray:HomeDatenArray mitKanalArray:BrennerKanalArray];
			//			[BrennerDiagramm setNeedsDisplay:YES];
			[SolarGitterlinien setWerteArray:lastDatenArray mitKanalArray:StatusKanalArray];
			[SolarGitterlinien setNeedsDisplay:YES];
			//NSLog(@"DatenpaketArray: %@",[HomeDatenArray description]);
			
			AnzReports=0;
			ReportErrIndex=-1;
			NSRange r=NSMakeRange(1,[lastDatenArray count]-1); // Erster Wert ist Abszisse
			NSString* TemperaturwerteString=[[lastDatenArray subarrayWithRange:r] componentsJoinedByString:@"\t"];
			
			[SolarLaufzeitFeld setStringValue:[self stringAusZeit:tempZeit]]; 
			//NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%2.2f\t%@",tempZeit,TemperaturwerteString];
			NSString* tempWertFeldString=[NSString stringWithFormat:@"\t%d\t%@",tempZeit,TemperaturwerteString];
			//[TemperaturWertFeld setString:tempWertFeldString];
			
			NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@\r%@",[SolarDatenFeld string],tempWertFeldString];
			
			[SolarDatenFeld setString:TemperaturDatenString];
			
			//[DruckDatenView setString:TemperaturDatenString];
			NSRange insertAtEnd=NSMakeRange([[SolarDatenFeld textStorage] length],0);
			[SolarDatenFeld scrollRangeToVisible:insertAtEnd];
			
			//[TemperaturWertFeld setStringValue:[TemperaturZeilenString copy]];
			//NSLog(@"TemperaturDatenString: %@",TemperaturDatenString);
			//					Origin des vorhandenen DocumentViews
			//					NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
			
			//					Frame des vorhandenen DocumentViews
			//					NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
			
			//					Abszisse der Anzeige
			tempZeit*= SolarZeitKompression; // fuer Anzeige
			
			//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			//NSLog(@"SolarDatenAktion tempFrame.size.width: %2.2f   tempZeit: %d",tempFrame.size.width,tempZeit);
			//NSLog(@"SolarDatenAktion tempOrigin alt  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			float rest=tempFrame.size.width-(float)tempZeit; // tempframe von documentView
			//NSLog(@"SolarDatenAktion rest: %2.2f",rest);
			
			//if ((rest<120)&& (!IOW_busy))
			if ((rest<120)) // Platz wird knapp oder neue tempZeit ist groesser als bestehender tempFrame
			{
				//NSLog(@"Solar rest zu klein: %2.2f",rest);
				//NSLog(@"tempOrigin alt  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				//NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				
				//						Verschiebedistanz des angezeigten Fensters
				
				float delta=0;
				if (rest && (rest<120))
				{
					delta=[[SolarDiagrammScroller contentView]frame].size.width-150;
				}
				else 
				{
					delta=[[SolarDiagrammScroller contentView]frame].size.width-rest-150;
				}

				//NSLog(@"SolarDatenAktion rest zu klein    rest: %2.2f  delta: %2.2f",rest, delta);
				NSPoint scrollPoint=[[SolarDiagrammScroller documentView]bounds].origin;
				
				//	DocumentView vergroessern
				tempFrame.size.width+=delta;
				
				//	Origin des DocumentView verschieben
				tempOrigin.x-=delta;
				
				//	Origin der Bounds verschieben
				scrollPoint.x += delta;
				
				//NSLog(@"SolarDatenAktion tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				//NSLog(@"SolarDatenAktion tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				
				NSRect MKDiagrammRect=[SolarDiagramm frame];
				MKDiagrammRect.size.width=tempFrame.size.width;
				[SolarDiagramm setFrame:MKDiagrammRect];
				
				NSRect SolarEinschaltRect=[SolarEinschaltDiagramm frame];
				SolarEinschaltRect.size.width=tempFrame.size.width;
				[SolarEinschaltDiagramm setFrame:SolarEinschaltRect];
				
				NSRect GitterlinienRect=[Gitterlinien frame];
				GitterlinienRect.size.width=tempFrame.size.width;
				[SolarGitterlinien setFrame:GitterlinienRect];
				
				NSRect DocRect=	[[SolarDiagrammScroller documentView]frame];
				DocRect.size.width=tempFrame.size.width;
				
				[[SolarDiagrammScroller documentView] setFrame:DocRect];
				[[SolarDiagrammScroller documentView] setFrameOrigin:tempOrigin];
				
				
				[[SolarDiagrammScroller contentView] scrollPoint:scrollPoint];
				[SolarDiagrammScroller setNeedsDisplay:YES];
				
			}
		}// 7 Daten
		
		
	}// if dataenarray
	
}


- (void)clearSolarData
{
	NSLog(@"clearSolarData");
	[SolarDatenFeld setString:[NSString string]];
	AnzDaten=0;
	SolarDatenserieStartZeit=[NSCalendarDate calendarDate];
	[SolarDatenserieStartZeit retain];
	//NSDictionary* DatumDic=[NSDictionary dictionaryWithObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"datastart"forKey:@"data"];
	[NotificationDic setObject:SolarDatenserieStartZeit forKey:@"datenseriestartzeit"];
	
	NSCalendarDate* AnzeigeDatum= [SolarDatenserieStartZeit copy];
	[AnzeigeDatum setCalendarFormat:@"%d.%m.%y %H:%M"];
	[StartzeitFeld setStringValue:[AnzeigeDatum description]];
	[AnzahlSolarDatenFeld setStringValue:@""];
	[LastSolarDataFeld setStringValue:@""];
	[LastSolarDatazeitFeld setStringValue:@""];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	
	//par=0;
	
	if (DatenpaketArray && [DatenpaketArray count])
	{
		[DatenpaketArray removeAllObjects];
	}
	float Feldbreite=[[SolarDiagrammScroller contentView]frame].size.width;
	float x = [[SolarDiagrammScroller contentView]frame].origin.x;
	[SolarDiagramm clean];
	NSRect SolarDiagrammRect=[SolarDiagramm frame];
	SolarDiagrammRect.size.width = Feldbreite;
	SolarDiagrammRect.origin.x=x;
	[SolarDiagramm setFrame:SolarDiagrammRect];
	[SolarDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[SolarDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[SolarDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[SolarDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[SolarDiagramm setStartZeit:DatenserieStartZeit];
	
	[SolarEinschaltDiagramm clean];
	NSRect EinschaltDiagrammRect=[SolarEinschaltDiagramm frame];
	EinschaltDiagrammRect.size.width = Feldbreite;
	EinschaltDiagrammRect.origin.x=x;
	[SolarEinschaltDiagramm setFrame:EinschaltDiagrammRect];
	[SolarEinschaltDiagramm setStartZeit:DatenserieStartZeit];
	
	[SolarGitterlinien clean];
	NSRect GitterlinienRect=[SolarGitterlinien frame];
	GitterlinienRect.size.width = Feldbreite;
	GitterlinienRect.origin.x=x;
	[SolarGitterlinien setFrame:GitterlinienRect];
	[SolarGitterlinien setStartZeit:DatenserieStartZeit];
	
	NSRect DocRect=	[[SolarDiagrammScroller documentView]frame];
	DocRect.size.width=Feldbreite;
	
	
	[[SolarDiagrammScroller documentView] setFrame:DocRect];
	NSPoint tempOrigin=[[SolarDiagrammScroller documentView] frame].origin;
	
	[[SolarDiagrammScroller documentView] setFrameOrigin:tempOrigin];
	
	NSPoint scrollPoint=[[SolarDiagrammScroller documentView]bounds].origin;
	
	[[SolarDiagrammScroller contentView] scrollPoint:scrollPoint];
	[SolarDiagrammScroller setNeedsDisplay:YES];
	
}
#pragma mark end solar

- (void)reportUpdate:(id)sender
{
	NSLog(@"rData reportUpdate");
	
	[self clearData];
	[StartzeitFeld setStringValue:@""];
	[Kalender setDateValue: [NSDate date]];

	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"clear"forKey:@"data"];
	//DatenserieStartZeit=[[NSCalendarDate calendarDate]retain];
	//[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"datenvonheute" object:NULL userInfo:NotificationDic];
	//[StopTaste setEnabled:NO];
	//[StartTaste setEnabled:YES];
	
}

- (void)reportSuchen:(id)sender
{
/*
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	//[NotificationDic setObject:[[Kalender dateValue]description] forKey:@"datum"];
	[NotificationDic setObject:[SuchDatumFeld stringValue] forKey:@"datum"];
	
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSLog(@"reportSuchen NotificationDic: %@",[NotificationDic description]);
	
	[nc postNotificationName:@"HomeDataKalender" object:self userInfo:NotificationDic];
*/
}


- (void)reportKalender:(id)sender
{	
	if (Kalenderblocker)
	{
		NSLog(@"reportKalender	Kalenderblocker");
		return;
	}
	Kalenderblocker=1;
	NSLog(@"reportKalender	sender: %@",[sender dateValue]);
	NSString* HeuteDatumString = [[[[NSDate date]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSString* KalenderDatumString = [[[[sender dateValue]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSLog(@"sender: heute: %@ Kalender: %@",HeuteDatumString, KalenderDatumString);

	if ([HeuteDatumString isEqualToString:KalenderDatumString])
	{
		NSLog(@"reportKalender Datum=heute");
		if (Heuteblocker)
		{
		Heuteblocker=0;
		[self reportUpdate:NULL];
		}
		return;
	}
	Heuteblocker=1;
	//NSLog(@"\n***   reportKalender: Datum: %@",[sender dateValue]);
	NSString* PickDate=[[Kalender dateValue]description];
	//NSLog(@"PickDate: %@",PickDate);
	//NSDate* KalenderDatum=[Kalender dateValue];
	//NSDate* KalenderDatum=[sender dateValue];
	//NSLog(@"Kalenderdatum: %@",KalenderDatum);
	//NSLog(@"reportKalender Suffix: %@",[self DatumSuffixVonDate:[Kalender dateValue]]);
	NSArray* DatumStringArray=[PickDate componentsSeparatedByString:@" "];
	NSLog(@"DatumStringArray: %@",[DatumStringArray description]);
	
	NSArray* DatumArray=[[DatumStringArray objectAtIndex:0] componentsSeparatedByString:@"-"];
	NSString* SuffixString=[NSString stringWithFormat:@"/HomeDaten/HomeDaten%@%@%@.txt",[[DatumArray objectAtIndex:0]substringFromIndex:2],[DatumArray objectAtIndex:1],[DatumArray objectAtIndex:2]];
	//NSLog(@"DatumArray: %@",[DatumArray description]);
	//NSLog(@"reportKalender SuffixString: %@",SuffixString);
	//NSLog(@"tag: %d jahr: %d",tag,jahr);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:SuffixString forKey:@"suffixstring"];
	//[NotificationDic setObject:[[Kalender dateValue]description] forKey:@"datum"];
	[NotificationDic setObject:[[sender dateValue]description] forKey:@"datum"];
	
	//[SuchDatumFeld setStringValue:[[sender dateValue]description]];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSLog(@"reportKalender NotificationDic: %@",[NotificationDic description]);
	
	[nc postNotificationName:@"HomeDataKalender" object:self userInfo:NotificationDic];
	
}



- (void)reportSolarKalender:(id)sender
{	
	if (SolarKalenderblocker)
	{
		NSLog(@"reportSolarKalender	Kalenderblocker");
		return;
	}
	SolarKalenderblocker=1;
	NSLog(@"\n***");
	NSLog(@"reportSolarKalender	sender: %@",[sender dateValue]);
	NSString* HeuteDatumString = [[[[NSDate date]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSString* KalenderDatumString = [[[[sender dateValue]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSLog(@"sender: %@ heute: %@",HeuteDatumString, KalenderDatumString);

	if ([HeuteDatumString isEqualToString:KalenderDatumString])
	{
		if (SolarHeuteblocker)
		{
		SolarHeuteblocker=0;
		[self reportSolarUpdate:NULL];
		}
		return;
	}
	SolarHeuteblocker=1;
	//NSLog(@"\n***   reportKalender: Datum: %@",[sender dateValue]);
	NSString* PickDate=[[SolarKalender dateValue]description];
	//NSLog(@"PickDate: %@",PickDate);
	//NSDate* KalenderDatum=[Kalender dateValue];
	//NSDate* KalenderDatum=[sender dateValue];
	//NSLog(@"Kalenderdatum: %@",KalenderDatum);
	//NSLog(@"reportKalender Suffix: %@",[self DatumSuffixVonDate:[Kalender dateValue]]);
	NSArray* DatumStringArray=[PickDate componentsSeparatedByString:@" "];
	//NSLog(@"DatumStringArray: %@",[DatumStringArray description]);
	
	NSArray* DatumArray=[[DatumStringArray objectAtIndex:0] componentsSeparatedByString:@"-"];
	NSString* SuffixString=[NSString stringWithFormat:@"/SolarDaten/SolarDaten%@%@%@.txt",[[DatumArray objectAtIndex:0]substringFromIndex:2],[DatumArray objectAtIndex:1],[DatumArray objectAtIndex:2]];
	//NSLog(@"DatumArray: %@",[DatumArray description]);
	//NSLog(@"reportSolarKalender SuffixString: %@",SuffixString);
	//NSLog(@"tag: %d jahr: %d",tag,jahr);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:SuffixString forKey:@"suffixstring"];
	//[NotificationDic setObject:[[Kalender dateValue]description] forKey:@"datum"];
	[NotificationDic setObject:[[sender dateValue]description] forKey:@"datum"];
	
	//[SuchDatumFeld setStringValue:[[sender dateValue]description]];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//NSLog(@"reportSolarKalender NotificationDic: %@",[NotificationDic description]);
	
	[nc postNotificationName:@"SolarDataKalender" object:self userInfo:NotificationDic];
	
}

- (NSString*)DatumSuffixVonDate:(NSDate*)dasDatum
{
	NSArray* DatumStringArray=[[dasDatum description]componentsSeparatedByString:@" "];
	//NSLog(@"DatumStringArray: %@",[DatumStringArray description]);
	NSArray* DatumArray=[[DatumStringArray objectAtIndex:0] componentsSeparatedByString:@"-"];
	NSString* SuffixString=[NSString stringWithFormat:@"%@%@%@",[[DatumArray objectAtIndex:0]substringFromIndex:2],[DatumArray objectAtIndex:1],[DatumArray objectAtIndex:2]];
	NSLog(@"DatumArray: %@",[DatumArray description]);
	NSLog(@"SuffixString: %@",SuffixString);
	return SuffixString;
}

- (void)setKalenderBlocker:(int)derStatus;
{
	Kalenderblocker=derStatus;
}



- (int)StatistikJahr
{
	int jahr=[[StatistikJahrPop selectedItem]tag];
	return jahr;
}
- (int)StatistikMonat
{
	int monat=[[StatistikMonatPop selectedItem]tag];
	return monat;

}

- (NSDictionary*)SolarStatistikDatum
{
	NSMutableDictionary* tempDatumDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	return tempDatumDic;

}

- (void)reportSolarStatistikKalender:(id)sender
{	
	NSLog(@"\n***");
	NSLog(@"reportSolarStatistikKalender	sender: %@",[sender dateValue]);
	NSString* HeuteDatumString = [[[[NSDate date]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSString* KalenderDatumString = [[[[sender dateValue]description]componentsSeparatedByString:@" "]objectAtIndex:0];
	NSLog(@"sender: %@ heute: %@",HeuteDatumString, KalenderDatumString);

	if ([HeuteDatumString isEqualToString:KalenderDatumString])
	{
		if (SolarHeuteblocker)
		{
		SolarHeuteblocker=0;
		[self reportSolarUpdate:NULL];
		}
		return;
	}
		
	NSArray* DatumArray=[KalenderDatumString componentsSeparatedByString:@"-"];
	//NSString* SuffixString=[NSString stringWithFormat:@"/SolarDaten/SolarDaten%@%@%@.txt",[[DatumArray objectAtIndex:0]substringFromIndex:2],[DatumArray objectAtIndex:1],[DatumArray objectAtIndex:2]];
	NSLog(@"DatumArray: %@",[DatumArray description]);
	//NSLog(@"reportSolarKalender SuffixString: %@",SuffixString);
	//NSLog(@"tag: %d jahr: %d",tag,jahr);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:HeuteDatumString forKey:@"heute"];
	[NotificationDic setObject:KalenderDatumString forKey:@"kalenderdatum"];
	[NotificationDic setObject:[DatumArray objectAtIndex:0] forKey:@"kalenderjahr"];
	[NotificationDic setObject:[DatumArray objectAtIndex:1] forKey:@"kalendermonat"];
	[NotificationDic setObject:[DatumArray objectAtIndex:2] forKey:@"kalendertag"];
	//[SuchDatumFeld setStringValue:[[sender dateValue]description]];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSLog(@"reportSolarStatistikKalender NotificationDic: %@",[NotificationDic description]);
	
	[nc postNotificationName:@"SolarStatistikKalender" object:self userInfo:NotificationDic];
	
}

- (NSTextView*)DruckDatenView
{
	//NSLog(@"Data DruckDatenView");
	NSCalendarDate* SaveDatum=[NSCalendarDate date];
	int jahr=[SaveDatum yearOfCommonEra];
	NSRange jahrRange=NSMakeRange(2,2);
	NSString* jahrString=[[[NSNumber numberWithInt:jahr]stringValue]substringWithRange:jahrRange];
	int monat=[SaveDatum monthOfYear];
	NSString* monatString;
	if (monat<10)
	{
		monatString=[NSString stringWithFormat:@"0%d",monat];;
	}
	else
	{
		monatString=[NSString stringWithFormat:@"%d",monat];;
	}
	int tag=[SaveDatum dayOfMonth];
	
	NSString* tagString;
	if (tag<10)
	{
		tagString=[NSString stringWithFormat:@"0%d",tag];
	}
	else
	{
		tagString=[NSString stringWithFormat:@"%d",tag];
	}
	
	int stunde=[SaveDatum hourOfDay];
	NSString* stundeString;
	if (stunde<10)
	{
		stundeString=[NSString stringWithFormat:@"0%d",stunde];
	}
	else
	{
		stundeString=[NSString stringWithFormat:@"%d",stunde];
	}
	
	
	int minute=[SaveDatum minuteOfHour];
	NSString* minuteString;
	if (minute<10)
	{
		minuteString=[NSString stringWithFormat:@"0%d",minute];
	}
	else
	{
		minuteString=[NSString stringWithFormat:@"%d",minute];
	}
	
	NSString* TitelString=@"HomeCentral\rFalkenstrasse 20\r8630 Rueti\rDatum: ";
	NSString* DatumString=[NSString stringWithFormat:@"%@.%@.%@  %@:%@",tagString,monatString,jahrString,stundeString,minuteString];
	NSArray* tempZeilenArray=[[TemperaturDatenFeld string]componentsSeparatedByString:@"\r"];
	NSMutableArray* tempNeuerZeilenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	//NSLog(@"tempZeilenArray vor: %@",[tempZeilenArray description]);
	if ([tempZeilenArray count]>1)
	{
		NSEnumerator* tabEnum=[tempZeilenArray objectEnumerator];
		id eineZeile;
		while (eineZeile=[tabEnum nextObject])
		{
			//NSLog(@"eineZeile vor: %@",eineZeile);
			if ([eineZeile length]>1)
			{
				[tempNeuerZeilenArray addObject:[eineZeile substringFromIndex:1]];
			}
			//eineZeile=[eineZeile substringFromIndex:1];
			//NSLog(@"eineZeile nach: %@",eineZeile);
		}//while
		//NSLog(@"tempNeuerZeilenArray nach: %@",[tempNeuerZeilenArray description]);
		
		
		//[DatenserieStartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
		NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@ %@\r\rStartzeit: %@\r%@",TitelString,DatumString,DatenserieStartZeit,[tempNeuerZeilenArray componentsJoinedByString:@"\r"]];
		//NSLog(@"TemperaturDatenString: %@",TemperaturDatenString);
		[DruckDatenView setString:TemperaturDatenString];
	}//if count
	//NSLog(@"Data DruckDatenView end");
	return DruckDatenView;
}

- (int)Datenquelle
{
	return Quelle;
}

- (NSCalendarDate*)DatenserieStartZeit
{
	return DatenserieStartZeit;
}

- (void)ErrStringAktion:(NSNotification*)note
{
if ([[note userInfo]objectForKey:@"err"])
{
	NSString* tempErrString=[[note userInfo]objectForKey:@"err"];
	NSCalendarDate* errZeit=[NSCalendarDate calendarDate];
	[errZeit setCalendarFormat:@"%H:%M"];

	errString =[[NSString stringWithFormat:@"%@\n%@: %@",errString,errZeit,tempErrString]retain];
	
}
}

- (BOOL)saveErrString
{
	
	//NSLog(@"saveErrString");
	//NSLog(@"saveErrString errPfad: %@",errPfad);
	if (errString)
	{
		//NSLog(@"saveErrString da");
		//NSLog(@"saveErrString errString: %@" ,errString);
		
		BOOL errWriteOK=[errString writeToFile:errPfad atomically:YES];
		
		//NSLog(@"saveErrString errWriteOK: %d",errWriteOK);
		[errString release];
		return errWriteOK;
	}
	else
	{
		//NSLog(@"saveErrString kein errString");
	}
	return 0;
}

- (IBAction)reportClearData:(id)sender
{
	NSLog(@"reportClearData");
	[TemperaturDatenFeld setString:[NSString string]];
	
}

- (void)clearData
{
	NSLog(@"clearData");
	[TemperaturDatenFeld setString:[NSString string]];
	AnzDaten=0;
	ErrZuLang=0;
	ErrZuKurz=0;
	DatenserieStartZeit=[NSCalendarDate calendarDate];
	[DatenserieStartZeit retain];
	//NSDictionary* DatumDic=[NSDictionary dictionaryWithObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"datastart"forKey:@"data"];
	[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	
	NSCalendarDate* AnzeigeDatum= [DatenserieStartZeit copy];
	[AnzeigeDatum setCalendarFormat:@"%d.%m.%y %H:%M"];
	[StartzeitFeld setStringValue:[AnzeigeDatum description]];
	[BrenndauerFeld setStringValue:@"0:00:00"];
	[AnzahlDatenFeld setStringValue:@""];
	//[StartzeitFeld setStringValue:@""];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	
	//par=0;
	
	if (DatenpaketArray && [DatenpaketArray count])
	{
		[DatenpaketArray removeAllObjects];
	}
	float Feldbreite=[[TemperaturDiagrammScroller contentView]frame].size.width;
	float x = [[TemperaturDiagrammScroller contentView]frame].origin.x;
	[TemperaturMKDiagramm clean];
	NSRect TemperaturDiagrammRect=[TemperaturMKDiagramm frame];
	TemperaturDiagrammRect.size.width = Feldbreite;
	TemperaturDiagrammRect.origin.x=x;
	[TemperaturMKDiagramm setFrame:TemperaturDiagrammRect];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor redColor] forKanal:0];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor blueColor] forKanal:1];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor blackColor] forKanal:2];
	[TemperaturMKDiagramm setGraphFarbe:[NSColor grayColor] forKanal:3];
	[TemperaturMKDiagramm setStartZeit:DatenserieStartZeit];
	
	[BrennerDiagramm clean];
	NSRect BrennerDiagrammRect=[BrennerDiagramm frame];
	BrennerDiagrammRect.size.width = Feldbreite;
	BrennerDiagrammRect.origin.x=x;
	[BrennerDiagramm setFrame:BrennerDiagrammRect];
	[BrennerDiagramm setStartZeit:DatenserieStartZeit];
	
	[Gitterlinien clean];
	NSRect GitterlinienRect=[Gitterlinien frame];
	GitterlinienRect.size.width = Feldbreite;
	GitterlinienRect.origin.x=x;
	[Gitterlinien setFrame:GitterlinienRect];
	[Gitterlinien setStartZeit:DatenserieStartZeit];
	
	NSRect DocRect=	[[TemperaturDiagrammScroller documentView]frame];
	DocRect.size.width=Feldbreite;
	
	
	[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	
	[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
	
	NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
	
	[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
	[TemperaturDiagrammScroller setNeedsDisplay:YES];
	
}




- (NSString*)DruckDatenString
{
	NSCalendarDate* SaveDatum=[NSCalendarDate date];
	int jahr=[SaveDatum yearOfCommonEra];
	NSRange jahrRange=NSMakeRange(2,2);
	NSString* jahrString=[[[NSNumber numberWithInt:jahr]stringValue]substringWithRange:jahrRange];
	int monat=[SaveDatum monthOfYear];
	NSString* monatString=[[NSNumber numberWithInt:monat]stringValue];
	int tag=[SaveDatum dayOfMonth];
	NSString* tagString=[[NSNumber numberWithInt:tag]stringValue];
	int stunde=[SaveDatum hourOfDay];
	NSString* stundeString=[[NSNumber numberWithInt:stunde]stringValue];
	int minute=[SaveDatum minuteOfHour];
	NSString* minuteString=[[NSNumber numberWithInt:minute]stringValue];
	NSString* TitelString=@"HomeCentral\rFalkenstrasse 20\r8630 Rueti\rDaten vom: ";
	NSString* DatumString=[NSString stringWithFormat:@"%@.%@.%@  %@:%@",tagString,monatString,jahrString,stundeString,minuteString];
	
	NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@ %@\r\r%@",TitelString,DatumString,[TemperaturDatenFeld string]];
	return TemperaturDatenString;
	
}

- (void)BrenndauerAktion:(NSNotification*)note
{
	//NSLog(@"BrenndauerAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"brenndauerstring"])
	{
		[BrenndauerFeld setStringValue: [[note userInfo]objectForKey:@"brenndauerstring"]];
		
	}
	
}

- (void)setBrennerStatistik:(NSDictionary*)derDatenDic
{
	/*
	 derDatenDic enthaelt Arrays der Brennerstatistik und der Temperaturstatistik
	 Jedes Objekt der Arrays enthaelt das Datum und den TagDesJahres
	 */
	
	
	//NSLog(@"[StatistikDiagrammScroller documentView]: w: %2.2f",[[StatistikDiagrammScroller documentView]frame].size.width);
	
	
	//NSLog(@"Data setBrennerStatstik: %@",[derDatenDic description]);
	NSArray* TemperaturdatenArray =[NSArray array];
	NSArray* BrennerdatenArray =[NSArray array];
//	NSArray* TemperaturKanalArray =[NSArray array];
//	NSArray* BrennerKanalArray =[NSArray array];
	if ([derDatenDic objectForKey:@"temperaturkanalarray"])
	{
//		TemperaturKanalArray=[derDatenDic objectForKey:@"temperaturkanalarray"];
	}
	else
	{
//		TemperaturKanalArray=[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
	}
	
	
	if ([derDatenDic objectForKey:@"temperaturdatenarray"])
	{
		//NSLog(@"Data setBrennerStatstik: BrennerdatenArray %@",[[derDatenDic objectForKey:@"temperaturdatenarray"] description]);
		NSSortDescriptor* tagDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"tagdesjahres"
																							ascending:YES] autorelease];
		NSArray* sortDescriptors = [NSArray arrayWithObject:tagDescriptor];
		TemperaturdatenArray = [[derDatenDic objectForKey:@"temperaturdatenarray"] sortedArrayUsingDescriptors:sortDescriptors];
		
	}
	//NSLog(@"Data setBrennerStatstik: A");
	if ([derDatenDic objectForKey:@"brennerkanalarray"])
	{
//		BrennerKanalArray=[derDatenDic objectForKey:@"brennerkanalarray"];
//		NSLog(@"Data setBrennerStatstik: BrennerKanalArray %@",[[derDatenDic objectForKey:@"brennerkanalarray"] description]);
	}
	else
	{
//		BrennerKanalArray=[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
	}
	
	//NSLog(@"Data setBrennerStatstik: B");
	
	if ([derDatenDic objectForKey:@"brennerdatenarray"])
	{
		//NSLog(@"Data setBrennerStatstik: BrennerdatenArray %@",[[derDatenDic objectForKey:@"brennerdatenarray"] description]);
		NSSortDescriptor* tagDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"tagdesjahres"
																							ascending:YES] autorelease];
		NSArray* sortDescriptors = [NSArray arrayWithObject:tagDescriptor];
		BrennerdatenArray = [[derDatenDic objectForKey:@"brennerdatenarray"] sortedArrayUsingDescriptors:sortDescriptors];
		BrennerdatenArray = [[derDatenDic objectForKey:@"brennerdatenarray"] sortedArrayUsingDescriptors:sortDescriptors];

		
		
		//BrennerdatenArray=[derDatenDic objectForKey:@"brennerdatenarray"]:
		//NSLog(@"Data setBrennerStatstik: BrennerdatenArray sortiert%@",[BrennerdatenArray description]);
	}
	//NSLog(@"Data setBrennerStatstik: C");
	// Temperatur- und Brennerdaten des gleichen Tages zusammenfuehren
	//NSLog(@"setBrennerStatstik 2");
	NSArray* BrennertagArray=[BrennerdatenArray valueForKey:@"tagdesjahres"];
	NSArray* TemperaturtagArray=[TemperaturdatenArray valueForKey:@"tagdesjahres"];
	
	
	NSMutableArray* StatistikArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int index=0;
	
	for (index=0;index<366;index++)
	{
		
		int anz=0;
		NSNumber* indexNumber = [NSNumber numberWithInt:index];
		NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		int TempIndex=[TemperaturtagArray indexOfObject:indexNumber];
		if (TempIndex < NSNotFound) // Es gibt einen Eintrag
		{
			anz++;
			[tempDic addEntriesFromDictionary:[TemperaturdatenArray objectAtIndex:TempIndex]];
		}
		
		int BrennerIndex=[BrennertagArray indexOfObject:indexNumber];
		if (BrennerIndex < NSNotFound) // Es gibt einen Eintrag
		{
			anz++;
			[tempDic addEntriesFromDictionary:[BrennerdatenArray objectAtIndex:BrennerIndex]];
		}
		
		
		//		NSLog(@"index: %d tagindex: %d anz: %d tempDic: %@",index, tagindex, anz, [tempDic description]);
		
		if (anz)
		{
			[StatistikArray addObject:tempDic];
		}
	}
	//NSLog(@"Data setBrennerStatstik: D");
	//NSLog(@"Data setBrennerStatstik: StatistikArray: %@",[StatistikArray description]);
	int i=0;
	[TemperaturStatistikDiagramm setOffsetX:[[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]intValue]]; // Startwert der Abszisse setzen
	[TagGitterlinien setOffsetX:[[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]intValue]];
	[BrennerStatistikDiagramm setOffsetX:[[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]intValue]]; // Startwert der Abszisse setzen
	int tagdesjahresMin=[[[StatistikArray objectAtIndex:0]objectForKey:@"tagdesjahres"]intValue];
	int tagdesjahresMax=[[[StatistikArray objectAtIndex:[StatistikArray count]-1]objectForKey:@"tagdesjahres"]intValue];
	//NSLog(@"tagdesjahresMin: %d tagdesjahresMax: %d ",tagdesjahresMin,tagdesjahresMax);
	
	// Breite des Diagramms anpassen
	float AnzeigeBreite=[StatistikDiagrammScroller  frame].size.width;
	//NSLog(@"AnzeigeBreite: %2.2f",AnzeigeBreite);
	NSPoint tempOrigin=[[StatistikDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[[StatistikDiagrammScroller documentView] frame];
	//NSLog(@"	tempFrame w vor: %2.2f",tempFrame.size.width);
	float maxZeit=(tagdesjahresMax-tagdesjahresMin) * 10;//ZeitKompression;
		//		tempZeit=[[HomeDatenArray objectAtIndex:0]intValue]- firstZeit;
	float newWidth=maxZeit+20;
	tempFrame.size.width=newWidth;
	//NSLog(@"	tempFrame w nach: %2.2f",tempFrame.size.width);
	[[StatistikDiagrammScroller documentView]setFrame:tempFrame];
	
	NSRect tempBrennerFrame=[BrennerStatistikDiagramm frame];
	tempBrennerFrame.size.width=newWidth;
	[BrennerStatistikDiagramm setFrame:tempBrennerFrame];
	
	NSRect tempTemperaturFrame=[TemperaturStatistikDiagramm frame];
	tempTemperaturFrame.size.width=newWidth;
	[TemperaturStatistikDiagramm setFrame:tempTemperaturFrame];
	
	NSRect tempTagGitterFrame=[TagGitterlinien frame];
	tempTagGitterFrame.size.width=newWidth;
	[TagGitterlinien setFrame:tempTagGitterFrame];
	AnzeigeBreite+=100.0;
	float delta=maxZeit-AnzeigeBreite;
	//NSLog(@"delta: %2.2f",delta);
	tempOrigin.x -=delta;
	[[StatistikDiagrammScroller documentView] setFrameOrigin:tempOrigin];
	//NSLog(@"Data setBrennerStatstik: E");
	//NSLog(@"Data setBrennerStatstik: [StatistikArray count]: %d",[StatistikArray count]);
	for (i=0;i<[StatistikArray count];i++)
	{
		NSMutableArray* tempWerteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		// Abszisse: tag des Jahres
		[tempWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]];
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"mittel"])
		{
			[tempWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"mittel"]];
		}
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"tagmittel"])
		{
			[tempWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"tagmittel"]];
		}
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"nachtmittel"])
		{
			[tempWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"nachtmittel"]];
		}
		
		//		if ([[StatistikArray objectAtIndex:i]objectForKey:@"calenderdatum"])
		{
			//			[tempWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"calenderdatum"]];
		}
		//NSLog(@"setBrennerStatstik i: %d",i);
		[TemperaturStatistikDiagramm setWerteArray:tempWerteArray mitKanalArray:BrennerStatistikTemperaturKanalArray];
		
		
		
		// Brennerstatistikdaten
		
		NSMutableArray* tempBrennerWerteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		// Abszisse: tag des Jahres
		[tempBrennerWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]];
		
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"einschaltdauer"])
		{
			[tempBrennerWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"einschaltdauer"]];
		}
		
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"laufzeit"])
		{
			[tempBrennerWerteArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"laufzeit"]];
		}
		/*
		// Breite des Diagramms anpassen
		NSPoint tempOrigin=[[StatistikDiagrammScroller documentView] frame].origin;
		NSRect tempFrame=[[StatistikDiagrammScroller documentView] frame];
		
		int tempZeit=0;
		//		tempZeit=[[HomeDatenArray objectAtIndex:0]intValue]- firstZeit;
		
		*/
		//NSLog(@"setBrennerStatstik i: %d tempBrennerWerteArray: %@",i,[tempBrennerWerteArray description]);
		//NSLog(@"setBrennerStatstik i: %d BrennerKanalArray: %@",i,[BrennerStatistikKanalArray description]);
		
		[BrennerStatistikDiagramm setWerteArray:tempBrennerWerteArray mitKanalArray:BrennerStatistikKanalArray];
		
		// Taglinien
		
		NSMutableArray* tempDatumArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		// Abszisse: tag des Jahres
		[tempDatumArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"tagdesjahres"]];
		
		if ([[StatistikArray objectAtIndex:i]objectForKey:@"calenderdatum"])
		{
			[tempDatumArray addObject:[[StatistikArray objectAtIndex:i]objectForKey:@"calenderdatum"]];
		}
		//NSLog(@"Data setBrennerStatstik: i: %d tempDatumArray: %@",i,[tempDatumArray description]);
		[TagGitterlinien setWerteArray:tempDatumArray mitKanalArray:BrennerStatistikTemperaturKanalArray];
		//[TagGitterlinien  setNeedsDisplay:YES];
	}
//NSLog(@"Data setBrennerStatstik: F");
}


- (IBAction)reportStatistikJahr:(id)sender
{
	//NSLog(@"reportStatistikJahr: %d",[[sender selectedItem]tag]);
	[TemperaturStatistikDiagramm clean];
	[TagGitterlinien clean];
	NSMutableDictionary* tempDatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempDatenDic setObject:[NSNumber numberWithInt:1]forKey:@"aktion"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:tempDatenDic];
		[TagGitterlinien setNeedsDisplay:YES];

	
}
- (IBAction)reportStatistikMonat:(id)sender
{
//NSLog(@"reportStatistikMonat: %d",[[sender selectedItem]tag]);


}


- (NSString*)stringAusZeit:(NSTimeInterval) dieZeit
{
	int ZeitInt=(int)dieZeit;
	int Zeitsekunden = ZeitInt % 60;
	ZeitInt/=60;
	int Zeitminuten = ZeitInt%60;
	int Zeitstunden = ZeitInt/60;
	//NSLog(@"Zeitdauer: %2.2f %d Zeiterzeit: %2d:%2d:%2d",dieZeit, Zeitstunden,Zeitminuten,Zeitsekunden);
	NSString* SekundenString;
	if (Zeitsekunden<10)
	{
		
		SekundenString=[NSString stringWithFormat:@"0%d",Zeitsekunden];
	}
	else
	{
		SekundenString=[NSString stringWithFormat:@"%d",Zeitsekunden];
	}
	
	NSString* MinutenString;
	if (Zeitminuten<10)
	{
		
		MinutenString=[NSString stringWithFormat:@"0%d",Zeitminuten];
	}
	else
	{
		MinutenString=[NSString stringWithFormat:@"%d",Zeitminuten];
	}
	
	NSString* StundenString;
	if (Zeitstunden<10)
	{
		
		StundenString=[NSString stringWithFormat:@" %d",Zeitstunden];
	}
	else
	{
		StundenString=[NSString stringWithFormat:@"%d",Zeitstunden];
	}
	
	
	NSString* ZeitdauerString=[NSString stringWithFormat:@"%@:%@:%@",StundenString,MinutenString,SekundenString];
	//NSLog(@"Zeitdauer: %d ZeitdauerString:%@",(int)dieZeit, ZeitdauerString);
	return ZeitdauerString;
}






- (void)loadURL:(NSURL *)URL
{
	NSLog(@"Data loadURL URL: %@",URL );
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)setURLToLoad:(NSURL *)URL
{
    [URL retain];
    [URLToLoad release];
    URLToLoad = URL;
}


- (IBAction)reload:(id)sender 
{
    [webView reload:self];
 }



- (void)SimReadAktion:(NSTimer*) derTimer;
{
	//
	//NSLog(@"SimReadAktion ");
	if (SimRun)
	{
		if (DatenpaketArray==NULL)// Sammelarray fuer Daten eines Pakets
		{
			DatenpaketArray=[[NSMutableArray alloc]initWithCapacity:0];
			
		}
		else
		{
			if ([DatenpaketArray count])
			{
				[DatenpaketArray removeAllObjects]; 
			}
		}
		
		/*		
		 int t=[[NSCalendarDate calendarDate] timeIntervalSinceReferenceDate];
		 
		 int t=10*[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit];// *ZeitKompression;
		 //NSLog(@"t0: %X ",t);
		 t/=60;
		 t &= 0xFFFF;
		 int lb=t;
		 lb <<=8;
		 lb &= 0xFF00;
		 lb >>=8;
		 int hb = t;
		 hb >>= 8;
		 //NSLog(@"hb: %X lb: %X",hb,lb);
		 int e=hb;
		 //NSLog(@"e: %X",e);
		 e <<=8;
		 //NSLog(@"e: %X",e);
		 e |=lb;
		 //NSLog(@"t: %X hb: %X lb: %X e: %X",t,hb,lb,e);
		 */
		//	int tempSimZeit=10*[[NSCalendarDate calendarDate] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
		int tempSimZeit=10*[[NSCalendarDate calendarDate] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
		
		[DatenpaketArray addObject:[NSNumber numberWithInt:tempSimZeit]]; // Zeitstempel
		tempSimZeit*=ZeitKompression;
		srandom(time(NULL));
		float y=(float)random() / RAND_MAX * (100);
		int yy=(int)y;
		//NSLog(@"y: %2.2f yy: %d",y,yy);
		float u=10.0*sin(((int)tempSimZeit)%900/10) +50.0;
		[DatenpaketArray addObject:[NSNumber numberWithInt:10]];
		[DatenpaketArray addObject:[NSNumber numberWithFloat:y]];
		[DatenpaketArray addObject:[NSNumber numberWithFloat:u]];
		[DatenpaketArray addObject:[NSNumber numberWithFloat:10-u]];
		if ((int)tempSimZeit%100 >50)
		{
			[DatenpaketArray addObject:[NSNumber numberWithInt:0]];
		}
		else
		{
			[DatenpaketArray addObject:[NSNumber numberWithInt:1]];
		}
		[DatenpaketArray addObject:[NSNumber numberWithInt:0]];
		[DatenpaketArray addObject:[NSNumber numberWithInt:0]];
		NSArray* TemperaturKanalArray= [NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"1",@"0",@"0",@"0",nil];
		NSArray* BrennerKanalArray=[NSArray arrayWithObjects:@"0",@"0",@"0",@"1" ,@"0",@"0",@"0",@"0",nil];
		NSLog(@"SimReadAktion DatenpaketArray: %@",[DatenpaketArray description]);
		//
		AnzDaten++;
		[AnzahlDatenFeld setIntValue:AnzDaten];
		[TemperaturMKDiagramm setWerteArray:DatenpaketArray mitKanalArray:TemperaturKanalArray];
		[TemperaturMKDiagramm setNeedsDisplay:YES];
		[BrennerDiagramm setWerteArray:DatenpaketArray mitKanalArray:BrennerKanalArray];
		[BrennerDiagramm setNeedsDisplay:YES];
		[Gitterlinien setWerteArray:DatenpaketArray mitKanalArray:BrennerKanalArray];
		[Gitterlinien setNeedsDisplay:YES];
		
		NSString* TemperaturDatenString=[NSString stringWithFormat:@"%@\r\t %d\t%d\t%d",[TemperaturDatenFeld string],AnzDaten,tempSimZeit,yy];
		[TemperaturDatenFeld setString:TemperaturDatenString];
		
		if (AnzDaten %7 == 0)
		{
			simDaySaved=0;
			NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[NotificationDic setObject:@"savepart"forKey:@"data"];
			[NotificationDic setObject:SimDatenserieStartZeit forKey:@"datenseriestartzeit"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
			//NSLog(@"savePart: Tag: %d",[SimDatenserieStartZeit dayOfMonth]);
		}
		
		if ((AnzDaten %23 == 0)&& (simDaySaved==0))
		{
			[DatenserieStartZeit dateByAddingTimeInterval:84600];
			NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[NotificationDic setObject:@"saveganz"forKey:@"data"];
			//[NotificationDic setObject:@"savepart"forKey:@"data"];
			[NotificationDic setObject:SimDatenserieStartZeit forKey:@"datenseriestartzeit"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
			//[DatenserieStartZeit addTimeInterval:84600];
			NSLog(@"saveGanz: Tag: %d",[SimDatenserieStartZeit dayOfMonth]);
			
			simDaySaved=YES;
		}
		
		//NSLog(@"ReadAktion note: %@",[[note userInfo]description]);
		NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
		//NSRect tempFrame=[TemperaturDiagrammScroller frame];
		NSRect tempFrame=[[TemperaturDiagrammScroller documentView] frame];
		
		float rest=tempFrame.size.width-(tempSimZeit);//*ZeitKompression);
		//NSLog(@"rest: %2.2f",rest);
		if (rest<100)
		{
			//		NSLog(@"rest zu klein: %2.2f",rest);
			//		NSLog(@"tempOrigin alt  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			//		NSLog(@"tempFrame: alt x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			float delta=[[TemperaturDiagrammScroller contentView]frame].size.width-150;
			NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
			tempFrame.size.width+=delta;
			
			tempOrigin.x-=delta;
			scrollPoint.x += delta;
			
			//		NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
			//		NSLog(@"tempFrame: neu x %2.2f y %2.2f heigt %2.2f width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
			NSRect MKDiagrammRect=[TemperaturMKDiagramm frame];
			MKDiagrammRect.size.width=tempFrame.size.width;
			[TemperaturMKDiagramm setFrame:MKDiagrammRect];
			
			NSRect BrennerRect=[BrennerDiagramm frame];
			BrennerRect.size.width=tempFrame.size.width;
			[BrennerDiagramm setFrame:BrennerRect];
			
			NSRect GitterlinienRect=[Gitterlinien frame];
			GitterlinienRect.size.width=tempFrame.size.width;
			[Gitterlinien setFrame:GitterlinienRect];
			
			NSRect DocRect=	[[TemperaturDiagrammScroller documentView]frame];
			DocRect.size.width=tempFrame.size.width;
			
			[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
			[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			
			
			[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
			[TemperaturDiagrammScroller setNeedsDisplay:YES];
			
			
		}
		
		//NSLog(@"SimReadAktion end");
		
		
		
	} // if SimRun
	
	
}


- (IBAction)reportSimStart:(id)sender 
{
	int Stunde,Minute;
	SimDatenserieStartZeit=[[NSCalendarDate calendarDate]retain];
	NSCalendarDate *StartZeit = [NSCalendarDate calendarDate];
	//dateWithString:@"Friday, 1 July 2001, 11:45"
	//calendarFormat:@"%A, %d %B %Y, %I:%M"];
	NSLog(@"reportSimStart: heute: %@",[StartZeit description]);
	Stunde =[StartZeit hourOfDay];
	Minute =[StartZeit minuteOfHour];
	//NSLog(@"h: %d min: %d",Stunde, Minute);
	[StartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
	[StartzeitFeld setStringValue:[StartZeit description]];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"datastart"forKey:@"data"];
	[NotificationDic setObject:[NSCalendarDate date]forKey:@"datenseriestartzeit"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	[StopTaste setEnabled:YES];
	[StartTaste setEnabled:NO];
	
	[DatenpaketArray removeAllObjects]; // Aufräumen fuer naechste Serie
	NSMutableDictionary* infoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]retain];
	
	NSDate *now = [[NSDate alloc] init];
	SimTimer =[[NSTimer alloc] initWithFireDate:now
									   interval:1.0
										 target:self 
									   selector:@selector(SimReadAktion:) 
									   userInfo:infoDic
										repeats:YES];
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:SimTimer forMode:NSDefaultRunLoopMode];
	
	//[SimTimer release];
	[now release];
	
	SimRun=1;			
	
	[ClearTaste setEnabled:NO];
}

- (IBAction)reportSimStop:(id)sender 
{
	NSLog(@"reportSimStop");
	SimRun=0;
	[ClearTaste setEnabled:YES];
	if ([SimTimer isValid])
	{
		[SimTimer invalidate];
		[SimTimer release];
	}
	
}

- (IBAction)reportSimClear:(id)sender
{
	
	[self clearData];
	
}


- (IBAction)reportStart:(id)sender
{
	/*
	 
	 NSCalendarDate *newDate = [[NSCalendarDate alloc]
	 initWithString:@"03.24.01 22:00 PST"
	 calendarFormat:@"%m.%d.%y %H:%M %Z"];
	 */
	NSLog(@"Data reportStart");
	NSCalendarDate* StartZeit=[NSCalendarDate calendarDate];
	[StartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
	errString=[NSString stringWithFormat:@"Logfile vom: %@\r",[StartZeit description]];
	[errString retain];
	[StartzeitFeld setStringValue:[StartZeit description]];
	[StartZeit setCalendarFormat:@"%d%m%y_%H%M"];
	
	// Pfad fuer Logfile einrichten
	BOOL FileOK=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/USBInterfaceDaten"]retain];
	FileOK= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	if (FileOK)
	{
		errPfad=[USBPfad stringByAppendingPathComponent:@"Logs"];
		if (![Filemanager fileExistsAtPath:[USBPfad stringByAppendingPathComponent:@"Logs"] isDirectory:&istOrdner]&&istOrdner)
		{
        FileOK =[Filemanager createDirectoryAtPath:USBPfad withIntermediateDirectories:NO attributes:NULL error:NULL];

			//FileOK=[Filemanager createDirectoryAtPath:[USBPfad stringByAppendingPathComponent:@"Logs"] attributes:NULL];
		
		}
	}
	if (FileOK)
	{
		errPfad=[NSString stringWithFormat:@"%@/errString_%@.txt",[USBPfad stringByAppendingPathComponent:@"Logs"],StartZeit];

		[errPfad retain];
		NSLog(@"reportStart errPfad: %@",errPfad);

	}
	
	[DatenserieStartZeit release];
	
	DatenserieStartZeit= [[NSCalendarDate calendarDate]retain];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"datastart"forKey:@"data"];
	[NotificationDic setObject:[NSCalendarDate calendarDate]forKey:@"datenseriestartzeit"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	[StopTaste setEnabled:YES];
	[StartTaste setEnabled:NO];
	[ClearTaste setEnabled:NO];
	Quelle=0;
}

- (IBAction)reportStop:(id)sender
{
	NSLog(@"Data reportStop");
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"datastop"forKey:@"data"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	[StartTaste setEnabled:YES];
	[StopTaste setEnabled:NO];
	[ClearTaste setEnabled:YES];
	
}

- (IBAction)reportClear:(id)sender
{
	NSLog(@"reportClear");
	
	[self clearData];
	NSCalendarDate* StartZeit=[NSCalendarDate calendarDate];
	[StartZeit setCalendarFormat:@"%d.%m.%y %H:%M"];
//	[StartzeitFeld setStringValue:[StartZeit description]];

	[StartzeitFeld setStringValue:@""];

	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:@"clear"forKey:@"data"];
	DatenserieStartZeit=[[NSCalendarDate calendarDate]retain];
	[NotificationDic setObject:DatenserieStartZeit forKey:@"datenseriestartzeit"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"data" object:NULL userInfo:NotificationDic];
	[StopTaste setEnabled:NO];
	[StartTaste setEnabled:YES];

}




- (IBAction)reportPrint:(id)sender
{
	NSLog(@"reportPrint");
	[[TemperaturDiagrammScroller documentView]print:NULL];
}

- (IBAction)reportHeute:(id)sender
{
	NSLog(@"Data reportHeute");


}

- (void)setZeitKompression
{
	//NSLog(@"setZeitKompression");
	ZeitKompression=[[ZeitKompressionTaste titleOfSelectedItem]floatValue];
	
	[TemperaturMKDiagramm setEinheitenDicY:[NSDictionary dictionaryWithObject:[ZeitKompressionTaste titleOfSelectedItem] forKey:@"zeitkompression"]];
	[TemperaturMKDiagramm setNeedsDisplay:YES];
	[BrennerDiagramm setEinheitenDicY:[NSDictionary dictionaryWithObject:[ZeitKompressionTaste titleOfSelectedItem] forKey:@"zeitkompression"]];
	[BrennerDiagramm setNeedsDisplay:YES];
	[Gitterlinien setEinheitenDicY:[NSDictionary dictionaryWithObject:[ZeitKompressionTaste titleOfSelectedItem] forKey:@"zeitkompression"]];
	[Gitterlinien setNeedsDisplay:YES];
	int tempIntervall=2;
	
	
	//NSLog(@"reportZeitKompression Zeitkompression tag raw: %d tag int: %d",[[ZeitKompressionTaste selectedItem]tag],[[ZeitKompressionTaste selectedItem]tag]);
	
	switch ([[ZeitKompressionTaste selectedItem]tag])
	{
		case 0: // 5
			break;
		case 1: // 2
			break;
		case 2: // 1.0
			break;
			
		case 3: // 0.75
		case 4: // 0.5
			tempIntervall=5;
			break;
			
		case 5: // 0.2
			tempIntervall=10;
			break;
		case 6: // 0.1
			tempIntervall=20;
			break;
		case 7: // 0.05
			tempIntervall=30;
			break;	
	} // switch tag
	
	//if ([[sender titleOfSelectedItem]floatValue] <1.0)
	{
		[Gitterlinien setEinheitenDicY:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:tempIntervall] forKey:@"intervall"]];
		
	}
	
	[[TemperaturDiagrammScroller contentView]setNeedsDisplay:YES];
	
}


- (IBAction)reportZeitKompression:(id)sender
{
	float stretch=[[sender titleOfSelectedItem]floatValue]/ZeitKompression;
	
	NSLog(@"reportZeitKompression: %2.2F stretch: %2.2f",[[sender titleOfSelectedItem]floatValue],stretch);
	
	ZeitKompression=[[sender titleOfSelectedItem]floatValue];
	//[TemperaturMKDiagramm setEinheitenDicY:[NSDictionary dictionaryWithObject:[sender titleOfSelectedItem] forKey:@"zeitkompression"]];
	[TemperaturMKDiagramm setZeitKompression:ZeitKompression];
	//[BrennerDiagramm setEinheitenDicY:[NSDictionary dictionaryWithObject:[sender titleOfSelectedItem] forKey:@"zeitkompression"]];
	[BrennerDiagramm setZeitKompression:ZeitKompression];
	//[Gitterlinien setEinheitenDicY:[NSDictionary dictionaryWithObject:[sender titleOfSelectedItem] forKey:@"zeitkompression"]];
	
	int tempIntervall=2;
	
	
	//NSLog(@"reportZeitKompression Zeitkompression tag raw: %d tag int: %d",[[sender selectedItem]tag],[[sender selectedItem]tag]);
	
	switch ([[sender selectedItem]tag])
	{
		case 0: // 5
			break;
		case 1: // 2
			break;
		case 2: // 1.0
			break;
			
		case 3: // 0.75
		case 4: // 0.5
			tempIntervall=5;
			break;
			
		case 5: // 0.2
			tempIntervall=10;
			break;
		case 6: // 0.1
			tempIntervall=20;
			break;
		case 7: // 0.05
			tempIntervall=30;
			break;	
		case 8: // 0.02
			tempIntervall=60;
			break;	
		case 9: // 0.01
			tempIntervall=120;
			break;	

	} // switch tag
	
	//if ([[sender titleOfSelectedItem]floatValue] <1.0)
	{
		[Gitterlinien setEinheitenDicY:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:tempIntervall] forKey:@"intervall"]];
		
	}
	
	NSArray* StringArray=[[TemperaturDatenFeld string]componentsSeparatedByString:@"\r"];
	NSMutableArray* AbszissenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	for (i=0;i<[StringArray count];i++)
	{
		if ([StringArray objectAtIndex:i])
		{
			NSArray* ZeilenArray=[[StringArray objectAtIndex:i]componentsSeparatedByString:@"\t"];
			if ([ZeilenArray count]>1)
			{
				[AbszissenArray addObject:[ZeilenArray objectAtIndex:1]]; // Object 0 ist 
			}
		}
	}
	//NSLog(@"Data AbszissenArray: %@",[AbszissenArray description]);
	[Gitterlinien setZeitKompression:ZeitKompression mitAbszissenArray:AbszissenArray];
	
	
	
	
	NSRect DocRect=	[[TemperaturDiagrammScroller documentView]frame];
	NSRect ContRect=[[TemperaturDiagrammScroller contentView]frame];
	if ((DocRect.size.width * stretch) > ContRect.size.width)
	{
	DocRect.size.width *= stretch;
	
	NSRect MKRect=[TemperaturMKDiagramm frame];
	MKRect.size.width = DocRect.size.width;
	[TemperaturMKDiagramm setFrame:MKRect];
	
	NSRect BrennerRect=[BrennerDiagramm frame];
	BrennerRect.size.width = DocRect.size.width;
	[BrennerDiagramm setFrame:BrennerRect];

	NSRect GitterRect=[Gitterlinien frame];
	GitterRect.size.width = DocRect.size.width;
	[Gitterlinien setFrame:GitterRect];

	
	
	
	[[TemperaturDiagrammScroller documentView] setFrame:DocRect];
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	
	[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
	
	NSPoint scrollPoint=[[TemperaturDiagrammScroller documentView]bounds].origin;
	
	[[TemperaturDiagrammScroller contentView] scrollPoint:scrollPoint];
	[TemperaturDiagrammScroller setNeedsDisplay:YES];
	
	
	[[TemperaturDiagrammScroller contentView]setNeedsDisplay:YES];
	}
	
}


- (void)setTemperaturwerteArray:(NSArray*) derTemperaturwerteArray
{
	NSLog(@"\n\n                    rData   setTemperaturwerteArray");
	//NSView* tempContentView=[MehrkanalDiagrammScroller contentView];
	
	NSPoint tempOrigin=[[TemperaturDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[TemperaturMKDiagramm frame];
	
	//	NSLog(@"tempFrame: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
	//	NSLog(@"tempOrigin x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
	
	//Array fuer Zeit und Daten einer Zeile
	NSMutableArray* tempKanalDatenArray=[[NSMutableArray alloc]initWithCapacity:9];
	NSMutableArray* tempKanalSelektionArray=[[NSMutableArray alloc]initWithCapacity:8];
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[TemperaturDatenFeld string]];//Vorhandene Daten im Wertfeld
	
	
	float tempZeit=0.0;
	
	float ZeitKompression=[[ZeitKompressionTaste titleOfSelectedItem]floatValue];
	NSMutableArray* tempDatenArray=(NSMutableArray*)[TemperaturDaten objectForKey:@"datenarray"];
	
	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler setEinkanalDaten tempDatenArray: %@",[tempDatenArray description]);
		tempZeit=[[NSCalendarDate calendarDate] timeIntervalSinceDate:DatenserieStartZeit];//*ZeitKompression;
		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler setEinkanalDaten                    leer  tempDatenArray: %@",[tempDatenArray description]);
		
		DatenserieStartZeit=[NSCalendarDate calendarDate];
		[DatenserieStartZeit retain];
		[TemperaturDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		NSMutableArray* tempStartWerteArray=[[NSMutableArray alloc]initWithCapacity:8];
		
		int i;
		for (i=0;i<8;i++)
		{
			float y=(float)random() / RAND_MAX * (255);
			//y=127.0;
			[tempStartWerteArray addObject:[NSNumber numberWithInt:(int)y]];
		}
		[TemperaturMKDiagramm setStartWerteArray:tempStartWerteArray];
	}
	
	//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
	NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];
	
	//	NSLog(@"reportReadRandom8  tempZeitString: %@",tempZeitString);
	//[tempZeilenString appendFormat:@"\t%@",tempZeitString];
	
	
	int i;
	for (i=0;i<8;i++)
	{
		float y=(float)random() / RAND_MAX * (255);
		[tempKanalDatenArray addObject:[NSNumber numberWithInt:(int)y]];
		
		//		NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
		NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];
		
		//NSLog(@"tempWertString: %@",tempWertString);
		//[tempZeilenString appendFormat:@"\t%@",tempWertString];
		
		//Array der Daten einer Zeile: Element i der Datenleseaktion
		
		if (i==0)
		{	
			float rest=tempFrame.size.width-tempZeit;
			if (rest<100)
			{
				//NSLog(@"rest zu klein",rest);
				if (rest<0)//Wert hat nicht Platz
				{
					tempFrame.size.width=tempZeit+100;
					tempOrigin.x=tempZeit-100;
				}
				else
				{
					tempFrame.size.width+=200;
					tempOrigin.x-=200;
				}
				//NSLog(@"tempFrame: neu origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				
				[TemperaturMKDiagramm setFrame:tempFrame];	
				[[TemperaturDiagrammScroller documentView] setFrameOrigin:tempOrigin];
				
				
			}
		}//i=0;
		
	}
	
	//NSLog(@"tempZeilenString: %@",tempZeilenString);
	{
		//[tempZeilenString appendFormat:@"\n"];//Zeilenende
	}
	NSArray* ZeilenArray=[tempZeilenString componentsSeparatedByString:@"\n"];
	//NSLog(@"ZeilenArray: %@",[ZeilenArray description]);
	
	NSString* neueZeile=[ZeilenArray objectAtIndex:[ZeilenArray count]-2];
	//	NSLog(@"neueZeile: %@",neueZeile);
	
	//	[TemperaturWertFeld setStringValue: neueZeile];
	
	
	//	[MehrkanalDatenFeld setString:tempZeilenString];
	
	
	//Array der Daten einer Zeile: erstes Element: Zeit der Datenleseaktion
	[tempKanalDatenArray insertObject:[NSNumber numberWithFloat:tempZeit] atIndex:0];
	//	NSArray*tempArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	[tempDatenArray addObject:tempKanalDatenArray];
	//NSLog(@"tempZeilenString vor: %@",tempZeilenString);
	
	//NSLog(@"Mehrkanal tempZeilenString nach: %@",tempZeilenString);
	
	
	//[MehrkanalDatenFeld setString:tempZeilenString];
	
	
	
	NSLog(@"ADWandler reportRead8RandomKanal       tempZeit: %2.2f  Werte: %@",tempZeit,[tempKanalDatenArray description]);
	
	[TemperaturMKDiagramm setWerteArray:tempKanalDatenArray mitKanalArray:tempKanalSelektionArray];
	
}

- (void)ReportHandlerCallbackAktion:(NSNotification*)note
{
	NSLog(@"EEDatenlesenAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"datenarray"]&&[[[note userInfo]objectForKey:@"datenarray"] count])
	{
		NSArray* Datenarray=[[note userInfo]objectForKey:@"datenarray"];//Array der Reports
		NSString* byte0=[Datenarray objectAtIndex:0];
		NSString* byte1=[Datenarray objectAtIndex:1];
		
		NSLog(@"byte0: %@ byte1: %@",byte0,byte1);
		NSScanner* ErrScanner = [NSScanner scannerWithString:byte1];
		int scanWert=0;
		if ([ErrScanner scanHexInt:&scanWert]) //intwert derDaten
		{
			NSLog(@"byte1: %@ scanWert: %02X",byte0,scanWert);
			if (scanWert&0x80)
			{
				NSLog(@"I2C Fehler");
				
				NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
				[Warnung addButtonWithTitle:@"OK"];
				//	[Warnung addButtonWithTitle:@""];
				//	[Warnung addButtonWithTitle:@""];
				//	[Warnung addButtonWithTitle:@"Abbrechen"];
				[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"TWI-Fehler"]];
				
				NSString* s1=@"Moeglicherweise ist die Adresse des Slave falsch.";
				NSString* s2=@"Der Slave mit dieser Adresse ist eventuell nicht eingesteckt";
				NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
				[Warnung setInformativeText:InformationString];
				[Warnung setAlertStyle:NSWarningAlertStyle];
				
				int antwort=[Warnung runModal];
				
				return;
			}
			
		}
		
		int anzBytes=0;
		int i=0;
		switch ([byte0 intValue])
		{
			case 2:		//	write-Report
				[Eingangsdaten removeAllObjects];
				NSLog(@"write Report");
				break;
				
			case 3:		//	read-Report		
				anzBytes=[byte1 intValue];	//Anz Daten im Report
				NSLog(@"read Report: anzBytes: %d",anzBytes);
				for (i=0;i<anzBytes;i++)
				{
					
					[Eingangsdaten addObject:[Datenarray objectAtIndex:i+2]];
					
				}
				
				break;
				
		}//byte0
		
	}
	if ([Eingangsdaten count]&&[Eingangsdaten count]==AnzahlDaten)
	{
		
		NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];
		//		NSLog(@"Eingangsdaten: %@ \nAnz: %d",[Eingangsdaten description],[Eingangsdaten count]);
		NSMutableArray* tempKesselArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		
		
		
		
		int k,bit;
		bit=0;
		for (k=0;k<AnzahlDaten/6+1;k++)
		{
			NSMutableDictionary* tempReportDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			for (bit=0;bit<6;bit++)
			{
				if (k*6+bit<AnzahlDaten)
				{
					[tempReportDic setObject:[Eingangsdaten objectAtIndex:k*6+bit] forKey:[bitnummerArray objectAtIndex:bit]];
				}
				else//Auffüllen
				{
					
				}
			}
			//NSLog(@"k: %d tempReportDic: %@",k,[tempReportDic description]);
			[DumpArray addObject:tempReportDic];
			
		}
		//NSLog(@"DumpArray: %@",[DumpArray description]);
		
		int i;
		
		NSScanner* EEScanner;
		
		int KesselCode=0;
		
		for (i=0;i<24;i++)
		{
			//int wert=[[Eingangsdaten objectAtIndex:i]intValue];
			EEScanner = [NSScanner scannerWithString:[Eingangsdaten objectAtIndex:i]];
			int scanWert=0;
			if ([EEScanner scanHexInt:&scanWert]) //intwert derDaten
			{
				KesselCode=scanWert>>6; //	6 Stellen nach rechts schieben, bleiben bit0 und bit1 
			}
			
			[tempKesselArray addObject:[NSNumber numberWithInt:KesselCode]];
			
		}
		//NSArray* tagArray=[Eingangsdaten subarrayWithRange:NSMakeRange(0,24)];
		
		//NSLog(@"tagArray: %@ \nAnz: %d",[tagArray description],[tagArray count]);
		int TagPopIndex=[TagPop indexOfSelectedItem];
		
		//NSLog(@"ReportHandlerCallbackAktion: Tag: %d",TagPopIndex);
		
		[[[Datenplan objectAtIndex:TagPopIndex]objectForKey:@"Heizung"]setBrennerStundenArray:tempKesselArray forKey:@"kessel"];
		
		IOW_busy=0;
	}
}

- (void)IOWAktion:(NSNotification*)note
{
	NSLog(@"IOWAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"iow"])
	{
		[StartTaste setEnabled:[[[note userInfo]objectForKey:@"iow"]intValue]==1];
		//NSLog(@"Eingangsdaten: %@ \nAnz: %d",[Eingangsdaten description],[Eingangsdaten count]);
	}
	
}


- (void)I2CAktion:(NSNotification*)note
{
	//NSLog(@"I2CAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"fertig"])
	{
		//NSLog(@"Eingangsdaten: %@ \nAnz: %d",[Eingangsdaten description],[Eingangsdaten count]);
	}
	
}
- (void)writeIOWLog:(NSString*)derFehler
{
NSLog(@"Data writeIOWLog: %@",derFehler);
NSString* tempFehlerString=[IOWFehlerLog string];
[IOWFehlerLog setString:[NSString stringWithFormat:@"%@\n%@  Zeit: %@",tempFehlerString, derFehler,[NSCalendarDate calendarDate]]];
[derFehler release];

}

- (IBAction)readTagplan:(id)sender
{
	//NSLog(@"readTagplan");
	
	
	int tagIndex=[TagPop indexOfSelectedItem];
	NSString* Tag=[TagPop itemTitleAtIndex:tagIndex];
	int I2CIndex=[I2CPop indexOfSelectedItem];
	NSString* EEPROM_i2cAdresse=[I2CPop itemTitleAtIndex:I2CIndex];
	AnzahlDaten=0x20;
	int i2cadresse;
	NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresse];
	
	if ([theScanner scanHexInt:&i2cadresse])
	{
		//NSLog(@"readTagplan: EEPROM_i2cAdresse string: %@ int: %x	",EEPROM_i2cAdresse,i2cadresse);
		
	}
	[self setI2CStatus:1];
	[self readTagplan:i2cadresse vonAdresse:tagIndex*0x20 anz:0x20];
	[self setI2CStatus:0];
	
}

- (IBAction)readDatenplan:(id)sender
{
	
	aktuellerTag=0;
	NSDate *now = [[NSDate alloc] init];
	NSMutableDictionary* infoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[infoDic setObject:[NSNumber numberWithInt:0] forKey:@"tag"];
	
	IOWTimer =[[NSTimer alloc] initWithFireDate:now
									   interval:0.05
										 target:self 
									   selector:@selector(readWocheFunktion:) 
									   userInfo:infoDic
										repeats:YES];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:IOWTimer forMode:NSDefaultRunLoopMode];
	
	[IOWTimer release];
	[now release];
	
}

- (void)writeDatenplan:(id)sender
{
	
	//	if ([IOWTimer isValid])
	//		[IOWTimer invalidate];
	aktuellerTag=0;
	//	[self setI2CStatus:1];
	NSLog(@"writeDatenplan");
	NSMutableDictionary* infoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[infoDic setObject:[NSNumber numberWithInt:0] forKey:@"tag"];
	NSDate *now = [[NSDate alloc] init];
	IOWTimer =[[NSTimer alloc] initWithFireDate:now
									   interval:0.3
										 target:self 
									   selector:@selector(writeWocheFunktion:) 
									   userInfo:infoDic
										repeats:YES];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:IOWTimer forMode:NSDefaultRunLoopMode];
	
	[IOWTimer release];
	[now release];
	
}


- (void)readWocheFunktion:(NSTimer*) derTimer;	
{
	
	//NSLog(@"readWoche");
	NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	NSMutableDictionary* tempInfoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	if ([derTimer userInfo])
	{
		tempInfoDic=(NSMutableDictionary*)[derTimer userInfo];
		aktuellerTag=[[tempInfoDic objectForKey:@"tag"]intValue];
	}
	
	if (aktuellerTag==0)
	{
		[self setI2CStatus:1];
	}
	
	[TagPop selectItemAtIndex:aktuellerTag];
	NSString* Tag=[Wochentage objectAtIndex: aktuellerTag];
	int I2CIndex=0;//					[I2CPop indexOfSelectedItem];
	NSString* EEPROM_i2cAdresse=[I2CPop itemTitleAtIndex:I2CIndex];
	AnzahlDaten=0x20;
	int i2cadresse;
	NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresse];
	
	if ([theScanner scanHexInt:&i2cadresse])
	{
		//NSLog(@"readTagplan: EEPROM_i2cAdresse string: %@ int: %x	",EEPROM_i2cAdresse,i2cadresse);
		
	}
	//NSLog(@"readWoche: EEPROM_i2cAdresse: %x tagIndex: %d MemAdresse: %x",i2cadresse, aktuellerTag,aktuellerTag*0x20);
	//IOW_busy=1;
	[self readTagplan:i2cadresse vonAdresse:aktuellerTag*0x20 anz:0x20];
	
	
	if (aktuellerTag==6)
	{
		[IOWTimer invalidate];
		[self setI2CStatus:0];
		//[TagPop selectItemAtIndex:0];
	}
	else
	{
		aktuellerTag++;
		[tempInfoDic setObject:[NSNumber numberWithInt:aktuellerTag] forKey:@"tag"];
	}
}


- (void)setI2CStatus:(int)derStatus
{
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* i2cStatusDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[i2cStatusDic setObject:[NSNumber numberWithInt:derStatus]forKey:@"status"];
	//NSLog(@"Data  setI2CStatus: Status: %d",derStatus);
	[nc postNotificationName:@"i2cstatus" object:self userInfo:i2cStatusDic];
	
}


- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten
{
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	
	
	NSMutableDictionary* readEEPROMDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	NSMutableArray* i2cAdressArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	//Adressierung EEPROM
	[i2cAdressArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
	[i2cAdressArray addObject:[NSNumber numberWithInt:0x83]]; // Startbit 3 bytes ohne Stopbit
	[i2cAdressArray addObject:[NSNumber numberWithInt:i2cAdresse]]; // I2C-Adresse EEPROM mit WRITE
	int lbyte=startAdresse%0x100;
	int hbyte=startAdresse/0x100;
	
	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];
	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];
	//NSLog(@"readTagplan i2cAdressArray: %@",[i2cAdressArray description]);
	[Adresse setStringValue:[i2cAdressArray componentsJoinedByString:@" "]];
	[readEEPROMDic setObject:i2cAdressArray forKey:@"adressarray"];
	
	NSMutableArray* i2cCmdArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	//Anforderung Daten
	[i2cCmdArray addObject:[NSNumber numberWithInt:0x03]];	// read-Report
	[i2cCmdArray addObject:[NSNumber numberWithInt:anzDaten]]; // anz Daten
	[i2cCmdArray addObject:[NSNumber numberWithInt:i2cAdresse+1]]; // I2C-Adresse EEPROM mit READ
	//	[i2cCmdArray addObject:[NSString stringWithFormat:@"% 02X",[[NSNumber numberWithInt:i2cAdresse+1]stringValue]]]; // I2C-Adresse EEPROM mit READ
	[readEEPROMDic setObject:i2cCmdArray forKey:@"cmdarray"];
	
	NSString* cmdString=[NSString string];;
	int k=0;
	for(k=0;k<[i2cCmdArray count];k++)
	{
		//	cmdString=[cmdString stringByAppendingString:[NSString stringWithFormat:@"% 02X",[[i2cCmdArray objectAtIndex:k]stringValue]]];
		
	}
	[Cmd setStringValue:[i2cCmdArray componentsJoinedByString:@" "]];
	//	[Cmd setStringValue:cmdString];
	
	//	NSLog(@"readTagplan: readEEPROMDic: %@",[readEEPROMDic description]);
	
	[nc postNotificationName:@"i2ceepromread" object:self userInfo:readEEPROMDic];
	
	
	//NSLog(@"readTagplan Eingangsdaten: %@ \nAnz: %d",[Eingangsdaten description],[Eingangsdaten count]);
}






- (int)writeEEPROM:(int)i2cAdresse anAdresse:(int)startAdresse mitDaten:(NSArray*)dieDaten
{
	//NSLog(@"writeEEPROM: i2cAdresse: %02X dieDaten: %@",i2cAdresse, [dieDaten description]);
	int writeErr=0;
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* writeEEPROMDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	NSMutableArray* i2cWriteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];//Sammelarray fuer die Arrays der Reports
	int anzDaten=[dieDaten count];
	//NSLog(@"writeEEPROM Aresse: %02X dieDaten: %@  anz: %d",startAdresse,[dieDaten description],[dieDaten count]);
	//Adressierung EEPROM
	//[i2cWriteArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
	int pages=(anzDaten)/6; // 
	int restdaten=(anzDaten)%6;
	
	//NSLog(@"Anz Pages: %d restPage: %d",pages, restdaten);
	
	if (anzDaten<=3) // nur ein Report mit Start/Stop
	{
		NSMutableArray* tempWriteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[tempWriteArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
		[tempWriteArray addObject:[NSNumber numberWithInt:0xc3 + anzDaten]]; // Startbit, Startadresse, bis 3 bytes,  Stopbit
		[tempWriteArray addObject:[NSNumber numberWithInt:i2cAdresse]]; // I2C-Adresse EEPROM mit WRITE
		int lbyte=startAdresse%0x100;
		int hbyte=startAdresse/0x100;
		[tempWriteArray addObject:[NSNumber numberWithInt:hbyte]];
		[tempWriteArray addObject:[NSNumber numberWithInt:lbyte]];
		
		int k;
		for (k=0;k<anzDaten;k++)
		{
			[tempWriteArray addObject:[dieDaten objectAtIndex:k]];
		}
		
		[i2cWriteArray addObject:tempWriteArray];//in Sammelarray fuer die Arrays der Reports
		
		//		[writeEEPROMDic setObject:i2cWriteArray forKey:@"i2ceepromarray"];
		//		[nc postNotificationName:@"i2ceepromwrite" object:self userInfo:writeEEPROMDic];
		
	}
	else
	{
		NSMutableArray* tempWriteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[tempWriteArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
		[tempWriteArray addObject:[NSNumber numberWithInt:0x83]]; // Startbit, Startadresse, 4 bytes  
		[tempWriteArray addObject:[NSNumber numberWithInt:i2cAdresse]]; // I2C-Adresse EEPROM mit WRITE
		
		int lbyte=startAdresse%0x100;
		int hbyte=startAdresse/0x100;
		[tempWriteArray addObject:[NSNumber numberWithInt:hbyte]];
		[tempWriteArray addObject:[NSNumber numberWithInt:lbyte]];
		int k=0;
		//die 3 ersten Datenbytes
		
		//		for(k=0;k<3;k++)
		{
			//			[i2cWriteArray addObject:[dieDaten objectAtIndex:k]];
		}
		[i2cWriteArray addObject:tempWriteArray];//in Sammelarray fuer die Arrays der Reports
		
		//		[writeEEPROMDic setObject:i2cWriteArray forKey:@"i2ceepromarray"];
		//		[nc postNotificationName:@"i2ceepromwrite" object:self userInfo:writeEEPROMDic];
		//		NSLog(@"Data writeEEPROM Start-Report  i2cWriteArray: %@  anz: %d",[i2cWriteArray description],[i2cWriteArray count]);		
		//		[i2cWriteArray removeAllObjects];
		
		
		
		int pageIndex=0;
		for (pageIndex=0;pageIndex<pages;pageIndex++)
		{
			NSMutableArray* tempWriteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
			[tempWriteArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
			
			
			if ((pageIndex==pages-1)&&(restdaten==0))// letzter Report, keine Restdaten
			{
				[tempWriteArray addObject:[NSNumber numberWithInt:0x46]]; // Stopflag, anzDaten
			}
			else
			{
				[tempWriteArray addObject:[NSNumber numberWithInt:0x06]]; // keine Flags, anzDaten
			}
			
			
			for (k=0;k<6;k++)
			{
				
				[tempWriteArray addObject:[dieDaten objectAtIndex:(pageIndex*6)+k]];
			}
			
			[i2cWriteArray addObject:tempWriteArray];//in Sammelarray fuer die Arrays der Reports
			
			//			[writeEEPROMDic setObject:i2cWriteArray forKey:@"i2ceepromarray"];
			//			[nc postNotificationName:@"i2ceepromwrite" object:self userInfo:writeEEPROMDic];
			//			NSLog(@"Data writeEEPROM Report: %d  i2cWriteArray: %@  anz: %d",pageIndex,[i2cWriteArray description],[i2cWriteArray count]);		
			
			//			[i2cWriteArray removeAllObjects];
			
		}
		
		
		
		
		if (restdaten)
		{
			NSMutableArray* tempWriteArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
			[tempWriteArray addObject:[NSNumber numberWithInt:0x02]];	//write-Report
			[tempWriteArray addObject:[NSNumber numberWithInt: 0x40 + restdaten]];//restdaten und Stopbit
			for (k=0;k<restdaten; k++)
			{
				[tempWriteArray addObject:[dieDaten objectAtIndex:(pages*6)+k]];
			}
			
			[i2cWriteArray addObject:tempWriteArray];//in Sammelarray fuer die Arrays der Reports	
			
			//			[writeEEPROMDic setObject:i2cWriteArray forKey:@"i2ceepromarray"];
			//			[nc postNotificationName:@"i2ceepromwrite" object:self userInfo:writeEEPROMDic];
			NSLog(@"Data writeEEPROM   i2cWriteArray: %@  anz: %d",[i2cWriteArray description],[i2cWriteArray count]);		
			
		}
		
		
		int i;
		for (i=0;i< [i2cWriteArray count];i++)
		{
			//NSLog(@"i2cWriteArray index: %d Object: %@",i,[[i2cWriteArray objectAtIndex:i]description]);
			
		}
		[Adresse setStringValue:[i2cWriteArray componentsJoinedByString:@" "]];
		
		// Dic fuer userInfo: Array und Zaehler
		//[self setI2CStatus:1];
		
		NSMutableDictionary* infoDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[infoDic setObject:i2cWriteArray forKey:@"reportarray"];
		[infoDic setObject:[NSNumber numberWithInt:0] forKey:@"reportnummer"];
		//NSLog(@"WriteEEPROM Start Timer:  Anz Reports: %d",[i2cWriteArray count]);
		
		// Timer fuer das Senden der Reports
		
		NSDate *now = [[NSDate alloc] init];
		NSTimer* WriteTimer =[[NSTimer alloc] initWithFireDate:now
													  interval:0.03
														target:self 
													  selector:@selector(WriteEEPROMFunktion:) 
													  userInfo:infoDic
													   repeats:YES];
		
		NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:WriteTimer forMode:NSDefaultRunLoopMode];
		
		[WriteTimer release];
		[now release];
		
		
	}//	anz>3
	return writeErr;
}

- (void)WriteEEPROMFunktion:(NSTimer*) derTimer;
{
	if ([[derTimer userInfo] objectForKey:@"reportarray"])
	{
		
		NSArray* i2cWriteArray=[[derTimer userInfo] objectForKey:@"reportarray"];
		//NSLog(@"WriteEEPROMFunktion i2cWriteArray : %@",[i2cWriteArray description]);
		int ReportNummer=[[[derTimer userInfo] objectForKey:@"reportnummer"]intValue];
		if (ReportNummer==0)
		{
			[self setI2CStatus:1];
		}
		
		if (ReportNummer<[i2cWriteArray count])
		{
			//NSLog(@"WriteEEPROMFunktion ReportNummer: %d",ReportNummer);
			NSMutableDictionary* writeEEPROMDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];		
			[writeEEPROMDic setObject:[i2cWriteArray objectAtIndex:ReportNummer]forKey:@"i2ceepromarray"];
			//NSLog(@"WriteEEPROMFunktion [i2cWriteArray objectAtIndex:ReportNummer]: %@",[[i2cWriteArray objectAtIndex:ReportNummer] description]);
			[nc postNotificationName:@"i2ceepromwrite" object:self userInfo:writeEEPROMDic];
			
			ReportNummer++;
			if (ReportNummer<[i2cWriteArray count])
			{
				[[derTimer userInfo] setObject:[NSNumber numberWithInt:ReportNummer]forKey:@"reportnummer"];
			}
			else
			{
				if ([derTimer isValid])
				{
					NSLog(@"WriteEEPROMFunktion Tag fertig: Timer invalidate");
					
					[derTimer invalidate];
					//				[self setI2CStatus:0];
					//				[derTimer release];				
				}
				
			}
		}
		
		
		
	}
	else
	{
		
		[derTimer invalidate];
	}
	
	
}	


- (IBAction)writeTagplan:(id)sender
{
	NSMutableArray* tempTagplanArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int TagPopIndex=[TagPop indexOfSelectedItem];
	
	NSLog(@"writeTagplan: Tag: %d",TagPopIndex);
	rHeizungplan* tempTagplan=[[Datenplan objectAtIndex:TagPopIndex]objectForKey:@"Heizung"];
	NSArray* tempKesselStundenplanArray=[tempTagplan BrennerStundenArrayForKey:@"kessel"];
	NSArray* tempTagStundenplanArray=[tempTagplan BrennerStundenArrayForKey:@"modetag"];
	NSArray* tempNachtStundenplanArray=[tempTagplan BrennerStundenArrayForKey:@"modenacht"];
	
	int i;
	for (i=0;i<24;i++)
	{
		int hexKesselWert=[[tempKesselStundenplanArray objectAtIndex:i]intValue]<<6;//Bit 6,7
		int hexTagWert=[[tempTagStundenplanArray objectAtIndex:i]intValue]<<4;// Bit 4,5
		hexTagWert &=0x30;
		int hexNachtWert=[[tempNachtStundenplanArray objectAtIndex:i]intValue]<<2;//Bit 2,3
		hexNachtWert &=0x0C;
		int hexWert= hexKesselWert + hexTagWert + hexNachtWert;
		NSLog(@"writeTagplan i: %d   hexKesselWert: %02X   hesTagWert %02X   hexNachtWert: %02X    hexWert: %02X",i,hexKesselWert, hexTagWert, hexNachtWert, hexWert);
		[tempTagplanArray addObject:[NSNumber numberWithInt:hexWert]];
		
	}
	
	//NSLog(@"writeTagplan: tempTagplan: %@",[tempTagplan description]);
	
	//NSLog(@"writeTagplan: tempTagplan: %@",[tempKesselStundenplanArray description]);
	
	/*
	 int charCode;
	 int hexCode=0;
	 NSString* codeString=[NSString alloc];
	 if ([tempKesselStundenplanArray count])
	 {
	 
	 int i;
	 for (i=0;i<24;i++)
	 {
	 if (i<[tempKesselStundenplanArray count])
	 {
	 int hexWert=[[tempKesselStundenplanArray objectAtIndex:i]intValue]<<6;
	 //				hexWert+=0x08;
	 
	 //				[tempTagplanArray addObject:[NSNumber numberWithInt:hexWert]];
	 //				NSLog(@"writeTagplan: i: %d Wert: %02X",i,hexWert);
	 }
	 else // leere Werte
	 {
	 //[tempIOWTagplanArray addObject:@"0"];
	 [tempTagplanArray addObject:[NSNumber numberWithInt:0x00]];
	 }
	 
	 }//for i
	 */
	/*
	 NSArray* tempModeStundenplanArray=[tempTagplan BrennerStundenArrayForKey:@"modetag"];
	 if ([tempModeStundenplanArray count])
	 {
	 int i;
	 for (i=0;i<24;i++)
	 {
	 if (i<[tempModeStundenplanArray count])
	 {
	 //				int hexWert=[[tempModeStundenplanArray objectAtIndex:i]intValue]<<6;
	 int hexWert=[[tempModeStundenplanArray objectAtIndex:i]intValue]<<4;
	 hexWert&=0x30;
	 
	 //				[tempTagplanArray addObject:[NSNumber numberWithInt:hexWert]];
	 //				NSLog(@"writeTagplan Modetag :  i: %d Wert: %02X, hexwert: %02X",i,[[tempModeStundenplanArray objectAtIndex:i]intValue],hexWert);
	 }
	 else // leere Werte
	 {
	 //[tempIOWTagplanArray addObject:@"0"];
	 //				[tempTagplanArray addObject:[NSNumber numberWithInt:0x08]];
	 }
	 
	 }//for i
	 
	 }
	 */
	/*
	 NSArray* tempModeNachtStundenplanArray=[tempTagplan BrennerStundenArrayForKey:@"modenacht"];
	 if ([tempModeStundenplanArray count])
	 {
	 int i;
	 for (i=0;i<24;i++)
	 {
	 if (i<[tempModeNachtStundenplanArray count])
	 {
	 //				int hexWert=[[tempModeNachtStundenplanArray objectAtIndex:i]intValue]<<6;
	 int hexWert=[[tempModeNachtStundenplanArray objectAtIndex:i]intValue]<<2;
	 hexWert&=0x0C;
	 
	 //				[tempTagplanArray addObject:[NSNumber numberWithInt:hexWert]];
	 //				NSLog(@"writeTagplan Modenacht :  i: %d Wert: %02X, hexwert: %02X",i,[[tempModeNachtStundenplanArray objectAtIndex:i]intValue],hexWert);
	 }
	 else // leere Werte
	 {
	 //[tempIOWTagplanArray addObject:@"0"];
	 //				[tempTagplanArray addObject:[NSNumber numberWithInt:0x08]];
	 }
	 
	 }//for i
	 
	 }
	 
	 }//if Tagplan count
	 */
	//NSLog(@"writeTagplan: tempIOWTagplanArray: %@ Anzahl: %d",[tempIOWTagplanArray description],[tempIOWTagplanArray count]);
	NSLog(@"writeTagplan: tempIOWTagplanArray Anzahl: %d",[tempTagplanArray count]);
	
	//	[self setI2CStatus:1];
	[self writeEEPROM:0xA0 anAdresse:TagPopIndex*0x20 mitDaten: tempTagplanArray];
	[self setI2CStatus:0];
	
	
	
	
}

- (void)writeWocheFunktion:(NSTimer*) derTimer
{
	NSLog(@"writeWocheFunktion");
	NSMutableDictionary* tempInfoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	if ([derTimer userInfo])
	{
		tempInfoDic=(NSMutableDictionary*)[derTimer userInfo];
		aktuellerTag=[[tempInfoDic objectForKey:@"tag"]intValue];
	}
	NSLog(@"writeWocheFunktion aktuellerTag: %d",aktuellerTag);
	if (aktuellerTag==0)
	{
		[self setI2CStatus:1];
	}
	NSMutableArray* tempTagplanArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	[TagPop selectItemAtIndex:aktuellerTag];
	NSString* Tag=[Wochentage objectAtIndex: aktuellerTag];
	int I2CIndex=0;//					[I2CPop indexOfSelectedItem];
	NSString* EEPROM_i2cAdresse=[I2CPop itemTitleAtIndex:I2CIndex];
	AnzahlDaten=0x20;
	int i2cadresse;
	NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresse];
	
	if ([theScanner scanHexInt:&i2cadresse])
	{
		//NSLog(@"writeWocheFunktion: EEPROM_i2cAdresse string: %@ int: %x	",EEPROM_i2cAdresse,i2cadresse);
		
	}
	//NSLog(@"writeWocheFunktion: EEPROM_i2cAdresse: %x tagIndex: %d MemAdresse: %x",i2cadresse, aktuellerTag,aktuellerTag*0x20);
	//IOW_busy=1;
	rHeizungplan* aktuellerTagplan=[[Datenplan objectAtIndex:aktuellerTag]objectForKey:@"Heizung"];
	NSArray* tempKesselStundenplanArray=[aktuellerTagplan BrennerStundenArrayForKey:@"kessel"];
	NSArray* tempTagStundenplanArray=[aktuellerTagplan BrennerStundenArrayForKey:@"modetag"];
	NSArray* tempNachtStundenplanArray=[aktuellerTagplan BrennerStundenArrayForKey:@"modenacht"];
	
	//NSLog(@"writeWocheFunktion Tag: %@: aktuellerStundenplan: %@",[Wochentage objectAtIndex:aktuellerTag],[aktuellerStundenplan description]);
	if ([tempKesselStundenplanArray count])
	{
		int i;
		for (i=0;i<24;i++)
		{
			if (i<[tempKesselStundenplanArray count])
			{
				int hexKesselWert=[[tempKesselStundenplanArray objectAtIndex:i]intValue]<<6;//Bit 6,7
				int hexTagWert=[[tempTagStundenplanArray objectAtIndex:i]intValue]<<4;// Bit 4,5
				hexTagWert &=0x30;
				int hexNachtWert=[[tempNachtStundenplanArray objectAtIndex:i]intValue]<<2;//Bit 2,3
				hexNachtWert &=0x0C;
				int hexWert= hexKesselWert + hexTagWert + hexNachtWert;
				//				NSLog(@"writeTagplan i: %d   hexKesselWert: %02X   hesTagWert %02X   hexNachtWert: %02X    hexWert: %02X",i,hexKesselWert, hexTagWert, hexNachtWert, hexWert);
				
				
				[tempTagplanArray addObject:[NSNumber numberWithInt:hexWert]];
				NSLog(@"writeTagplan: i: %d Wert: %02X",i,hexWert);
			}
			else // leere Werte
			{
				//[tempIOWTagplanArray addObject:@"0"];
				[tempTagplanArray addObject:[NSNumber numberWithInt:0x08]];
			}
			
		}//for i
		
		[self writeEEPROM:i2cadresse anAdresse:aktuellerTag*0x20 mitDaten:tempTagplanArray];
		
		
		if (aktuellerTag==6)
		{
			
			[IOWTimer invalidate];
			[self setI2CStatus:0];
			NSLog(@"writeWocheFunktion: Timer Schluss");
			//[TagPop selectItemAtIndex:0];
		}
		else
		{
			aktuellerTag++;
			[tempInfoDic setObject:[NSNumber numberWithInt:aktuellerTag] forKey:@"tag"];
			
		}
		
	}//if count
}



- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
//NSLog(@"shouldSelectTabViewItem: %@ Identifier: %d",[tabViewItem label],[[tabViewItem identifier]intValue]);
if ([[tabViewItem identifier]intValue]==1)
{
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		NSMutableDictionary* BalkendatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[BalkendatenDic setObject:[NSNumber numberWithInt:1]forKey:@"aktion"];
		[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:BalkendatenDic];

}

if ([[tabViewItem identifier]intValue]==3)
{
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		NSMutableDictionary* BalkendatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[BalkendatenDic setObject:[NSNumber numberWithInt:3]forKey:@"aktion"];
		[nc postNotificationName:@"StatistikDaten" object:NULL userInfo:BalkendatenDic];

}


return YES;
}








-(BOOL)windowShouldClose:(id)sender
{
	NSLog(@"Data windowShouldClose");
    return YES;
}


@end


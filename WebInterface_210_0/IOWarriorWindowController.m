#import "IOWarriorWindowController.h"
#import "IOWarriorLib.h"
#import "MacroNamePanelController.h"
#import <SystemConfiguration/SCPreferences.h>
#import <SystemConfiguration/SCNetworkConfiguration.h>

enum downloadflag{downloadpause, heute, last, datum}downloadFlag;

void reportHandlerCallback (void *	 		target,
                            IOReturn                     result,
                            void * 			refcon,
                            void * 			sender,
                            UInt32		 	bufferSize);
static NSString *SystemVersion ()
{
	NSString *systemVersion = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];    
//	NSLog(@"systemVersion: %@",systemVersion);

   
   
	NSArray* VersionArray=[systemVersion componentsSeparatedByString:@"."];
//	NSLog(@"VersionArray: %@",[VersionArray description]);
return systemVersion;
}


/* itoa:  convert n to characters in s */


char* itoa(int val, int base){
	
	static char buf[32] = {0};
	
	int i = 30;
	
	for(; val && i ; --i, val /= base)
	
		buf[i] = "0123456789abcdef"[val % base];
	
	return &buf[i+1];
	
}



@implementation IOWarriorWindowController

static NSString *	SystemVersion();
int			SystemNummer;

NSString*	kReportDirectionIn = @"R";
static NSString*	kReportDirectionOut = @"W";

static NSString*	kReportDirectionKey = @"R/W";
static NSString*	kReportIDKey = @"Id";
static NSString*	kReportDataKey = @"data";

static NSString*	kMacroNameKey = @"name";
static NSString*	kDefaultMacrosKey = @"default macros";

IOWarriorWindowController* gWindowController = nil;

//


void IOWarriorCallback ()
/*" Called when IOWarrior is added or removed. "*/
{
    [gWindowController populateInterfacePopup];
}

- (void)Alert:(NSString*)derFehler
{
   /*
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
   */
   NSAlert * DebugAlert=[[NSAlert alloc]init];
   DebugAlert.messageText= @"Debugger!";
   DebugAlert.informativeText = [NSString stringWithFormat:@"Mitteilung: \n%@",derFehler];

		[DebugAlert runModal];

}

/*" Invoked when the nib file including the window has been loaded. "*/
- (void) awakeFromNib
{
   
   NSString* ASString = @"return do shell script \"curl http://checkip.dyndns.org/\"";
   NSAppleScript* IP_appleScript = [[NSAppleScript alloc] initWithSource: ASString];
   //DLog(@"IP_appleScript: %@ ",[IP_appleScript description]);
   NSDictionary* IPErr=nil;
   /*
   NSAppleEventDescriptor * IP_Descriptor = [IP_appleScript executeAndReturnError:&IPErr];
   
   //NSLog(@"IPdescriptor: %@ IPErr: %@",[IP_Descriptor stringValue],IPErr);
   NSString* IP_AddressString = [IP_Descriptor stringValue];
   NSArray* IP_DescriptorArray = [IP_AddressString componentsSeparatedByString:@"Current IP Address:"];
   NSLog(@"IP_AddressArray: %@ ",[IP_DescriptorArray description]);

   NSArray* IP_AddressArray = [[IP_DescriptorArray objectAtIndex:1] componentsSeparatedByString:@"</body></html>"];
   
   NSString* IP_Address = [IP_AddressArray objectAtIndex:0];
   
   NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
   
   char first=[IP_Address characterAtIndex:0];
   if (![CharOK characterIsMember:first])
			{
            //NSLog(@"DataVonHeute: String korrigieren");
            IP_Address=[IP_Address substringFromIndex:1];
         }

   NSLog(@"IP_Address: %@ ",IP_Address);
*/
	oldHour=[[NSCalendarDate date]hourOfDay];
	daySaved=NO;
	int adresse=0xABCD;
	adresse = 0xA030;
	int lbyte=adresse<<8;
	lbyte &= 0xff00;
	lbyte >>=8;
	int hbyte=adresse>>8;
	
	uint8_t aa=0xA0;
	
	char* TWIString=itoa((int)aa,16);
	//NSLog(@"aa: %d TWIString: %s",aa,TWIString);
	//int lbyte=adresse%0x100;
	//int hbyte=adresse/0x100;
	//lbyte>>=8;
	//NSLog(@"adresse: %x lbyte: %x hbyte; %x",adresse, lbyte,hbyte);
	
	//gesichert=0;
	anzDataOK=0;
	old=0;
	uint8_t Daten=0xfc;
	
	
	NSImage* myImage = [NSImage imageNamed: @"HAUS"];
	[NSApp setApplicationIconImage: myImage];

	
	anzSessionFiles=0; // Anzahl gesicherte Files am aktuellen Tag
	
	/*
	[WindowMenu setDelegate:self];
	[[WindowMenu itemWithTag:1] setTarget:self];//AVR
	[[WindowMenu itemWithTag:2] setTarget:self];//Data
	[[WindowMenu itemWithTag:3] setTarget:self];//AVR
*/
	
	uint8_t TagStundenCodeA=(Daten>>4);	//	Stunde A oberer Balken im char, bit 4, 5
	TagStundenCodeA &= 0x03;	//	Bit 0, 1
	
	uint8_t TagStundenCodeB=(Daten>>2);	//	Stunde A oberer Balken im char, bit 3, 2
	TagStundenCodeB &= 0x03;	//	Bit 0, 1
	
	//NSLog(@"Daten: %02X TagStundenCodeA: %02X TagStundenCodeB; %02X",Daten, TagStundenCodeA,TagStundenCodeB);
	
	TagStundenCodeA >>=2;
	//
	
	TagStundenCodeB >>=2;
	//
	//NSLog(@"Daten: %02X TagStundenCodeA: %02X TagStundenCodeB; %02X",Daten, TagStundenCodeA,TagStundenCodeB);
	
	uint8_t zahl=244;
	char string[3];
	uint8_t l,h;                             // schleifenzähler
	//NSLog(@"zahl: %d   hex: %02X ",zahl, zahl);
	
	
	//  string[4]='\0';                       // String Terminator
	string[2]='\0';                       // String Terminator
	l=(zahl % 16);
	if (l<10)
		string[1]=l +'0';  
	else
	{
		l%=10;
		string[1]=l + 'A'; 
		
	}
	zahl /=16;
	h= zahl % 16;
	if (h<10)
		string[0]=h +'0';  
	else
	{
		h%=10;
		string[0]=h + 'A'; 
	}
	
	
	
	
	
	NSString* hexString=[NSString stringWithUTF8String:string ];
	//NSLog(@"l: %d h: %d zahl convertiert: %@ ",l,h, hexString);
	
	// set the global ptr to the main window controller to self, needed for iowarrior callbacks
	gWindowController = self;
	//	NSString *systemVersion = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];    
	//	NSLog(@"systemVersion: %@",systemVersion);
	//	NSArray* VersionArray=[systemVersion componentsSeparatedByString:@"."];
	//	NSLog(@"VersionArray: %@",[VersionArray description]);
	// init the IOWarrior library
	NSString* SysVersion=SystemVersion();
	NSArray* VersionArray=[SysVersion componentsSeparatedByString:@"."];
	SystemNummer=[[VersionArray objectAtIndex:1]intValue];
	//NSLog(@"SystemVersion aus Funktion: %@ Nummer: %d ",SysVersion,SystemNummer);
	//IOWarriorInit ();
	//IOWarriorIsPresent (); // builds the list of available IOWarrior interface, speeds up library operations
	//IOWarriorSetDeviceCallback (IOWarriorCallback, nil);
	isReading = false;
	isTracking = false;
	ignoreDuplicates = YES;
	
	dumpTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	Dump_DS=[[rDump_DS alloc]init];
	[dumpTable setDelegate:Dump_DS];
	[dumpTable setDataSource:Dump_DS];
	dumpCounter=0;
	[self populateInterfacePopup];
	[self interfacePopupChanged:self];
	[self tableViewSelectionDidChange:nil];
	logEntries = [[NSMutableArray alloc] init];
	[logTable setTarget:self];
	[logTable setDoubleAction:@selector(logTableDoubleClicked)];
	// populate macropopup
	[self updateMacroPopup];
	[ignoreDuplicatesCheckBox setState:ignoreDuplicates];
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
			 selector:@selector(TastenAktion:)
				  name:@"Tastenaktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(EinzelTastenAktion:)
				  name:@"Einzeltastenaktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(SendTastenAktion:)
				  name:@"SendTastenAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(SendAktion:)
				  name:@"SendAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(InputAktion:)
				  name:@"InputAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(BeendenAktion:)
				  name:@"IOWarriorBeenden"
				object:nil];

	
	[nc addObserver:self
			 selector:@selector(FensterSchliessenAktion:)
				  name:@"NSWindowWillCloseNotification"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(FensterWirdSchliessenAktion:)
				  name:@"NSWindowShouldCloseNotification"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(sendCmdAktion:)
				  name:@"sendcmd"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(i2cEEPROMReadReportAktion:)
				  name:@"i2ceepromread"
				object:nil];
	
	
	[nc addObserver:self
			 selector:@selector(i2cEEPROMWriteReportAktion:)
				  name:@"i2ceepromwrite"
				object:nil];
	
	
	[nc addObserver:self
			 selector:@selector(i2cStatusAktion:) // Action von USBWrrior
				  name:@"i2cstatus"
				object:nil];
	
	
	[nc addObserver:self
			 selector:@selector(DataAktion:)
				  name:@"data"
				object:nil];

	[nc addObserver:self
			 selector:@selector(HomeDataDownloadAktion:)
				  name:@"HomeDataDownload"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(HomeDataKalenderAktion:)
				  name:@"HomeDataKalender"
				object:nil];

	[nc addObserver:self
			 selector:@selector(HomeDataSolarKalenderAktion:)
				  name:@"SolarDataKalender"
				object:nil];

	//HomeDataSolarKalenderAktion
	[nc addObserver:self
			 selector:@selector(StatistikDatenAktion:)
				  name:@"StatistikDaten"
				object:nil];

	[nc addObserver:self
			 selector:@selector(HomeDataSolarStatistikKalenderAktion:)
				  name:@"SolarStatistikKalender"
				object:nil];

	
	
		[nc addObserver:self
			 selector:@selector(DatenVonHeuteAktion:)
				  name:@"datenvonheute"
				object:nil];

	[nc addObserver:self
			 selector:@selector(SolarDataDownloadAktion:)
				  name:@"SolarDataDownload"
				object:nil];
	
		[nc addObserver:self
			 selector:@selector(SolarDatenVonHeuteAktion:)
				  name:@"solardatenvonheute"
				object:nil];


	
	[nc addObserver:self
			 selector:@selector(HomeDataSolarKalenderAktion:)
				  name:@"HomeDataSolarKalender"
				object:nil];

   [nc addObserver:self
			 selector:@selector(SolarStatistikDatenAktion:)
				  name:@"SolarStatistikDaten"
				object:nil];
   


	
	lastDataRead=[[NSData alloc]init];
	//	[self readPList];
	
		[self showAVR:NULL];
	
   
   //[AVR setWochenplan:NULL];

	//	[self showADWandler:NULL];	
	/*
	 [ADWandler setInterfaceNummer:2];
	 [ADWandler setTabIndex:1];
	 [ADWandler setEinkanalWahlTaste:3];
	 
	 NSMutableArray* tempKanalArray=[[NSMutableArray alloc]initWithCapacity:0];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [ADWandler setMehrkanalWahlTasteMitArray:tempKanalArray];
	 //[NSArray arrayWithObjects:0,1,1,1,0,1,0,1,0,nil]];
	 [self Alert:@"ADWandler awake vor readPList "];
	 [self readPList];
	 */
	//	
	//	[self readPList];
	//	[ADWandler showWindow:self];
   
   [self showHomeData:NULL];
   
	[self showData:NULL]; // Observer von Data muessen vor HomeData aktiviert sein
	
	
	//NSLog(@"BIN  zahl: %d bin: %02X",14, 14);
	
	HomeClient = [[rHomeClient alloc]init];
	
	  
   
	lastDataZeit=0;
	//[self startHomeData];
	//NSLog(@"awake vor AktuelleDaten");
	
   // heutige Daten laden
   NSString* AktuelleDaten = [NSString string];
   AktuelleDaten=[HomeData DataVonHeute];
   
	//NSLog(@"awake nach AktuelleDaten returnstring: %@",AktuelleDaten);
   
	//NSLog(@"awake AktuelleDaten: \n%@",AktuelleDaten);
   
	if (AktuelleDaten &&[AktuelleDaten length])
	{
		//NSLog(@"awake openWithString\n\n");
      
		[self openWithString:AktuelleDaten];
      
		[self setStatistikDaten];
      
      //NSArray* IP_Array = [HomeData Router_IP];
      /*
      NSLog(@"IP_Array: %@",[IP_Array description]);
     
      if ([IP_Array count] >1)
      {
         if ([[IP_Array objectAtIndex:0] isEqualToString:[IP_Array objectAtIndex:1]]) // gleiche IP
         {
            [Data setRouter_IP:[IP_Array objectAtIndex:0]];

         }
         else
         {
            
         }
      
      }
      else
      {
         [Data setRouter_IP:[IP_Array objectAtIndex:0]];
         
      }
      */
      
      NSString* IP_String = [HomeData Router_IP];
      [Data setRouter_IP:IP_String];
	}
	else
	{
		NSLog(@"awake Kein Input");
	}
   NSLog(@"end DatenVonHeute");
   
	
	#pragma mark awake Solar
	
   [HomeData setPumpeLeistungsfaktor:0.0138];  // W/s
   [HomeData setElektroLeistungsfaktor:0.833]; // W/s
   [HomeData setFluidLeistungsfaktor:0.0625]; // Leistungsuebertragung in kJ/s*K
 
   
   
   NSString* AktuelleSolarDaten=[HomeData SolarDataVonHeute];
	//NSString* AktuelleSolarDaten=[HomeData TestSolarData];
	
   
   //NSLog(@"awake nach AktuelleSolarDaten");
	//NSLog(@"awake AktuelleSolarDaten: \n%@",AktuelleSolarDaten);
	if (AktuelleSolarDaten &&[AktuelleSolarDaten length])
	{
		//NSLog(@"awake openWithSolarString\n\n");
		[self openWithSolarString:AktuelleSolarDaten];
      
      [self setSolarStatistikDaten];
	}
	else
	{
		NSLog(@"awake Kein SolarInput");
	}
	
   //NSLog(@"end SolarDatenVonHeute");



	//[Data showWindow:self];
	//[Data writeIOWLog:@"IOWFehler Start"];

//	[self setStatistikDaten];
	
	
	// Kontrolle vor Beenden
	TWIStatus=1;
}




- (void) dealloc
{
	NSLog(@"dealloc");
}


- (void) populateInterfacePopup
/*" Inserts currently available IOWarrior interfaces into popup menu. "*/
{
	//NSLog(@"populateInterfacePopup");
    int i, interfaceCount;
    int vor=[interfacePopup numberOfItems];
	BOOL neu=NO;
	if (vor &&[[interfacePopup itemAtIndex:0]tag]==-1);
	{
	neu=YES;
	}
	
    [interfacePopup removeAllItems];
    interfaceCount = IOWarriorCountInterfaces ();
	//NSLog(@"vor: %d interfaceCount: %d",vor,interfaceCount);
    if (0 == interfaceCount)
    {
        [interfacePopup setEnabled:NO];
		if (vor &&!neu)
		{
		NSRunAlertPanel (@"IOWarrior: Auf Wiedersehen", @"Es ist kein IOWarrior mehr eingesteckt.", @"OK", nil, nil);
		}
		else if (neu)
		{
		//NSRunAlertPanel (@"IOWarrior: Guten Tag", @"Ich habe noch keinen IOWarrior gefunden.", @"OK", nil, nil);
		}
    }
    else
    {
        [interfacePopup setEnabled:YES];
		if (interfaceCount>vor)
		{
		NSRunAlertPanel (@"IOWarrior: Guten Tag", @"Ich habe einen neuen IOWarrior gefunden.", @"OK", nil, nil);
		}

    }
    for (i = 0; i < interfaceCount; i++)
    {
        IOWarriorListNode* 	listNode;
        NSString*		title;

        listNode = IOWarriorInterfaceListNodeAtIndex (i);
        title = [NSString stringWithFormat:@"%@ (SN %@)", [self nameForIOWarriorInterfaceType:listNode->interfaceType],
            listNode->serialNumber];
        [interfacePopup addItemWithTitle:title];
		[[interfacePopup itemWithTitle:title]setTag:i];
    }
	
    [self interfacePopupChanged:self];
}

- (NSString*) nameForIOWarriorInterfaceType:(int) inType
/*" Returns a human readable name for a given IOWarrior interface type. "*/
{
    switch (inType)
    {
        case kIOWarrior40Interface0:
            return @"IOWarrior40 Interface 0";
            break;

        case kIOWarrior40Interface1:
            return @"IOWarrior40 Interface 1";
            break;

        case kIOWarrior24Interface0:
            return @"IOWarrior24 Interface 0";
            break;

        case kIOWarrior24Interface1:
            return @"IOWarrior24 Interface 1";
            break;
    }
    return @"Unknown interface type";
}




/*" Invoked when user hits 'Write"-Button. "*/
- (IBAction)doWrite:(id)sender
{
    char*                           buffer;
    int                             i;
    int                             result = 0;
    int                             reportID = -1;
    IOWarriorListNode*              listNode;
    int                             reportSize;

    if (NO == IOWarriorIsPresent ())
    {
        NSRunAlertPanel (@"Kein IOWarrior gefunden", @"Es ist kein Interface eingesteckt.", @"OK", nil, nil);
       [NSApp terminate:self];
		 return;
    }
    reportSize = [self reportSizeForInterfaceType:[self currentInterfaceType]];
	NSLog(@"doWrite: reportSize: %d",reportSize);
    buffer = malloc (reportSize);
    for (i = 0 ; i < reportSize ; i++)
    {
        NSControl *theSubview;
        NSScanner *theScanner;
        unsigned	  value;
        
        theSubview = (NSControl*) [[window contentView] viewWithTag:i + 100];
		
        theScanner = [NSScanner scannerWithString:[theSubview stringValue]];
		
        if ([theScanner scanHexInt:&value])
        {
			NSLog(@"doWrite: index: %d	string: %@		value: %02X	",i,[theSubview stringValue],value);
            buffer[i] = (char) value;
        }
        else
        {
            NSRunAlertPanel (@"Invalid data format", @"Please only use hex values between 00 and FF.", @"OK", nil, nil);
            free (buffer);
            return;
        }
		//NSLog(@"doWrite: index: %d	buffer: %x",i,buffer);
    }
	
//	 buffer[0]=0x99;
//	 buffer[1]=0x99;
	
	for (i = 0 ; i < reportSize ; i++)
	 {
	 NSLog(@" i: %d buffer: %X",i,buffer[i]);
	 }

	 NSLog(@"doWrite [interfacePopup indexOfSelectedItem]: %d",[interfacePopup indexOfSelectedItem]);
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
	//NSLog(@"doWrite listNode: %d",listNode);
    if (listNode)
    {
        if (![self reportIdRequiredForWritingToInterfaceOfType:listNode->interfaceType])
        {
            result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize, buffer);
        }
        else
        {
            if ([[NSScanner scannerWithString:[reportIDField stringValue]] scanHexInt:&reportID])
            {
                char tempBuffer[reportSize + 1];
    
                tempBuffer[0] = reportID;
    
                memcpy (&tempBuffer[1], buffer, reportSize);
                
                result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize + 1, tempBuffer);
            }
            else
            {
                NSRunAlertPanel (@"Invalid report id number format", @"Please only use hex values between 00 and FF.", @"OK", nil, nil);
            }
        }
        
        if (0 != result)
		{
            NSRunAlertPanel (@"IOWarrior Error", @"An error occured while trying to write to the selected IOWarrior device.", @"OK", nil, nil);
			[NSApp terminate:self];
			return;
		}

        else
        {
		//NSLog(@"doWrite: ");
            [self addLogEntryWithDirection:kReportDirectionOut
                                reportID:reportID
                                reportSize:reportSize
                                reportData:buffer];
        }
    }
    free (buffer);
}

/*" Invoked when user hits 'Read'-button. "*/
- (IBAction)doRead:(id)sender
{

    if (isReading)
    {
        [self stopReading];
    }
    else
    {
        [self startReading];
    }
}

- (void) stopReading
{
NSLog(@"stopReading begin");
    [readButton setTitle:@"Read"];
	NSLog(@"stopReading 1");
	if (readTimer&&[readTimer isValid])
	{
    [readTimer invalidate];
	}
	NSLog(@"stopReading 2");
    isReading = YES;
	NSLog(@"stopReading end");;
}

- (void) startReading
{
	//NSLog(@"iowarrior startReading");
	
//	return;
	
	anzDaten=0;
    IOWarriorListNode* 	listNode;
    
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (nil == listNode) // if there is no interface, exit and don't invoke timer again
        return;
    
    if (listNode->interfaceType == kIOWarrior24Interface0 ||
        listNode->interfaceType == kIOWarrior40Interface0)
    {
        // if user has selected some kind of interface0, read every 0.05 seconds using getReport request
        [self setLastValueRead:nil];
        [readButton setTitle:@"Stop Reading"];
		
		// read ankuendigen
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"iowbusy"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"ReadStart" object:self userInfo:NotificationDic];
		anzDataOK=0;
		
        // read immediatly
        [self read:nil];
        // activate timer
		
        readTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(read:) userInfo:nil repeats:YES];
    }
    else
    {
        // we have somd kind of interface1, install interrupt handler
        char* buffer;
        
        buffer = malloc(8);
        IOWarriorSetInterruptCallback(listNode->ioWarriorHIDInterface, buffer, 8, reportHandlerCallback, CFBridgingRetain(self));
    }
}

void reportHandlerCallback (void *	 		target,
                   IOReturn                 result,
                   void * 			refcon,
                   void * 			sender,
                   UInt32		 	bufferSize)
{    
	//NSLog(@"reportHandlerCallback");
	
	if (kIOReturnSuccess == result)
	{
		int                         reportID = -1;
		NSData*                     dataRead;
		char*                       buffer = (char*) target;
		IOWarriorWindowController*  controller = CFBridgingRelease(refcon);
		NSMutableArray*	DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		reportID = buffer[0];
		dataRead = [NSData dataWithBytes:buffer length:bufferSize];
		
		//NSLog(@"reportHandlerCallback: Data: %@",[dataRead description]);
		NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];
		NSMutableDictionary* tempReportDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		const unsigned char *dataBuffer = [dataRead bytes];
		int i;
		
		for (i = 0; i < [dataRead length]; ++i)
		{
			
			NSString* tempString=[NSString stringWithFormat:@"%02lX", (unsigned long)dataBuffer[ i ]];
			//[tempReportDic setObject:tempString forKey:[bitnummerArray objectAtIndex:i]];
			[DatenArray addObject:tempString];
			
		}
		
		//NSLog(@"DatenArray: %@",[DatenArray description]);
		//NSLog(@"tempReportDic: %@",[tempReportDic description]);
		
		[controller setDump:DatenArray];		
		
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:[DatenArray copy]forKey:@"datenarray"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		
		[nc postNotificationName:@"ReportHandlerCallback" object:NULL userInfo:NotificationDic];
		
		[controller addLogEntryWithDirection:kReportDirectionIn
											 reportID:reportID
										  reportSize:bufferSize - 1
										  reportData:&buffer[1]];
		[controller setLastValueRead:dataRead];
		// }
	}
}

-(void)HomeDataDownloadAktion:(NSNotification*)note
{
/*
Ausgeloest von Funktionen in rHomeData:
downloadDidFinish: downloadflag, lastdatazeit, datastring, 
LastData: downloadflag, lastdatazeit, datastring,
DataVon: downloadflag, lastdatazeit, datastring,
HomeDataDownload


*/
   //NSLog(@"HomeDataDownloadAktion userInfo: *%@*",[[note userInfo] objectForKey:@"lastdatazeit" ]);
	
	
	if ([AVR WriteWoche_busy]) // Woche wird noch geschrieben
	{
		return;
	}
	
	int flag=downloadpause;
	NSString* DataString=@"";
	if ([[note userInfo] objectForKey:@"downloadflag"])
	{
		flag=[[[note userInfo] objectForKey:@"downloadflag"]intValue];
	}
	
	if ([[note userInfo] objectForKey:@"datastring"])
	{
		DataString=[[note userInfo] objectForKey:@"datastring"];
	}
		
	//NSLog(@"HomeDataDownloadAktion flag: %d\n DataString: \n%@",flag, DataString);
	//NSLog(@"HomeDataDownloadAktion flag: %d length: %d",flag,[DataString length]);
   
   // enum downloadflag{downloadpause, heute, last, datum}downloadFlag;
	
   switch (flag)
	{
		case heute: // 1
		{
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				lastDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
            NSLog(@"IOW HomeDataDownloadAktion case heute: lastDataZeit: %d", lastDataZeit);
			}
			else
			{
				lastDataZeit=0;
            //NSLog(@"IOW HomeDataDownloadAktion case heute: lastDataZeit ist 0");
			}
			
			if ([DataString length])
			{
				// 12.08.09 [self openWithString:DataString];// im Aufruf von DataVonHeute ausgelöst
				
				if (![DownloadTimer isValid])
				{
					DownloadTimer=[NSTimer scheduledTimerWithTimeInterval:12
																					target:self 
																				 selector:@selector(DownloadFunktion:) 
																				 userInfo:nil 
																				  repeats:YES];
					
					
					//NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
					//[runLoop addTimer:DownloadTimer forMode:NSDefaultRunLoopMode];
					
					//[DownloadTimer release];
				}
				
			}
			else
			{
				NSLog(@"Kein Input");
			}
			
		}break;
			
		case last:
		{
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[NotificationDic setObject:[NSNumber numberWithInt:lastDataZeit] forKey:@"previouslastdatazeit"];
			int tempLastDataZeit=0;
         
         
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				tempLastDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
			}
			//NSLog(@"IOW HomeDataDownloadAktion case last:  lastDataZeit: %d tempLastDataZeit: %d",lastDataZeit,tempLastDataZeit);
			if (!(tempLastDataZeit==lastDataZeit))
			{
				//NSLog(@"IOW Neue Daten: neuer DataString: %@",DataString);
				lastDataZeit=tempLastDataZeit;
				
				if ([DataString length])
				{
					NSArray* tempDataArray = [DataString componentsSeparatedByString:@"\n"];
					if ([tempDataArray count])
					{
						//NSLog(@"tempDataArray: %@",[[tempDataArray objectAtIndex:0]description]);
						NSArray* tempZeilenArray=[[tempDataArray objectAtIndex:0]componentsSeparatedByString:@"\t"];
						//NSLog(@"IOW tempZeilenArray: %@",[tempZeilenArray description]);
						
						[NotificationDic setObject:tempZeilenArray forKey:@"lastdatenarray"];
						NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
						[nc postNotificationName:@"lasthomedata" object:self userInfo:NotificationDic];
						
						
						
					}//count
					
					
				}// length
			}
			
			
		}break;//last
			
		case datum:
		{
			NSLog(@"HomeDataDownloadAktion datum");

			if ([DownloadTimer isValid])
			{
				NSLog(@"  HomeDataDownloadAktion DownloadTimer invalidate");

				[DownloadTimer invalidate];
			}
			
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				lastDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
			}
			else
			{
				lastDataZeit=0;
			}
			
			if ([DataString length])
			{
				[Data reportClear:NULL];
	//			[self openWithString:DataString];
			}
		}//datum
			
	}//switch flag
	
	flag=downloadpause;
}

- (void)DownloadFunktion:(NSTimer*)derTimer
{
	//NSLog(@"DownloadTimer DownloadFunktion");
	
	NSString* AktuelleDaten=[HomeData LastData];
	if (AktuelleDaten == NULL)
	{
		//NSLog(@"DownloadFunktion: AktuelleDaten von HomeData ist NULL");
	}
		NSString* AktuelleSolarDaten=[HomeData LastSolarData];
	if (AktuelleSolarDaten == NULL)
	{
		NSLog(@"DownloadFunktion: AktuelleSolarDaten von HomeData ist NULL");
	}

}

- (void)DataAktion:(NSNotification*)note
{
	//NSLog(@"DataAktion: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"data"])
	{
		if ([[[note userInfo]objectForKey:@"data"]isEqualToString:@"datastart"])
		{
			[self startReading];
		}
		
		if ([[[note userInfo]objectForKey:@"data"]isEqualToString:@"datastop"])
		{
			
			[self stopReading];
		}
		
		if ([[[note userInfo]objectForKey:@"data"]isEqualToString:@"savepart"])
		{
			
			
			if ([[note userInfo]objectForKey:@"datenseriestartzeit"])
			{
				[self DruckDatenSchreibenMitDatum:[[note userInfo]objectForKey:@"datenseriestartzeit"] ganzerTag:NO];
			}
			else
			{
				[self DruckDatenSchreibenMitDatum:[NSCalendarDate date] ganzerTag:NO];
			}
			
			
		}
		
		if ([[[note userInfo]objectForKey:@"data"]isEqualToString:@"saveganz"])
		{
			if ([[note userInfo]objectForKey:@"datenseriestartzeit"])
			{
				
				[self DruckDatenSchreibenMitDatum:[[note userInfo]objectForKey:@"datenseriestartzeit"] ganzerTag:YES];
			
			}
			else
			{
				[self DruckDatenSchreibenMitDatum:[NSCalendarDate date] ganzerTag:YES];
			}
			[Data clearData];
		}
		
	}

}

- (void)DatenVonHeuteAktion:(NSNotification*)note
{
	NSLog(@"DatenVonHeuteAktion");
	[Data setKalenderBlocker:0];

	[self openWithString:[HomeData DataVonHeute]];

}

- (void)KalenderFunktion:(NSTimer*)derTimer
{
	[Data setKalenderBlocker:0];
}

- (void)SolarDatenVonHeuteAktion:(NSNotification*)note
{
	NSLog(@"SolarDatenVonHeuteAktion");
	[Data setSolarKalenderBlocker:0];
	[self openWithSolarString:[HomeData SolarDataVonHeute]];

}


-(IBAction)reportHeute:(id)sender
{
	NSLog(@"IOW reportHeute Open With String; %@",[HomeData DataVonHeute]);
	[Data setKalenderBlocker:0];
	[self openWithString:[HomeData DataVonHeute]];
	//NSLog(@"AktuelleDaten: %@",[HomeData DataVonHeute]);
}

- (IBAction)reportPrint:(id)sender
{
NSLog(@"IOWarr WindowController reportPrint");
[Data reportPrint:NULL];
}


-(void)openWithString:(NSString*)derDatenString
{
   // Daten aus HomeDaten.txt auslesen. Enthaelt beim Start die Daten des aktuellen Tages
   
	//NSLog(@"openWithString DatenString length; %d",[derDatenString length]);
	NSArray* rohDatenArray = [NSArray array];
	NSString* TagString = [NSString string];
	int Tag=0;
	int Monat=0;
	int Jahr=0;
	
	NSString* ZeitString = [NSString string];
	NSString* StartDatumString=[NSString string];
	NSCalendarDate* StartZeit= [NSCalendarDate date];

	NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
	char last=[derDatenString characterAtIndex:[derDatenString length]-1];
	//NSLog(@"Letzter Char: %c",last);
	// eventuelle Zeilenschaltung am Ende entfernen

	if (![CharOK characterIsMember:last])
	{
		derDatenString=[derDatenString substringToIndex:[derDatenString length]-1];
	}
	
	if ([derDatenString length])
	{
		//NSLog(@"openWithString DatenString: \n%@",derDatenString);
		NSArray* tempDatenArray= [derDatenString componentsSeparatedByString:@"\n"];
		//	NSArray* tempDatenArray= [DatenString componentsSeparatedByString:@"\r"];
		
		//NSLog(@"openWithString tempDatenArray count: %d",[tempDatenArray count]);
		int DataOffset=12;
		if ([tempDatenArray count] >DataOffset)	// mindestens 1 Data
		{
			
			// Tabellenkopf entfernen: Zeile mit Datum suchen
			
         DataOffset=0;
			NSEnumerator* DataEnum=[tempDatenArray objectEnumerator];
			id eineZeile;
			while (eineZeile=[DataEnum nextObject])
			{
				DataOffset++;
				//NSLog(@"eineZeile: %@",eineZeile);
				NSRange r=[eineZeile rangeOfString:@"Startzeit:"];
				
            // Zeile mit "Startzeit" suchen, offset in Dataoffset speichern
				if (!(NSEqualRanges(r,NSMakeRange(NSNotFound,0))))
				{
					//NSLog(@"openWithString bingo: %@",eineZeile);
					break;
				}
			}//while
			//NSLog(@"DataOffset: %d",DataOffset);
			
			//		DataOffset += 3; // Zeile mit Startzeit
			//		DatenArray = [[tempDatenArray subarrayWithRange:NSMakeRange(DataOffset,[tempDatenArray count]-DataOffset)]retain];
			
			NSString* DatumString= [tempDatenArray objectAtIndex:DataOffset-1];
			
			// Eventuellen Leerschlag am Anfang entfernen
			char first=[DatumString characterAtIndex:0];
			if (![CharOK characterIsMember:first])
			{
				DatumString=[DatumString substringFromIndex:1];
			}
			
			// Datumstring nach leerschlaegen auftrennen
			NSArray* tempDatumArray= [DatumString componentsSeparatedByString:@" "];
			//NSLog(@"openWithString tempDatumArray: %@ count: %d",[tempDatumArray description], [tempDatumArray count]);
			
			switch ([tempDatumArray count])
			{
				case 4: // aktuell
				{
					TagString=[tempDatumArray objectAtIndex:1];
					ZeitString=[[tempDatumArray objectAtIndex:2]substringWithRange:NSMakeRange(0,5)];
					StartDatumString= [[tempDatenArray objectAtIndex:DataOffset-1]substringFromIndex:11];
					NSString* Kalenderformat=[[NSCalendarDate date]calendarFormat];
					
					StartZeit=[NSCalendarDate dateWithString:StartDatumString calendarFormat:Kalenderformat];
					//NSLog(@"Format: %@ StartZeit: %@",Kalenderformat,[StartZeit description]);
					Tag=[StartZeit dayOfMonth];
					Monat=[StartZeit monthOfYear];
					Jahr=[StartZeit yearOfCommonEra];
					//NSLog(@"openWithString StartZeit case 4: %@ tag: %d monat: %d Jahr: %d",[StartZeit description],Tag, Monat, Jahr);
					
				}break;
					
				case 5: // ab 12.3.09
				{
					TagString=[tempDatumArray objectAtIndex:2];
					ZeitString=[[tempDatumArray objectAtIndex:4]substringWithRange:NSMakeRange(0,5)];
					StartDatumString= [[tempDatenArray objectAtIndex:10]substringFromIndex:11];
					int l=[StartDatumString length];
					StartDatumString= [StartDatumString substringToIndex:l-1];
					//NSLog(@"openWithString StartDatumString 5: *%@*",StartDatumString);
					NSString* Kalenderformat=[[NSCalendarDate date]calendarFormat];
					
					StartZeit=[NSCalendarDate dateWithString:StartDatumString calendarFormat:Kalenderformat];
					//NSLog(@"Format: %@ StartZeit: %@",Kalenderformat,[StartZeit description]);
					//NSLog(@"openWithString StartZeit case 5: %@ tag: %d",[StartZeit description],[StartZeit dayOfMonth]);
					
					
				}break;
					
				case 6:	//	vor 12.3.09
				{
					TagString=[tempDatumArray objectAtIndex:3];
					ZeitString=[[tempDatumArray objectAtIndex:5]substringWithRange:NSMakeRange(0,5)];
					
				}break;
					
					
			}	//	switch count
			
			
			//NSLog(@"tempDatenArray count: %d",[tempDatenArray count]);
			//NSLog(@"Tag: %@ Zeit: %@",TagString, ZeitString);
			//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
			
			
			
			rohDatenArray = [tempDatenArray subarrayWithRange:NSMakeRange(DataOffset,[tempDatenArray count]-DataOffset)];
			NSMutableArray* DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
			//NSLog(@"openWithString rohDatenArray count: %lu",(unsigned long)[rohDatenArray count]);
			int i=0;
			for (i=0;i<[rohDatenArray count];i++)
			//for (i=0;i<1;i++)

			{
            
				NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
				tempDatenArray = [NSMutableArray arrayWithArray: [[rohDatenArray objectAtIndex:i] componentsSeparatedByString:@"\t"]];
				while ([tempDatenArray count]<9)
				{
					[tempDatenArray addObject: [NSNumber numberWithInt:0]];
				}
				//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
				NSString* tempZeilenString= [tempDatenArray componentsJoinedByString:@"\r"];
				if (i==0)
				{
					//NSLog(@"openWithString erster tempZeilenString : \n%@",tempZeilenString);
				}
				[DatenArray addObject:tempZeilenString];
			}
			
			if ([DatenArray count])
			{
				//NSLog(@"openWithString DatenArray sauber: %@",[DatenArray description]);
				//NSLog(@"openWithString DatenArray sauber length: %d",[DatenArray count]);
				//NSLog(@"DatenArray: %@",[[DatenArray objectAtIndex:0]description]);
				NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[NotificationDic setObject:[NSNumber numberWithInt:Tag] forKey:@"datumtag"];
				[NotificationDic setObject:[NSNumber numberWithInt:Monat] forKey:@"datummonat"];
				[NotificationDic setObject:[NSNumber numberWithInt:Jahr] forKey:@"datumjahr"];
				[NotificationDic setObject:[ZeitString copy]forKey:@"datumzeit"];
				[NotificationDic setObject:[[StartZeit description] copy]forKey:@"startzeit"];
				[NotificationDic setObject:[DatenArray copy] forKey:@"datenarray"];
				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"externedaten" object:self userInfo:NotificationDic];
				
			}	// if [DatenArray count]
			
		}	// [tempDatenArray count] >11
		
	}
	
	
	
	//} // if count

}//openWithString


- (IBAction)reportOpen:(id)sender
{
	NSLog(@"reportOpen");
	int DataOffset=12;	// erste Zeile der Daten
	NSOpenPanel* OeffnenDialog= [NSOpenPanel openPanel];
	[OeffnenDialog setCanChooseFiles:YES];
	[OeffnenDialog setCanChooseDirectories:NO];
	[OeffnenDialog setAllowsMultipleSelection:NO];
   [OeffnenDialog setAllowedFileTypes:[NSArray arrayWithObjects:@"txt",@"doc",nil]];
    
	NSString* OrderPfad= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TempDaten"];
   [OeffnenDialog  setDirectoryURL:[NSURL fileURLWithPath:OrderPfad isDirectory:YES]];

	//int antwort = [OeffnenDialog runModalForDirectory:OrderPfad file:nil types: [NSArray arrayWithObjects:@"txt",@"doc",nil]];
	//NSLog(@"antwort: %d filenames: %@",antwort, [[OeffnenDialog filenames] description]);
	
	int antwort = [OeffnenDialog runModal];
	
	if ([OeffnenDialog URLs] && [[OeffnenDialog URLs]count])
	{
      NSString* DatenString=[NSString stringWithContentsOfURL:[[OeffnenDialog URLs] objectAtIndex:0] encoding:NSMacOSRomanStringEncoding error:NULL];
	[self openWithString:DatenString];
	
	return;
	} // if count
	
}


#pragma mark solar

-(void)SolarDataDownloadAktion:(NSNotification*)note
{
/*
Ausgeloest von Funktionen in rHomeData:
downloadDidFinish: downloadflag, lastdatazeit, datastring, 
LastSolarData: downloadflag, lastdatazeit, datastring,
SolarDataVon: downloadflag, lastdatazeit, datastring,
SolarDataDownload

*/
	//NSLog(@"SolarDataDownloadAktion: %@",[note userInfo]);
	
	if ([AVR WriteWoche_busy]) // Woche wird noch geschrieben
	{
		return;
	}
	
	int flag=downloadpause;
	NSString* DataString=@"";
	if ([[note userInfo] objectForKey:@"downloadflag"])
	{
		flag=[[[note userInfo] objectForKey:@"downloadflag"]intValue];
	}
	
	if ([[note userInfo] objectForKey:@"datastring"])
	{
		DataString=[[note userInfo] objectForKey:@"datastring"];
	}
		
	//NSLog(@"SolarDataDownloadAktion flag: %d\n DataString: \n%@",flag, DataString);
	//NSLog(@"SolarDataDownloadAktion flag: %d length: %d",flag,[DataString length]);

	switch (flag)
	{
		case heute:
		{
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				lastSolarDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
			}
			else
			{
				lastSolarDataZeit=0;
			}
			
			if ([DataString length])
			{
				// 12.08.09 [self openWithString:DataString];// im Aufruf von DataVonHeute ausgelöst
				/*
				if (![SolarDownloadTimer isValid])
				{
					SolarDownloadTimer=[[NSTimer scheduledTimerWithTimeInterval:12
																					target:self 
																				 selector:@selector(SolarDownloadFunktion:) 
																				 userInfo:nil 
																				  repeats:YES]retain];
					
					
					//NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
					//[runLoop addTimer:DownloadTimer forMode:NSDefaultRunLoopMode];
					
					//[DownloadTimer release];
				}
				*/
			}
			else
			{
				NSLog(@"Kein Input");
			}
			
		}break;
			
		case last:
		{
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[NotificationDic setObject:[NSNumber numberWithInt:lastSolarDataZeit] forKey:@"previouslastdatazeit"];
			int tempLastDataZeit=0;
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				tempLastDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
			}
			//NSLog(@"SolarDataDownloadAktion lastDataZeit: %d tempLastDataZeit: %d",lastDataZeit,tempLastDataZeit);
			if (!(tempLastDataZeit==lastSolarDataZeit))   // nicht jede Serie in Diagramm laden
			{
				//NSLog(@"Neue Daten: neuer DataString: %@",DataString);
				lastSolarDataZeit=tempLastDataZeit;
				
				if ([DataString length])
				{
					NSArray* tempDataArray = [DataString componentsSeparatedByString:@"\n"];
					if ([tempDataArray count])
					{
						//NSLog(@"tempDataArray: %@",[[tempDataArray objectAtIndex:0]description]);
						NSArray* tempZeilenArray=[[tempDataArray objectAtIndex:0]componentsSeparatedByString:@"\t"];
						//NSLog(@"tempZeilenArray: %@",[tempZeilenArray description]);
						
						[NotificationDic setObject:tempZeilenArray forKey:@"lastdatenarray"];
						NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
						[nc postNotificationName:@"lastsolardata" object:self userInfo:NotificationDic];
						
						
						
					}//count
					
					
				}// length
			}
			
			
		}break;//last
			
		case datum:
		{
			NSLog(@"SolarDataDownloadAktion datum");

         
			//if ([DownloadTimer isValid])
			{
				NSLog(@"  SolarDataDownloadAktion DownloadTimer invalidate");

				[DownloadTimer invalidate];
            DownloadTimer = nil;
			}
			
			if ([[note userInfo] objectForKey:@"lastdatazeit"])
			{
				lastSolarDataZeit=[[[note userInfo] objectForKey:@"lastdatazeit"]intValue];
			}
			else
			{
				lastSolarDataZeit=0;
			}
			
			if ([DataString length])
			{
				[Data reportSolarClear:NULL];
	//			[self openWithString:DataString];
			}
		}//datum
			
	}//switch flag
	
	flag=downloadpause;
}


- (void)SolarDownloadFunktion:(NSTimer*)derTimer
{
return;
// in DownloadFunktion verschoben
	NSLog(@"DownloadTimer SolarDownloadFunktion");
	
	NSString* AktuelleDaten=[HomeData LastSolarData];
	NSLog(@"SolarDownloadFunktion: AktuelleDaten. %@",AktuelleDaten);
	if (AktuelleDaten == NULL)
	{
		NSLog(@"SolarDownloadFunktion: AktuelleDaten von HomeData ist NULL");
	}
	
}




-(void)openWithSolarString:(NSString*)derDatenString
{
	//NSLog(@"openWithSolarString DatenString length: %d", [derDatenString length]);
	NSArray* rohDatenArray = [NSArray array];
	NSString* TagString = [NSString string];
	int Tag=0;
	int Monat=0;
	int Jahr=0;
	
	NSString* ZeitString = [NSString string];
	NSString* StartDatumString=[NSString string];
	NSCalendarDate* StartZeit= [NSCalendarDate date];

	NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
	char last=[derDatenString characterAtIndex:[derDatenString length]-1];
	//NSLog(@"Letzter Char: %c",last);
	// eventuelle Zeilenschaltung am Ende entfernen

	if (![CharOK characterIsMember:last])
	{
		derDatenString=[derDatenString substringToIndex:[derDatenString length]-1];
	}
	
	if ([derDatenString length])
	{
		//NSLog(@"openWithString DatenString: \n%@",derDatenString);
		NSArray* tempDatenArray= [derDatenString componentsSeparatedByString:@"\n"];
		//	NSArray* tempDatenArray= [DatenString componentsSeparatedByString:@"\r"];
		
		//NSLog(@"openWithString tempDatenArray count: %d",[tempDatenArray count]);
		int DataOffset=12;
		if ([tempDatenArray count] >DataOffset)	// mindestens 1 Data
		{
			
			// Tabellenkopf entfernen: Zeile mit Datum suchen
			DataOffset=0;
			NSEnumerator* DataEnum=[tempDatenArray objectEnumerator];
			id eineZeile;
			while (eineZeile=[DataEnum nextObject])
			{
				DataOffset++;
				//NSLog(@"eineZeile: %@",eineZeile);
				NSRange r=[eineZeile rangeOfString:@"Startzeit:"];
				
				if (!(NSEqualRanges(r,NSMakeRange(NSNotFound,0))))
				{
					//NSLog(@"openWithString bingo: %@",eineZeile);
					break;
				}
			}//while
			//NSLog(@"DataOffset: %d",DataOffset);
			
			//		DataOffset += 3; // Zeile mit Startzeit
			//		DatenArray = [[tempDatenArray subarrayWithRange:NSMakeRange(DataOffset,[tempDatenArray count]-DataOffset)]retain];
			
			NSString* DatumString= [tempDatenArray objectAtIndex:DataOffset-1];
			
			// Eventuellen Leerschlag am Anfang entfernen
			char first=[DatumString characterAtIndex:0];
			if (![CharOK characterIsMember:first])
			{
				DatumString=[DatumString substringFromIndex:1];
			}
			
			
			NSArray* tempDatumArray= [DatumString componentsSeparatedByString:@" "];
			//NSLog(@"openWithSolarString tempDatumArray: %@ count: %d",[tempDatumArray description], [tempDatumArray count]);
			
			switch ([tempDatumArray count])
			{
				case 4:
				{
					TagString=[tempDatumArray objectAtIndex:1];
					ZeitString=[[tempDatumArray objectAtIndex:2]substringWithRange:NSMakeRange(0,5)];
					StartDatumString= [[tempDatenArray objectAtIndex:DataOffset-1]substringFromIndex:11];
					NSString* Kalenderformat=[[NSCalendarDate date]calendarFormat];
					
					StartZeit=[NSCalendarDate dateWithString:StartDatumString calendarFormat:Kalenderformat];
					//NSLog(@"openWithSolarString Format: %@ StartZeit: %@",Kalenderformat,[StartZeit description]);
					Tag=[StartZeit dayOfMonth];
					Monat=[StartZeit monthOfYear];
					Jahr=[StartZeit yearOfCommonEra];
					//NSLog(@"openWithSolarString case 4 StartZeit: %@ tag: %d monat: %d Jahr: %d",[StartZeit description],Tag, Monat, Jahr);
					
				}break;
					
				case 5: // ab 12.3.09
				{
					TagString=[tempDatumArray objectAtIndex:2];
					ZeitString=[[tempDatumArray objectAtIndex:4]substringWithRange:NSMakeRange(0,5)];
					StartDatumString= [[tempDatenArray objectAtIndex:10]substringFromIndex:11];
					int l=[StartDatumString length];
					StartDatumString= [StartDatumString substringToIndex:l-1];
					//NSLog(@"openWithString case 5 StartDatumString 5: *%@*",StartDatumString);
					NSString* Kalenderformat=[[NSCalendarDate date]calendarFormat];
					
					StartZeit=[NSCalendarDate dateWithString:StartDatumString calendarFormat:Kalenderformat];
					//NSLog(@"Format: %@ StartZeit: %@",Kalenderformat,[StartZeit description]);
					//NSLog(@"StartZeit: %@ tag: %d",[StartZeit description],[StartZeit dayOfMonth]);
					
					
				}break;
					
				case 6:	//	vor 12.3.09
				{
					TagString=[tempDatumArray objectAtIndex:3];
					ZeitString=[[tempDatumArray objectAtIndex:5]substringWithRange:NSMakeRange(0,5)];
					
				}break;
					
					
			}	//	switch count
			
			
			//NSLog(@"tempDatenArray count: %d",[tempDatenArray count]);
			//NSLog(@"Tag: %@ Zeit: %@",TagString, ZeitString);
			//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
			
			
//			DataOffset += 2; // Zeile mit Startzeit
			
			rohDatenArray = [tempDatenArray subarrayWithRange:NSMakeRange(DataOffset,[tempDatenArray count]-DataOffset)];
			NSMutableArray* DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
			//NSLog(@"openWithSolarString rohDatenArray count: %d",[rohDatenArray count]);
			int i=0;
			/*
			for (i=0;i<10;i++)

			{
				NSString* tempRohdatenString=[rohDatenArray objectAtIndex:i];
				NSLog(@"i: %d tempRohdatenString: %@",i,tempRohdatenString);
			}
			*/
			for (i=0;i<[rohDatenArray count];i++)
			{
				NSMutableArray* tempDatenArray=[[NSMutableArray alloc]initWithCapacity:0];
				NSString* tempRohdatenString=[rohDatenArray objectAtIndex:i];
				//NSLog(@"tempRohdatenString: %@",tempRohdatenString);
				if ([[rohDatenArray objectAtIndex:i]length])
				{ 
				tempDatenArray = (NSMutableArray*) [[rohDatenArray objectAtIndex:i]componentsSeparatedByString:@"\t"];
				//NSLog(@"tempDatenArray vor add: %@",[tempDatenArray description]);
				while ([tempDatenArray count]<9)
				{
					[tempDatenArray addObject: [NSNumber numberWithInt:0]];
				}
				//NSLog(@"tempDatenArray: %@",[tempDatenArray description]);
				NSString* tempZeilenString= [tempDatenArray componentsJoinedByString:@"\r"];
				if (i==0)
				{
					//NSLog(@"openWithSolarString erster tempZeilenString : \n%@",tempZeilenString);
				}
				[DatenArray addObject:tempZeilenString];
				}
			}
			
			if ([DatenArray count])
			{
				//NSLog(@"openWithSolarString DatenArray sauber: %@",[DatenArray description]);
				//NSLog(@"openWithSolarString DatenArray sauber length: %d",[DatenArray count]);
				//NSLog(@"openWithSolarString DatenArray first: %@",[[DatenArray objectAtIndex:0]description]);
				NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[NotificationDic setObject:[NSNumber numberWithInt:Tag] forKey:@"datumtag"];
				[NotificationDic setObject:[NSNumber numberWithInt:Monat] forKey:@"datummonat"];
				[NotificationDic setObject:[NSNumber numberWithInt:Jahr] forKey:@"datumjahr"];
				[NotificationDic setObject:[ZeitString copy]forKey:@"datumzeit"];
				[NotificationDic setObject:[[StartZeit description] copy]forKey:@"startzeit"];
				[NotificationDic setObject:[DatenArray copy] forKey:@"datenarray"];
				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"externesolardaten" object:self userInfo:NotificationDic];
				
			}	// if [DatenArray count]
			
		}	// [tempDatenArray count] >11
		
	}
	
	//NSLog(@"openWithSolarString end");
	
	//} // if count

}

#pragma mark end solar

- (void)read:(NSTimer*) inTimer
{
    UInt8*		buffer;
    int	 		result = 0;
    int 		reportID = -1;
    NSData*		dataRead;
    IOWarriorListNode* 	listNode;
    int                 reportSize;
	NSMutableArray*	DatenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (nil == listNode) // if there is no interface, exit and don't invoke timer again
        return;
    
    reportSize = [self reportSizeForInterfaceType:listNode->interfaceType];
    if (listNode->interfaceType == kIOWarrior24Interface0 ||
        listNode->interfaceType == kIOWarrior40Interface0)
    {
		
        buffer = malloc (reportSize);
        
        result = IOWarriorReadFromInterface (listNode->ioWarriorHIDInterface, 0, reportSize, buffer);
		
        if (result != 0)
        {
 //           NSRunAlertPanel (@"IOWarrior Error", @"Es gab einen Fehler beim Lesen vom eingesteckten USB-Device.", @"OK", nil, nil);
			
			[Data writeIOWLog:@"IOWFehler: Fehler beim Lesen"];
//			[readTimer invalidate];
//			isReading = YES;

			//[self doRead:self]; // invalidates timer
            return ;
        }
        dataRead = [NSData dataWithBytes:buffer length:reportSize];
		NSString* tempString=[dataRead description];
		//NSLog(@"read: neue Daten da: tempString: %@",tempString);
		if (![dataRead isEqualTo:lastValueRead]) // erste Uebereinstimmung
		{
			anzDataOK = 1;
			[self setLastValueRead:dataRead];
		}
		
		if ([dataRead isEqualTo:lastValueRead] && anzDataOK == 1) // zweite Uebereinstimmung
		{
			//NSLog(@"Gesicherte Daten da: %@",dataRead);
			//			[self setLastValueRead:dataRead];
			anzDataOK=2;
			//		}
			
			//        if (!ignoreDuplicates || (ignoreDuplicates && ![dataRead isEqualTo:lastValueRead]))
			
			if (!ignoreDuplicates || (ignoreDuplicates  && (anzDataOK>=2)))
			{
				//NSLog(@"read: neue Daten da: %d tempString: %@",anzDaten, tempString);
				anzDaten++;
				anzDataOK=0;
				[self addLogEntryWithDirection:kReportDirectionIn
									  reportID:reportID
									reportSize:reportSize
									reportData:buffer];
				//            [self setLastValueRead:dataRead];
				
				// Daten aufbereiten
				const unsigned char *dataBuffer = [dataRead bytes];
				int i;
				
				for (i = 0; i < [dataRead length]; ++i)
				{
					if (!(dataBuffer[0]==0xFF)) // relevante Daten. erstes Byte ist nie FF
					{
						//NSLog(@"i: %d dataBuffer[ i ]: %x",i,dataBuffer[ i ]);
						NSString* tempString=[NSString stringWithFormat:@"%02X", (unsigned long)dataBuffer[ i ]];
						//[tempReportDic setObject:tempString forKey:[bitnummerArray objectAtIndex:i]];
						[DatenArray addObject:tempString];
					}
				}
				if ([DatenArray count])
				{
					//NSLog(@"DatenArray: %@ Mark: %@",[DatenArray description],[DatenArray objectAtIndex:0]);
					NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
					[NotificationDic setObject:[DatenArray copy]forKey:@"datenarray"];
					NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
					[nc postNotificationName:@"read" object:NULL userInfo:NotificationDic];
											
					if ([[NSCalendarDate date]hourOfDay]>oldHour) // Jede Stunde Daten updaten
					{
						//DruckDatenSchreibenMitDatum
						daySaved=NO;
//						[self DruckDatenSchreibenMitDatum:[Data DatenserieStartZeit] ganzerTag:NO];
						oldHour=[[NSCalendarDate date]hourOfDay];
					}
					else if (([[NSCalendarDate date]minuteOfHour]==59) && (oldHour==23) && (daySaved==NO)) //	letzte Min vor Mitternacht, Tag noch nicht gesichert
					{
//						[self DruckDatenSchreibenMitDatum:[Data DatenserieStartZeit] ganzerTag:YES];
						daySaved=YES;	// nur einmal sichern
						newDay=NO;
					}
					else if (([[NSCalendarDate date]hourOfDay]==0) && (oldHour==23) && (newDay==NO)) //	Mitternacht
					{
						newDay=YES;
						[Data clearData];
						
						oldHour=0; // 
					
					}
				}
				
			}	//	if ignoreDuplicates
		}	// id anz==2
	free (buffer);
	}	// if listNode
}

- (int) reportSizeForInterfaceType:(int) inType
/*" Returns the size of an output report written to an interface of type inType exluding size for report id. "*/
{
    int result = 0;
    
    switch (inType)
    {
        case kIOWarrior40Interface0: result = 4; break;
        case kIOWarrior40Interface1: result = 7; break;
        case kIOWarrior24Interface0: result = 2; break;
        case kIOWarrior24Interface1: result = 7; break;
    }
    return result;
}

- (BOOL) reportIdRequiredForWritingToInterfaceOfType:(int) inType
/*" Returns YES if interfaces of type inType can take an report id different from 0 when writing output reports. "*/
{
    BOOL result = NO;
    
    switch (inType)
    {
        case kIOWarrior40Interface0:
        case kIOWarrior24Interface0:
            result = NO;
        break;
            
        case kIOWarrior40Interface1:
        case kIOWarrior24Interface1:
            result = YES;
        break;
    }
    return result;
}

- (int) currentInterfaceType
/*" Returns the type of the currently selected interface. "*/
{
    int selectedInterface = [interfacePopup indexOfSelectedItem];
    
    if (-1 != selectedInterface && (selectedInterface < IOWarriorCountInterfaces ()))
        return (IOWarriorInterfaceListNodeAtIndex (selectedInterface))->interfaceType;
    
    return -1;
}

- (IOWarriorHIDDeviceInterface**) currentInterface
/*" Returns the currently selected interfaces. "*/
{
    int selectedInterface = [interfacePopup indexOfSelectedItem];
    
    if (-1 != selectedInterface && (selectedInterface < IOWarriorCountInterfaces ()))
        return (IOWarriorInterfaceListNodeAtIndex (selectedInterface))->ioWarriorHIDInterface;
    
    return nil;
}

- (IBAction)interfacePopupChanged:(id)sender
{
	
    int currentType = [self currentInterfaceType];
    int newReportSize = [self reportSizeForInterfaceType:currentType];
    int	i;
        
    // disable or enable report data text field and captions
    for (i = 100; i <= 106; i++)
    {
        NSTextField* subview;
        BOOL        state;
        
        if (i < 100 + newReportSize)
            state = YES;
        else
            state = NO;
        
        subview = (NSTextField*)[[window contentView] viewWithTag:i];
        NSAssert (subview, @"could't get subview for tag");
        [subview setEnabled:state];
        if (state)
            [subview setStringValue:@"00"];
        else
            [subview setStringValue:@"--"];
        
        subview = (NSTextField*)[[window contentView] viewWithTag:i + 100];
        NSAssert (subview, @"could't get subview for tag");
        if (state)
            [subview setTextColor:[NSColor blackColor]];
        else
            [subview setTextColor:[NSColor grayColor]];
    }
    [reportIDField setEnabled: ([self reportIdRequiredForWritingToInterfaceOfType:currentType] ? YES : NO)];
}

- (void) addLogEntryWithDirection:(NSString*) inDirection reportID:(int) inReportID reportSize:(int) inSize reportData:(UInt8*) inData
{
    NSDictionary *entry;

    entry = [IOWarriorWindowController logEntryWithDirection:inDirection
                                                    reportID:inReportID
                                                  reportSize:inSize
                                                  reportData:inData
                                                        name:@""];
    [logEntries addObject:entry];
    [logTable reloadData];
    [logTable scrollRowToVisible:[logEntries count] - 1];
	

	
	
}

+ (NSDictionary*) logEntryWithDirection:(NSString*) inDirection reportID:(int) inReportID reportSize:(int) inSize reportData:(UInt8*) inData
                                   name:(NSString*) inName;
{
    NSMutableDictionary *entry;

    entry = [NSMutableDictionary dictionary];
    [entry setObject:inDirection forKey:kReportDirectionKey];
    [entry setObject:[NSNumber numberWithInt:inReportID] forKey:kReportIDKey];
    [entry setObject:[NSData dataWithBytes:inData length:inSize] forKey:kReportDataKey];
    [entry setObject:inName forKey:kMacroNameKey];

    return [NSDictionary dictionaryWithDictionary:entry];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [logEntries count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
    NSDictionary* entry = [logEntries objectAtIndex:rowIndex];
    id 		result;
    int		reportID = [[entry objectForKey:kReportIDKey] intValue];
    id		rowIdentifier = [aTableColumn identifier];

    if (nil != (result = [entry objectForKey:rowIdentifier]))
    {
        if ([rowIdentifier isEqualTo:kReportIDKey] && reportID == -1)
            return @"";
        else if ([rowIdentifier isEqualTo:kReportIDKey])
            return [NSString stringWithFormat:@"0x%02x", reportID];
        else
            return result;
    }
    else
    {
        NSData* data = [entry objectForKey:kReportDataKey];
        char*	buffer = (char*) [data bytes];
        int	byteOffset = [rowIdentifier intValue];

        if (reportID != -1 || byteOffset < 4)
            return [NSString stringWithFormat:@"0x%02x", (UInt8) buffer[byteOffset]];
        else
            return @"";
    }
}

- (void)logTableDoubleClicked
{
    int index = [logTable selectedRow];

    if (-1 != index)
    {
        NSDictionary* logEntry = [logEntries objectAtIndex:index];

        [self updateInterfaceFromLogEntry:logEntry];
    }
}

- (void) updateInterfaceFromLogEntry:(NSDictionary*) inLogEntry
{
    if ([[inLogEntry objectForKey:kReportDirectionKey] isEqualTo:kReportDirectionOut])
    {
        int 	reportID = [[inLogEntry objectForKey:kReportIDKey] intValue];
        NSData* reportData = [inLogEntry objectForKey:kReportDataKey];
        int	i;
        UInt8* 	bytes = (UInt8*) [reportData bytes];
        
        if (reportID != -1)
        {
            [reportIDField setStringValue:[NSString stringWithFormat:@"%02x",reportID]];
        }
        for (i = 0; i < ((reportID == -1)?4:7); i++)
        {
            NSControl* theSubview;
            
            theSubview = (NSControl*) [[window contentView] viewWithTag:i + 100];
            [theSubview setStringValue:[NSString stringWithFormat:@"%02x",bytes[i]]];
        }
    }
}

- (void) setLastValueRead:(NSData*) inData
{
   
    lastValueRead = inData;
}

- (void) setNewDump
{
	NSDictionary* tempReportDic=[NSDictionary dictionaryWithObject:@"" forKey:@"n"];
	NSArray* tempDumpArray=[NSArray arrayWithObject:tempReportDic];
	[Dump_DS setDumpTabelle: tempDumpArray];
	//[dumpTable reloadData];


}

- (void) setDump:(NSArray*)derDatenArray
{
	if ([[derDatenArray objectAtIndex:0]intValue]==3)
	{

	NSArray* bitnummerArray=[NSArray arrayWithObjects: @"report", @"anz", @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];
	//		NSMutableArray* tempKesselArray=[[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableDictionary* tempReportDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	NSMutableArray* tempDumpArray=[[NSMutableArray alloc]initWithCapacity:0];
	int k,anz;
	anz=[derDatenArray count];
	for (k=0;k<anz;k++)
	{
		
		NSString* tempString=[derDatenArray objectAtIndex:k];
		//NSString* tempString=[NSString stringWithFormat:@"%02X",[[derDatenArray objectAtIndex:k]intValue]];
		[tempReportDic setObject:tempString forKey:[bitnummerArray objectAtIndex:k]];
		
	}
	NSString* nummerString=[NSString stringWithFormat:@"%02X",dumpCounter];
	dumpCounter++;
	[tempReportDic setObject:nummerString forKey:@"n"];
	[tempDumpArray addObject:tempReportDic];
	//NSLog(@"setDump tempReportDic: %@",[tempReportDic description]);
	//[dumpTabelle addObject:tempReportDic];
	[Dump_DS setDumpTabelle: tempDumpArray];
	[dumpTable reloadData];
	}
}

- (void) setWriteDump:(NSArray*)derDatenArray
{
	if ([[derDatenArray objectAtIndex:0]intValue]==2)
	{

	NSArray* bitnummerArray=[NSArray arrayWithObjects: @"report", @"anz", @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];
	//		NSMutableArray* tempKesselArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableDictionary* tempReportDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	NSMutableArray* tempDumpArray=[[NSMutableArray alloc]initWithCapacity:0];
	int k,anz;
	anz=[derDatenArray count];
	for (k=0;k<anz;k++)
	{
		
		NSString* tempString=[NSString stringWithFormat:@"%02X",[[derDatenArray objectAtIndex:k]intValue]];
		//NSString* tempString=[derDatenArray objectAtIndex:k];
		[tempReportDic setObject:tempString forKey:[bitnummerArray objectAtIndex:k]];
		
	}
	NSString* nummerString=[NSString stringWithFormat:@"%02X",dumpCounter];
	dumpCounter++;
	[tempReportDic setObject:nummerString forKey:@"n"];
	[tempDumpArray addObject:tempReportDic];
	//NSLog(@"setDump tempReportDic: %@",[tempReportDic description]);
	//[dumpTabelle addObject:tempReportDic];
	[Dump_DS setDumpTabelle: tempDumpArray];
	[dumpTable reloadData];
	}
}

- (IBAction)clearLogEntries:(id)sender
{
	anzDaten=0;
    [logEntries removeAllObjects];
    [logTable reloadData];
}

/*" Invoked by the runtime system before a message is sent to any object of the class. Initializes default preferences. "*/
+ (void) initialize
{
    NSMutableDictionary* 	defaultValues;
    NSMutableArray*		defaultMacros;
    NSDictionary*		entry;
    UInt8			buffer[7];
    
    
    defaultValues = [NSMutableDictionary dictionary];
    defaultMacros = [NSMutableArray array];

    // Enable LCD mode macro
    bzero (buffer, 7);
    buffer[0] = 1;
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                       reportID:4
                     reportSize:7
                     reportData:buffer
                           name:@"Enable LCD Mode"];
    [defaultMacros addObject:entry];

    // Init display macro
    bzero (buffer, 7);
    buffer[0] = 0x03;
    buffer[1] = 0x38;
    buffer[2] = 0x01;
    buffer[3] = 0x0F;
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                               reportID:5
                             reportSize:7
                             reportData:buffer
                                   name:@"Init display"];
    [defaultMacros addObject:entry];

    // Write to display macro
    bzero (buffer, 7);
    buffer[0] = 0x84;
    buffer[1] = 'T';
    buffer[2] = 'e';
    buffer[3] = 's';
    buffer[4] = 't';
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                               reportID:5
                             reportSize:7
                             reportData:buffer
                                   name:@"Write to display"];
    [defaultMacros addObject:entry];
    
    // Move to display start macro
    bzero (buffer, 7);
    buffer[0] = 0x01;
    buffer[1] = 0x80;
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                                                    reportID:5
                                                  reportSize:7
                                                  reportData:buffer
                                                        name:@"Move to first LCD pos."];
    [defaultMacros addObject:entry];

    // Read from 4 bytes from display macro
    bzero (buffer, 7);
    buffer[0] = 0x84;
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                                                    reportID:6
                                                  reportSize:7
                                                  reportData:buffer
                                                        name:@"Read 4 bytes from LCD"];
    [defaultMacros addObject:entry];
    // Enable Infra red reception (IOWarrior 24)
    bzero (buffer, 7);
    buffer[0] = 0x01;
    entry = [IOWarriorWindowController logEntryWithDirection:kReportDirectionOut
                                                    reportID:0x0C
                                                  reportSize:7
                                                  reportData:buffer
                                                        name:@"Enable Infra red reception (IOWarrior 24)"];
    
    [defaultMacros addObject:entry];
    
    
    [defaultValues setObject:[NSArray arrayWithArray:defaultMacros] forKey:kDefaultMacrosKey];

    [[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

/*" Invoked when macro popup changes. Fills in macro data into current gui. "*/
- (IBAction)macroPopupChanged:(id)sender
{
    int 		index = [macroPopup indexOfSelectedItem];
    NSUserDefaults* 	defaults = [NSUserDefaults standardUserDefaults];
    NSArray*		macros = [defaults objectForKey:kDefaultMacrosKey];

    [self updateInterfaceFromLogEntry:[macros objectAtIndex:index]];
}

- (IBAction)addMacro:(id)sender
{
    int index;

    index = [logTable selectedRow];
    if (-1 != index)
    {
        NSDictionary* 	logEntry = [logEntries objectAtIndex:index];
        

        if ([[logEntry objectForKey:kReportDirectionKey] isEqualTo:kReportDirectionOut])
        {
            NSString*	macroName = [MacroNamePanelController chooseMacroName];
            if (nil != macroName)
            {
                NSUserDefaults* 	defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray*		macros = [NSMutableArray arrayWithArray:[defaults objectForKey:kDefaultMacrosKey]];
                NSMutableDictionary*	newMacro = [NSMutableDictionary dictionaryWithDictionary:logEntry];
    
                [newMacro setObject:macroName forKey:kMacroNameKey];
                [macros addObject:[NSDictionary dictionaryWithDictionary:newMacro]];
                [defaults removeObjectForKey:kDefaultMacrosKey];
                [defaults setObject:[NSArray arrayWithArray:macros] forKey:kDefaultMacrosKey];
                [self updateMacroPopup];
            }
        }
    }
}

- (IBAction)deleteMacro:(id)sender
{
    int	index;

    index = [macroPopup indexOfSelectedItem];
    if (index > 0)
    {
        NSUserDefaults* 	defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray*		macros = [NSMutableArray arrayWithArray:[defaults objectForKey:kDefaultMacrosKey]];

        [macros removeObjectAtIndex:index];
        [defaults removeObjectForKey:kDefaultMacrosKey];
        [defaults setObject:[NSArray arrayWithArray:macros] forKey:kDefaultMacrosKey];
        [self updateMacroPopup];
    }
}

- (void) updateMacroPopup
{
    NSUserDefaults*	defaults = [NSUserDefaults standardUserDefaults];
    NSArray*		macros = [defaults objectForKey:kDefaultMacrosKey];
    int			i;

    [macroPopup removeAllItems];
    for (i = 0; i < [macros count]; i++)
    {
        NSDictionary *macro = [macros objectAtIndex:i];

        [macroPopup addItemWithTitle:[macro objectForKey:kMacroNameKey]];
    }    
}

- (IBAction)resetReportValues:(id)sender
{
    int i;
    
    for (i = 0 ; i < 7 ; i++)
    {
        NSControl *theSubview;

        theSubview = (NSControl*) [[window contentView] viewWithTag:i + 100];
        [theSubview setStringValue:@"00"];
    }
}

- (IBAction)duplicateCheckboxClicked:(id)sender
{
    ignoreDuplicates = [ignoreDuplicatesCheckBox state];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if (-1 == [logTable selectedRow]) // nothing selected
    {
        [addMacroButton setEnabled:NO];
    }
    else // log entry selected
    {
        [addMacroButton setEnabled:YES];
    }
}

- (void)readPList
{
	BOOL USBDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/USBInterfaceDaten"];
	USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    HomeSndCalcVolume: %@",[HomeSndCalcPfad description]);	
	if (USBDatenDa)
	{
		
		//NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);
		
		NSString* PListName=@"USBInteface.plist";
		NSString* PListPfad;
		//NSLog(@"\n\n");
		PListPfad=[USBPfad stringByAppendingPathComponent:PListName];
		NSLog(@"awake: PListPfad: %@ ",PListPfad);
		if (PListPfad)		
		{
			NSMutableDictionary* tempPListDic;//=[[NSMutableDictionary alloc]initWithCapacity:0];
			if ([Filemanager fileExistsAtPath:PListPfad])
			{
				tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
				//NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);

				if ([tempPListDic objectForKey:@"lasttabindex"])
				{
					int lastTabIndex=[[tempPListDic objectForKey:@"lasttabindex"]intValue];
					[ADWandler setTabIndex:lastTabIndex];
				}
				if ([tempPListDic objectForKey:@"lastinterface"])
				{
					int lastInterfaceNummer=[[tempPListDic objectForKey:@"lastinterface"]intValue];
					[ADWandler setInterfaceNummer:lastInterfaceNummer];
				}

				if ([tempPListDic objectForKey:@"lastinterface"])
				{
					int EinkanalWahlTastensegment=[[tempPListDic objectForKey:@"einkanaltastensegment"]intValue];
					[ADWandler setEinkanalWahlTaste:EinkanalWahlTastensegment];

				}
				if ([tempPListDic objectForKey:@"mehrkanaltastenarray"])
				{
					NSArray* MehrkanalTastenArray=[tempPListDic objectForKey:@"mehrkanaltastenarray"];
					[ADWandler setMehrkanalWahlTasteMitArray:MehrkanalTastenArray];

				}
				
				
				
			}
			
		}
		//	NSLog(@"PListOK: %d",PListOK);
		
	}//USBDatenDa
}

- (void)savePListAktion:(NSNotification*)note
{
	BOOL USBDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/USBInterfaceDaten"];
	USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    HomeSndCalcVolume: %@",[HomeSndCalcPfad description]);	
	if (USBDatenDa)
	{
		;
	}
	else
	{
      BOOL OrdnerOK=[Filemanager createDirectoryAtPath:USBPfad withIntermediateDirectories:NO attributes:NULL error:NULL];
		//BOOL OrdnerOK=[Filemanager createDirectoryAtPath:USBPfad attributes:NULL];
		//Datenordner ist noch leer
		
	}
	
	
	
	//	NSLog(@"savePListAktion: PListDic: %@",[PListDic description]);
	//	NSLog(@"savePListAktion: PListDic: Testarray:  %@",[[PListDic objectForKey:@"testarray"]description]);
	NSString* PListName=@"USBInteface.plist";
	
	NSString* PListPfad;
	//NSLog(@"\n\n");
	//NSLog(@"savePListAktion: SndCalcPfad: %@ ",SndCalcPfad);
	PListPfad=[USBPfad stringByAppendingPathComponent:PListName];
	//	NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
	if (PListPfad)
		
	{
		NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
		
		NSMutableDictionary* tempPListDic;//=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSFileManager *Filemanager=[NSFileManager defaultManager];
		if ([Filemanager fileExistsAtPath:PListPfad])
		{
			tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
			//NSLog(@"savePListAktion: vorhandener PListDic: %@",[tempPListDic description]);
		}
		
		else
		{
			tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			NSLog(@"savePListAktion: neuer PListDic");
		}
		if ([ADWandler lastTabIndex])
		{
			[tempPListDic setObject:[NSNumber numberWithInt:[ADWandler lastTabIndex]] forKey:@"lasttabindex"];
		}
		//[tempPListDic setObject:[NSNumber numberWithInt:AnzahlAufgaben] forKey:@"anzahlaufgaben"];
		//[tempPListDic setObject:[NSNumber numberWithInt:MaximalZeit] forKey:@"zeit"];
		if ([ADWandler lastInterfaceNummer])
		{
			[tempPListDic setObject:[NSNumber numberWithInt:[ADWandler lastInterfaceNummer]] forKey:@"lastinterface"];
		}
		//[tempPListDic setObject:[NSNumber numberWithInt:[ADWandler lastTabIndex]] forKey:@"lasttabindex"];
		if ([ADWandler EinkanalWahlTastensegment])
		{
			[tempPListDic setObject:[NSNumber numberWithInt:[ADWandler EinkanalWahlTastensegment]]forKey:@"einkanaltastensegment"];
		}
		if ([ADWandler MehrkanalTastenArray])
		{
			[tempPListDic setObject:[ADWandler MehrkanalTastenArray] forKey:@"mehrkanaltastenarray"];
		}
		//NSLog(@"savePListAktion: gesicherter PListDic: %@",[tempPListDic description]);
		
		BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
		
	}
	//	NSLog(@"PListOK: %d",PListOK);
	
	//[tempUserInfo release];
}

- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"IOW windowShouldClose");
/*	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];

	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];

*/
	if ([AVR TWIStatus])
	{
      return YES;
	}
	else 
	{
      return NO;
	}

	//return YES;
}

-(void)DruckDatenSchreibenMitDatum:(NSCalendarDate*)dasDatum ganzerTag:(int)ganz
{
	BOOL USBDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/USBInterfaceDaten"];
	USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    HomeSndCalcVolume: %@",[HomeSndCalcPfad description]);	
	if (USBDatenDa)
	{
		;
	}
	else
	{
      BOOL OrdnerOK=[Filemanager createDirectoryAtPath:USBPfad withIntermediateDirectories:NO attributes:NULL error:NULL];

		//BOOL OrdnerOK=[Filemanager createDirectoryAtPath:USBPfad attributes:NULL];
		//Datenordner ist noch leer
		
	}
	
	//NSCalendarDate* SaveDatum=[NSCalendarDate date];
	int jahr=[dasDatum yearOfCommonEra];
	NSRange jahrRange=NSMakeRange(2,2);
	NSString* jahrString=[[[NSNumber numberWithInt:jahr]stringValue]substringWithRange:jahrRange];
	int monat=[dasDatum monthOfYear];
	NSString* monatString;
	if (monat<10)
	{
		monatString=[NSString stringWithFormat:@"0%d",monat];;
	}
	else
	{
		monatString=[NSString stringWithFormat:@"%d",monat];;
	}
	
	
	
	//NSString* monatString=[[NSNumber numberWithInt:monat]stringValue];
	
	int tagdesmonats=[dasDatum dayOfMonth];
	
	//	Test
	/*
	if (ganz)
	{
	
	old++;
	
	}
	tag+=old;
	*/
	// end Test
	
	NSString* tagString;
	if (tagdesmonats<10)
	{
		//[NSString stringWithFormat:@"0%d",Brennsekunden];
		tagString=[NSString stringWithFormat:@"0%d",tagdesmonats];;
	}
	else
	{
		//NSString* tagString=[[NSNumber numberWithInt:tag]stringValue];
		tagString=[NSString stringWithFormat:@"%d",tagdesmonats];;
	}
	int stunde=[dasDatum hourOfDay];
	NSString* stundeString=[[NSNumber numberWithInt:stunde]stringValue];
	int minute=[dasDatum minuteOfHour];
	NSString* minuteString=[[NSNumber numberWithInt:minute]stringValue];
	
	NSString* DocOrdnerName=@"Druckdaten";
	
	NSString* DocOrdnerPfad;
	//NSLog(@"\n\n");
	//NSLog(@"savePListAktion: SndCalcPfad: %@ ",SndCalcPfad);
	DocOrdnerPfad=[USBPfad stringByAppendingPathComponent:DocOrdnerName];
	//NSLog(@"DruckDatenSchreiben: DocOrdnerPfad: %@ ",DocOrdnerPfad);
	if (!([Filemanager fileExistsAtPath:DocOrdnerPfad isDirectory:&istOrdner]&&istOrdner))
	{
      BOOL OrdnerOK=[Filemanager createDirectoryAtPath:DocOrdnerPfad withIntermediateDirectories:NO attributes:NULL error:NULL];

		//BOOL OrdnerOK=[Filemanager createDirectoryAtPath:DocOrdnerPfad attributes:NULL];
		if (OrdnerOK==0)
		{
			NSLog(@"Ordner an DocOrdnerPfad failed: %@",DocOrdnerPfad);
			return;
		}
		
	}
	
	if ([Filemanager fileExistsAtPath:DocOrdnerPfad isDirectory:&istOrdner]&&istOrdner)
	{
		//NSLog(@"\r\r\r\r\rDruckdatenschreiben: DocOrdnerPfad: %@ ",DocOrdnerPfad);
		
		//NSString* DatumString=[NSString stringWithFormat:@"%@_%@_%@_%@_%@_",monatString,tagString,jahrString,stundeString,minuteString];
		NSString* DatumString=[NSString stringWithFormat:@"%@_%@_%@",monatString,tagString,jahrString];
		//NSString* dailyFolderName=[DatumString stringByAppendingString:@"Tagesdaten"];
		NSString* dailyFolderPfad=[DocOrdnerPfad stringByAppendingPathComponent:DatumString];
		if (!([Filemanager fileExistsAtPath:dailyFolderPfad isDirectory:&istOrdner]&&istOrdner))
		{
			//NSLog(@"dailyFolder noch nicht da: dailyFolderPfad: %@",dailyFolderPfad);
         BOOL OrdnerOK=[Filemanager createDirectoryAtPath:dailyFolderPfad withIntermediateDirectories:NO attributes:NULL error:NULL];

         //BOOL OrdnerOK=[Filemanager createDirectoryAtPath:dailyFolderPfad attributes:NULL];
			anzSessionFiles=0; // noch keine Files fuer diese Stunde
			if (OrdnerOK==0)
			{
				NSLog(@"Ordner an dailyFolderPfad failed: %@",dailyFolderPfad);
				return;
			}
		}
		else
		{
			//NSLog(@"dailyFolder schon da: dailyFolderPfad: %@",dailyFolderPfad);
		}			

		
		NSMutableArray* tempTagesFilesArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:dailyFolderPfad error:NULL];
		//NSLog(@"TagesFiles roh: %@",[tempTagesFilesArray description]);
		if (tempTagesFilesArray)
		{
			
			[tempTagesFilesArray removeObject:@".DS_Store"];
			
		}
		int anzTagesFiles=[tempTagesFilesArray count];
		//NSLog(@"TagesFiles: %@ Pfad: %@ anzTagesFiles: %d",[tempTagesFilesArray description],dailyFolderPfad,anzTagesFiles);
		NSString* DocPfad;
		
		if (anzSessionFiles == 0) // Noch kein File in dieser Session gesichert
		{
			
			NSString* DocName=[NSString stringWithFormat:@"%@_%d_%@",DatumString,anzTagesFiles,@"Temperaturdaten.txt"];
			//NSString* DocName=[NSString stringWithFormat:@"%@_%d_%@",DatumString,anzTagesFiles,@"Temperaturdaten.txt"];
			//NSString* DocName=[DatumString stringByAppendingString:@"Temperaturdaten.txt"];
			DocPfad=[dailyFolderPfad stringByAppendingPathComponent:DocName];
			//NSLog(@"erstes File in Session: DocPfad: %@",DocPfad);
			anzSessionFiles++;
		}
		else
		{
			NSString* DocName=[NSString stringWithFormat:@"%@_%d_%@",DatumString,anzTagesFiles-1,@"Temperaturdaten.txt"];
			//NSString* DocName=[NSString stringWithFormat:@"%@_%d_%@",DatumString,anzTagesFiles-1,@"Temperaturdaten.txt"];
			//NSString* DocName=[DatumString stringByAppendingString:@"Temperaturdaten.txt"];
			DocPfad=[dailyFolderPfad stringByAppendingPathComponent:DocName];
			//NSLog(@"bestehendes File in Session: DocPfad: %@",DocPfad);
			
		}
		
		
		if ([Filemanager fileExistsAtPath:DocPfad])	// schon ein File mit dem gleichen Zeitstempel da
		{
			NSLog(@"Bestehendes Doc");
			//[Filemanager removeFileAtPath:DocPfad handler:NULL];
			//NSArray* tempTextArray=[[[Data DruckDatenView]string]componentsSeparatedByString:@"\r"];
			//NSLog(@"tempTextArray: %@",[tempTextArray description]);
			//NSLog(@"Bestehendes Doc  textStorage length: %d",[[[Data DruckDatenView] textStorage] length]);
			NSRange SaveRange=NSMakeRange(0,[[[Data DruckDatenView] textStorage] length]);
			//NSTextView* DruckView=[[Data DruckDatenView] RTFFromRange:SaveRange];
			BOOL writeOK=[[[Data DruckDatenView] RTFFromRange:SaveRange] writeToFile:DocPfad  atomically:YES]; // Schreiben als NSData*
			NSLog(@"Bestehendes Doc writeOK: %d",writeOK);
			
		}
		else
		{
			//NSLog(@"Neues Doc");
			//DatumString=[NSString stringWithFormat:@"%@_%@",DatumString, minuteString];	// Docname mit Minute
			//NSString* neuerDocName=[DatumString stringByAppendingString:@"Temperaturdaten.txt"];
			//NSString* neuerDocPfad=[DocOrdnerPfad stringByAppendingPathComponent:DocName];
			//NSLog(@"Neues Doc  textStorage length: %d",[[[Data DruckDatenView] textStorage] length]);
			
			NSRange SaveRange=NSMakeRange(0,[[[Data DruckDatenView] textStorage] length]);
			//NSTextView* DruckView=[[Data DruckDatenView] RTFFromRange:SaveRange];
			BOOL writeOK=[[[Data DruckDatenView] RTFFromRange:SaveRange] writeToFile:DocPfad  atomically:YES]; // Schreiben als NSData*
			//NSLog(@"Neues Doc writeOK: %d",writeOK);
			
			
			
		}
		
		
		
		
	}
	
	
}

- (BOOL)Beenden
{

	if (beendet)
	{
		return NO;
	}
	NSLog(@"Beenden");
	if ([AVR TWIStatus] == 0) // Homebus noch deaktiviert
	{
			NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus ist deaktiviert!"]];
		
		NSString* s1=@"Der Homebus muss aktiviert sein, um beenden zu koennen.";
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		return NO;

	
	}
	[self savePListAktion:NULL];
	if ([Data Datenquelle]==0)	// Daten von IOW
	{
		[self DruckDatenSchreibenMitDatum:[NSCalendarDate date] ganzerTag:NO];
	}
	//NSLog(@"Beenden vor saveErrString");
	BOOL saveOK=[Data saveErrString];
	beendet=1;
	return YES;
}


- (BOOL) FensterWirdSchliessenAktion:(NSNotification*)note
{
	NSLog(@"IOW FensterWirdSchliessenAktion: %@ anz Window: %d",[[note object]description],[[NSApp windows]count]);
	return NO;
}


- (void) FensterSchliessenAktion:(NSNotification*)note
{
	//NSLog(@"IOW FensterSchliessenAktion: %@ titel: %@ anz Window: %d",[[note object]description],[[note object]title],[[NSApp windows]count]);
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
/*
	[nc removeObserver:self
			 selector:@selector(FensterSchliessenAktion:)
				  name:@"NSWindowWillCloseNotification"
				object:nil];
*/

	if ([[[note object]title]isEqualToString:@"Einstellungen"])
	{
		return;
	}
	else if ([self Beenden] )
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		[NSApp terminate:self];
		
	}
	return;
   
}


- (void)BeendenAktion:(NSNotification*)note
{
	NSLog(@"BeendenAktion");
	if ([[note userInfo]objectForKey:@"quelle"])
   {
      switch ([[[note userInfo]objectForKey:@"quelle"]intValue])
      {
            case 1:
         {
            
         }break;
         default:
         {
            [self terminate:self];
         }
      }
      
   }
   else
   {
      [self terminate:self];
   }
	

}


- (IBAction)terminate:(id)sender
{
	BOOL OK=[self Beenden];
	NSLog(@"terminate OK: %d",OK);
	if (OK)
	{
		[NSApp terminate:self];
		
	}
	


}


@end

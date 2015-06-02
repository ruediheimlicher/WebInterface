//
//  rAVRController.m
//  USBInterface
//
//  Created by Sysadmin on 12.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "IOWarriorWindowController.h"


@implementation IOWarriorWindowController(rAVRController)

- (IBAction)showAVR:(id)sender
{
	//NSLog(@"AVR showAVR");
	//	[self Alert:@"showAVR start init"];
	if (!AVR)
	{
		//[self Alert:@"showAVR vor init"];
		//NSLog(@"showAVR");
		//[EinstellungenFenster showWindow:NULL];

		AVR=[[rAVR alloc]init];
		//[self Alert:@"showAVR nach init"];
	}
	//[self Alert:@"showAVR nach init"];
	//	NSMutableArray* 
	//	if ([AVR window]) ;
	
	//	[self Alert:@"showAVR window da"];
	[AVR showWindow:NULL];
	beendet=0;
	// [self Alert:@"showAVR nach showWindow"];
	if (IOWarriorIsPresent ())
	{
		//	NSArray* HexStringArray=[NSArray arrayWithObjects:@"9F",@"FF",nil];
		//	[self WriteHexStringArray: HexStringArray];
	}
	
}

- (void)sendCmdAktion:(NSNotification*)note
{
	NSLog(@"sendCmdAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"hexstringarray"])
	{
	NSMutableArray* HexStringArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"hexstringarray"]];
	
	
//	NSArray* HexStringArray=[NSArray arrayWithObjects:@"9F",@"FF",nil];

      
	[self WriteHexStringArray: HexStringArray];
	
	}

}



- (IBAction)InitI2C:(id)sender

{
	char*                           buffer;
	int                             i;
	int                             result = 0;
	int                             reportID = 1;
	IOWarriorListNode*              listNode;
	int                             reportSize;
	NSString*	kReportDirectionIn=@"R";
	NSString*	kReportDirectionOut=@"W";
	/*
	if (NO == IOWarriorIsPresent ())
	{
		NSRunAlertPanel (@"Kein IOWarrior gefunden", @"Es ist kein Interface eingesteckt.", @"OK", nil, nil);
		[NSApp terminate:self];
		return;
	}
	*/
	[interfacePopup selectItemAtIndex:1];
	[self interfacePopupChanged:self];
	reportSize = [self reportSizeForInterfaceType:[self currentInterfaceType]];
	//NSLog(@"InitI2C: reportSize: %d",reportSize);
	buffer = malloc (reportSize);
	buffer[0]=0x01;
	buffer[1]=0x01;
	for (i = 2 ; i < reportSize ; i++)
	{
		buffer[i]=0x00;
	}
	/*
	 for (i = 0 ; i < reportSize ; i++)
	 {
	 NSLog(@" buffer: %x",buffer[i]);
	 }
	 */
	[self startReading];
	listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
	//NSLog(@"doWrite listNode: %d",listNode);
	if (listNode)
	{
		
		result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize+1, buffer);
		if (0 != result)
		{
			NSRunAlertPanel (@"IOWarrior Error in InitI2C", @"An error occured while trying to write to the selected IOWarrior device.", @"OK", nil, nil);
			[NSApp terminate:self];
			return;
		}
		else
		{
			//NSLog(@"InitI2C: ");
			[self addLogEntryWithDirection:kReportDirectionOut
										 reportID:reportID
									  reportSize:reportSize
									  reportData:buffer];
		}
		
		
	}
	
	free (buffer);
	
}


- (IBAction)ResetI2C:(id)sender
{
    char*                           buffer;
    int                             i;
    int                             result = 0;
    int                             reportID = 1;
    IOWarriorListNode*              listNode;
    int                             reportSize;
	NSString*	kReportDirectionIn=@"R";
	NSString*	kReportDirectionOut=@"W";
	/*
    if (NO == IOWarriorIsPresent ())
    {
        NSRunAlertPanel (@"Kein IOWarrior gefunden", @"Es ist kein Interface eingesteckt.", @"OK", nil, nil);
		[NSApp terminate:self];
		return;
    }
	 */
	[interfacePopup selectItemAtIndex:1];
	[self interfacePopupChanged:self];
    reportSize = [self reportSizeForInterfaceType:[self currentInterfaceType]];
	//NSLog(@"resetI2C: reportSize: %d",reportSize);
    buffer = malloc (reportSize);
	buffer[0]=0x01;
	buffer[1]=0x00;
	for (i = 2 ; i < reportSize ; i++)
	{
		buffer[i]=0x00;
	}
	for (i = 0 ; i < reportSize ; i++)
	{
		//NSLog(@" buffer: %d",buffer[i]);
	}
	
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
	//NSLog(@"doWrite listNode: %d",listNode);
	if (listNode)
    {
		
		result = IOWarriorWriteToInterface (listNode->ioWarriorHIDInterface, reportSize+1, buffer);
		if (0 != result)
		{
            NSRunAlertPanel (@"IOWarrior Error in ResetI2C", @"An error occured while trying to write to the selected IOWarrior device.", @"OK", nil, nil);
			[NSApp terminate:self];
			return;
		}
        else
        {
			//NSLog(@"resetI2C: ");
            [self addLogEntryWithDirection:kReportDirectionOut
								  reportID:reportID
                                reportSize:reportSize
                                reportData:buffer];
        }
		
		
	}
	
    free (buffer);
}

- (void)twiStatusAktion:(NSNotification*)note
{
	NSLog(@"AVRController twiStatusAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"status"])
	{
		switch ([[[note userInfo]objectForKey:@"status"] intValue]) 
		{
			case 0: //	TWI wird ausgeschaltet
			{
				//	Port 0: Bit 0-3 auf FF setzen (Eingaenge). 
				//	Bit 7 auf L setzen: AVR anzeigen, das TWI ausgeschaltet werden soll 
				//	Bit 6 auf H setzen: warten bis AVR das Bit auf L zieht (TWI ausgeschaltet)
				//	Port 1: FF setzen (Eingaenge)
				NSArray* startHexStringArray=[NSArray arrayWithObjects:@"4F",@"FF",nil];//27.10.08
//				NSArray* startHexStringArray=[NSArray arrayWithObjects:@"1F",@"FF",nil];
				[self WriteHexStringArray:startHexStringArray];
				
				NSMutableDictionary* twiInfoDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				
				//[twiInfoDic setObject:tempEEPROMArray forKey:@"pagearray"];
				
				// Timer fuer die Reaktion des AVR auf das Setzen des TWI-Bits
				
				NSDate *now = [[NSDate alloc] init];
				NSTimer* TWITimer =[[NSTimer alloc] initWithFireDate:now
															interval:0.1
															  target:self 
															selector:@selector(twiStatusTimerAktion:) 
															userInfo:twiInfoDic
															 repeats:YES];
				
//				NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//				[runLoop addTimer:TWITimer forMode:NSDefaultRunLoopMode];
				
				[TWITimer release];
				[now release];
				
				
			}break;
				
			case 1: //TWI wird wieder eingeschaltet
			{
				[self ResetI2C:NULL];
				[interfacePopup selectItemAtIndex:0];
				[self interfacePopupChanged:self];
				NSArray* startHexStringArray=[NSArray arrayWithObjects:@"CF",@"FF",nil];
				[self WriteHexStringArray:startHexStringArray];
				
				
			}break;
		}//switch
	} // if note
}

- (void)twiStatusTimerAktion:(NSTimer*)derTimer
{
NSLog(@"lastDataRead: %@",lastDataRead);


}

- (void)i2cStatusAktion:(NSNotification*)note
{
	//NSLog(@"i2cStatusAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"status"])
	{
		if ([[[note userInfo]objectForKey:@"status"] intValue])
		{
			[self InitI2C:NULL];
		}
		else
		{
			[self ResetI2C:NULL];
		}
		
	}
	
}

- (void)i2cEEPROMReadReportAktion:(NSNotification*)note
{

	//NSLog(@"i2cEEPROMReadReportAktion note: %@",[[note userInfo]description]);
	
	if ([[note userInfo]objectForKey:@"adressarray"])
	{
		NSMutableArray* HexArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"adressarray"]];
		//NSLog(@"i2cEEPROMReadReportAktion HexArray: %@",[HexArray description]);

		[self WriteHexArray: HexArray];		
	}
	if ([[note userInfo]objectForKey:@"cmdarray"])
	{
		
		NSMutableArray* HexArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"cmdarray"]];
		
		[self WriteHexArray: HexArray];
		[self setNewDump];
	}
	
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"i2c" object:self userInfo:NotificationDic];
	
	
}


- (void)i2cEEPROMWriteReportAktion:(NSNotification*)note
{
	if ([[note userInfo]objectForKey:@"i2ceepromarray"])
	{
		
		NSMutableArray* HexArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"i2ceepromarray"]];
		//NSLog(@"i2cEEPROMWriteReportAktion HexArray: %@",[HexArray description]);
		
		
		
		
//		[self setWriteDump:HexArray];
		[self WriteHexArray: HexArray];
		
		
	}

	//NSLog(@"i2cEEPROMWriteReportAktion note: %@",[[note userInfo]description]);
	
	
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"i2c" object:self userInfo:NotificationDic];

}


- (void)i2cAVRReadReportAktion:(NSNotification*)note
{

	NSLog(@"i2AVRReadReportAktion note: %@",[[note userInfo]description]);
	
	if ([[note userInfo]objectForKey:@"adressarray"])
	{
		NSMutableArray* HexArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"adressarray"]];
		//NSLog(@"i2cEEPROMReadReportAktion HexArray: %@",[HexArray description]);

		[self WriteHexArray: HexArray];		
	}
	
	if ([[note userInfo]objectForKey:@"cmdarray"])
	{
		
		NSMutableArray* HexArray=[[NSMutableArray alloc]initWithArray:[[note userInfo]objectForKey:@"cmdarray"]];
		
		NSMutableDictionary* twiInfoDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				
		[twiInfoDic setObject:HexArray forKey:@"cmdarray"];
				
				// Timer fuer die Reaktion des AVR auf das Setzen des TWI-Bits
				
		NSDate *now = [[NSDate alloc] init];
		NSTimer* AVRTimer= [NSTimer scheduledTimerWithTimeInterval:0.5 
															target:self 
														  selector:@selector(twiAVRTimerAktion:) 
														  userInfo:twiInfoDic 
														   repeats:YES];
		

					
//				NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//				[runLoop addTimer:TWITimer forMode:NSDefaultRunLoopMode];
				
//				[AVRTimer release];
				[now release];
				

		//[self WriteHexArray: HexArray];
		//[self setNewDump];
	}
	
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"fertig"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"i2c" object:self userInfo:NotificationDic];
	
	
}

- (IBAction)twiAVRTimerAktion:(NSTimer*)derTimer
{
	NSLog(@"twiAVRTimerAktion note: %@",[[derTimer userInfo]description]);
	if ([[derTimer userInfo] objectForKey:@"cmdarray"])
	{
		NSArray* AVRArray=[[derTimer userInfo] objectForKey:@"cmdarray"];
		[self WriteHexArray: AVRArray];
		}
		[derTimer invalidate];
		

	}
	
- (void)setBrennerDatenFor:(int)dasJahr
{
	NSArray* BrennerDatenArray=[HomeData BrennerStatistikVonJahr:2010 Monat:0];
	NSLog(@"IOW BrennerStatistik: %@",[BrennerDatenArray description]);
	NSArray* BrennerKanalArray=		[NSArray arrayWithObjects:@"0",@"0",@"0",@"1" ,@"0",@"0",@"0",@"0",nil];


}


- (void)StatistikDatenAktion:(NSNotification*)note
{
	/*
	 Aufgerufen, wenn der Tab von Statistik geoeffnet wird
	 */
	//NSLog(@"AVRController StatistikDatenAktion");
	//NSLog(@"AVRController BrennerStatistik note: %@ ",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"aktion"])
	{
		int jahr=[Data StatistikJahr];
		int monat=[Data StatistikMonat];
		NSArray* TemperaturKanalArray=[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		NSArray* BrennerKanalArray=	[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		
		NSMutableDictionary* StatDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
		if ([[[note userInfo]objectForKey:@"aktion"]intValue]==1)
		{
			
			NSArray* BrennerDatenArray=[HomeData BrennerStatistikVonJahr:jahr Monat:monat];
			if (BrennerDatenArray && [BrennerDatenArray count])
			{
				//NSLog(@"AVRController BrennerStatistik: %@",[BrennerDatenArray description]);
				
				
				[StatDic setObject:BrennerDatenArray forKey:@"brennerdatenarray"];
				[StatDic setObject:BrennerKanalArray forKey:@"brennerkanalarray"];
				[StatDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
				
			}
			
			
			NSArray* TemperaturDatenArray=[HomeData TemperaturStatistikVonJahr:jahr Monat:monat];
			if (TemperaturDatenArray && [TemperaturDatenArray count])
			{
				//NSLog(@"AVRController StatistikDatenAktion TempDatenArray: %@",[TemperaturDatenArray description]);
				[StatDic setObject:TemperaturDatenArray forKey:@"temperaturdatenarray"];
				[StatDic setObject:TemperaturKanalArray forKey:@"temperaturkanalarray"];
				//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
				
				[Data setBrennerStatistik:StatDic];
				
			}
		} // aktion =1
		if ([[[note userInfo]objectForKey:@"aktion"]intValue]==3)
		{
			NSDictionary* tempDatumDic = [Data SolarStatistikDatum];
			
			int jahr=[[tempDatumDic objectForKey:@"jahr"]intValue];
			int monat=[[tempDatumDic objectForKey:@"monat"]intValue];
			int tag=[[tempDatumDic objectForKey:@"tag"]intValue];
			
			
			NSArray* SolarDatenArray=[HomeData SolarErtragVonJahr:jahr Monat:monat Tag:tag];
			if (SolarDatenArray && [SolarDatenArray count])
			{
				//NSLog(@"AVRController SolarStatistik: %@",[SolarDatenArray description]);
				
				
            
				[StatDic setObject:SolarDatenArray forKey:@"brennerdatenarray"];
				[StatDic setObject:SolarDatenArray forKey:@"brennerkanalarray"];
				[StatDic setObject:[NSNumber numberWithInt:3] forKey:@"aktion"];
				
			}
		}
		
		
		
	}
}

- (void)SolarStatistikDatenAktion:(NSNotification*)note
{
	/*
	 Aufgerufen, wenn der Tab von SolarStatistik geoeffnet wird
	 */
	//NSLog(@"AVRController SolarStatistikDatenAktion");
	NSLog(@"AVRController SolarStatistikDatenAktion note *** aktion: %d ",[[[note userInfo]objectForKey:@"aktion" ]intValue]);
	if ([[note userInfo]objectForKey:@"aktion"])
	{
		int jahr=[Data SolarStatistikJahr];
		int monat=[Data SolarStatistikMonat];
      monat=0;
		NSArray* TemperaturKanalArray=[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];

      NSArray* ElektroKanalArray=	[NSArray arrayWithObjects:@"0",@"1",@"1",@"0" ,@"0",@"0",@"0",@"0",nil];
      NSArray* StatistikKanalArray=	[NSArray arrayWithObjects:@"0",@"1",@"1",@"1" ,@"0",@"0",@"0",@"0",nil];
      
      
    NSArray* ElektroStatistikKanalArray=	[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		
		NSMutableDictionary* StatDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
		if ([[[note userInfo]objectForKey:@"aktion"]intValue]==1) // Pop
		{
         [self setSolarStatistikDaten];
         return;
         
         
         NSDictionary* tempDatumDic = [Data SolarStatistikDatum];
			
			int jahr=[[tempDatumDic objectForKey:@"jahr"]intValue];
			int monat=[[tempDatumDic objectForKey:@"monat"]intValue];
			int tag=[[tempDatumDic objectForKey:@"tag"]intValue];

			
			NSArray* ElektroDatenArray=[HomeData ElektroStatistikVonJahr:jahr Monat:monat];
			if (ElektroDatenArray && [ElektroDatenArray count])
			{
            
				//NSLog(@"AVRController ElektroStatistik: %@",[ElektroDatenArray description]);
				
				[StatDic setObject:ElektroDatenArray forKey:@"brennerdatenarray"];
				[StatDic setObject:ElektroKanalArray forKey:@"elektrokanalarray"];
				[StatDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
				
			}
			
			
			NSArray* TemperaturDatenArray=[HomeData TemperaturStatistikVonJahr:jahr Monat:monat];
			if (TemperaturDatenArray && [TemperaturDatenArray count])
			{
				//NSLog(@"AVRController StatistikDatenAktion TempDatenArray: %@",[TemperaturDatenArray description]);
				[StatDic setObject:TemperaturDatenArray forKey:@"temperaturdatenarray"];
				[StatDic setObject:TemperaturKanalArray forKey:@"temperaturkanalarray"];
				//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
				
			}
         
         NSArray* SolarDatenArray=[HomeData SolarErtragVonJahr:jahr vonMonat:monat];
			if (SolarDatenArray && [SolarDatenArray count])
			{
				//NSLog(@"AVRController SolarStatistik: %@",[SolarDatenArray description]);
            
				[StatDic setObject:SolarDatenArray forKey:@"elektrodatenarray"];
				[StatDic setObject:ElektroKanalArray forKey:@"elektrokanalarray"];
				[StatDic setObject:[NSNumber numberWithInt:3] forKey:@"aktion"];
				
			}


         NSArray* KollektorDatenArray=[HomeData KollektorMittelwerteVonJahr:jahr];
         
			if (KollektorDatenArray && [KollektorDatenArray count])
			{
				//NSLog(@"AVRController StatistikDatenAktion KollektorDatenArray: %@",[KollektorDatenArray description]);
				[StatDic setObject:KollektorDatenArray forKey:@"kollektortemperaturarray"];
				[StatDic setObject:StatistikKanalArray forKey:@"temperaturkanalarray"];
				//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
				
			}

         
         [Data setSolarStatistik:StatDic];
		} // aktion =1
      
		if ([[[note userInfo]objectForKey:@"aktion"]intValue]==3)
		{
         
         
         [self setSolarStatistikDaten];
         return;
         
			NSDictionary* tempDatumDic = [Data SolarStatistikDatum];
			
			int jahr=[[tempDatumDic objectForKey:@"jahr"]intValue];
			int monat=[[tempDatumDic objectForKey:@"monat"]intValue];
			int tag=[[tempDatumDic objectForKey:@"tag"]intValue];
			
			
			
         
         
         NSArray* SolarDatenArray=[HomeData SolarErtragVonJahr:jahr vonMonat:monat];
			if (SolarDatenArray && [SolarDatenArray count])
			{
				//NSLog(@"AVRController SolarStatistik: %@",[SolarDatenArray description]);

				[StatDic setObject:SolarDatenArray forKey:@"elektrodatenarray"];
				[StatDic setObject:ElektroKanalArray forKey:@"elektrokanalarray"];
				[StatDic setObject:[NSNumber numberWithInt:3] forKey:@"aktion"];
				
			}
         
         
         NSArray* KollektorDatenArray=[HomeData KollektorMittelwerteVonJahr:jahr];
         
			if (KollektorDatenArray && [KollektorDatenArray count])
			{
				//NSLog(@"AVRController StatistikDatenAktion KollektorDatenArray: %@",[KollektorDatenArray description]);
				[StatDic setObject:KollektorDatenArray forKey:@"kollektortemperaturarray"];
				[StatDic setObject:StatistikKanalArray forKey:@"temperaturkanalarray"];
				//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
				
			}
         
         [Data setSolarStatistik:StatDic];

		}
		
		
		
	}
}




- (void)setStatistikDaten
{
	int jahr=[Data StatistikJahr];
	int monat=[Data StatistikMonat];
	//NSLog(@"setStatistikDaten: jahr: %d monat: %d",jahr, monat);
	NSMutableDictionary* StatDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
	NSArray* BrennerDatenArray=[HomeData BrennerStatistikVonJahr:jahr Monat:monat];
	if (BrennerDatenArray && [BrennerDatenArray count])
	{
		NSArray* BrennerKanalArray=		[NSArray arrayWithObjects:@"1",@"0",@"0",@"0" ,@"0",@"0",@"0",@"0",nil];
		//NSLog(@"AVRController setStatistikDaten BrennerDatenArray: %@",[BrennerDatenArray description]);
		
		[StatDic setObject:BrennerDatenArray forKey:@"brennerdatenarray"];
		[StatDic setObject:BrennerKanalArray forKey:@"brennerkanalarray"];
		[StatDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
	}
   else
   {
      NSLog(@"AVRController setStatistikDaten: BrennerDaten nicht da");
   }
	
	NSArray* TemperaturDatenArray=[HomeData TemperaturStatistikVonJahr:jahr Monat:monat];
	if (TemperaturDatenArray && [TemperaturDatenArray count])
	{
		//NSLog(@"AVRController setStatistikDaten TemperaturDatenArray: %@",[TemperaturDatenArray description]);
		[StatDic setObject:TemperaturDatenArray forKey:@"temperaturdatenarray"];
		
		//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
		
		[Data setBrennerStatistik:StatDic];
		
	}
	
}




- (void)setSolarStatistikDaten
{
	int jahr=[Data SolarStatistikJahr];
	int monat=[Data SolarStatistikMonat];
   
	//NSLog(@"setSolarStatistikDaten: jahr: %d monat: %d",jahr, monat);
   
	NSMutableDictionary* StatDic=[[NSMutableDictionary alloc]initWithCapacity:0];

   NSArray* KollektorTemperaturArray = [HomeData KollektorMittelwerteVonJahr:jahr];
   if (KollektorTemperaturArray && [KollektorTemperaturArray count])
   {
      //NSLog(@"AVRController setSolarStatistikDaten KollektorTemperaturArray count: %d",[KollektorTemperaturArray count]);

      [StatDic setObject:KollektorTemperaturArray forKey:@"kollektortemperaturarray"];
      
   }
	NSArray* ElektroDatenArray=[HomeData ElektroStatistikVonJahr:jahr Monat:monat];
	if (ElektroDatenArray && [ElektroDatenArray count])
	{
      //NSLog(@"AVRController setSolarStatistikDaten ElektroDatenArray count: %d",[ElektroDatenArray count]);
      
		//NSLog(@"AVRController setSolarStatistikDaten ElektroDatenArray: %@",[ElektroDatenArray description]);

		NSArray* ElektroKanalArray=[NSArray arrayWithObjects:@"1",@"1",@"0",@"0" ,@"0",@"0",@"0",@"0",nil]; // angezeigte Kanaele
		
		[StatDic setObject:ElektroDatenArray forKey:@"elektrodatenarray"];
		[StatDic setObject:ElektroKanalArray forKey:@"kanalarray"];
		[StatDic setObject:[NSNumber numberWithInt:1] forKey:@"aktion"];
		
	}
	
	NSArray* TemperaturDatenArray=[HomeData TemperaturStatistikVonJahr:jahr Monat:monat];
	if (TemperaturDatenArray && [TemperaturDatenArray count])
	{
      //NSLog(@"AVRController setSolarStatistikDaten TemperaturDatenArray count: %d",[TemperaturDatenArray count]);

		//NSLog(@"AVRController setStatistikDaten TemperaturDatenArray: %@",[TemperaturDatenArray description]);
		NSArray* TemperaturKanalArray=[NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"0",@"0",@"0",@"0",nil]; // angezeigte Kanaele
		[StatDic setObject:TemperaturKanalArray forKey:@"temperaturkanalarray"];
		[StatDic setObject:TemperaturDatenArray forKey:@"temperaturdatenarray"];
		//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
	}
 
   NSArray* SolarertragArray=[HomeData SolarErtragVonJahr:jahr vonMonat:0];
	if (SolarertragArray && [SolarertragArray count])
	{
      NSLog(@"AVRController setSolarStatistikDaten SolarertragArray count: %d",[SolarertragArray count]);
      
		//NSLog(@"AVRController setStatistikDaten SolarertragArray: %@",[SolarertragArray description]);
		//NSArray* TemperaturKanalArray=[NSArray arrayWithObjects:@"1",@"1",@"1",@"1" ,@"0",@"0",@"0",@"0",nil]; // angezeigte Kanaele
		
		[StatDic setObject:SolarertragArray forKey:@"solarertragarray"];
      
		//[StatDic setObject:SolarertragDatenArray forKey:@""];
		
		//[StatDic setObject:[NSNumber numberWithInt:2] forKey:@"aktion"];
	}

   
   
	[Data setSolarStatistik:StatDic];
}

@end

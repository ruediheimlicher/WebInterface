//
//  rHomeClient.m
//  WebInterface
//
//  Created by Sysadmin on 15.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rHomeClient.h"

#define TAGPLANBREITE		0x40	// 64 Bytes, 2 page im EEPROM
#define RAUMPLANBREITE		0x200	// 512 Bytes

#define WEBSERVER_VHOST "www.ruediheimlicher.ch"
#define PW "ideur00"
#define CGI "cgi-bin/eeprom.pl"
#define CGI_UPDATE_CLEAR "cgi-bin/eepromupdate.pl"

#define START_STATUS0   10
#define END_STATUS0   11

#define START_STATUS1   20
#define END_STATUS1   21
#define START_WRITE   30
#define END_WRITE   31
#define START_READ   40
#define END_READ   41


#define ERR_WRITE   99


// convert a single hex digit character to its integer value
unsigned char h2int(char c)
{
        if (c >= '0' && c <='9'){
                return((unsigned char)c - '0');
        }
        if (c >= 'a' && c <='f'){
                return((unsigned char)c - 'a' + 10);
        }
        if (c >= 'A' && c <='F'){
                return((unsigned char)c - 'A' + 10);
        }
        return(0);
}


@implementation rHomeClient 

- (int)HexStringZuInt:(NSString*) derHexString
{
	int returnInt=-1;
	NSScanner* theScanner = [NSScanner scannerWithString:derHexString];
	
	if ([theScanner scanHexInt:&returnInt])
	{
		//NSLog(@"HexStringZuInt string: %@ int: %x	",derHexString,returnInt);
		return returnInt;
	}
   
   return returnInt;
}

- (id)init
{
	self = [super init];
   
   
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
			 selector:@selector(EEPROMReadStartAktion:)
				  name:@"EEPROMReadStart"
				object:nil];

	[nc addObserver:self
			 selector:@selector(EEPROMReadWocheStartAktion:)
				  name:@"EEPROMReadWocheStart"
				object:nil];
	
	

	
   [nc addObserver:self
			 selector:@selector(EEPROMReadDataAktion:)
				  name:@"EEPROMReadData"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(TWIStatusAktion:)
				  name:@"twistatus"
				object:nil];

	[nc addObserver:self
			 selector:@selector(LocalStatusAktion:)
				  name:@"localstatus"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(TestStatusAktion:)
				  name:@"teststatus"
				object:nil];
   
   [nc addObserver:self
          selector:@selector(LoadTestAktion:)
              name:@"loadtest"
            object:nil];

	
		[nc addObserver:self
			 selector:@selector(HomeClientWriteStandardAktion:)
				  name:@"HomeClientWriteStandard"
				object:nil];

		[nc addObserver:self
			 selector:@selector(HomeClientWriteModifierAktion:)
				  name:@"HomeClientWriteModifier"
				object:nil];

   [nc addObserver:self
			 selector:@selector(EEPROMUpdateClearAktion:)
				  name:@"EEPROMUpdateClear"
				object:nil];
	
   [nc addObserver:self
			 selector:@selector(updateEEPROMAktion:)
				  name:@"updateEEPROM"
				object:nil];
	

      [nc addObserver:self
			 selector:@selector(EEPROMWriteWocheAktion:)
				  name:@"EEPROMWriteWoche"
				object:nil];

   [nc addObserver:self
          selector:@selector(resetMasterAktion:)
              name:@"resetmaster"
            object:nil];

   
   SendEEPROMDataDic = [[NSMutableDictionary alloc]initWithCapacity:0];

   
   
   
#pragma mark HomeCentralURL
	
HomeCentralURL=@"http://ruediheimlicher.dyndns.org";
	
   //LocalHomeCentralURL=@"192.168.1.210";
   //HomeCentralURL=@"http://192.168.1.210";
   //HomeCentralURL=@"https://ruediheimlicher.ch";
	
	pw = @"ideur00";
	    // Set the WebView delegates
		webView=[[WebView  alloc]init];
    [webView setFrameLoadDelegate:self];
    [webView setUIDelegate:self];
    [webView setResourceLoadDelegate:self];
	//WebPreferences *prefs = [webView preferences]; 
	//[prefs setUsesPageCache:NO]; 
	//[prefs setCacheModel:WebCacheModelDocumentViewer];
	// Maximale Anzahl Versuche um die EEPROM-Daten zu vom Webserver zu lesen
	maxAnzahl = 25;
   loadAlertOK = 0;
   loadTestStatus=0;
   //lastEEPROMData = [[NSString string]retain];
	return self;
}


- (void)EEPROMReadStartAktion:(NSNotification*)note
{
	//NSLog(@"HomeClient EEPROMReadStartAktion note: %@",[[note userInfo]description]);
	NSString* hByte = [NSString string];
	NSString* lByte = [NSString string];
	NSString* EEPROMAdresseZusatz= [NSString string];
	NSString* titel = [NSString string];
   int tagbalkentyp=0; // tagbalkentyp
   
   WebTask = eepromread;
   if ([[note userInfo]objectForKey:@"webtask"])
   {
      WebTask = [[[note userInfo]objectForKey:@"webtask"]intValue];
   }
   
   int wochentagindex =0;
   if ([[note userInfo]objectForKey:@"wochentagindex"])
   {
      wochentagindex = [[[note userInfo]objectForKey:@"wochentagindex"]intValue];
   }
   
   
   
   //[NotificationDic setObject:[NSNumber numberWithInt:wochentagindex] forKey:@"wochentagindex"];
   if ([[note userInfo]objectForKey:@"eepromadressezusatz"])
	{
		EEPROMAdresseZusatz= [[[note userInfo]objectForKey:@"eepromadressezusatz"]stringValue];
	}
   
	//NSLog(@"EEPROMAdresseZusatz: %@",[EEPROMAdresseZusatz description]);
	if ([[note userInfo]objectForKey:@"hbyte"])
	{
		hByte= [[[note userInfo]objectForKey:@"hbyte"]stringValue];
		//NSLog(@"hByte: %@ length: %d",hByte,[hByte length]);
		if ([hByte length]==1)
		{
			hByte = [NSString stringWithFormat:@"0%@",hByte];
		}
	}
	if ([[note userInfo]objectForKey:@"lbyte"])
	{
		lByte= [[[note userInfo]objectForKey:@"lbyte"]stringValue];
		if ([lByte length]==1)
		{
			lByte = [NSString stringWithFormat:@"0%@",lByte];
		}
		
	}
   
   if ([[note userInfo]objectForKey:@"titel"])
	{
		titel= [[note userInfo]objectForKey:@"titel"];
		
	}
   
   if ([[note userInfo]objectForKey:@"tagbalkentyp"])
	{
		tagbalkentyp= [[[note userInfo]objectForKey:@"tagbalkentyp"]intValue];
		
	}
   
   // Dic fuer senden an Homeserver mit Adresse laden:
   [SendEEPROMDataDic setObject:hByte forKey:@"hbyte"];
   [SendEEPROMDataDic setObject:lByte forKey:@"lbyte"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"adrload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"dataload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];
   [SendEEPROMDataDic setObject:titel forKey:@"titel"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
   
	
   //	NSString* TWIReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresse,hByte, lByte];
	NSString* EEPROMReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresseZusatz,hByte, lByte];
	NSString* EEPROMReadStartURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, EEPROMReadStartURLSuffix];
	
	//NSLog(@"EEPROMReadStartAktion EEPROMReadStartURLSuffix: %@",EEPROMReadStartURLSuffix);
   
	//NSLog(@"EEPROMReadStartURL: %@",EEPROMReadStartURL);
	//NSURL *URL = [NSURL URLWithString:HomeCentralURL];
	NSURL *URL = [NSURL URLWithString:EEPROMReadStartURL];
	[self loadURL:URL];
}


- (void)EEPROMReadWocheStartAktion:(NSNotification*)note
{
	NSLog(@"EEPROMReadWocheStartAktion note: %@",[[note userInfo]description]);
	NSString* hByte = [NSString string];
	NSString* lByte = [NSString string];
	NSString* EEPROMAdresseZusatz= [NSString string];
	NSString* titel = [NSString string];
   int tagbalkentyp=0; // tagbalkentyp
   
   WebTask = eepromreadwoche;
   
   if ([[note userInfo]objectForKey:@"eepromadressezusatz"])
	{
		EEPROMAdresseZusatz= [[[note userInfo]objectForKey:@"eepromadressezusatz"]stringValue];
	}
	
		
	//NSLog(@"EEPROMAdresseZusatz: %@",[EEPROMAdresseZusatz description]);
	if ([[note userInfo]objectForKey:@"hbyte"])
	{
		hByte= [[[note userInfo]objectForKey:@"hbyte"]stringValue];
		//NSLog(@"hByte: %@ length: %d",hByte,[hByte length]);
		if ([hByte length]==1)
		{
			hByte = [NSString stringWithFormat:@"0%@",hByte];
		}
	}
	if ([[note userInfo]objectForKey:@"lbyte"])
	{
		lByte= [[[note userInfo]objectForKey:@"lbyte"]stringValue];
		if ([lByte length]==1)
		{
			lByte = [NSString stringWithFormat:@"0%@",lByte];
		}
		
	}

   if ([[note userInfo]objectForKey:@"titel"])
	{
		titel= [[note userInfo]objectForKey:@"titel"];
		
	}

   if ([[note userInfo]objectForKey:@"tagbalkentyp"])
	{
		tagbalkentyp= [[[note userInfo]objectForKey:@"tagbalkentyp"]intValue];
		
	}

   /*
   // Dic fuer senden an Homeserver mit Adresse laden:
   [SendEEPROMDataDic setObject:hByte forKey:@"hbyte"];
   [SendEEPROMDataDic setObject:lByte forKey:@"lbyte"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"adrload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"dataload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];
   [SendEEPROMDataDic setObject:titel forKey:@"titel"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
    */
	
//	NSString* TWIReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresse,hByte, lByte]; 
	NSString* EEPROMReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresseZusatz,hByte, lByte]; 
	NSString* EEPROMReadStartURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, EEPROMReadStartURLSuffix];
	
	NSLog(@"EEPROMReadWocheStartAktion EEPROMReadStartURLSuffix: %@",EEPROMReadStartURLSuffix);

	NSLog(@"EEPROMReadWocheStartURL: %@",EEPROMReadStartURL);
	//NSURL *URL = [NSURL URLWithString:HomeCentralURL];
	NSURL *URL = [NSURL URLWithString:EEPROMReadStartURL];
	[self loadURL:URL];
}

- (void)readWocheTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* readWocheTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"readWocheTimerFunktion  statusTimerDic: %@",[statusTimerDic description]);
   
	if ([readWocheTimerDic objectForKey:@"anzahl"])
	{
      
   }
   
   
}




- (void)EEPROMReadDataAktion:(NSNotification*)note
{
	//NSLog(@"EEPROMReadDataAktion note: %@",[[note userInfo]description]);
	//NSString* DataString = [NSString string];
	if ([[note userInfo]objectForKey:@"rdata"])
	{
		// Zaehler fuer Anzahl Versuche einsetzen
		NSMutableDictionary* sendTimerDic=[[NSMutableDictionary alloc]initWithDictionary:[note userInfo]];
		//[sendTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
		[sendTimerDic setObject:[NSNumber numberWithInt:maxAnzahl]forKey:@"anzahl"];
		int sendResetDelay=2.0;
		//NSLog(@"EEPROMReadDataAktion  sendTimerDic: %@",[sendTimerDic description]);
	
		sendTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(sendTimerFunktion:) 
															userInfo:sendTimerDic 
															 repeats:YES];
						
/* In sendTimerFunktion verschoben

		int d=[[[note userInfo]objectForKey:@"rdata"]intValue];
		NSString* TWIReadDataURLSuffix = [NSString stringWithFormat:@"pw=%@&rdata=%d",pw,d]; 
		NSString* TWIReadDataURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIReadDataURLSuffix];
		NSURL *URL = [NSURL URLWithString:TWIReadDataURL];
		[self loadURL:URL];
*/
	}
} // EEPROMReadDataAktion


- (void)sendTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* sendTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"sendTimerFunktion  sendTimerDic: %@",[sendTimerDic description]);
   
 	if ([sendTimerDic objectForKey:@"anzahl"])
	{
      
		int anz=[[sendTimerDic objectForKey:@"anzahl"] intValue];
		if (anz )
		{
			if ([sendTimerDic objectForKey:@"rdata"])
			{
				//NSLog(@"sendTimer fire  Anzahl: %d",anz);
		//		int d=[[sendTimerDic objectForKey:@"rdata"]intValue];
				int d=[[sendTimerDic objectForKey:@"anzahl"]intValue];
				NSString* TWIReadDataURLSuffix = [NSString stringWithFormat:@"pw=%@&rdata=%d",pw,d]; 
				NSString* TWIReadDataURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIReadDataURLSuffix];
				NSURL *URL = [NSURL URLWithString:TWIReadDataURL];
				//NSLog(@"sendTimer fire anzahl: %d URL: %@",anz,URL);
				[self loadURL:URL];
				anz--;
				[sendTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
			}

		}
		else
		{

			NSLog(@"sendTimerFunktion sendTimer invalidate");
			
			//
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];
			//[Warnung addButtonWithTitle:@"Abbrechen"];
			[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"EEPROM lesen misslungen"]];
			
			NSString* s1=@"Timeout bei Verbindung zu HomeCentral";
			NSString* s2=@"";
			NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
			[Warnung setInformativeText:InformationString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			
			int antwort=[Warnung runModal];
			switch (antwort)
			{
				case NSAlertFirstButtonReturn://
				{ 
					NSLog(@"NSAlertFirstButtonReturn");
					[NSApp stopModalWithCode:0];
               
				}break;
					
					
			}//switch
			//
         
         if ([derTimer isValid])
         {
			[derTimer invalidate];
         }
		}
		
		
	}
}

- (void)EEPROMisWriteOKRequest
{
		//NSLog(@"EEPROMisWriteOKRequest ");
		// Zaehler fuer Anzahl Versuche einsetzen
		NSMutableDictionary* confirmTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
		int sendResetDelay=2.0;
		//NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
		confirmTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
															  target:self 
															selector:@selector(confirmTimerFunktion:) 
															userInfo:confirmTimerDic 
															 repeats:YES];
															 
	
}

- (void)confirmTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* confirmTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"confirmTimerFunktion  confirmTimerDic: %@",[confirmTimerDic description]);

	if ([confirmTimerDic objectForKey:@"anzahl"])
	{
		
		int anz=[[confirmTimerDic objectForKey:@"anzahl"] intValue];
		if (anz < maxAnzahl)
		{
				NSString* TWIReadDataURLSuffix = [NSString stringWithFormat:@"pw=%@&iswriteok=1",pw]; 
				NSString* TWIReadDataURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIReadDataURLSuffix];
				NSURL *URL = [NSURL URLWithString:TWIReadDataURL];
				//NSLog(@"confirmTimerFunktion  URL: %@",URL);
				[self loadURL:URL];
				anz++;
				[confirmTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
		
      }
		else
		{
			NSLog(@"confirmTimerFunktion confirmTimer invalidate");
			// Misserfolg an AVRClient senden
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"iswriteok"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
			
			[derTimer invalidate];
			
		}
		
		
	}
}

- (void)LocalStatusAktion:(NSNotification*)note
{
   //NSLog(@"HomeClient LocalStatusAktion note: %@",[[note userInfo]description]);

   if ([[note userInfo]objectForKey:@"status"] && [[[note userInfo]objectForKey:@"status"]intValue]==1) // URL umschalten
   {
      HomeCentralURL = @"http://192.168.1.210";
      //NSLog(@"LocalStatusAktion local: HomeCentralURL: %@",HomeCentralURL);
   }
   else
   {
      HomeCentralURL = @"http://ruediheimlicher.dyndns.org";
   //NSLog(@"LocalStatusAktion global: HomeCentralURL: %@",HomeCentralURL);
   }
   NSLog(@"HomeClient LocalStatusAktion HomeCentralURL: %@",HomeCentralURL);
}

- (void)LoadTestAktion:(NSNotification*)note
{
   NSLog(@"LoadTestAktion note: %@",[[note userInfo]description]);
   
   // Zaehler fuer Anzahl Versuche einsetzen
			NSMutableDictionary* loadTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[loadTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
   
   loadTestStatus = START_STATUS0;
   [loadTimerDic setObject:[NSNumber numberWithInt:3]forKey:@"delay"];
   
   NSURL* loadURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=0"];
   [self loadURL:loadURL];
   int sendResetDelay=3.0;
   
   
			//NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
   
			NSTimer* loadTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
                                                              target:self
                                                            selector:@selector(loadTimerFunktion:)
                                                            userInfo:loadTimerDic
                                                             repeats:YES];
   
   
   //				NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
   //				[runLoop addTimer:TWITimer forMode:NSDefaultRunLoopMode];
   
   
}

- (void)loadTimerFunktion:(NSTimer*) derTimer
{
   NSMutableDictionary* statusTimerDic=(NSMutableDictionary*) [derTimer userInfo];
   NSLog(@"loadTimerFunktion  statusTimerDic: %@",[statusTimerDic description]);
   
   if ([statusTimerDic objectForKey:@"anzahl"])
   {
      int anz=[[statusTimerDic objectForKey:@"anzahl"] intValue];
      NSLog(@"loadTimerFunktion anzahl: %d loadTestStatus: %d",(int)[[statusTimerDic objectForKey:@"anzahl"] integerValue],loadTestStatus);
      
      //if (anz < maxAnzahl)
      if (anz < 10)
      {
         anz++;
         if (anz>1)
         {
            switch (loadTestStatus)
            {
               case START_STATUS0:
               {
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                  NSLog(@"loadTimerFunktion  START_STATUS0 loaddelay: %d",loaddelay);

               }break;
                  
                  
               case START_READ:
               {
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                  NSLog(@"loadTimerFunktion  START_READ loaddelay: %d",loaddelay);

               }break;
                  
               case END_READ:
               {
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                  NSLog(@"loadTimerFunktion  END_READ loaddelay: %d",loaddelay);
                  if (loaddelay)
                  {
                     loaddelay--;
                  }
                  else
                  {
                     NSLog(@"loadtimeFunktion testdataok: %d",testdataok);
                     if (testdataok)
                     {
                        NSURL* dataURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&wadr=0&lbyte=40&hbyte=10&data=0+0+0+0+0+0+0+0"];
                        [self loadURL:dataURL];
                        
                        loadTestStatus = START_WRITE;
                        anz=0;
                        loaddelay = 1;
                        
                        
                     }
                     else
                     {
                        NSURL* dataURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&wadr=0&lbyte=40&hbyte=10&data=ff+ff+ff+ff+ff+ff+ff+ff"];
                        [self loadURL:dataURL];
                        
                        loadTestStatus = START_WRITE;
                        anz=0;
                        loaddelay = 1;

                     }

                     
                     
                     // Status 1 setzen
                     // NSURL* statusURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=1"];
                     // [self loadURL:statusURL];
                     // anz = 0;
                  }
                  [statusTimerDic setObject:[NSNumber numberWithInt:loaddelay] forKey:@"delay"];

                  
                  
               }break;
                  
                  
               case END_STATUS0:
               {
                 
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                   NSLog(@"loadTimerFunktion  END_STATUS0 loaddelay: %d",loaddelay);
                  if (loaddelay)
                  {
                     loaddelay--;
                  }
                  else
                  {
                     NSURL* dataURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&radr=0&hb=10&lb=40"];
                     [self loadURL:dataURL];
                     
                     loadTestStatus = START_READ;
                     anz=0;
                     loaddelay = 1;

                     /*
                     NSURL* dataURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&wadr=0&lbyte=40&hbyte=10&data=ff+ff+ff+ff+ff+ff+ff+ff"];
                     [self loadURL:dataURL];
                     
                     loadTestStatus = START_WRITE;
                     anz=0;
                     loaddelay = 1;
                     */
                  }
                   [statusTimerDic setObject:[NSNumber numberWithInt:loaddelay] forKey:@"delay"];
               }break;
                  
               case START_WRITE:
               {
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                  NSLog(@"loadTimerFunktion  START_WRITE loaddelay: %d",loaddelay);
                  if (loaddelay)
                  {
                     //loaddelay--;
                  }
                  else
                  {

                  }
                  
               }break;
 
               case END_WRITE:
               {
                  int loaddelay = [[statusTimerDic objectForKey:@"delay"] intValue];
                  NSLog(@"loadTimerFunktion  END_WRITE loaddelay: %d",loaddelay);
                  anz=0;
                  if (loaddelay)
                  {
                     loaddelay--;
                  }
                  else
                  {
                      //Status 1 setzen
                      NSURL* statusURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=1"];
                      [self loadURL:statusURL];
                     NSAlert * LoadAlert=[NSAlert alertWithMessageText:@"Load OK"
                                                          defaultButton:NULL
                                                        alternateButton:NULL
                                                            otherButton:NULL 
                                              informativeTextWithFormat:@"Mitteilung:\n%@",@"alles OK"];
                     [LoadAlert runModal];

                     anz=10;
                  }
                  [statusTimerDic setObject:[NSNumber numberWithInt:loaddelay] forKey:@"delay"];
                  
               }break;
                 
               case ERR_WRITE:
               {
                  NSURL* statusURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=1"];
                  [self loadURL:statusURL];
                  NSAlert * LoadAlert=[NSAlert alertWithMessageText:@"Load Fehler"
                                                      defaultButton:NULL
                                                    alternateButton:NULL
                                                        otherButton:NULL
                                          informativeTextWithFormat:@"Mitteilung:\n%@",@"Fehler beim Laden"];
                  [LoadAlert runModal];

               }
                  
                  
            }// switch
            if (loadTestStatus == START_STATUS0)
            {
               //NSURL* loadURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=1"];
              // [self loadURL:loadURL];

            }
            
            
            /*
            NSString* TWIStatus0URLSuffix = [NSString stringWithFormat:@"pw=%@&isstat0ok=1",pw];
            
            TWIStatus0URL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatus0URLSuffix];
            [statusTimerDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            
            
            NSURL *URL = [NSURL URLWithString:TWIStatus0URL];
            //NSLog(@"statusTimerFunktion  URL: %@",URL);
            [self loadURL:URL];
             */
         }
         
         [statusTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
         
         
         // Blinkanzeige im PW-Feld
         NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         if (anz%2==0)// gerade
         {
            //[self loadURL:URL];
            
            //[tempDataDic setObject:@"*" forKey:@"wait"];
         }
         else
         {
            //[tempDataDic setObject:@" " forKey:@"wait"];
         }
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    //     [nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
         
      }
      
      else
      {
         
         NSLog(@"loadTimerFunktion statusTimer invalidate");
         //Status 1 setzen
         NSURL* statusURL = [NSURL URLWithString:@"http://192.168.1.210/twi?pw=ideur00&status=1"];
         [self loadURL:statusURL];

         // Misserfolg an AVRClient senden
         NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"isstatusok"];
         if ([statusTimerDic objectForKey:@"local"] && [[statusTimerDic objectForKey:@"local"]intValue]==1 )
         {
            [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"local"];
         }
         else
         {
            [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            
         }
         
         
         
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         
         
         
  //       [nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
         
         [derTimer invalidate];
 //        [derTimer release];
         
      }
      
   }
}


- (void)resetMasterAktion:(NSNotification*)note
{
   //NSLog(@"resetMasterAktion note: %@",[[note userInfo]description]);
   if ([[note userInfo]objectForKey:@"reset"] && [[[note userInfo]objectForKey:@"reset"]intValue]==1) // Master reetten
   {
      //NSString* resetMasterSuffix = [NSString stringWithFormat:@"pw=%@&task=%@",pw,@"68+6f+6d+65+72"];
      NSString* resetMasterSuffix = [NSString stringWithFormat:@"pw=%@&task=%@",pw,@"homer"];

      //NSString* resetMasterSuffix = [NSString stringWithFormat:@"pw=%@&task=68+6f",pw];

      //NSString* resetMasterSuffix = [NSString stringWithFormat:@"pw=%@&task=%@",pw,@"1"];
      
      
      NSString* TWIStatusSuffix = [NSString stringWithFormat:@"pw=%@&status=%@",pw,@"1"];
      NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatusSuffix];


      NSString* resetMasterURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, resetMasterSuffix];
      
      //NSLog(@"resetMasterAktion resetMasterURLString: %@ TWIStatusURLString: %@",resetMasterURLString,TWIStatusURLString);
      
      NSURL *URL = [NSURL URLWithString:resetMasterURLString];
      //NSLog(@"resetMasterAktion URL: %@",URL);
      [self loadURL:URL];
      
      

      
   }
}





- (void)TestStatusAktion:(NSNotification*)note
{
   NSLog(@"TestStatusAktion note: %@",[[note userInfo]description]);
   
   if ([[note userInfo]objectForKey:@"test"] && [[[note userInfo]objectForKey:@"test"]intValue]==1) // URL umschalten
   {
      HomeCentralURL = @"http://192.168.1.213";
      //NSLog(@"TestStatusAktion local: HomeCentralURL: %@",HomeCentralURL);
   }
   else
   {
      HomeCentralURL = @"http://ruediheimlicher.dyndns.org";
      //NSLog(@"TestStatusAktion global: HomeCentralURL: %@",HomeCentralURL);
   }
   NSLog(@"TestStatusAktion HomeCentralURL: %@",HomeCentralURL);
}


- (void)TWIStatusAktion:(NSNotification*)note
{
	NSLog(@"HomeClient TWIStatusAktion note: %@",[[note userInfo]description]);
	
	if ([[note userInfo]objectForKey:@"status"])
	{
		NSString* TWIStatusSuffix=[NSString string];
		if ([[[note userInfo]objectForKey:@"status"]intValue])         //neuer Status ist 1
		{
			TWIStatusSuffix = [NSString stringWithFormat:@"pw=%@&status=%@",pw,@"1"];
			NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatusSuffix];
			
          NSLog(@"TWIStatusAktion Status > 1  TWIStatusURL: %@",TWIStatusURLString);
			
         NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
         NSLog(@"TWIStatusAktion URL: %@",URL);
			[self loadURL:URL];
         
         if (sendTimer && [sendTimer isValid])
         {
            [sendTimer invalidate];
            sendTimer = nil;
         }
		
      }
		else        // neuer Status ist 0
		{
         
			TWIStatusSuffix = [NSString stringWithFormat:@"pw=%@&status=%@",pw,@"0"];
			
			
			NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatusSuffix];
			
           NSLog(@"TWIStatusAktion Status > 0 TWIStatusURL: %@",TWIStatusURLString);
         
         NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
			//NSLog(@"TWIStatusAktion URL: %@",URL);
			[self loadURL:URL];
			
			//  Blinkanzeige im PWFeld
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			//[tempDataDic setObject:@"*" forKey:@"wait"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
         
			// Zaehler fuer Anzahl Versuche einsetzen
			NSMutableDictionary* confirmTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
         
         if ([[note userInfo]objectForKey:@"status"] && [[[note userInfo]objectForKey:@"status"]intValue]==1)
         {
            [confirmTimerDic setObject:[NSNumber numberWithInt:1]forKey:@"local"];
         }
         else
         {
            [confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"local"];
           
         }
         int sendResetDelay=1.0;
			//NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
         
			confirmStatusTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
                                                              target:self
                                                            selector:@selector(statusTimerFunktion:)
                                                            userInfo:confirmTimerDic
                                                             repeats:YES];
			
		}
		
	}// if status
	
}//TWIStatusAktion





- (void)statusTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* statusTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"statusTimerFunktion  statusTimerDic: %@",[statusTimerDic description]);

	if ([statusTimerDic objectForKey:@"anzahl"])
	{		
		int anz=[[statusTimerDic objectForKey:@"anzahl"] intValue];
      NSString* TWIStatus0URL;
		if (anz < maxAnzahl)
		{
			anz++;
			if (anz>1)
			{
            NSString* TWIStatus0URLSuffix = [NSString stringWithFormat:@"pw=%@&isstat0ok=1",pw];
            
            TWIStatus0URL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatus0URLSuffix];
            [statusTimerDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            
            
            NSURL *URL = [NSURL URLWithString:TWIStatus0URL];
            NSLog(@"statusTimerFunktion  URL: %@",URL);
            [self loadURL:URL];
			}
			
			[statusTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
         

			// Blinkanzeige im PW-Feld
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			if (anz%2==0)// gerade
			{
			//[self loadURL:URL];

				//[tempDataDic setObject:@"*" forKey:@"wait"];
			}
			else
			{
				//[tempDataDic setObject:@" " forKey:@"wait"];
			}
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
			
		}
 
		else
		{
			
			NSLog(@"statusTimerFunktion statusTimer invalidate");
			// Misserfolg an AVRClient senden
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"isstatusok"];
         if ([statusTimerDic objectForKey:@"local"] && [[statusTimerDic objectForKey:@"local"]intValue]==1 )
         {
            [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"local"];
         }
         else
         {
            [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            
         }
			
         
         
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         
         
         
			[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
			
			[derTimer invalidate];
			
		}
		
	}
}

- (void)readEthTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzahlDaten
{
	
	NSLog(@"readEthTagplan i2cAdresse: %d startAdresse: %d anzDaten: %d",i2cAdresse,startAdresse,anzahlDaten);
	//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//NSMutableDictionary* readEEPROMDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	//NSMutableArray* i2cAdressArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	
}




- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzahlDaten
{
	[self readEthTagplan:i2cAdresse vonAdresse:startAdresse anz: anzahlDaten];
	
	return;
}


- (void)HomeClientWriteStandardAktion:(NSNotification*)note
{
	/*
    Einfuegen in ehemaliger EEPROMWrite-Aktion (iow):
    - Daten aus StundenByteArray
    - logString=[logString stringByAppendingString:[NSString stringWithFormat:@"%02X ",[[dieDaten objectAtIndex:xy]intValue]]];
    
    
    */
   //NSLog(@"HomeClientWriteStandardAktion note stundenbytearray %@",[[note userInfo]description]);
	//NSLog(@"HomeClientWriteStandardAktion note stundenbytearray %@",[[[note userInfo]objectForKey:@"stundenbytearray"]componentsJoinedByString:@" \t "]);
   //	int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
   //	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
   //	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
   //	NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenarray"];
   
   WebTask = idle;
   
   //NSLog(@"HomeClientWriteStandardAktion tagbalkentyp aus userinfo: %@", [[note userInfo]objectForKey:@"tagbalkentyp"]);
   [SendEEPROMDataDic setObject:[[note userInfo]objectForKey:@"titel"] forKey:@"titel"];
   [SendEEPROMDataDic setObject:[[note userInfo]objectForKey:@"tagbalkentyp"] forKey:@"tagbalkentyp"];
	
   NSArray* DatenByteArray=[[note userInfo]objectForKey:@"stundenbytearray"];
   
	NSString* lbyte=[[[note userInfo]objectForKey:@"lbyte"]stringValue];
	NSString* hbyte=[[[note userInfo]objectForKey:@"hbyte"]stringValue];

   if ([lbyte length]==1)
   {
      lbyte = [@"0" stringByAppendingString:lbyte];
   }

   if ([hbyte length]==1)
   {
      hbyte = [@"0" stringByAppendingString:hbyte];
   }

   //NSLog(@"HomeClientWriteStandardAktion lbyte als String: %@ hbyte als String: %@",lbyte,hbyte);
   [SendEEPROMDataDic setObject:hbyte forKey:@"hbyte"];
   [SendEEPROMDataDic setObject:lbyte forKey:@"lbyte"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1]forKey:@"adrload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0]forKey:@"dataload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1]forKey:@"permanent"];
   
   
	//NSString* EEPROM_i2cAdresseString=[I2CPop itemTitleAtIndex:I2CIndex];
	//AnzahlDaten=0x20; //32 Bytes, TAGPLANBREITE;
   //	unsigned int EEPROM_i2cAdresse = [[[note userInfo]objectForKey:@"eepromadresse"]intValue];
   //	NSString*  EEPROM_i2cAdresse_String = [[note userInfo]objectForKey:@"eepromadressestring"];
	NSString*  EEPROM_i2cAdresse_Zusatz = [[note userInfo]objectForKey:@"eepromadressezusatz"];
	// URL aufbauen
	NSString* WriteDataSuffix=[NSString string];
	//if ([[note userInfo]objectForKey:@"pw"])//
	{
		// URL aufbauen
		// pw, Adresszusatz fuer das EEPROM (wadr) anfuegen
		WriteDataSuffix = [NSString stringWithFormat:@"pw=%@&wadr=%@",pw,EEPROM_i2cAdresse_Zusatz];
		
		// lbyte, hbyte anfuegen
		WriteDataSuffix = [NSString stringWithFormat:@"%@&lbyte=%@&hbyte=%@",WriteDataSuffix,lbyte,hbyte];
		//NSLog(@"HomeClientWriteStandardAktion WriteDataSuffix: %@",WriteDataSuffix);
		
		// data anfuegen
		int i=0;
		NSString* DataString=@"&data=";
		//NSLog(@" Datenarray count %d",[DatenArray count]);
		//NSLog(@" DataString: %@",DataString);
		NSString* TestString=[NSString string];// Kontrolle
		//			for (i=0;i<[DatenByteArray count];i++)
		for (i=0;i<8;i++)
		{
			//DataString  = [DataString stringByAppendingString:[[DatenByteArray objectAtIndex:i]stringValue]];
			if (i<[DatenByteArray count])
			{
				DataString= [NSString stringWithFormat:@"%@%x",DataString,[[DatenByteArray objectAtIndex:i]intValue]];
				//TestString= [NSString stringWithFormat:@"%@%x",TestString,[[DatenByteArray objectAtIndex:i]intValue]];
            
			}
			else
			{
				DataString= [NSString stringWithFormat:@"%@%x",DataString,0xFF];
				//TestString= [NSString stringWithFormat:@"%@%x",TestString,0xFF];
				
			}
			if (i< (8-1))
			{
				DataString = [DataString stringByAppendingString:@"+"];
				//TestString = [TestString stringByAppendingString:@"+"];
			}
		}
		//NSLog(@"HomeClientWriteStandardAktion DataString: %@ TestString: %@",DataString, TestString);
		/*
       // +++++++++
       uint8_t data[8];
       const char* urlbuf= [TestString UTF8String];
       char* buffer;
       buffer = malloc (32);
       strcpy(buffer, urlbuf);
       printf("C-String urlbuf\n");
       printf(urlbuf);
       printf("\n");
       //NSLog(@"\nurlbuf: %c\n",urlbuf);
       
       uint8_t index=0;
       char* linePtr = malloc(32);
       linePtr = strtok(buffer,"+");
       
       printf("buffer: %s\n", buffer);
       
       while (linePtr !=NULL)
       {
       printf("index: %d linePtr: %s\n", index,linePtr);
       
       data[index++] = strtol(linePtr,NULL,16); //http://www.mkssoftware.com/docs/man3/strtol.3.asp
       //strcpy(linePtr,&data[index++]);
       linePtr = strtok(NULL,"+");
       }
       
       NSLog(@"A  data: %d %d %d %d %d %d %d %d",data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]);
       printf("\ndata: %d %d %d %d %d %d %d %d\n",data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7]);
       
       NSLog(@"++");
       //void eepromdecode(char *urlbuf, char data[])
       */
		/*
       {
       const char* urlbuf= [TestString UTF8String];
       NSLog(@"\nurlbuf 2: %s\n",urlbuf);
       uint8_t index=0;
       char c;
       char *dst = malloc(32);
       char* data[8];
       uint8_t l=strlen(urlbuf);
       //dst=urlbuf;
       while (c = *urlbuf)
       {
       printf("\n\nc aus urlbuf: %c\n",c);
       if (c == '+') // Trennung
       {
       printf("\nZeichen ist + dst: %s *\n",dst);
       //+*dst = '\0';
       int l=strlen(dst);
       printf("l: %d",l);
       //dst[l+1] = '\0';
       printf(" * dst: ");
       printf(dst);
       printf("*\n");
       //int i=atoi(dst);
       
       //NSLog(@"index: %d i: %d",index, i);
       //data[index]=i;
       //strcpy( data[index],dst);
       index++;
       urlbuf++;
       //+*dst = '\0';
       //c = *urlbuf;
       //urlbuf++;
       //c = (h2int(c) << 4) | h2int(*urlbuf);
       }
       else
       {
       *dst = c;
       
       }
       printf("dst ende: %s\n",dst);
       //dst++;
       urlbuf++;
       
       } // while
       
       // *dst = '\0';
       //l=strlen(data);
       
       //NSString* ResString= [NSString stringWithUTF8String:data];
       //	NSLog(@"data: %d %d %d %d",data[0],data[1],data[2],data[3]);
       NSLog(@"\ndata: %c",data[0]);
       
       }
       */
		
		
		// +++++++++++++++
		
		WriteDataSuffix = [NSString stringWithFormat:@"%@%@",WriteDataSuffix,DataString];
		//NSLog(@"HomeClientWriteStandardAktion WriteDataSuffix ganz: %@",WriteDataSuffix);
	}
   NSString* HomeClientURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, WriteDataSuffix];
   NSLog(@"HomeClientWriteStandardAktion HomeClientURLString: %@",HomeClientURLString);
   NSURL *URL = [NSURL URLWithString:HomeClientURLString];
   
   [self loadURL:URL];
   
   //NSLog(@"HomeClientWriteStandardAktion DatenByteArray count: %d",[DatenByteArray count]);
   NSString* EEPROM_DataString=[DatenByteArray componentsJoinedByString:@"+"];
   if ([DatenByteArray count]<8)// Tagplanbalken geben nur 6 Bytes
   {
      EEPROM_DataString= [EEPROM_DataString stringByAppendingString:@"+255+255"];
   }
   //NSLog(@"HomeClientWriteStandardAktion EEPROM_DataString: %@",EEPROM_DataString);
   //NSLog(@"EEPROM_DataString: l=%d",[EEPROM_DataString length]);
   
 
   // Datastring sichern fuer senden an HomeServer
   if ([EEPROM_DataString length])
   {
      [SendEEPROMDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"dataload"];
      if ([SendEEPROMDataDic objectForKey:@"adrload"])
      {
         if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
         {
//            NSLog(@"HomeClientWriteStandardAktion SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
            //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
 //           [self sendEEPROMDataMitDic:SendEEPROMDataDic];
         }
      }// adrload
   } // if length
   
}


- (void)HomeClientWriteEEPROM:(NSDictionary*)updateDic
{
	/*
    Einfuegen in ehemaliger EEPROMWrite-Aktion (iow):
    - Daten aus StundenByteArray
    - logString=[logString stringByAppendingString:[NSString stringWithFormat:@"%02X ",[[dieDaten objectAtIndex:xy]intValue]]];
    
    
    */
   int ladeposition = [[updateDic objectForKey:@"ladeposition"]intValue];
   NSLog(@"HomeClientWriteEEPROM ladeposition vor abschicken: %d",ladeposition  );
   if ([[updateDic objectForKey:@"updatearray"]count])
   {
      NSMutableDictionary* sendDic = (NSMutableDictionary*)[[updateDic objectForKey:@"updatearray"]objectAtIndex:ladeposition];
      //NSLog(@"HomeClientWriteEEPROM updateDic stundenbytearray %@",[[sendDic objectForKey:@"stundenbytearray"] description]);
      
      //NSLog(@"HomeClientWriteStandardAktion note stundenbytearray %@",[[[note userInfo]objectForKey:@"stundenbytearray"]description]);
      //	int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
      //	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
      //	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
      //	NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenarray"];
      
      //[sendDic setObject:[NSNumber numberWithInt:ladeposition]forKey:@"ladeposition"];
      
      WebTask = idle;
      
      [SendEEPROMDataDic setObject:[sendDic objectForKey:@"titel"] forKey:@"titel"];
      [SendEEPROMDataDic setObject:[sendDic objectForKey:@"tagbalkentyp"] forKey:@"tagbalkentyp"];
      
      NSArray* DatenByteArray=[sendDic objectForKey:@"stundenbytearray"];
      
      NSString* lbyte=[[sendDic objectForKey:@"lbyte"]stringValue];
      NSString* hbyte=[[sendDic objectForKey:@"hbyte"]stringValue];
      
      if ([lbyte length]==1)
      {
         lbyte = [@"0" stringByAppendingString:lbyte];
      }
      
      if ([hbyte length]==1)
      {
         hbyte = [@"0" stringByAppendingString:hbyte];
      }
      
      //NSLog(@"HomeClientWriteEEPROM lbyte als String: %@ hbyte als String: %@",lbyte,hbyte);
      [SendEEPROMDataDic setObject:hbyte forKey:@"hbyte"];
      [SendEEPROMDataDic setObject:lbyte forKey:@"lbyte"];
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1]forKey:@"adrload"];
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0]forKey:@"dataload"];
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1]forKey:@"permanent"];
      
      
      //NSString* EEPROM_i2cAdresseString=[I2CPop itemTitleAtIndex:I2CIndex];
      //AnzahlDaten=0x20; //32 Bytes, TAGPLANBREITE;
      //	unsigned int EEPROM_i2cAdresse = [[[note userInfo]objectForKey:@"eepromadresse"]intValue];
      //	NSString*  EEPROM_i2cAdresse_String = [[note userInfo]objectForKey:@"eepromadressestring"];
      NSString*  EEPROM_i2cAdresse_Zusatz = [sendDic objectForKey:@"eepromadressezusatz"];
      // URL aufbauen
      NSString* WriteDataSuffix=[NSString string];
      //if ([[note userInfo]objectForKey:@"pw"])//
      {
         // URL aufbauen
         // pw, Adresszusatz fuer das EEPROM (wadr) anfuegen
         WriteDataSuffix = [NSString stringWithFormat:@"pw=%@&wadr=%@",pw,EEPROM_i2cAdresse_Zusatz];
         
         // lbyte, hbyte anfuegen
         WriteDataSuffix = [NSString stringWithFormat:@"%@&lbyte=%@&hbyte=%@",WriteDataSuffix,lbyte,hbyte];
         //NSLog(@"HomeClientWriteEEPROM WriteDataSuffix: %@",WriteDataSuffix);
         
         // data anfuegen
         int i=0;
         NSString* DataString=@"&data=";
         //NSLog(@" Datenarray count %d",[DatenArray count]);
         //NSLog(@" DataString: %@",DataString);
         NSString* TestString=[NSString string];// Kontrolle
         //			for (i=0;i<[DatenByteArray count];i++)
         for (i=0;i<8;i++)
         {
            //DataString  = [DataString stringByAppendingString:[[DatenByteArray objectAtIndex:i]stringValue]];
            if (i<[DatenByteArray count])
            {
               DataString= [NSString stringWithFormat:@"%@%x",DataString,[[DatenByteArray objectAtIndex:i]intValue]];
               //TestString= [NSString stringWithFormat:@"%@%x",TestString,[[DatenByteArray objectAtIndex:i]intValue]];
               
            }
            else
            {
               DataString= [NSString stringWithFormat:@"%@%x",DataString,0xFF];
               //TestString= [NSString stringWithFormat:@"%@%x",TestString,0xFF];
               
            }
            if (i< (8-1))
            {
               DataString = [DataString stringByAppendingString:@"+"];
               //TestString = [TestString stringByAppendingString:@"+"];
            }
         }
         
         WriteDataSuffix = [NSString stringWithFormat:@"%@%@",WriteDataSuffix,DataString];
         //NSLog(@"HomeClientWriteStandardAktion WriteDataSuffix ganz: %@",WriteDataSuffix);
      }
      NSString* HomeClientURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, WriteDataSuffix];
      //NSLog(@"HomeClientWriteEEPROM HomeClientURLString: %@",HomeClientURLString);
      NSURL *URL = [NSURL URLWithString:HomeClientURLString];
      
      [self loadURL:URL];
      
      NSString* EEPROM_DataString=[DatenByteArray componentsJoinedByString:@"+"];
      if ([DatenByteArray count]<8) // Tagplanbalken geben nur 6 Bytes
      {
         EEPROM_DataString= [EEPROM_DataString stringByAppendingString:@"+255+255"];
      }
      //NSLog(@"HomeClientWriteStandardAktion EEPROM_DataString: %@",EEPROM_DataString);
      //NSLog(@"EEPROM_DataString: l=%d",[EEPROM_DataString length]);
      
      
      // Datastring sichern fuer senden an HomeServer
      if ([EEPROM_DataString length])
      {
         [SendEEPROMDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
         [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"dataload"];
         if ([SendEEPROMDataDic objectForKey:@"adrload"])
         {
            if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
            {
               //            NSLog(@"HomeClientWriteStandardAktion SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
               //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
               //           [self sendEEPROMDataMitDic:SendEEPROMDataDic];
            }
         }// adrload
      } // if length
   } // if count
}

- (void)HomeClientWriteModifierAktion:(NSNotification*)note
{
	//NSLog(@"HomeClientWriteModifierAktion note  %@",[[note userInfo]description]);
	//NSLog(@"HomeClientWriteModifierAktion note stundenbytearray %@",[[[note userInfo]objectForKey:@"modifierstundenbytearray"]description]);

//	int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
//	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
//	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
//	NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenarray"];
   
   WebTask = idle;
   
	NSArray* DatenByteArray=[[note userInfo]objectForKey:@"modifierstundenbytearray"];

	NSString* lbyte=[[note userInfo]objectForKey:@"lbyte"];
	NSString* hbyte=[[note userInfo]objectForKey:@"hbyte"];
	NSLog(@"lbyte: %@ hbyte: %@",lbyte,hbyte);
	//NSLog(@"DatenByteArray: %@",[DatenByteArray description]);

	NSString*  EEPROM_i2cAdresse_Zusatz = [[note userInfo]objectForKey:@"eepromadressezusatz"];
	
	// URL aufbauen
	NSString* WriteDataSuffixA=[NSString string];
	NSString* WriteDataSuffixB=[NSString string];
	//if ([[note userInfo]objectForKey:@"pw"])//
	{
		WriteDataSuffixA = [NSString stringWithFormat:@"pw=%@&wadr=%@",pw,EEPROM_i2cAdresse_Zusatz]; 
		WriteDataSuffixA = [NSString stringWithFormat:@"%@&lbyte=%@&hbyte=%@",WriteDataSuffixA,lbyte,hbyte];

		WriteDataSuffixB = [NSString stringWithFormat:@"pw=%@&wadr=%@",pw,EEPROM_i2cAdresse_Zusatz]; 
		int lb=[lbyte intValue];
		lb +=32;
		lbyte =[[NSNumber numberWithInt:lb]stringValue];
		WriteDataSuffixB = [NSString stringWithFormat:@"%@&lbyte=%@&hbyte=%@",WriteDataSuffixB,lbyte,hbyte];

		NSLog(@"HomeClientWriteModifierAktion WriteDataSuffixA: %@",WriteDataSuffixA);
		NSLog(@"HomeClientWriteModifierAktion WriteDataSuffixB: %@",WriteDataSuffixB);
		
		
		int i=0;
		NSString* DataStringA=@"&data="; // 32 Bytes
		NSString* DataStringB=@"&data=";	// 24 Bytes
		//NSLog(@" Datenarray count %d",[DatenArray count]);
		//NSLog(@" DataString: %@",DataString);
		NSString* TestString=[NSString string];
		
		for (i=0;i<[DatenByteArray count];i++)
		{
			NSArray* TagDatenArray=[DatenByteArray objectAtIndex:i];
			NSLog(@"TagDatenArray: %@",[TagDatenArray description]);
			int k=0;
			// TagDatenArray abarbeiten
			for (k=0;k<8;k++)
			{
				{
					if (i<4)
					{
						DataStringA= [NSString stringWithFormat:@"%@%x",DataStringA,[[TagDatenArray objectAtIndex:k]intValue]];
						// + als Trennzeichen einfuegen
						if (k< (8-1))
						{
							DataStringA = [DataStringA stringByAppendingString:@"+"];
						}
						
					}
					else 
					{
						DataStringB= [NSString stringWithFormat:@"%@%x",DataStringB,[[TagDatenArray objectAtIndex:k]intValue]];
						if (k< (8-1))
						{
							DataStringB = [DataStringB stringByAppendingString:@"+"];
						}
						
					}
					
					TestString= [NSString stringWithFormat:@"%@%x",TestString,[[TagDatenArray objectAtIndex:k]intValue]];
				}
				
			}// for k
			
			// + als Trennzeichen einfuegen
			if (i< 3)
				{
					DataStringA = [DataStringA stringByAppendingString:@"+"];
					TestString = [TestString stringByAppendingString:@"+"];
				}
			else if ((i>3) && (i<6))
			{
				DataStringB = [DataStringB stringByAppendingString:@"+"];
			}
		}
		NSLog(@"HomeClientWriteStandardAktion \nDataStringA: %@ \nDataStringB: %@",DataStringA, DataStringB);
		
		
		WriteDataSuffixA = [NSString stringWithFormat:@"%@%@",WriteDataSuffixA,DataStringA];
		WriteDataSuffixB = [NSString stringWithFormat:@"%@%@",WriteDataSuffixB,DataStringB];
		
		//NSLog(@"HomeClientWriteModifierAktion WriteDataSuffix ganz: %@",WriteDataSuffix);
	}
		NSString* HomeClientURLStringA =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, WriteDataSuffixA];
		NSLog(@"HomeClientWriteModifierAktion HomeClientURLStringA: %@",HomeClientURLStringA);
		NSURL *URL_A = [NSURL URLWithString:HomeClientURLStringA];

		NSString* HomeClientURLStringB =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, WriteDataSuffixB];
		NSLog(@"HomeClientWriteModifierAktion HomeClientURLStringB: %@",HomeClientURLStringB);
		
		NSURL *URL_B = [NSURL URLWithString:HomeClientURLStringB];
		
//		[self loadURL:URL];

	}


- (void)setHomeCentralI2C:(int)derStatus
{
	
}

- (void)setWebI2C:(int)derStatus
{
	
}

- (NSString*)ReadURLForEEPROM:(int)EEPROMADDRESS hByte: (int)hbyte lByte:(int)lbyte
{
	NSLog(@"ReadURLForEEPROM EEPROMAddresse: %X  hbyte: %X lbyte: %X", EEPROMADDRESS, hbyte, lbyte);
	
	NSString* ReadURL = [NSString string];
	
	
	return ReadURL;
}
- (NSString*)WriteURLForAddress:(int)EEPROMADDRESS fromAddress: (int)startAddress
{
	NSString* WriteURL =  [NSString string];
	
	return WriteURL;
	
}

#pragma mark EEPROM 2 HomeServer
- (int)sendEEPROMDataMitDic:(NSDictionary*)EEPROMDataDic
{
   int err=0;
   //NSLog(@"sendEEPROMDataMitDic URL: %s EEPROMDataDic: %@",WEBSERVER_VHOST ,[EEPROMDataDic description] );
   /*
    WEBSERVER_VHOST
   
    cgi-bin/eeprom.pl?pw=Pong&d0= usw
    */
   if ([SendEEPROMDataDic objectForKey:@"adrload"] && ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1))
   {
      if ([[SendEEPROMDataDic objectForKey:@"dataload"]intValue]==1 && ([[SendEEPROMDataDic objectForKey:@"dataload"]intValue]==1))// EEPROMData ist da
      {
         if ([[SendEEPROMDataDic objectForKey:@"eepromdatastring" ] length])
         {
            NSString* URLString = [NSString stringWithFormat:@"http://%s/%s?pw=%s&perm=%@&hbyte=%@&lbyte=%@&data=%@&titel=%@&tagbalkentyp=%@",
                                   WEBSERVER_VHOST,
                                   CGI,
                                   PW,
                                   [EEPROMDataDic objectForKey:@"permanent"],
                                   [EEPROMDataDic objectForKey:@"hbyte"],
                                   [EEPROMDataDic objectForKey:@"lbyte"],
                                   [EEPROMDataDic objectForKey:@"eepromdatastring"],
                                   [EEPROMDataDic objectForKey:@"titel"],
                                   [EEPROMDataDic objectForKey:@"tagbalkentyp"]
                                   
                                   ];
            NSLog(@"sendEEPROMDataMitDic URLString: \n%@",URLString );
            
            NSURL *URL = [NSURL URLWithString:URLString];
            //NSLog(@"sendEEPROM URL: %@",URL );
            NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
            //	[[NSURLCache sharedURLCache] removeAllCachedResponses];
            //	NSLog(@"Cache mem: %d",[[NSURLCache sharedURLCache]memoryCapacity]);
            //	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:HCRequest];
            //	NSLog(@"loadURL:Vor loadRequest");
            if (HCRequest)
            {
               //NSLog(@"loadURL:Request OK");
               [[webView mainFrame] loadRequest:HCRequest];
            }
            [SendEEPROMDataDic setObject:@"" forKey:@"eepromdatastring"];
         }
         [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"dataload"]; // SendEEPROMDataDic deaktivieren
      }
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"adrload"];
   }
	//[self loadURL:URL];
   
   return err;
}




- (void)EEPROMUpdateClearAktion:(NSNotification*)note
{
   
 /*
   NSString* URLString = [NSString stringWithFormat:@"https://%s/%s?pw=%s&perm=%d",
                          WEBSERVER_VHOST,
                          CGI_UPDATE_CLEAR,
                          PW,
                          13
                          ];
  */
   NSString* URLString = [NSString stringWithFormat:@"http://%s/%s?pw=%s&perm=%d",
                          WEBSERVER_VHOST,
                          CGI_UPDATE_CLEAR,
                          PW,
                          13
                          ];
   
   //NSString* URLString = @"http://www.ruediheimlicher.ch/cgi-bin/eepromupdate.pl";
   NSURL *URL = [NSURL URLWithString:URLString];
   NSLog(@"EEPROMUpdateClearAktion URL: %@",URL );
   NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
   if (HCRequest)
   {
      //NSLog(@"loadURL:Request OK");
      [[webView mainFrame] loadRequest:HCRequest];
   }
   
   //cgi-bin/eepromupdate.pl?perm=13
   [self loadURL:URL];
}


- (void)EEPROMWriteWocheAktion:(NSNotification*)note
{
   //NSLog(@"EEPROMWriteWocheAktion %@ ",[[note userInfo]description]);
   [self updateEEPROMAktion:note];
}



- (void)updateEEPROMAktion:(NSNotification*)note
{
   NSLog(@"updateEEPROMAktion ");
   NSMutableDictionary* updateDic=(NSMutableDictionary*) [note userInfo];
   //NSLog(@"updateEEPROMAktion updateDic: %@",[updateDic description]);
   //NSLog(@"updateEEPROMAktion updatearray: %@",[[updateDic objectForKey:@"updatearray"]objectAtIndex:0]);
   //NSDictionary* sendDic = [[updateDic objectForKey:@"updatearray"]objectAtIndex:0];
   NSMutableDictionary* sendDic = [[NSMutableDictionary alloc]initWithDictionary:updateDic];
   
   
   // Startwert fuer anzahl Versuche beim Warten auf busy=0
   [sendDic setObject:[NSNumber numberWithInt:10] forKey:@"anzahl"];
   
   // Ladeposition, wird in der Timerfunktion inkrementiert
   [sendDic setObject:[NSNumber numberWithInt:0 ] forKey:@"ladeposition"];

   // Anzahl Pakete, die gesendet werden sollen
   [sendDic setObject:[NSNumber numberWithInt:[[updateDic objectForKey:@"updatearray"]count]] forKey:@"updatecounter"];
   
   //NSLog(@"updateEEPROMAktion sendDic: %@",[sendDic description]);
   
   //NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   
   //[NotificationDic setObject:sendDic forKey:@"userInfo"];

   //[self HomeClientWriteEEPROM:sendDic];
  //[self HomeClientWriteStandardAktion:(NSNotification*)sendDic];
   
   int sendDelay=1.0;
   
   
   
   EEPROMUpdateTimer=[NSTimer scheduledTimerWithTimeInterval:sendDelay
                                                       target:self
                                                     selector:@selector(EEPROMUpdateTimerfunktion:)
                                                     userInfo:sendDic
                                                      repeats:YES];

   
}

- (void)EEPROMUpdateTimerfunktion:(NSTimer*)timer
{
   //NSLog(@"EEPROMUpdateTimerfunktion WriteWoche_busy: %d",WriteWoche_busy);
	NSMutableDictionary* updateDic=(NSMutableDictionary*) [timer userInfo];
	//NSLog(@"WriteModifierTimerfunktion  WriteTimerDic: %@",[WriteTimerDic description]);
	int busycounter=[[updateDic objectForKey:@"anzahl"]intValue]; // Zaehler der Verbindungsversuche bei busy
   int updatecounter=[[updateDic objectForKey:@"updatecounter"]intValue];
   int ladeposition=[[updateDic objectForKey:@"ladeposition"]intValue];
	
   
   //NSLog(@"EEPROMUpdateTimerfunktion anzahlcounter: %d",anzahlcounter);
   //NSLog(@"EEPROMUpdateTimerfunktion updatecounter: %d",updatecounter);
   //NSLog(@"EEPROMUpdateTimerfunktion ladeposition: %d",ladeposition);
   
   busycounter--;
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSDictionary* tempDataDic=[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:busycounter],@"busycount",
                              nil];
   [nc postNotificationName:@"EEPROMbusycount" object:self userInfo:tempDataDic];

   if (busycounter == 0) // zu lange gewartet oder alles geschickt
   {
      NSLog(@"anzahlcounter == 0 > EEPROMUpdateTimer invalidate");
      [timer invalidate];
      
   }
   else if (ladeposition == updatecounter-1)
   {
      NSLog(@"ladeposition == updatecounter-1 > EEPROMUpdateTimer invalidate");
      [timer invalidate];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      NSDictionary* tempDataDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:1],@"fertig",
                                 nil];
      
      [nc postNotificationName:@"EEPROMUpdateFertig" object:self userInfo:tempDataDic];
      
      
      return;
   }

	//NSLog(@"EEPROMUpdateTimerfunktion Webserver_busy: %d",Webserver_busy);
   // Webserver busy??
	//if (Webserver_busy)
	if (WriteWoche_busy)
   {
      //NSLog(@"EEPROMUpdateTimerfunktion WriteWoche_busy blockiert Ablauf: WriteWoche_busy: %d ",WriteWoche_busy);
      WriteWoche_busy--;
      if (WriteWoche_busy==1)
      {
         [[NSSound soundNamed:@"Pop"] play];
      }
   
   }
   else 
   {
      NSLog(@"EEPROMUpdateTimerfunktion WriteWoche_busy laesst Ablauf zu");
      
      NSDictionary* tempDataDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ladeposition],@"ladeposition", nil];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"EEPROMLadeposition" object:self userInfo:tempDataDic];

      WriteWoche_busy=10;
      [self HomeClientWriteEEPROM:updateDic];
      [updateDic setObject:[NSNumber numberWithInt:ladeposition+1]forKey:@"ladeposition"];
   
   }
  
  
   
   //[updateDic setObject:[NSNumber numberWithInt:anzahlcounter]forKey:@"anzahlcounter"];
   //
   
}

/*
- (void)EEPROMUpdateTimerFunktion:(NSTimer*)timer
{
   NSLog(@"WriteModifierTimerfunktion WriteWoche_busy: %d",WriteWoche_busy);
	NSMutableDictionary* updateDic=(NSMutableDictionary*) [timer userInfo];
	//NSLog(@"WriteModifierTimerfunktion  WriteTimerDic: %@",[WriteTimerDic description]);
	int timeoutcounter=[[updateDic objectForKey:@"timeoutcounter"]intValue];
	NSLog(@"timeoutcounter: %d",timeoutcounter);
	
   // Webserver busy??
	if (Webserver_busy)
	{
      NSLog(@"EEPROMUpdateTimerFunktion Webserver_busy beep");
		NSBeep();
		timeoutcounter--;
		[updateDic setObject:[NSNumber numberWithInt:timeoutcounter] forKey:@"timeoutcounter"];
		
		if (timeoutcounter == 0)
		{
			NSLog(@"timeoutcounter ist null");
			[timer invalidate];
			[timer release];
			WriteWoche_busy=0;
			
			//[self setTWITaste:YES];
		}
		return;
	}
   
   
}
*/

#pragma mark Statistik pl

- (void)KollektormittelwerteberechnenMitJahr:(int)jahr
{
      int monat = 1;
   
   NSString* URLString = [NSString stringWithFormat:@"http://%s/%s?jahr=%d&monat=%d",
                          WEBSERVER_VHOST,
                          "cgi-bin/kollektormittelwerte.pl",
                          jahr,
                          monat
                          
                          ];
/*
 NSString* URLString = [NSString stringWithFormat:@"https://%s/%s?jahr=%d&monat=%d",
 WEBSERVER_VHOST,
 "cgi-bin/kollektormittelwerte.pl",
 jahr,
 monat
 
 ];

 */
   //NSString* URLString = @"http://www.ruediheimlicher.ch/cgi-bin/hello.pl";
   NSURL *URL = [NSURL URLWithString:URLString];
   NSLog(@"Kollektormittelwerteberechnen URL: %@",URL );
   NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
   if (HCRequest)
   {
      //NSLog(@"loadURL:Request OK");
      [[webView mainFrame] loadRequest:HCRequest];
   }
   
   //cgi-bin/eepromupdate.pl?perm=13
   [self loadURL:URL];
}

#pragma mark URL-Stuff
- (NSString *)url
{
	return url;
}

- (void)setURL:(NSString *)u
{
	url = u;
}


- (void)loadURL:(NSURL *)URL
{
	NSLog(@"loadURL: %@",URL);
	NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
//	NSLog(@"Cache mem: %d",[[NSURLCache sharedURLCache]memoryCapacity]);
//	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:HCRequest]; // > crash
//	NSLog(@"loadURL:Vor loadRequest");
	if (HCRequest)
	{
      //NSLog(@"loadURL:Request OK");
      [[webView mainFrame] loadRequest:HCRequest];
      loadAlertOK=0;
	}
   //- [[webView mainFrame] stopLoading]
}

- (void)setURLToLoad:(NSURL *)URL
{
	URLToLoad = URL;
}


- (void)setFrameStatus: (NSString *)s
{
	
}


- (NSString *)source
{
	
	return _source;
}
- (void)setSource:(NSString *)webContent
{
	_source = webContent;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
   return nil;
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	
   [tempDataDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
	//NSLog(@"***       HomeClient Webview didFinishLoadForFrame  ***");
	//NSLog(@"sender: %@",[sender description]);
	// Only report feedback for the main frame.
	NSString* HTML_Inhalt=[self dataRepresentationOfType:HTMLDocumentType];
	NSLog(@"didFinishLoadForFrame Antwort: \nHTML_Inhalt: \t%@\n",HTML_Inhalt);
	loadAlertOK=1;
	NSRange CheckRange;
	NSString* Code_String= @"okcode=";
	NSString* Status0_String= @"status0";
	NSString* Status1_String= @"status1";
	NSString* PW_String= @"ideur00";
   NSString* taskok_String= @"taskok";
	
	NSString* status0_String= @"status0+"; // Status 0 ist bestaetigt
   
   NSString* EEPROMUpdate_String= @"eepromupdate";
   
	//NSString* Status0_String= @"status=0";
	//NSString* Status1_String= @"status=1";

	
	
	// 
	// Test, ob Webseite eine okcode-Antwort ist
	CheckRange = [HTML_Inhalt rangeOfString:Code_String];
	if (CheckRange.location < NSNotFound)
	{
		//NSLog(@"didFinishLoadForFrame: okcode ist da");
		[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"okcode"];
		
		CheckRange = [HTML_Inhalt rangeOfString:Status0_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"didFinishLoadForFrame: Status = 0");
			//[tempDataDic setObject:@"status" forKey:@"antwort"];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"twistatus"];
         loadTestStatus = END_STATUS0;
		}
		
		CheckRange = [HTML_Inhalt rangeOfString:Status1_String];
		if (CheckRange.location < NSNotFound)
		{
         //NSLog(@"didFinishLoadForFrame: Status = 1");
			//[tempDataDic setObject:@"status" forKey:@"antwort"];
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"twistatus"];
         loadTestStatus = END_STATUS1;
		}

      // isstatus0ok vorhanden??
		
		//NSString* status0_String= @"status0+";
		CheckRange = [HTML_Inhalt rangeOfString:status0_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: status0+ ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"status0"];
			[confirmStatusTimer invalidate];
         loadTestStatus = END_STATUS0;
		}
		else
		{
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"status0"];
		}

// end isstatus0ok		
		
      
      // radr vorhanden??
		NSString* EEPROM_Adresse_String= @"radr";
      
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Adresse_String];
		if (CheckRange.location < NSNotFound)
		{
			//			NSLog(@"didFinishLoadForFrame: radr ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"radrok"];
		}
		else
		{
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"radrok"];
		}
		
      
      // data vorhanden??
      
		NSString* Data_String= @"data"; 
		CheckRange = [HTML_Inhalt rangeOfString:Data_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame okcode: data ist da  loc: %lu",(unsigned long)CheckRange.location);
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"data"];
		}
		else
		{
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"data"];
		}
		
		//eeprom laden gelungen
		NSString* EEPROM1_String= @"eeprom+"; 
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM1_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: eeprom+ ist da loc: %lu ",(unsigned long)CheckRange.location);
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom+"];
         //loadTestStatus = END_WRITE;
      }
		else
		{
			//[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"eeprom+"];
		}
		
		// eeprom laden nicht gelungen
		NSString* EEPROM0_String= @"eeprom-"; 
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM0_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: eeprom- ist da ");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom-"];
		}
		else
		{
			//[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"eeprom-"];
		}
		
				
		NSString* EEPROM_Write_Adresse_String= @"wadr"; // Write-Adresse ist angekommen
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_Adresse_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"didFinishLoadForFrame: wadr ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"wadrok"];
			[self EEPROMisWriteOKRequest];
			
			
		}
		else
		{
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"wadrok"];
		}


		//EEPROm schreiben ist gelungen
		NSString* EEPROM_Write_OK_String= @"write+"; 
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_OK_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: write+ ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"writeok"];
			[confirmTimer invalidate];
			Webserver_busy=0;
         WriteWoche_busy --;
         loadTestStatus = END_WRITE;
         
         // Daten an HomeServer schicken
         if ([SendEEPROMDataDic objectForKey:@"dataload"])
         {
            if ([[SendEEPROMDataDic objectForKey:@"dataload"]intValue]==1 )// EEPROM Data ist da
            {
               if ([SendEEPROMDataDic objectForKey:@"adrload"])
               {
                  if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
                  {
                     //NSLog(@"didFinishLoad SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
                     //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
                     
                     //if (WriteWoche_busy==3)
                     {
                        WriteWoche_busy--;
                        [self sendEEPROMDataMitDic:SendEEPROMDataDic];
                     }
                  }
               }// adrload
            }
         }
         
      }
		else
		{
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
         
		}

		//EEPROm schreiben ist nicht gelungen
		NSString* EEPROM_Write_NOT_OK_String= @"write-"; 
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_NOT_OK_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: write- ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
		}

      // taskok angekommen?
      CheckRange = [HTML_Inhalt rangeOfString:taskok_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"didFinishLoadForFrame: taskok ist da");
         [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"taskok"];
      }
      else
      {
         [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"taskok"];
      }



		
	} // if okcode
	
	// Data lokalisieren	
		NSString* Data_String= @"data"; 
	
		{
		
		CheckRange = [HTML_Inhalt rangeOfString:Data_String];
		if (CheckRange.location < NSNotFound)
		{
         // data ist angekommen, sendTimer ausschalten
         
         //NSLog(@"didFinishLoadForFrame read EEPROM Antwort: \nHTML_Inhalt: \t\t\t\t%@",HTML_Inhalt);
			//NSLog(@"didFinishLoadForFrame: data ist da  loc: %d",CheckRange.location);
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"data"];
			int datastart=0, dataend=0;
			//NSLog(@"didFinishLoadForFrame: nach pw   eeprom+ ist da loc: %d",CheckRange.location);
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom+"];
			[sendTimer invalidate];
			
         // location von = feststellen: Beginn Datastring
			
         NSString* Gleich_String= @"=";
			CheckRange = [HTML_Inhalt rangeOfString:Gleich_String];
			if (CheckRange.location < NSNotFound)
			{
				//NSLog(@"didFinishLoadForFrame: = ist da  loc: %d",CheckRange.location);
				datastart=CheckRange.location+1;
				dataend=datastart;
				[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"gleich"];
			}
			else
			{
				[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"gleich"];
			}
			
         // location von </p> feststellen: Ende Datastring
			NSString* tag_String= @"</p>"; 
			CheckRange = [HTML_Inhalt rangeOfString:tag_String];
			if (CheckRange.location < NSNotFound)
			{
				//NSLog(@"didFinishLoadForFrame: < ist da  loc: %d",CheckRange.location);
				dataend=CheckRange.location;
				[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"tag"];
			}
			else
			{
				[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"tag"];
			}
         
         // EEPROM-String extrahieren
         
			NSString* EEPROM_DataString=[HTML_Inhalt substringWithRange:NSMakeRange(datastart,dataend-datastart)];
			NSLog(@"didFinishLoad EEPROM_DataString: %@ WebTask: %d",EEPROM_DataString,WebTask);
         
         NSString* ff_String= @"ff+ff+ff+ff"; // test-Data
         NSRange CheckRange = [EEPROM_DataString rangeOfString:ff_String];
         if (CheckRange.location < NSNotFound)
         {
            lastEEPROMData = EEPROM_DataString;
            NSLog(@"loadTimerFunktion ff+ff+  loc: %d",CheckRange.location);
            testdataok = 1;
            
            if (lastEEPROMData)
            {
               lastEEPROMData = EEPROM_DataString;
            }
            else
            {
               lastEEPROMData = [NSString stringWithString:EEPROM_DataString];
            }
         }
         else
         {
            testdataok=0;
            
            
         }
         //lastEEPROMData = @"asdfghjkl";
         loadTestStatus = END_READ;
			NSLog(@"didFinishLoad lastEEPROMData: %@",lastEEPROMData);
			[tempDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
			
         // Datastring sichern fuer senden an HomeServer
         if ([EEPROM_DataString length])
         {
            // Hex in dez umwandeln fuer senden an HomeServer
            NSArray* tempDataArray = [EEPROM_DataString componentsSeparatedByString:@"+"];
            //NSLog(@"tempDataArray: %@",[tempDataArray description]);
            NSMutableArray* tempDezDataArray = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i=0;i<[tempDataArray count];i++)
            {
               int data = [self HexStringZuInt:[tempDataArray objectAtIndex:i] ];
               
               [tempDezDataArray addObject:[NSString stringWithFormat:@"%d",data]];
               //NSLog(@"data: %d string: %@",data, [NSString stringWithFormat:@"%d",data]);
            }
            EEPROM_DataString = [tempDezDataArray componentsJoinedByString:@"+"];
            
            //if (WebTask == eepromreadwoche)
            {
               
            }
            //else
            {
               [SendEEPROMDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
               [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"dataload"];
               if ([SendEEPROMDataDic objectForKey:@"adrload"])
               {
                  if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
                  {
                     //NSLog(@"didFinishLoad SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
                     //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
 //                    [self sendEEPROMDataMitDic:SendEEPROMDataDic];
                  }
               }// adrload
            }
         } // if length
		}
		else
		{
			//[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"data"];
		}
		
	} // if pw vorhanden
	
   
   NSString* HomeServerOK_String= @"homeserver+";
   CheckRange = [HTML_Inhalt rangeOfString:HomeServerOK_String];
   if (CheckRange.location < NSNotFound)
   {
      //NSLog(@"didFinishLoadForFrame: homeserver+ ist da");
      WriteWoche_busy--;

   }
   
   
	//NSString* EEPROMUpdate_String= @"eepromupdate";
   //CheckRange = [HTML_Inhalt rangeOfString:EEPROMUpdate_String];
   CheckRange = [HTML_Inhalt rangeOfString:@"eepromclearok"];
   if (CheckRange.location < NSNotFound)
   {
      NSLog(@"didFinishLoadForFrame: eepromupdate oder eepromclearok ist da");
      [tempDataDic setObject:@"eepromupdate ist geleert" forKey:@"eepromupdate"];
      [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"writeok"];
      //okcode=status1
      [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"okcode"];
      [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"twistatus"];
      [confirmTimer invalidate];
      Webserver_busy=0;

   }
   
	[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
	
   
	
	if (frame == [sender mainFrame]) 
	{
		[self setFrameStatus:nil];
	}
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    // Only report feedback for the main frame.
    if (frame == [sender mainFrame])
	 {
        NSString *provurl = [[[[frame provisionalDataSource] request] URL] absoluteString];
		  NSLog(@"HomeClient didStartProvisionalLoadForFrame: URL: %@",provurl);
       
       // URL: http://ruediheimlicher.dyndns.org/twi?pw=ideur00&rdata=10
       
       // [textField setStringValue:url];
    }
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	// String: didStartProvisionalLoadForFrame: URL: http://ruediheimlicher.dyndns.org/twi?pw=ideur00&status=1
	if (frame == [sender mainFrame])
	{
      if ([error code] == NSURLErrorCancelled)
      {
         NSLog(@"didFailProvisionalLoadWithError: -999");
         return;
      }
		NSRange CheckRange;
		NSString* Code_String= @"okcode=";
		NSString* Status0_String= @"status=0";
		NSString* Status1_String= @"status=1";
		NSString* PW_String= @"ideur00";
		NSString* Error_String= @"error";
      NSString* EEPROMUpdate_String= @"eepromupdate";
		
		NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
		NSString *provurl = [[[[frame provisionalDataSource] request] URL] absoluteString];
		NSLog(@"didFailProvisionalLoadWithError: URL: %@",provurl);
		[tempDataDic setObject:provurl forKey:@"provurl"];
		[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"waitrad"];
		// Test, ob URL einen okcode  enthält
		CheckRange = [provurl rangeOfString:PW_String]; // Passwortstring ist da, eigene URL
		NSLog(@"didFailProvisionalLoadWithError: CheckRange fuer pw-string?");
      
      if (CheckRange.location < NSNotFound)
		{
			[tempDataDic setObject:Error_String forKey:@"error"];
			//[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"passwortok"];
			CheckRange = [provurl rangeOfString:Status0_String]; // Fehler bei Status0-Anforderung
			if (CheckRange.location < NSNotFound)
			{
				NSLog(@"didFailProvisionalLoadWithError: Status = 0");
				//[tempDataDic setObject:@"status" forKey:@"antwort"];
				[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"twistatus"];
			}
			CheckRange = [provurl rangeOfString:Status1_String];// Fehler bei Status1-Anforderung
			if (CheckRange.location < NSNotFound)
			{
				NSLog(@"didFailProvisionalLoadWithError: Status = 1");
				//[tempDataDic setObject:@"status" forKey:@"antwort"];
				[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"twistatus"];
			}
		}
      CheckRange = [provurl rangeOfString:EEPROMUpdate_String]; // P
		if (CheckRange.location < NSNotFound)
      {
         
         NSLog(@"didFailProvisionalLoadWithError: EEPROM Update: %@",EEPROMUpdate_String);

      }
      
      NSString *errorDescription = [error localizedDescription];
      NSLog(@"didFailProvisionalLoadWithError: errorDescription: %@",errorDescription);
		if (!errorDescription) 
		{
			errorDescription = NSLocalizedString(@"An error occured during provisional download.",@"Provisorischer Download ging schief.");
		}	
		
		//NSBeginAlertSheet(@"Provisional Download misslungen", nil, nil, nil, [self window], nil, nil, nil, nil, errorDescription);
      
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		NSString* MessageText= NSLocalizedString(@"Error in ProvisionalDownload",@"Provisional Download misslungen");
		//NSString* Detailstring = @"
      
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageText]];
		
		//[tempDataDic setObject:[NSNumber numberWithInt:-1] forKey:@"twistatus"];
		
		NSString* s1=errorDescription;
		[tempDataDic setObject:errorDescription forKey:@"errordescription"];
		
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		
      [[webView mainFrame] stopLoading];
		
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
		
	}
	
}


- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{
		NSString *errorDescription = [error localizedDescription];
		if (!errorDescription) 
		{
			errorDescription = NSLocalizedString(@"An error occured during download.",@"Download ging schief.");
		}	
		
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		NSString* MessageText= NSLocalizedString(@"Error in Download",@"Download misslungen");
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageText]];
		
		NSString* s1=errorDescription;
		NSString* s2=@"Ort: HomeClient";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		
		
		NSLog(@"Webview didFailLoadWithError");
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:error forKey:@"error"];
		
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"LoadFail" object:self userInfo:NotificationDic];
	}
}


- (void)webView:(WebView *)sender willCloseFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{
		NSString *provurl = [[[[frame provisionalDataSource] request] URL] absoluteString];
		//NSLog(@"willCloseFrame: URL: %@",provurl);
	}
}



- (NSString *)frameStatus
{
    return frameStatus;
}




- (NSString *)dataRepresentationOfType:(NSString *)aType
{
	if (![aType isEqualToString:HTMLDocumentType])
	{
		NSLog(@" dataRepresentationOfType: kein HTML");
		return nil;
	}
	//NSLog(@" dataRepresentationOfType: HTML");
	[self setSource:[(DOMHTMLElement *)[[[webView mainFrame] DOMDocument] documentElement] outerHTML]];
	return [self source];
}





@end

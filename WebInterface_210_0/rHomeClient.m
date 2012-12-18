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
			 selector:@selector(HomeClientWriteStandardAktion:)
				  name:@"HomeClientWriteStandard"
				object:nil];

		[nc addObserver:self
			 selector:@selector(HomeClientWriteModifierAktion:)
				  name:@"HomeClientWriteModifier"
				object:nil];
	
   
   SendEEPROMDataDic = [[[NSMutableDictionary alloc]initWithCapacity:0]retain];

   
   
   
#pragma mark HomeCentralURL
	
HomeCentralURL=@"http://ruediheimlicher.dyndns.org";
	//LocalHomeCentralURL=@"192.168.1.210";

//HomeCentralURL=@"http://192.168.1.210";

	
	pw = @"ideur00";
	[pw retain];
	    // Set the WebView delegates
		webView=[[WebView  alloc]init];
    [webView setFrameLoadDelegate:self];
    [webView setUIDelegate:self];
    [webView setResourceLoadDelegate:self];
	//WebPreferences *prefs = [webView preferences]; 
	//[prefs setUsesPageCache:NO]; 
	//[prefs setCacheModel:WebCacheModelDocumentViewer];
	// Maximale Anzahl Versuche um die EEPROM-Daten zu vom Webserver zu lesen
	maxAnzahl = 10;
   
   
   
	return self;
}

- (void)EEPROMReadStartAktion:(NSNotification*)note
{
	//NSLog(@"EEPROMReadStartAktion note: %@",[[note userInfo]description]);
	NSString* hByte = [NSString string];
	NSString* lByte = [NSString string];
	NSString* EEPROMAdresseZusatz= [NSString string];
	
   
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
   
   // Dic fuer senden an Homeserver mit Adresse laden:
   [SendEEPROMDataDic setObject:hByte forKey:@"hbyte"];
   [SendEEPROMDataDic setObject:lByte forKey:@"lbyte"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"adrload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"dataload"];

	
//	NSString* TWIReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresse,hByte, lByte]; 
	NSString* EEPROMReadStartURLSuffix = [NSString stringWithFormat:@"pw=%@&radr=%@&hb=%@&lb=%@",pw,EEPROMAdresseZusatz,hByte, lByte]; 
	NSString* EEPROMReadStartURL =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, EEPROMReadStartURLSuffix];
	
	//NSLog(@"EEPROMReadStartAktion EEPROMReadStartURLSuffix: %@",EEPROMReadStartURLSuffix);

	//NSLog(@"EEPROMReadStartURL: %@",EEPROMReadStartURL);
	//NSURL *URL = [NSURL URLWithString:HomeCentralURL];
	NSURL *URL = [NSURL URLWithString:EEPROMReadStartURL];
	[self loadURL:URL];
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
	
		sendTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(sendTimerFunktion:) 
															userInfo:sendTimerDic 
															 repeats:YES]retain];
															 															 
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
				//NSLog(@"sendTimer fire URL: %@",URL);
				[self loadURL:URL];
				anz--;
				[sendTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
			}
		}
		else
		{
			NSLog(@"sendTimerFunktion sendTimer invalidate");
			
			//
			NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
			[Warnung addButtonWithTitle:@"OK"];
			[Warnung addButtonWithTitle:@""];
			[Warnung addButtonWithTitle:@""];
			[Warnung addButtonWithTitle:@"Abbrechen"];
			[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"EEPROM lesen misslungen"]];
			
			NSString* s1=@"";
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
					
				}break;
					
				case NSAlertSecondButtonReturn://
				{
					NSLog(@"NSAlertSecondButtonReturn");
					
				}break;
				case NSAlertThirdButtonReturn://		
				{
					NSLog(@"NSAlertThirdButtonReturn");
					
				}break;
				case NSAlertThirdButtonReturn+1://cancel		
				{
					NSLog(@"NSAlertThirdButtonReturn+1");
					[NSApp stopModalWithCode:0];
					[[self window] orderOut:NULL];
					
				}break;
					
			}//switch
			
			
			//
			[derTimer invalidate];
			[derTimer release];
		}
		
		
	}
}

- (void)EEPROMisWriteOKRequest
{
		//NSLog(@"EEPROMisWriteOKRequest ");
		// Zaehler fuer Anzahl Versuche einsetzen
		NSMutableDictionary* confirmTimerDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
		int sendResetDelay=2.0;
		//NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
		confirmTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(confirmTimerFunktion:) 
															userInfo:confirmTimerDic 
															 repeats:YES]retain];
															 
	
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
				NSLog(@"confirmTimerFunktion  URL: %@",URL);
				[self loadURL:URL];
				anz++;
				[confirmTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
		}
		else
		{
			NSLog(@"confirmTimerFunktion confirmTimer invalidate");
			// Misserfolg an AVRClient senden
			NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"iswriteok"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
			
			[derTimer invalidate];
			[derTimer release];
			
		}
		
		
	}
}

- (void)LocalStatusAktion:(NSNotification*)note
{
   //NSLog(@"LocalStatusAktion note: %@",[[note userInfo]description]);

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
   NSLog(@"LocalStatusAktion HomeCentralURL: %@",HomeCentralURL);
}


- (void)TWIStatusAktion:(NSNotification*)note
{
	//NSLog(@"TWIStatusAktion note: %@",[[note userInfo]description]);
	
	if ([[note userInfo]objectForKey:@"status"])
	{
		NSString* TWIStatusSuffix=[NSString string];
		if ([[[note userInfo]objectForKey:@"status"]intValue])//neuer Status ist 1
		{
			TWIStatusSuffix = [NSString stringWithFormat:@"pw=%@&status=%@",pw,@"1"];
			NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatusSuffix];
			
          //NSLog(@"TWIStatusAktion TWIStatusURL: %@",TWIStatusURLString);
			
         NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
         //NSLog(@"TWIStatusAktion URL: %@",URL);
			[self loadURL:URL];
		
      }
		else // neuer Status ist 0
		{
			TWIStatusSuffix = [NSString stringWithFormat:@"pw=%@&status=%@",pw,@"0"];
			
			
			NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@",HomeCentralURL, TWIStatusSuffix];
			
           //NSLog(@"TWIStatusAktion TWIStatusURL: %@",TWIStatusURLString);
			
			
         
         
         
         NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
			NSLog(@"TWIStatusAktion URL: %@",URL);
			[self loadURL:URL];
			
			//  Blinkanzeige im PWFeld
			NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[tempDataDic setObject:@"*" forKey:@"wait"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
         
			// Zaehler fuer Anzahl Versuche einsetzen
			NSMutableDictionary* confirmTimerDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
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
         
			confirmStatusTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
                                                              target:self
                                                            selector:@selector(statusTimerFunktion:)
                                                            userInfo:confirmTimerDic
                                                             repeats:YES]retain];
			
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
			if (anz==9)
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
			NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			if (anz%2==0)// gerade
			{
			//[self loadURL:URL];

				[tempDataDic setObject:@"*" forKey:@"wait"];
			}
			else
			{
				[tempDataDic setObject:@" " forKey:@"wait"];
			}
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
			
		}
		else
		{
			
			NSLog(@"statusTimerFunktion statusTimer invalidate");
			// Misserfolg an AVRClient senden
			NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
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
			[derTimer release];
			
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
	NSLog(@"HomeClientWriteStandardAktion note stundenbytearray %@",[[[note userInfo]objectForKey:@"stundenbytearray"]description]);
   //	int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
   //	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
   //	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
   //	NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenarray"];
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

   
   [SendEEPROMDataDic setObject:hbyte forKey:@"hbyte"];
   [SendEEPROMDataDic setObject:lbyte forKey:@"lbyte"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1]forKey:@"adrload"];
   [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0]forKey:@"dataload"];
   
   
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
   
   NSString* EEPROM_DataString=[DatenByteArray componentsJoinedByString:@"+"];
   EEPROM_DataString= [EEPROM_DataString stringByAppendingString:@"+ff+ff"];
   NSLog(@"EEPROM_DataString: %@",EEPROM_DataString);
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
            NSLog(@"SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
            //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
 //           [self sendEEPROMDataMitDic:SendEEPROMDataDic];
         }
      }// adrload
   } // if length
   
}


- (void)HomeClientWriteModifierAktion:(NSNotification*)note
{
	//NSLog(@"HomeClientWriteModifierAktion note  %@",[[note userInfo]description]);
	//NSLog(@"HomeClientWriteModifierAktion note stundenbytearray %@",[[[note userInfo]objectForKey:@"modifierstundenbytearray"]description]);

//	int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
//	int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
//	int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
//	NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenarray"];
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
   NSLog(@"sendEEPROMDataMitDic URL: %s EEPROMDataDic: %@",WEBSERVER_VHOST ,[EEPROMDataDic description] );
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
            NSString* URLString = [NSString stringWithFormat:@"http://%s/%s?pw=%s&hbyte=%@&lbyte=%@&data=%@",
                                   WEBSERVER_VHOST,
                                   CGI,
                                   PW,
                                   [EEPROMDataDic objectForKey:@"hbyte"],
                                   [EEPROMDataDic objectForKey:@"lbyte"],
                                   [EEPROMDataDic objectForKey:@"eepromdatastring"]
                                   ];
            NSLog(@"URLString: %@",URLString );
            
            NSURL *URL = [NSURL URLWithString:URLString];
            NSLog(@"sendEEPROM URL: %@",URL );
            NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0];
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
         [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"dataload"];
      }
      [SendEEPROMDataDic setObject:[NSNumber numberWithInt:0] forKey:@"adrload"];
   }
	//[self loadURL:URL];
   
   return err;
}


#pragma mark URL-Stuff
- (NSString *)url
{
	return url;
}

- (void)setURL:(NSString *)u
{
	[url release];
	url = [u retain];
}


- (void)loadURL:(NSURL *)URL
{
	//NSLog(@"loadURL: %@",URL);
	NSURLRequest *HCRequest = [ [NSURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0];
//	[[NSURLCache sharedURLCache] removeAllCachedResponses];
//	NSLog(@"Cache mem: %d",[[NSURLCache sharedURLCache]memoryCapacity]);
//	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:HCRequest];
//	NSLog(@"loadURL:Vor loadRequest");
	if (HCRequest)
	{
	//NSLog(@"loadURL:Request OK");
	[[webView mainFrame] loadRequest:HCRequest];
	}
	
}

- (void)setURLToLoad:(NSURL *)URL
{
	[URL retain];
	[URLToLoad release];
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
	[webContent retain];
	[_source release];
	_source = webContent;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	//NSLog(@"***       HomeClient Webview didFinishLoadForFrame  ***");
	//NSLog(@"sender: %@",[sender description]);
	// Only report feedback for the main frame.
	NSString* HTML_Inhalt=[self dataRepresentationOfType:HTMLDocumentType];
	//NSLog(@"didFinishLoadForFrame Antwort: \nHTML_Inhalt: \t\t\t\t%@",HTML_Inhalt);
	
	NSRange CheckRange;
	NSString* Code_String= @"okcode=";
	NSString* Status0_String= @"status0";
	NSString* Status1_String= @"status1";
	NSString* PW_String= @"ideur00";
	
	
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
		}
		
		CheckRange = [HTML_Inhalt rangeOfString:Status1_String];
		if (CheckRange.location < NSNotFound)
		{
			//			NSLog(@"didFinishLoadForFrame: Status = 1");
			//[tempDataDic setObject:@"status" forKey:@"antwort"];
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"twistatus"];
		}

      // isstatus0ok vorhanden??
		
		NSString* status0_String= @"status0+"; 
		CheckRange = [HTML_Inhalt rangeOfString:status0_String];
		if (CheckRange.location < NSNotFound)
		{
			NSLog(@"didFinishLoadForFrame: status0+ ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"status0"];
			[confirmStatusTimer invalidate];
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
			NSLog(@"didFinishLoadForFrame okcode: data ist da  loc: %d",CheckRange.location);
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
			//NSLog(@"didFinishLoadForFrame: eeprom+ ist da loc: %d ",CheckRange.location);
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom+"];
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
			//NSLog(@"didFinishLoadForFrame: write+ ist da");
			[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"writeok"];
			[confirmTimer invalidate];
			
         // Daten an HomeServer schicken
         if ([SendEEPROMDataDic objectForKey:@"dataload"])
         {
            if ([[SendEEPROMDataDic objectForKey:@"dataload"]intValue]==1 )// EEPROM Data ist da
            {
               
               if ([SendEEPROMDataDic objectForKey:@"adrload"])
               {
                  if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
                  {
                     NSLog(@"SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
                     //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
                     [self sendEEPROMDataMitDic:SendEEPROMDataDic];
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



		
	} // if okcode
	
	// 	
		NSString* Data_String= @"data"; 
	
		{
		
		CheckRange = [HTML_Inhalt rangeOfString:Data_String];
		if (CheckRange.location < NSNotFound)
		{
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
			NSLog(@"EEPROM_DataString: %@",EEPROM_DataString);
			//NSLog(@"EEPROM_DataString: l=%d",[EEPROM_DataString length]);
			[tempDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
			
         // Datastring sichern fuer senden an HomeServer
         if ([EEPROM_DataString length])
         {
            [SendEEPROMDataDic setObject:EEPROM_DataString forKey:@"eepromdatastring"];
            [SendEEPROMDataDic setObject:[NSNumber numberWithInt:1] forKey:@"dataload"];
            if ([SendEEPROMDataDic objectForKey:@"adrload"])
            {
               if ([[SendEEPROMDataDic objectForKey:@"adrload"]intValue]==1 )// EEPROMAdresse ist da
               {
                  NSLog(@"SendEEPROMDataDic: %@",[SendEEPROMDataDic description]);
                  //[nc postNotificationName:@"EEPROMsend2HomeServer" object:self userInfo:tempDataDic];
                  [self sendEEPROMDataMitDic:SendEEPROMDataDic];
               }
            }// adrload
         } // if length
		}
		else
		{
			//[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"data"];
		}
		
	} // if pw vorhanden
	
	
	
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
		  //NSLog(@"didStartProvisionalLoadForFrame: URL: %@",provurl);
       
       // URL: http://ruediheimlicher.dyndns.org/twi?pw=ideur00&rdata=10
       
       // [textField setStringValue:url];
    }
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	// String: didStartProvisionalLoadForFrame: URL: http://ruediheimlicher.dyndns.org/twi?pw=ideur00&status=1
	if (frame == [sender mainFrame])
	{
		NSRange CheckRange;
		NSString* Code_String= @"okcode=";
		NSString* Status0_String= @"status=0";
		NSString* Status1_String= @"status=1";
		NSString* PW_String= @"ideur00";
		NSString* Error_String= @"error";
		
		NSMutableDictionary* tempDataDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		
		NSString *provurl = [[[[frame provisionalDataSource] request] URL] absoluteString];
		NSLog(@"didFailProvisionalLoadWithError: URL: %@",provurl);
		[tempDataDic setObject:provurl forKey:@"provurl"];
		
		// Test, ob URL eine okcode  enthält
		CheckRange = [provurl rangeOfString:PW_String]; // Passwortstring ist da, eigene URL
		NSLog(@"didFailProvisionalLoadWithError: CheckRange");
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
		
		NSString *errorDescription = [error localizedDescription];
      NSLog(@"didFailProvisionalLoadWithError: errorDescription: %@",errorDescription);
		if (!errorDescription) 
		{
			errorDescription = NSLocalizedString(@"An error occured during provisional download.",@"Provisorischer Download ging schief.");
		}	
		
		//NSBeginAlertSheet(@"Provisional Download misslungen", nil, nil, nil, [self window], nil, nil, nil, nil, errorDescription);
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
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
		
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
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
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]retain];
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

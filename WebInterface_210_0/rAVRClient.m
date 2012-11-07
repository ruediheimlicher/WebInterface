//
//  rHomeClient.m
//  WebInterface
//
//  Created by Sysadmin on 15.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "IOWarriorWindowController.h"
#define TAGPLANBREITE		0x40	// 64 Bytes, 2 page im EEPROM

#define RAUMPLANBREITE		0x200	// 512 Bytes


@implementation rAVR(rHomeClient)

- (IBAction)setTWIState:(id)sender
{
	// YES: TWI wird EINgeschaltet
	// NO:	TWI wird AUSgeschaltet
	NSLog(@"AVRClient setTWIState: state: %d",[sender state]);
	//[readTagTaste setEnabled:YES];
	if ([sender state])
	{
		Webserver_busy=0;
      
	}
   else
   {
      
   }
   
   [LocalTaste setEnabled:[sender state]];
   
	[WriteWocheFeld setStringValue:@"-"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[EEPROMReadTaste setEnabled:![sender state]];
	//int twiOK=0;
	NSMutableDictionary* twiStatusDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [twiStatusDic setObject:[NSNumber numberWithInt:[sender state]]forKey:@"status"];
   [twiStatusDic setObject:[NSNumber numberWithInt:[LocalTaste state]]forKey:@"local"];
	//NSLog(@"AVRClient end");
	[nc postNotificationName:@"twistatus" object:self userInfo:twiStatusDic];
   [LocalTaste setState:![sender state]];

}

- (IBAction)reportLocalTaste:(id)sender;
{
   NSLog(@"AVRClient reportLocalTaste: state: %d",[sender state]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* localStatusDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[localStatusDic setObject:[NSNumber numberWithInt:[sender state]]forKey:@"status"];
	[nc postNotificationName:@"localstatus" object:self userInfo:localStatusDic];
}




- (void)setTWITaste:(int)status
{
	if (status) // TWI-Status ON
	{
		Webserver_busy=0;
	}
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[EEPROMReadTaste setEnabled:status];
	[TWIStatusTaste setState:status];
	//int twiOK=0;
	NSMutableDictionary* twiStatusDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[twiStatusDic setObject:[NSNumber numberWithInt:status]forKey:@"status"];
	[nc postNotificationName:@"twistatus" object:self userInfo:twiStatusDic];
}

- (int)TWIStatus
{
	return [TWIStatusTaste state];
}




- (IBAction)readEthTagplan:(id)sender
{
	if (Webserver_busy || WriteWoche_busy)
	{
		NSBeep();
		return;
	}
	
	[readTagTaste setEnabled:NO];
	[ReadFeld setStringValue:@""];
	[WriteFeld setStringValue:@""];
	[AdresseFeld setStringValue:@""];
	int	tempTag=[TagPop indexOfSelectedItem];
	int	tempRaum=[RaumPop indexOfSelectedItem];
	int	tempObjekt=[ObjektPop indexOfSelectedItem];
	//NSLog(@"tempRaum tag: %d %x",[[RaumPop selectedItem]tag],[[RaumPop selectedItem]tag]);
	uint16_t startadresse=tempRaum*RAUMPLANBREITE + tempObjekt*TAGPLANBREITE + tempTag*0x08;
	NSString* AdresseKontrollString = [NSString string];
	int hbyte=startadresse/0x100;
	if (hbyte < 0x0F)
	{
	AdresseKontrollString= [NSString stringWithFormat:@"hbyte: 0%X",hbyte];
	}
	else 
	{
		AdresseKontrollString= [NSString stringWithFormat:@"hbyte: %X",hbyte];
	}
/*
	NSString* hbString= [[NSNumber numberWithInt:hbyte]stringValue];
	if ([hbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
	{
		hbString=[NSString stringWithFormat:@"0%@",hbString];
	}
*/	
	int lbyte=startadresse%0x100;
	if (lbyte < 0x0F)
	{
		AdresseKontrollString= [NSString stringWithFormat:@"%@ lbyte: 0%X",AdresseKontrollString,lbyte];
	}
	else 
	{
		AdresseKontrollString= [NSString stringWithFormat:@"%@ lbyte: %X",AdresseKontrollString,lbyte];	
	}
	
/*	
	NSString* lbString= [[NSNumber numberWithInt:lbyte]stringValue];
	if ([lbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
	{
		lbString=[NSString stringWithFormat:@"0%@",lbString];
	}
*/
	
	[Adresse setStringValue:AdresseKontrollString];
	[Cmd setStringValue:@""];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
	[NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
	[NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"EEPROMReadStart" object:self userInfo:NotificationDic];
	Webserver_busy=1;
	
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];						// Hi-Bit der Adresse
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];						// Lo-Bit der Adresse
	
	NSLog(@"AVRClient readEthTagplan EEPROMAddresse: %X startadresse: %X  hbyte: %X lbyte: %X", [I2CPop indexOfSelectedItem], startadresse, hbyte, lbyte);
	
	//	NSString* ReadURL=[self ReadURLForEEPROM: EEPROMAddresse hByte: hbyte lByte: lbyte];
}


- (void)readEthSim:(id)sender
{
		NSLog(@"readEthSim");
		[Adresse setStringValue:@"Simulation gestartet"];
		NSMutableDictionary* sendTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[sendTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
		[sendTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahlread"];
		int sendResetDelay=5.0;
		//NSLog(@"EEPROMReadDataAktion  sendTimerDic: %@",[sendTimerDic description]);
//		if (simTimer)
		{
//			NSLog(@"readEthSim retainCount: %d",[simTimer retainCount]);
	//		[simTimer invalidate];
	//		NSLog(@"X");
	//		[simTimer release];
	//		NSLog(@"Y");
			
		}
		simTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(readEthSimTimerFunktion:) 
															userInfo:sendTimerDic 
															 repeats:YES]retain];
}



- (void)readEthSimTimerFunktion:(NSTimer*) derTimer
{
	
	NSMutableDictionary* sendTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	NSLog(@"readEthSimTimerFunktion  sendTimerDic: %@",[sendTimerDic description]);
		if (simTimer)
		{
			NSLog(@"readEthSim retainCount: %d",[simTimer retainCount]);
	//		[simTimer invalidate];
	//		NSLog(@"X");
	//		[simTimer release];
	//		NSLog(@"Y");
		}
	if ([sendTimerDic objectForKey:@"anzahlread"]) // Anzahl zu sendende Reads
	{
		int anzRead=[[sendTimerDic objectForKey:@"anzahlread"]intValue];
		if (anzRead < [maxSimAnzahlFeld intValue])
		{
			anzRead++;
			[sendTimerDic setObject:[NSNumber numberWithInt:anzRead]forKey:@"anzahlread"];
			NSString* SimString=[NSString stringWithFormat:@"Simulation %d",anzRead];
			[Adresse setStringValue:SimString];
		}
		else
		{
			NSLog(@"readEthSimTimerFunktion anzReads erreicht");
			[Adresse setStringValue:@"Simulation abgelaufen"];
			[derTimer invalidate];
			[derTimer release];
			return;
		
		}
	
	
	}

	if ([sendTimerDic objectForKey:@"anzahl"])
	{
		
		int anz=[[sendTimerDic objectForKey:@"anzahl"] intValue];
		if (anz < 4)
		{
			anz++;
			srand([[NSDate date]timeIntervalSinceReferenceDate]);
			float a=(float)random() / RAND_MAX * (7);
			int simTag=a;
			float b=(float)random() / RAND_MAX * (4);
			int simRaum=b;
			simRaum=0;
			float c=(float)random() / RAND_MAX * (8);
			int simObjekt=c;
			
			simObjekt=0;
			NSLog(@"readEthSim\n\n\n");
			NSLog(@"readEthSim: rand: %2.2F simTag: %d simRaum: %d simObjekt: %d",a, simTag, simRaum, simObjekt);
			uint16_t startadresse=simRaum*RAUMPLANBREITE + simObjekt*TAGPLANBREITE + simTag*0x08;
			
			int hbyte=startadresse/0x100;
			int lbyte=startadresse%0x100;
			NSLog(@"readEthSim   startadresse: %X  hbyte: %X lbyte: %X",startadresse, hbyte, lbyte);
			
			NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
			[NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
			[NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"EEPROMReadStart" object:self userInfo:NotificationDic];
			
		}
		else
		{
			NSLog(@"readEthSimTimerFunktion sendTimer invalidate");
			
			[derTimer invalidate];
			[derTimer release];
			
		}
	}
}





- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzahlDaten
{
	[self readEthTagplan:i2cAdresse vonAdresse:startAdresse anz: anzahlDaten];
	
	return;
	}
	
	
	
	
	
	
	
- (void)WriteStandardAktion:(NSNotification*)note
{
if (Webserver_busy)
	{
		NSBeep();
		return;
	}

	if ([TWIStatusTaste state])
	{
		//NSLog(@"TWIStatustaste: %d",[TWIStatusTaste state]);
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
		
		NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		
	}
	/*
	else if (Webserver_busy)
	{
		NSBeep();
	}
	*/
	else
	{
		Webserver_busy=1;// Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
		[AdresseFeld setStringValue:@""];
		[WriteFeld setStringValue:@""];
		[ReadFeld setStringValue:@""];
		[WriteWocheFeld setStringValue:@""];
		[StatusFeld setStringValue:@"Adresse wird übertragen"];
		
		//NSLog(@"WriteStandardAktion note: %@",[[note userInfo]description]);
		int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
		int Wochentag=[[[note userInfo]objectForKey:@"wochentag"]intValue];
		int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
		NSArray* DatenArray=[[note userInfo]objectForKey:@"stundenbytearray"];
		
		NSMutableDictionary* HomeClientDic=[[[NSMutableDictionary alloc]initWithDictionary:[note userInfo]]autorelease];
		
		int I2CIndex=[I2CPop indexOfSelectedItem];
		
		NSString* EEPROM_i2cAdresseString=[I2CPop itemTitleAtIndex:I2CIndex];
		
		[HomeClientDic setObject:EEPROM_i2cAdresseString forKey:@"eepromadressestring"];
		
		[HomeClientDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
		//AnzahlDaten=0x20; //32 Bytes, TAGPLANBREITE;
		unsigned int EEPROM_i2cAdresse;
		NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresseString];
		int ScannerErfolg=[theScanner scanHexInt:&EEPROM_i2cAdresse];
		[HomeClientDic setObject:[NSNumber numberWithInt:EEPROM_i2cAdresse] forKey:@"eepromadresse"];
		
		
		uint16_t i2cStartadresse=Raum*RAUMPLANBREITE + Objekt*TAGPLANBREITE+ Wochentag*0x08;
		//NSLog(@"i2cStartadresse: %04X",i2cStartadresse);
		uint8_t lb = i2cStartadresse & 0x00FF;
		[HomeClientDic setObject:[NSNumber numberWithInt:lb] forKey:@"lbyte"];
		uint8_t hb = i2cStartadresse >> 8;
		NSString* AdresseKontrollString = [NSString stringWithFormat:@"hbyte: %2X  lbyte: %2X",hb, lb];
		[Adresse setStringValue:AdresseKontrollString];
		
		[HomeClientDic setObject:[NSNumber numberWithInt:hb] forKey:@"hbyte"];
		[HomeClientDic setObject:DatenArray forKey:@"stundenbytearray"];
		//NSLog(@"WriteStandardAktion Raum: %d wochentag: %d Objekt: %d EEPROM: %02X lb: 0x%02X hb: 0x%02X ",Raum, Wochentag, Objekt,EEPROM_i2cAdresse,lb, hb);
		
		// Information an HomeClient schicken
		
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"HomeClientWriteStandard" object:self userInfo:HomeClientDic];
		
	}
}

- (void)WriteModifierAktion:(NSNotification*)note
{
	//NSLog(@"AVRClient WriteModifierAktion userInfo: %@",[[note userInfo] description]);
	if ([TWIStatusTaste state])
	{
		NSLog(@"TWIStatustaste: %d",[TWIStatusTaste state]);
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
		
		NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		
	}
	else
	{
		
//		Webserver_busy=1; // Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
		//WriteWoche_busy=1;
		[AdresseFeld setStringValue:@""];
		[WriteFeld setStringValue:@""];
		[ReadFeld setStringValue:@""];
		[WriteWocheFeld setStringValue:@""];
		[StatusFeld setStringValue:@"Adresse wird übertragen"];
		
		//NSLog(@"AVRClient WriteModifierAktion note: %@",[[note userInfo]description]);
		int Raum=[[[note userInfo]objectForKey:@"raum"]intValue];
		int Wochentag=0;	// ganze Woche [[[note userInfo]objectForKey:@"wochentag"]intValue];
		int Objekt=[[[note userInfo]objectForKey:@"objekt"]intValue];
		NSArray* DatenArray=[[[note userInfo]objectForKey:@"modifierstundenbytearray"]copy];
		
		NSMutableDictionary* HomeClientDic=[[[NSMutableDictionary alloc]initWithDictionary:[note userInfo]]autorelease];
		
		int I2CIndex=[I2CPop indexOfSelectedItem];
		
		NSString* EEPROM_i2cAdresseString=[I2CPop itemTitleAtIndex:I2CIndex];
		
		[HomeClientDic setObject:EEPROM_i2cAdresseString forKey:@"eepromadressestring"];
		
		[HomeClientDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
		//AnzahlDaten=0x20; //32 Bytes, TAGPLANBREITE;
		unsigned int EEPROM_i2cAdresse;
		NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresseString];
		int ScannerErfolg=[theScanner scanHexInt:&EEPROM_i2cAdresse];
		[HomeClientDic setObject:[NSNumber numberWithInt:EEPROM_i2cAdresse] forKey:@"eepromadresse"];
		
		
		uint16_t i2cStartadresse=Raum*RAUMPLANBREITE + Objekt*TAGPLANBREITE+ Wochentag*0x08;
		//NSLog(@"i2cStartadresse: %04X",i2cStartadresse);
		uint8_t lb = i2cStartadresse & 0x00FF;
		[HomeClientDic setObject:[NSNumber numberWithInt:lb] forKey:@"lbyte"];
		uint8_t hb = i2cStartadresse >> 8;
		NSString* AdresseKontrollString = [NSString stringWithFormat:@"hbyte: %2X  lbyte: %2X",hb, lb];
		[Adresse setStringValue:AdresseKontrollString];
		NSString* WriteWocheString=@"Woche schreiben: ";
		[WriteWocheFeld setStringValue:WriteWocheString];
		[HomeClientDic setObject:[NSNumber numberWithInt:hb] forKey:@"hbyte"];
		[HomeClientDic setObject:DatenArray forKey:@"modifierstundenbytearray"];
		NSLog(@"WriteModifierAktion Raum: %d wochentag: %d Objekt: %d EEPROM: %02X lb: 0x%02X hb: 0x%02X ",Raum, Wochentag, Objekt,EEPROM_i2cAdresse,lb, hb);
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"HomeClientWriteModifier" object:self userInfo:HomeClientDic];
		
		
		
		/*
		// Wochentag auf 0 setzen: Montag
		[HomeClientDic setObject:[NSNumber numberWithInt:0]forKey:@"wochentag"];
		[HomeClientDic setObject:[NSNumber numberWithInt:10]forKey:@"timeoutcounter"];

		// Information an Timer schicken
		int sendResetDelay=2.0;
		//NSLog(@"EEPROMReadDataAktion  HomeClientDic: %@",[HomeClientDic description]);
		NSTimer* WriteTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(WriteModifierTimerfunktion:) 
															userInfo:HomeClientDic 
															 repeats:YES]retain];

		//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		//[nc postNotificationName:@"HomeClientWriteModifier" object:self userInfo:HomeClientDic];
		*/
	} // Homebus aktiv
}
	
- (void)WriteModifierTimerfunktion:(NSTimer*)derTimer
{
	NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	NSLog(@"WriteModifierTimerfunktion WriteWoche_busy: %d",WriteWoche_busy);
	NSMutableDictionary* WriteTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"WriteModifierTimerfunktion  WriteTimerDic: %@",[WriteTimerDic description]);
	int timeoutcounter=[[WriteTimerDic objectForKey:@"timeoutcounter"]intValue];
	NSLog(@"timeoutcounter: %d",timeoutcounter);
	// Webserver busy??
	if (Webserver_busy)
	{
		NSBeep();
		timeoutcounter--;
		[WriteTimerDic setObject:[NSNumber numberWithInt:timeoutcounter] forKey:@"timeoutcounter"];
		
		if (timeoutcounter == 0)
		{
			NSLog(@"timeoutcounter ist null");
			[derTimer invalidate];
			[derTimer release];
			WriteWoche_busy=0;
			
			[self setTWITaste:YES];
		}
		return;
	}
	
	
	// Webserver auf busy setzen
	Webserver_busy=1; // Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
	timeoutcounter = 10;
	
	// Information des aktuellen Tages an HomeClient schicken
	
	int aktuellerWochentag=0;
	NSArray* ModifierStundenbyteArray=[NSArray array];
	if ([WriteTimerDic objectForKey:@"modifierstundenbytearray"]) // Stundenbytearrays fuer die ganze Woche
	{
		ModifierStundenbyteArray=[WriteTimerDic objectForKey:@"modifierstundenbytearray"];
		
	}
	
	if ([WriteTimerDic objectForKey:@"wochentag"]) // Zaehler fuer Wochentag
	{
		aktuellerWochentag=[[WriteTimerDic objectForKey:@"wochentag"]intValue]; // aktueller Wochentag, wird incrementiert
		if (aktuellerWochentag <7)
		{
			
			NSString* WriteWocheString=[WriteWocheFeld stringValue];
			WriteWocheString=[NSString stringWithFormat:@"%@ %@",WriteWocheString,[Wochentage objectAtIndex:aktuellerWochentag]];
			[WriteWocheFeld setStringValue:WriteWocheString];

			// aktuelle Adresse fuer das EEPROM zusammenstellen
			int Raum=[[WriteTimerDic objectForKey:@"raum"]intValue];
			int Objekt=[[WriteTimerDic objectForKey:@"objekt"]intValue];
			
			uint16_t i2cStartadresse=Raum*RAUMPLANBREITE + Objekt*TAGPLANBREITE+ aktuellerWochentag*0x08;
			//NSLog(@"i2cStartadresse: %04X",i2cStartadresse);
			uint8_t lb = i2cStartadresse & 0x00FF;
			[WriteTimerDic setObject:[NSNumber numberWithInt:lb] forKey:@"lbyte"];
			uint8_t hb = i2cStartadresse >> 8;
			
			//aktuellen Wochentag anzeigen:
			NSString* AdresseKontrollString = [NSString stringWithFormat:@"hbyte: %2X  lbyte: %2X",hb, lb];
			//[Adresse setStringValue:AdresseKontrollString];
			
			//NSLog(@"aktueller Wochentag: %@  Adresse: %@",[Wochentage objectAtIndex:aktuellerWochentag],AdresseKontrollString);
			[WriteTimerDic setObject:[NSNumber numberWithInt:hb] forKey:@"hbyte"];
			[WriteTimerDic setObject:[Wochentage objectAtIndex:aktuellerWochentag]forKey:@"wochentagstring"];			// aktuellen Array fuer den Wochentag einsetzen
			//NSLog(@"aktueller stundenbytearray: %@",[[ModifierStundenbyteArray objectAtIndex:aktuellerWochentag] description]);
			[WriteTimerDic setObject:[ModifierStundenbyteArray objectAtIndex:aktuellerWochentag] forKey:@"stundenbytearray"];
			
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"HomeClientWriteModifier" object:self userInfo:WriteTimerDic];
			
			
			// aktuellerWochentag incrementieren und in Dic laden
			
			
			//if (aktuellerWochentag <7)
			//{
			// Information an HomeClient:
			//NSLog(@"Senden an HomeClient: WriteTimerDic: %@",[WriteTimerDic description]);
			
			//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			//[nc postNotificationName:@"HomeClientWriteModifier" object:self userInfo:WriteTimerDic];
			
			//NSLog(@"naechster aktuellerWochentag: %d",aktuellerWochentag);
			
			
		}
		
		else// Woche fertig, Zeit fuer laden von SO
		{
			//NSLog(@"Woche fertig: naechster aktuellerWochentag: %d",aktuellerWochentag);
			NSString* WriteWocheString=[WriteWocheFeld stringValue];
			WriteWocheString=[NSString stringWithFormat:@"%@  %@",WriteWocheString,@"OK"];
			[WriteWocheFeld setStringValue:WriteWocheString];

			[derTimer invalidate];
			[derTimer release];
			[self setTWITaste:YES];
			WriteWoche_busy=0;
		}
		aktuellerWochentag++;
		// aktuellerWochentag fuer die naechste Runde einsetzen 			
		[WriteTimerDic setObject:[NSNumber numberWithInt:aktuellerWochentag] forKey:@"wochentag"];
		
	}
	else 
	{
		// Etwas ist schiefgegangen, der Timer hat keinen Zaehler fuer den Wochentag
		[derTimer invalidate];
		[derTimer release];
		[self setTWITaste:YES];
		WriteWoche_busy=0;
		return;
		
	}
	
	
	
	
	
}
	
	
- (void)setHomeCentralI2C:(int)derStatus
{

}
	
- (void)setWebI2C:(int)derStatus
{

}


- (void)loadURL:(NSURL *)URL
{

}
- (void)setURLToLoad:(NSURL *)URL
{

}
- (void)setFrameStatus: (NSString *)s
{

}

- (void)LoadDataAktion:(NSNotification*)note // Anzeige, dass Daten beim Start fertig geladen sind
{
	if (TWIStatusTaste)
	{
	//NSLog(@"LoadDataAktion TWIStatusTaste OK");
	}
	if ([[note userInfo]objectForKey:@"loaddataok"])
	{
		if ([[[note userInfo]objectForKey:@"loaddataok"]intValue])
		{
         [TWIStatusTaste setEnabled:YES];
         [LocalTaste setEnabled:YES];
		
		}
		else
		{
         [TWIStatusTaste setEnabled:NO];
         [LocalTaste setEnabled:NO];
		}
	}
}


- (void)FinishLoadAktion:(NSNotification*)note
{
	//NSLog(@"FinishLoadAktion: %@",[[note userInfo]description]);
	//NSString* Status_String= @"status";
	
	//NSString* Status0_String= @"status0";
	//NSString* Status1_String= @"status1";
	//NSString* PW_String= @"ideur00";
	//NSString* radrString= @"radr";
	//NSString* AntwortString;
	int OK_Code_Status=0;
	int TWI_Status=0;
	int Adresse_OK=0;
	int Data_OK=0;
	int Write_OK=0;
	if ([[note userInfo]objectForKey:@"okcode"]) 
	{
		OK_Code_Status=[[[note userInfo]objectForKey:@"okcode"]intValue]; // 
		//NSLog(@"FinishLoadAktion  okcode ist da: %d",OK_Code_Status);
		if (OK_Code_Status)// Es ist eine Statusmeldung
		{
			//[StatusFeld setStringValue:@"Statusmeldung"]; // TWI wieder aktiviert
			
		}
		else 
		{
			[StatusFeld setStringValue:@"keine Statusmeldung"];// TWI erfolgreich deaktiviert
			
		}
		
		
		if ([[note userInfo]objectForKey:@"twistatus"]) 
		{
			TWI_Status=[[[note userInfo]objectForKey:@"twistatus"]intValue];
			// Anzeigen, dass 
			[AdresseFeld setStringValue:@""];
			[WriteFeld setStringValue:@""];
			[ReadFeld setStringValue:@""];
			[WriteWocheFeld setStringValue:@""];
			//NSLog(@"FinishLoadAktion  twistatus ist da: %d",TWI_Status);
			
			if (TWI_Status==0)// TWI deaktiviert
			{	
				//NSBeep();
				//[StatusFeld setStringValue:@"Kontakt mit HomeCentral hergestellt"];// TWI erfolgreich deaktiviert
				//[PWFeld setStringValue:@"OK"];
				//[readTagTaste setEnabled:1];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
				
			}
			else 
			{
				NSBeep();
				[StatusFeld setStringValue:@"Kontakt mit HomeCentral beendet"]; // TWI wieder aktiviert
				[readTagTaste setEnabled:0];// TWI-Status ON, EEPROM gesperrt
				[PWFeld setStringValue:@""];
				//[AdresseFeld setStringValue:@""];
				//[WriteFeld setStringValue:@""];
				//[ReadFeld setStringValue:@""];
				
				
			}
		}
		
		// isstatus0ok
		
			if ([[note userInfo]objectForKey:@"status0"]) 
		{
			//TWI_Status=([[[note userInfo]objectForKey:@"status0"]intValue]==0);
			// Anzeigen, dass status0 angekommen ist: Status 0 ist gesetzt
			
			//
			
			//if (TWI_Status==0)// TWI deaktiviert
			
			if ([[[note userInfo]objectForKey:@"status0"]intValue]==1) // Status 0 hat geklappt
			{	
				NSBeep();
				TWI_Status=0;
				[AdresseFeld setStringValue:@""];
				[WriteFeld setStringValue:@""];
				[ReadFeld setStringValue:@""];
				[WriteWocheFeld setStringValue:@""];
				//NSLog(@"FinishLoadAktion  status0+ ist da: TWI_Status: %d",TWI_Status);
				[StatusFeld setStringValue:@"Kontakt mit HomeCentral hergestellt"];// TWI erfolgreich deaktiviert
				[PWFeld setStringValue:@"OK"];
				[readTagTaste setEnabled:1];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
				Webserver_busy =0;
			}
			else 
			{
				//NSBeep();
	//			[StatusFeld setStringValue:@"Kontakt mit HomeCentral beendet"]; // TWI wieder aktiviert
	//			[readTagTaste setEnabled:0];// TWI-Status ON, EEPROM gesperrt
	//			[PWFeld setStringValue:@""];
				//[AdresseFeld setStringValue:@""];
				//[WriteFeld setStringValue:@""];
				//[ReadFeld setStringValue:@""];
				
				
			}
			
		}
	
		// end isstatus0ok
		
		if ([[note userInfo]objectForKey:@"radrok"]) 
		{
			Adresse_OK=[[[note userInfo]objectForKey:@"radrok"]intValue];
			// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
			
			//NSLog(@"FinishLoadAktion read EEPROM: radrok ist da: %d TWI_Status: %d",Adresse_OK,TWI_Status);
			if ((TWI_Status==0)&&Adresse_OK)// Passwort OK
			{
				NSLog(@"radrok");
				[AdresseFeld setStringValue:@"OK"];
				[StatusFeld setStringValue:@"EEPROM-Adresse angekommen"];
				
				// Request fuer Data schicken
				
				NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
				[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"rdata"];
				
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"EEPROMReadData" object:self userInfo:NotificationDic];
				
			}
			else 
			{
				//[AdresseFeld setStringValue:@""];
				//[StatusFeld setStringValue:@"EEPROM-Adresse nicht angekommen"];
				
			}
			
		}// radrok
		
		
		// 12.12.09
		if ([[note userInfo]objectForKey:@"wadrok"]) 
		{
			Write_OK=[[[note userInfo]objectForKey:@"wadrok"]intValue];
			// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
			//Webserver_busy =0;
			//NSLog(@"FinishLoadAktion Write: Adresse uebertragen. wadrok ist da: %d",Write_OK);
			if ((TWI_Status==0)&&Write_OK)// Passwort OK
			{
				[AdresseFeld setStringValue:@"OK"];
				[StatusFeld setStringValue:@"EEPROM-Adresse angekommen"];
				Webserver_busy =0;
				
			}
			else 
			{
				//[Adresse setStringValue:@""];
				//[StatusFeld setStringValue:@"EEPROM-Adresse nicht angekommen"];
				
			}
			
		} // wadr
		
		if ([[note userInfo]objectForKey:@"writeok"]) 
		{
			
			Write_OK=[[[note userInfo]objectForKey:@"writeok"]intValue];
			// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
			//Webserver_busy =0;
			//NSLog(@"FinishLoadAktion  writeok ist da: %d",Write_OK);
			if ((TWI_Status==0)&&Write_OK)// Passwort OK
			{
				
				NSBeep();
				[WriteFeld setStringValue:@"OK"];
				[StatusFeld setStringValue:@"EEPROM-Daten geschrieben"];
				Webserver_busy =0;
				
			}
			else 
			{
				//[WriteFeld setStringValue:@""];
				//[StatusFeld setStringValue:@"EEPROM-Daten nicht geschrieben"];
				
			}
			
		} // writeok
		
		
		
		
		
	} // if okcode
	
	NSArray* EEPROMDataArray;
	if ([[note userInfo]objectForKey:@"data"]) 
	{
		Data_OK=[[[note userInfo]objectForKey:@"data"]intValue];
		// Anzeigen, dass die daten erfolgreich uebertragen wurde: 
		if ((TWI_Status==0)&&Data_OK)// Data OK
		{
			NSLog(@"FinishLoadAktion EEPROM lesen: data ist da");
			NSBeep();
			[ReadFeld setStringValue:@"OK"];
			[StatusFeld setStringValue:@"Daten angekommen"];
			if ([[note userInfo]objectForKey:@"eepromdatastring"])
			{
				//			[StatusFeld setStringValue:[[note userInfo]objectForKey:@"eepromdatastring"]];
				EEPROMDataArray = [[[note userInfo]objectForKey:@"eepromdatastring"] componentsSeparatedByString:@"+"];
				//NSLog(@"FinishLoadAktion EEPROMDataArray: %@",[EEPROMDataArray description]);
				NSString* DataString=[NSString string];;
				//NSLog(@"FinishLoadAktion DataString: %@",DataString);
				//NSLog(@"FinishLoadAktion EEPROMDataArraycount: %d",[EEPROMDataArray count]);
				
				if ([EEPROMDataArray count]==8) // 8 Bytes da, vollstaendig
				{
					int i=0;
					for (i=0;i<6;i++) // letzte zwei Byte sind immer FF
					{
						NSString* tempHexString= [EEPROMDataArray objectAtIndex:i];
						if ([tempHexString length]==1) // nur eine Stelle, fuehrende Null einfuegen
						{
							tempHexString=[NSString stringWithFormat:@"0%@",tempHexString];
						}
						//if (i%2)
						{
							//DataString = [NSString stringWithFormat:@"%@%@",DataString,[tempHexString uppercaseString]];
						}
						//else // zwischenraum einfuegen
						{
							DataString = [NSString stringWithFormat:@"%@ %@",DataString,[tempHexString uppercaseString]];
							
						}
					}
					[Cmd setStringValue:DataString];
					[EEPROMbalken setStundenArrayAusByteArray:EEPROMDataArray];
					[EEPROMbalken setWochentagString:[TagPop titleOfSelectedItem]];
					[EEPROMbalken setRaumString:[RaumPop titleOfSelectedItem]];
					[EEPROMbalken setObjektString:[ObjektPop titleOfSelectedItem]];
					Webserver_busy=0;
					[readTagTaste setEnabled:YES];
				}
			}
			NSMutableDictionary* sendTimerDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[sendTimerDic setObject:@"Read Data OK" forKey:@"timertext"];
			NSLog(@"TimeoutTimer start");
			TimeoutTimer=[[NSTimer scheduledTimerWithTimeInterval:1 
																		  target:self 
																		selector:@selector(TimeoutTimerFunktion:) 
																		userInfo:sendTimerDic 
																		 repeats:NO]retain];
			
			
		}
		else 
		{
			//[ReadFeld setStringValue:@""];
			//[StatusFeld setStringValue:@"Daten nicht angekommen"];
			
		}
		
		
	} // if data
	
	
	/*
	 if ([[note userInfo]objectForKey:@"twistatus"]) 
	 {
	 TWI_Status=[[[note userInfo]objectForKey:@"twistatus"]intValue];
	 if (TWI_Status)// Statusmeldung
	 {
	 [StatusFeld setStringValue:@"-"]; // TWI wieder aktiviert
	 
	 }
	 else 
	 {
	 [StatusFeld setStringValue:@"Kontakt hergestellt"];// TWI erfolgreich deaktiviert
	 }
	 
	 
	 
	 }
	 */
	
	int Error_OK=0;
	if ([[note userInfo]objectForKey:@"error"]) 
	{
		NSLog(@"FinishLoadAktion error");
		if ([[note userInfo]objectForKey:@"twistatus"])// Fehler beim Setzen von Status. 
		{
			Error_OK=[[[note userInfo]objectForKey:@"twistatus"]intValue];
			NSLog(@"Error_OK: %d",Error_OK);
			switch (Error_OK)
			 {
				case 0:// TWI_Status 0 setzen hat nicht geklappt,
				{
				[PWFeld setStringValue:@"  "];
				[TWIStatusTaste setState:1];
				}break;
				case 1:// TWI_Status 1 setzen hat nicht geklappt,
				{
				[PWFeld setStringValue:@"OK"];
				[TWIStatusTaste setState:0];
				}break;
				
				default:
					break;
			}
			
			
		}

	}// if error
	
	
	int Passwort_OK=0;
	if ([[note userInfo]objectForKey:@"passwortok"]) 
	{
		NSLog(@"FinishLoadAktion PasswortOK");
		Passwort_OK=[[[note userInfo]objectForKey:@"passwortok"]intValue];
		// Anzeigen, dass der Status auf dem Webserver erfolgreich modifiziert wurde: 
		
		
		if ((TWI_Status==0)&&Passwort_OK)// Passwort OK
		{
			[PWFeld setStringValue:@"OK"];
			//			[readTagTaste setEnabled:1];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
			//[StatusFeld setStringValue:@"Passwort OK"];
			
		}
		else 
		{
			//[PWFeld setStringValue:@""];
			//			[readTagTaste setEnabled:0];
			
		}
		
		
	}
	
	//int Adresse_OK=0;
	if ([[note userInfo]objectForKey:@"radrok"]) 
	{
		Adresse_OK=[[[note userInfo]objectForKey:@"radrok"]intValue];
		// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
		
		
		if ((TWI_Status==0)&&Passwort_OK && Adresse_OK)// Passwort OK
		{
			[AdresseFeld setStringValue:@"OK"];
			[StatusFeld setStringValue:@"Passwort OK"];
			
		}
		else 
		{
			//[AdresseFeld setStringValue:@""];
		}
		
		
	}
	
	
	
	//NSString* EEPROM_Adresse_Key= @"radr";
	/*
	 if ([AntwortString isEqualToString:Status_String])// Statusmeldung
	 {
	 if ([[note userInfo]objectForKey:@"wert"]) // 
	 {
	 int wert=[[[note userInfo]objectForKey:@"wert"]intValue];
	 if (wert)
	 {
	 [StatusFeld setStringValue:@"EEPROM-Adresse gesendet"];
	 }
	 else 
	 {
	 [StatusFeld setStringValue:@"EEPROM-Adresse nicht gesendet"];
	 }
	 
	 }
	 }
	 */
	
	
	/*
	 if ([[note userInfo]objectForKey:@"data"])
	 {	
	 //NSLog(@"FinishLoadAktion: %@",[[[note userInfo]objectForKey:@"data"]description]);
	 NSArray* tempDataArray=[[note userInfo]objectForKey:@"data"]; // Array der Key-Value-Werte
	 
	 if (tempDataArray && [tempDataArray count])
	 {
	 //NSLog(@"tempDataArray: %@",[tempDataArray description]);
	 int i=0;
	 int webtaskindex=0;
	 for (i=0;i<[tempDataArray count];i++)
	 {
	 NSDictionary* tempDataDic=[tempDataArray objectAtIndex:i];
	 //int tempStatus=[[tempDataDic objectForKey:@"status"]intValue];
	 
	 // Status der TWIStatus-Taste abfragen, readTag-Taste enablen
	 if ([tempDataDic objectForKey:@"status"])
	 {
	 //int tempStatus=[[tempDataDic objectForKey:@"status"]intValue];
	 //NSLog(@"tempStatus: %d",tempStatus);
	 // Anzeigen, dass der Status auf dem Webserver erfolgreich modifiziert wurde: 
	 [readTagTaste setEnabled:[[tempDataDic objectForKey:@"status"]intValue]==0];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
	 
	 
	 NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	 [tempDic setObject:@"status" forKey:@"art"];
	 [tempDic setObject:[tempDataDic objectForKey:@"status"] forKey:@"wert"];
	 //[WEBDATATabelle addObject:tempDic];
	 [WEBDATA_DS addValueKeyZeile:tempDic];
	 //NSLog(@"AVR awake WEBDATATabelle: %@",[WEBDATATabelle description]); 
	 }
	 
	 if ([tempDataDic objectForKey:@"radr"])
	 {
	 //int tempStatus=[[tempDataDic objectForKey:@"status"]intValue];
	 //NSLog(@"tempStatus: %d",tempStatus);
	 NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	 [tempDic setObject:@"radr" forKey:@"art"];
	 [tempDic setObject:[tempDataDic objectForKey:@"radr"] forKey:@"wert"];
	 [WEBDATA_DS addValueKeyZeile:tempDic];
	 
	 //NSLog(@"AVR awake WEBDATATabelle: %@",[WEBDATATabelle description]); 
	 [WEBDATATable reloadData];
	 [WEBDATATable scrollRowToVisible:[WEBDATATable numberOfRows]-1];
	 webtaskindex=1;
	 }
	 if ([tempDataDic objectForKey:@"hb"])
	 {
	 NSLog(@"objectForKey:hb");
	 NSMutableDictionary* tempAdressDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	 [tempAdressDic setObject:@"hb" forKey:@"art"];
	 [tempAdressDic setObject:[tempDataDic objectForKey:@"hb"] forKey:@"wert"];
	 [WEBDATA_DS addValueKeyZeile:tempAdressDic];
	 webtaskindex++;
	 }
	 if([tempDataDic objectForKey:@"lb"])
	 {
	 NSLog(@"objectForKey:lb");
	 NSMutableDictionary* tempAdressDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	 [tempAdressDic setObject:@"lb" forKey:@"art"];
	 [tempAdressDic setObject:[tempDataDic objectForKey:@"lb"] forKey:@"wert"];
	 [WEBDATA_DS addValueKeyZeile:tempAdressDic];
	 webtaskindex++;
	 }
	 
	 if (webtaskindex == 3) // Vollständig
	 {
	 WebTask=eepromread;
	 NSLog(@"webtaskindex == 3: WebTask: %d",WebTask);
	 }
	 }
	 [WEBDATATable reloadData];
	 [WEBDATATable scrollRowToVisible:[WEBDATATable numberOfRows]-1];
	 
	 
	 switch (WebTask)
	 {
	 case eepromread:
	 {
	 
	 
	 }break;
	 
	 
	 }// switch WebTask
	 } // if tempArray count
	 
	 
	 
	 } // if data
	 */
	
	
}


- (void)LoadFailAktion:(NSNotification*)note
{
	NSLog(@"LoadFailAktion: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"error"])
	{
		NSLog(@"LoadFailAktion  error: %@",[[note userInfo]objectForKey:@"error"]);
	}
	
	NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
	//[Warnung addButtonWithTitle:@""];
	//[Warnung addButtonWithTitle:@""];
	//[Warnung addButtonWithTitle:@"Abbrechen"];
	[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Webserver nicht erreichbar"]];
	
	NSString* s1=@"Der Webserver antwortet nicht.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	int antwort=[Warnung runModal];
	[TWIStatusTaste setState:YES];
	
}


- (void)TimeoutTimerFunktion:(NSTimer*)timer
{
	//NSLog(@"TimeoutTimerFunktion");
	if ([[timer userInfo]objectForKey:@"timertext"])
	{
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
		[Warnung addButtonWithTitle:@"OK"];
		//[Warnung addButtonWithTitle:@""];
		//[Warnung addButtonWithTitle:@""];
		//[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"EEPROM-Aktion"]];
		
		NSString* s1=[[timer userInfo]objectForKey:@"timertext"];
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		//	int antwort=[Warnung runModal];
		
	}
	[timer invalidate];
	//	[self setTWITaste:1];
	
}


- (void)StatusWaitAktion:(NSNotification*)note
{
	//NSLog(@"StatusWaitAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"wait"])
	{
		[PWFeld setStringValue:[[note userInfo]objectForKey:@"wait"]];
	}
}


- (void)setWEBDATAArray:(NSArray*)derDatenArray
{
	
	NSLog(@"AVR setWEBDATAArray: %@",[derDatenArray description]); 
	
	[WEBDATA_DS setValueKeyArray:derDatenArray];
	[WEBDATATable reloadData];
}

- (int)WriteWoche_busy
{
return WriteWoche_busy;
}
@end

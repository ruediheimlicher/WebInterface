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

- (IBAction)reportTWIState:(id)sender
{
	// YES: TWI wird EINgeschaltet
	// NO:	TWI wird AUSgeschaltet
	//NSLog(@"AVRClient reportTWIState: state: %u",(unsigned int)[sender state]);
	//[readTagTaste setEnabled:YES];
   
	if ([sender state])
	{
      [[NSSound soundNamed:@"Ping"] play];
      Webserver_busy=0;
     
       NSLog(@"TWI wird ON: TWI_ON_Flag: %d state: %ld",TWI_ON_Flag,(long)[sender state]);
	}
   else
   {
      [[NSSound soundNamed:@"Frog"] play];
      [Waitrad  startAnimation:NULL];
       [LocalTaste setState:NO];
      
      NSLog(@"TWI wird OFF: TWI_ON_Flag: %d state: %ld",TWI_ON_Flag,(long)[sender state]);   }
   
   [LocalTaste setEnabled:[sender state]];
   
	[WriteWocheFeld setStringValue:@"-"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[EEPROMReadTaste setEnabled:![sender state]];
	//int twiOK=0;
   if (![sender state])
   {
      
   }
	NSMutableDictionary* twiStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [twiStatusDic setObject:[NSNumber numberWithInt:[sender state]]forKey:@"status"];
   [twiStatusDic setObject:[NSNumber numberWithInt:[LocalTaste state]]forKey:@"local"];
	//NSLog(@"AVRClient end");
	[nc postNotificationName:@"twistatus" object:self userInfo:twiStatusDic];
//   [LocalTaste setState:![sender state]];
   
}

- (void)setTWIState:(int)status
{
   if (status)
	{
      [[NSSound soundNamed:@"Ping"] play];
		Webserver_busy=0;
      
	}
   else
   {
      [Waitrad  startAnimation:NULL];
      [[NSSound soundNamed:@"Glass"] play];
      TWI_ON_Flag=0;
      NSLog(@"TWI_ON_Flag ist 0");
   }
   [LocalTaste setEnabled:status];
   
	[WriteWocheFeld setStringValue:@"-"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[EEPROMReadTaste setEnabled:!status];
	//int twiOK=0;
   if (!status)
   {
      
      [Waitrad  startAnimation:NULL];
   }
	NSMutableDictionary* twiStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [twiStatusDic setObject:[NSNumber numberWithInt:status]forKey:@"status"];
   [twiStatusDic setObject:[NSNumber numberWithInt:[LocalTaste state]]forKey:@"local"];
	//NSLog(@"AVRClient end");
	[nc postNotificationName:@"twistatus" object:self userInfo:twiStatusDic];
   [LocalTaste setState:!status];
   
   
}


- (IBAction)reportLocalTaste:(id)sender;
{
   NSLog(@"AVRClient reportLocalTaste: state: %d",(long)[sender state]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* localStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[localStatusDic setObject:[NSNumber numberWithInt:[sender state]]forKey:@"status"];
	[nc postNotificationName:@"localstatus" object:self userInfo:localStatusDic];
   if ([LocalTaste isEnabled])
   {
      [TWIStatusTaste setEnabled:YES];
   }
}

- (IBAction)reportTestTaste:(id)sender;
{
   NSLog(@"AVRClient reportTestTaste: state: %ld",[sender state]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* localStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[localStatusDic setObject:[NSNumber numberWithInt:[sender state]]forKey:@"test"];
	[nc postNotificationName:@"teststatus" object:self userInfo:localStatusDic];

}

- (IBAction)reportResetTaste:(id)sender
{
   //NSLog(@"AVRClient reportResetTaste");
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"OK"];
   //	[Warnung addButtonWithTitle:@""];
   //	[Warnung addButtonWithTitle:@""];
   	[Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Master reset"]];
   
   NSString* s1=@"Soll der Master wirklich neu gestartet werden?";
   NSString* s2=@"Das dauert ca. 3 min.";
   NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
   [Warnung setInformativeText:InformationString];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   NSSecureTextField *input = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
   [[input cell]setEchosBullets:YES];
   [input setStringValue:@"passwort"];
  // [Warnung autorelease];
   [Warnung setAccessoryView:input];
   int resetok=0;
   int antwort=[Warnung runModal];
   //NSLog(@"AVRClient antwort: %d",antwort);
   
   switch (antwort)
   {
      case 1000:// OK
      {
         //NSLog(@"OK pw: %@",[input stringValue]);
         
         if ([[input stringValue]  isEqual: @"homer"])
         {
            [Waitrad stopAnimation:NULL];
            resetok=1; // reset ausfuehren

         }
         
      }break;
      case 1001: //abbrechen
      {
          [Waitrad  stopAnimation:NULL];
          //NSLog(@"Abbrechen");
         return;
      }break;
         
   }
   if (resetok)
   {
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* localStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [localStatusDic setObject:[NSNumber numberWithInt:1]forKey:@"reset"];
   [nc postNotificationName:@"resetmaster" object:self userInfo:localStatusDic];
   }
   else
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Zugriff verweigert!"]];
      int antwort=[Warnung runModal];
   }
}

- (IBAction)reportLoadTestTaste:(id)sender
{
   NSLog(@"AVRClient reportLoadTestTaste");


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
	NSMutableDictionary* twiStatusDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[twiStatusDic setObject:[NSNumber numberWithInt:status]forKey:@"status"];
	[nc postNotificationName:@"twistatus" object:self userInfo:twiStatusDic];
}

- (int)TWIStatus
{
	return [TWIStatusTaste state];
}




- (IBAction)readEthTagplan:(id)sender
{
   NSLog(@"AVRClient readEthTagplan ");
   enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;

	if (Webserver_busy || WriteWoche_busy)
	{
      NSLog(@"readEthTagplan Webserver_busy beep");
		NSBeep();
      
		return;
	}
	WebTask=eepromread; // eepromlesen
   
	[readTagTaste setEnabled:NO];
   [readWocheTaste setEnabled:NO];
	[ReadFeld setStringValue:@""];
	[WriteFeld setStringValue:@""];
   [writeWocheTaste setEnabled:NO];
	[AdresseFeld setStringValue:@""];
   
	int	tempTag=[TagPop indexOfSelectedItem];
   
   
   [self readEthTagplanVonRaum:[RaumPop indexOfSelectedItem] vonObjekt:[ObjektPop indexOfSelectedItem] vonTag:[TagPop indexOfSelectedItem]];

   //[self readEthTagplanVonTag:tempTag];
   
   
   return;

	int	tempRaum=[RaumPop indexOfSelectedItem];
	int	tempObjekt=[ObjektPop indexOfSelectedItem];
   
   
   int tagbalkentyp = [[[[[[[HomebusArray objectAtIndex:tempRaum]
                            objectForKey:@"wochenplanarray"]
                           objectAtIndex:0]
                          objectForKey:@"tagplanarray"]
                         objectAtIndex:tempObjekt]
                        objectForKey:@"tagbalkentyp"]intValue];
   
   NSLog(@"PList tagbalkentyp: %d",tagbalkentyp);
   //[readTagTaste setEnabled:YES];
   //return;
   
   
   //NSLog(@"tempRaum index: %d titel: %@",tempRaum, [[RaumPop selectedItem]title]);
   //NSLog(@"tempObjekt index: %d titel: %@",tempObjekt, [[ObjektPop selectedItem]title]);
   
	//NSLog(@"tempRaum indexdez: %d hex: %x",[[RaumPop selectedItem]tag],[[RaumPop selectedItem]tag]);
	
   //NSLog(@"tempRaum: %d,tempRaum*RAUMPLANBREITE: %X",tempRaum,tempRaum*RAUMPLANBREITE);
   //NSLog(@"tempObjekt: %d tempObjekt*TAGPLANBREITE: %X",tempObjekt,tempObjekt*TAGPLANBREITE);
   //NSLog(@"tempTag: %d tempTag*0x08: %X",tempTag,tempTag*0x08);
   uint16_t startadresse=tempRaum*RAUMPLANBREITE + tempObjekt*TAGPLANBREITE + tempTag*0x08;
	
   //NSLog(@"tempRaum: %X tempObjekt: %X tempTag: %X startadresse hex: %X dez: %d",tempRaum, tempObjekt, tempTag,startadresse,startadresse);
   
   
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
   
	uint16_t kontrollstartadresse = 0x100*hbyte+lbyte;
   //NSLog(@"kontrollstartadresse: %d",kontrollstartadresse);
   
   uint16_t kontrolltag = (kontrollstartadresse & 0x38)/0x08; // 0x38: 111 000 Bit 3-6
   //NSLog(@"kontrolltag: %d",kontrolltag);
   
   uint16_t kontrollobjekt = (kontrollstartadresse & 0x1C0)/0x40 ; // 0x1C0: 111 000 000 Bit 7-9
   //NSLog(@"kontrollobjekt: %d",kontrollobjekt);
   
   uint16_t kontrollraum = (kontrollstartadresse & 0xE00)/0x200; // 0xE0: 111 000 000 000 Bit 10-12
   //NSLog(@"kontrollraum: %d",kontrollraum);
   
   /*
    NSString* lbString= [[NSNumber numberWithInt:lbyte]stringValue];
    if ([lbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
    {
    lbString=[NSString stringWithFormat:@"0%@",lbString];
    }
    */
	
	[Adresse setStringValue:AdresseKontrollString];
	[Cmd setStringValue:@""];
   
   
   
   
   
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
	[NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
	[NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
   
   [NotificationDic setObject:[[ObjektPop selectedItem]title] forKey:@"titel"];
   [NotificationDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
   [NotificationDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
   
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"EEPROMReadStart" object:self userInfo:NotificationDic];
	Webserver_busy=1;
	
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];						// Hi-Bit der Adresse
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];						// Lo-Bit der Adresse
	
	//NSLog(@"AVRClient readEthTagplan EEPROMAddresse: %X startadresse: %X  hbyte: %X lbyte: %X", [I2CPop indexOfSelectedItem], startadresse, hbyte, lbyte);
	
	//	NSString* ReadURL=[self ReadURLForEEPROM: EEPROMAddresse hByte: hbyte lByte: lbyte];
   
}

- (IBAction)readEthWochenplan:(id)sender
{
   enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;
   [EEPROMReadDataArray removeAllObjects];
   
	if (Webserver_busy || WriteWoche_busy)
	{
      NSLog(@"readEthWochenplan Webserver_busy beep");
		NSBeep();
      
		return;
	}
	WebTask = eepromreadwoche;
	[readTagTaste setEnabled:NO];
   [readWocheTaste setEnabled:NO];
	[ReadFeld setStringValue:@""];
	[WriteFeld setStringValue:@""];
   [writeWocheTaste setEnabled:NO];

	[AdresseFeld setStringValue:@""];
	int	tempTag=[TagPop indexOfSelectedItem];
   // Start ist MO
   //int	tempTag=0;
   
   wochentagindex = 0; // Beginn
   
   //[self readEthTagplanVonTag:tempTag];
   [self readEthTagplanVonRaum:[RaumPop indexOfSelectedItem] vonObjekt:[ObjektPop indexOfSelectedItem] vonTag:wochentagindex];

   
   return;

	int	tempRaum=[RaumPop indexOfSelectedItem];
	int	tempObjekt=[ObjektPop indexOfSelectedItem];
   
   
   int tagbalkentyp = [[[[[[[HomebusArray objectAtIndex:tempRaum]
                            objectForKey:@"wochenplanarray"]
                           objectAtIndex:0]
                          objectForKey:@"tagplanarray"]
                         objectAtIndex:tempObjekt]
                        objectForKey:@"tagbalkentyp"]intValue];
   
   NSLog(@"readEthWochenplan PList tagbalkentyp: %d",tagbalkentyp);
   //return;
   
   
   //NSLog(@"tempRaum index: %d titel: %@",tempRaum, [[RaumPop selectedItem]title]);
   //NSLog(@"tempObjekt index: %d titel: %@",tempObjekt, [[ObjektPop selectedItem]title]);
   
	//NSLog(@"tempRaum indexdez: %d hex: %x",[[RaumPop selectedItem]tag],[[RaumPop selectedItem]tag]);
	
   //NSLog(@"tempRaum: %d,tempRaum*RAUMPLANBREITE: %X",tempRaum,tempRaum*RAUMPLANBREITE);
   //NSLog(@"tempObjekt: %d tempObjekt*TAGPLANBREITE: %X",tempObjekt,tempObjekt*TAGPLANBREITE);
   //NSLog(@"tempTag: %d tempTag*0x08: %X",tempTag,tempTag*0x08);
   uint16_t startadresse=tempRaum*RAUMPLANBREITE + tempObjekt*TAGPLANBREITE + tempTag*0x08;
	
   //NSLog(@"tempRaum: %X tempObjekt: %X tempTag: %X startadresse hex: %X dez: %d",tempRaum, tempObjekt, tempTag,startadresse,startadresse);
   
   
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
   
	uint16_t kontrollstartadresse = 0x100*hbyte+lbyte;
   //NSLog(@"kontrollstartadresse: %d",kontrollstartadresse);
   
   uint16_t kontrolltag = (kontrollstartadresse & 0x38)/0x08; // 0x38: 111 000 Bit 3-6
   //NSLog(@"kontrolltag: %d",kontrolltag);
   
   uint16_t kontrollobjekt = (kontrollstartadresse & 0x1C0)/0x40 ; // 0x1C0: 111 000 000 Bit 7-9
   //NSLog(@"kontrollobjekt: %d",kontrollobjekt);

   uint16_t kontrollraum = (kontrollstartadresse & 0xE00)/0x200; // 0xE0: 111 000 000 000 Bit 10-12
   //NSLog(@"kontrollraum: %d",kontrollraum);
   
   
/*	
	NSString* lbString= [[NSNumber numberWithInt:lbyte]stringValue];
	if ([lbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
	{
		lbString=[NSString stringWithFormat:@"0%@",lbString];
	}
*/
	
	[Adresse setStringValue:AdresseKontrollString];
	[Cmd setStringValue:@""];
   
     
   
   
   
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
	[NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
	[NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
   
   [NotificationDic setObject:[[ObjektPop selectedItem]title] forKey:@"titel"];
   [NotificationDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
   [NotificationDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
   [NotificationDic setObject:[NSNumber numberWithInt:wochentagindex] forKey:@"wochentagindex"];

	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"EEPROMReadWocheStart" object:self userInfo:NotificationDic];
	Webserver_busy=1;
	
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];						// Hi-Bit der Adresse
	//	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];						// Lo-Bit der Adresse
	
	NSLog(@"AVRClient readEthWochenplan EEPROMAddresse: %lX startadresse: %X  hbyte: %X lbyte: %X", (long)[I2CPop indexOfSelectedItem], startadresse, hbyte, lbyte);
	
	//	NSString* ReadURL=[self ReadURLForEEPROM: EEPROMAddresse hByte: hbyte lByte: lbyte];

}

- (void)readEthTagplanVonTag:(int)wochentag
{
   
   //   enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;
   
   
   //WebTask = eepromread;
   [readTagTaste setEnabled:NO];
   [readWocheTaste setEnabled:NO];
   [ReadFeld setStringValue:@""];
   [WriteFeld setStringValue:@""];
   [writeWocheTaste setEnabled:NO];

   [AdresseFeld setStringValue:@""];
   //int	tempTag=[TagPop indexOfSelectedItem];
   // Start ist MO
   int	tempTag=wochentag;
   wochentagindex = wochentag; // aktueller Tag
   
   int	tempRaum=[RaumPop indexOfSelectedItem];
   int	tempObjekt=[ObjektPop indexOfSelectedItem];
   
   
   int tagbalkentyp = [[[[[[[HomebusArray objectAtIndex:tempRaum]
                            objectForKey:@"wochenplanarray"]
                           objectAtIndex:0]
                          objectForKey:@"tagplanarray"]
                         objectAtIndex:tempObjekt]
                        objectForKey:@"tagbalkentyp"]intValue];
   
   NSLog(@"readEthTagplanVonTag: %d  ",wochentag);
   //return;
   
   
   //NSLog(@"tempRaum index: %d titel: %@",tempRaum, [[RaumPop selectedItem]title]);
   //NSLog(@"tempObjekt index: %d titel: %@",tempObjekt, [[ObjektPop selectedItem]title]);
   
   //NSLog(@"tempRaum indexdez: %d hex: %x",[[RaumPop selectedItem]tag],[[RaumPop selectedItem]tag]);
   
   //NSLog(@"tempRaum: %d,tempRaum*RAUMPLANBREITE: %X",tempRaum,tempRaum*RAUMPLANBREITE);
   //NSLog(@"tempObjekt: %d tempObjekt*TAGPLANBREITE: %X",tempObjekt,tempObjekt*TAGPLANBREITE);
   //NSLog(@"tempTag: %d tempTag*0x08: %X",tempTag,tempTag*0x08);
   uint16_t startadresse=tempRaum*RAUMPLANBREITE + tempObjekt*TAGPLANBREITE + tempTag*0x08;
   
   //NSLog(@"tempRaum: %X tempObjekt: %X tempTag: %X startadresse hex: %X dez: %d",tempRaum, tempObjekt, tempTag,startadresse,startadresse);
   
   
   
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
   
   uint16_t kontrollstartadresse = 0x100*hbyte+lbyte;
   //NSLog(@"kontrollstartadresse: %d",kontrollstartadresse);
   
   uint16_t kontrolltag = (kontrollstartadresse & 0x38)/0x08; // 0x38: 111 000 Bit 3-6
   //NSLog(@"kontrolltag: %d",kontrolltag);
   
   uint16_t kontrollobjekt = (kontrollstartadresse & 0x1C0)/0x40 ; // 0x1C0: 111 000 000 Bit 7-9
   //NSLog(@"kontrollobjekt: %d",kontrollobjekt);
   
   uint16_t kontrollraum = (kontrollstartadresse & 0xE00)/0x200; // 0xE0: 111 000 000 000 Bit 10-12
   //NSLog(@"kontrollraum: %d",kontrollraum);
   
   
   /*
    NSString* lbString= [[NSNumber numberWithInt:lbyte]stringValue];
    if ([lbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
    {
    lbString=[NSString stringWithFormat:@"0%@",lbString];
    }
    */
   
   [Adresse setStringValue:AdresseKontrollString];
   [Cmd setStringValue:@""];
   
   
   
   
   
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
   [NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
   [NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
   
   [NotificationDic setObject:[[ObjektPop selectedItem]title] forKey:@"titel"];
   [NotificationDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
   [NotificationDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
   [NotificationDic setObject:[NSNumber numberWithInt:wochentagindex] forKey:@"wochentagindex"];
   
   
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //[nc postNotificationName:@"EEPROMReadWocheFortsetung" object:self userInfo:NotificationDic];
   [nc postNotificationName:@"EEPROMReadStart" object:self userInfo:NotificationDic];
   Webserver_busy=1;
   
   //	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];						// Hi-Bit der Adresse
   //	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];						// Lo-Bit der Adresse
   
   //NSLog(@"AVRClient readEthTagplan EEPROMAddresse: %X startadresse: %X  hbyte: %X lbyte: %X", [I2CPop indexOfSelectedItem], startadresse, hbyte, lbyte);
   
   //	NSString* ReadURL=[self ReadURLForEEPROM: EEPROMAddresse hByte: hbyte lByte: lbyte];
   
   
}

- (void)readEthTagplanVonRaum:(int)raum vonObjekt: (int)objekt vonTag:(int)wochentag
{
   
   //   enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;
   
   
      //WebTask = eepromread;
      [readTagTaste setEnabled:NO];
      [readWocheTaste setEnabled:NO];
      [ReadFeld setStringValue:@""];
      [WriteFeld setStringValue:@""];
      [writeWocheTaste setEnabled:NO];

      [AdresseFeld setStringValue:@""];
      //int	tempTag=[TagPop indexOfSelectedItem];
      // Start ist MO
      int	tempTag=wochentag;
      wochentagindex = wochentag; // aktueller Tag
      
      //int	tempRaum=[RaumPop indexOfSelectedItem];
      //int	tempObjekt=[ObjektPop indexOfSelectedItem];
      
      
      int tagbalkentyp = [[[[[[[HomebusArray objectAtIndex:raum]
                               objectForKey:@"wochenplanarray"]
                              objectAtIndex:0]
                             objectForKey:@"tagplanarray"]
                            objectAtIndex:objekt]
                           objectForKey:@"tagbalkentyp"]intValue];
      
      NSLog(@"readEthTagplanVonRaum: %d  ",wochentag);
      //return;
      
      
      //NSLog(@"tempRaum index: %d titel: %@",tempRaum, [[RaumPop selectedItem]title]);
      //NSLog(@"tempObjekt index: %d titel: %@",tempObjekt, [[ObjektPop selectedItem]title]);
      
      //NSLog(@"tempRaum indexdez: %d hex: %x",[[RaumPop selectedItem]tag],[[RaumPop selectedItem]tag]);
      
      //NSLog(@"tempRaum: %d,tempRaum*RAUMPLANBREITE: %X",tempRaum,tempRaum*RAUMPLANBREITE);
      //NSLog(@"tempObjekt: %d tempObjekt*TAGPLANBREITE: %X",tempObjekt,tempObjekt*TAGPLANBREITE);
      //NSLog(@"tempTag: %d tempTag*0x08: %X",tempTag,tempTag*0x08);
      uint16_t startadresse=raum*RAUMPLANBREITE + objekt*TAGPLANBREITE + tempTag*0x08;
      
      //NSLog(@"tempRaum: %X tempObjekt: %X tempTag: %X startadresse hex: %X dez: %d",tempRaum, tempObjekt, tempTag,startadresse,startadresse);
   
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
      
      uint16_t kontrollstartadresse = 0x100*hbyte+lbyte;
      //NSLog(@"kontrollstartadresse: %d",kontrollstartadresse);
      
      uint16_t kontrolltag = (kontrollstartadresse & 0x38)/0x08; // 0x38: 111 000 Bit 3-6
      //NSLog(@"kontrolltag: %d",kontrolltag);
      
      uint16_t kontrollobjekt = (kontrollstartadresse & 0x1C0)/0x40 ; // 0x1C0: 111 000 000 Bit 7-9
      //NSLog(@"kontrollobjekt: %d",kontrollobjekt);
      
      uint16_t kontrollraum = (kontrollstartadresse & 0xE00)/0x200; // 0xE0: 111 000 000 000 Bit 10-12
      //NSLog(@"kontrollraum: %d",kontrollraum);
      
      
      /*
       NSString* lbString= [[NSNumber numberWithInt:lbyte]stringValue];
       if ([lbString length]==1) // nur eine Stelle, fuehrende Null einfuegen
       {
       lbString=[NSString stringWithFormat:@"0%@",lbString];
       }
       */
      
      [Adresse setStringValue:AdresseKontrollString];
      [Cmd setStringValue:@""];
      
      
      
      
      
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
      [NotificationDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
      [NotificationDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
      
      [NotificationDic setObject:[[ObjektPop selectedItem]title] forKey:@"titel"];
      [NotificationDic setObject:[NSNumber numberWithInt:tagbalkentyp] forKey:@"tagbalkentyp"];
      [NotificationDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
      [NotificationDic setObject:[NSNumber numberWithInt:wochentagindex] forKey:@"wochentagindex"];
      
   
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   //[nc postNotificationName:@"EEPROMReadWocheFortsetung" object:self userInfo:NotificationDic];
      [nc postNotificationName:@"EEPROMReadStart" object:self userInfo:NotificationDic];
      Webserver_busy=1;
      
      //	[i2cAdressArray addObject:[NSNumber numberWithInt:hbyte]];						// Hi-Bit der Adresse
      //	[i2cAdressArray addObject:[NSNumber numberWithInt:lbyte]];						// Lo-Bit der Adresse
      
      //NSLog(@"AVRClient readEthTagplan EEPROMAddresse: %X startadresse: %X  hbyte: %X lbyte: %X", [I2CPop indexOfSelectedItem], startadresse, hbyte, lbyte);
      
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
		simTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
															  target:self 
															selector:@selector(readEthSimTimerFunktion:) 
															userInfo:sendTimerDic 
															 repeats:YES];
}



- (void)readEthSimTimerFunktion:(NSTimer*) derTimer
{
	
	NSMutableDictionary* sendTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	NSLog(@"readEthSimTimerFunktion  sendTimerDic: %@",[sendTimerDic description]);
		if (simTimer)
		{
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
			
			NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
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
			
		}
	}
}




/*
- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzahlDaten
{
	[self readEthTagplan:i2cAdresse vonAdresse:startAdresse anz: anzahlDaten];
	
	return;
	}
*/	
	
	
	
	
	
	
- (void)WriteStandardAktion:(NSNotification*)note
{
   NSLog(@"AVRClient WriteStandardAktion note: %@",[[note userInfo]description]);
if (Webserver_busy)
	{
      NSLog(@"WriteStandardAktion Webserver_busy beep");
		NSBeep();
		return;
	}

	if ([TWIStatusTaste state])
	{
		NSLog(@"TWIStatustaste ok: %ld",(long)[TWIStatusTaste state]);
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
		
		NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
		NSString* s2=@"Quelle: WriteStandardAktion";
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		int antwort=[Warnung runModal];
		
	}
	else
	{
      //NSLog(@"TWIStatustaste nicht ok: %d",[TWIStatusTaste state]);
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
      
      //int permanent = [[[note userInfo]objectForKey:@"permanent"]intValue];
      
      //NSString* Titel = [[note userInfo]objectForKey:@"titel"];
		NSArray* StundenByteArray=[[note userInfo]objectForKey:@"stundenbytearray"];
		
		NSMutableDictionary* HomeClientDic=[[NSMutableDictionary alloc]initWithDictionary:[note userInfo]];
		[HomeClientDic setObject:[[note userInfo]objectForKey:@"titel"] forKey:@"titel"];
      
		int I2CIndex=[I2CPop indexOfSelectedItem];
		
		NSString* EEPROM_i2cAdresseString=[I2CPop itemTitleAtIndex:I2CIndex];
		
		[HomeClientDic setObject:EEPROM_i2cAdresseString forKey:@"eepromadressestring"];
		
		[HomeClientDic setObject:[NSNumber numberWithInt:[I2CPop indexOfSelectedItem]] forKey:@"eepromadressezusatz"];
		//AnzahlDaten=0x20; //32 Bytes, TAGPLANBREITE;
		unsigned int EEPROM_i2cAdresse;
		NSScanner* theScanner = [NSScanner scannerWithString:EEPROM_i2cAdresseString];
		int ScannerErfolg=[theScanner scanHexInt:&EEPROM_i2cAdresse];
		[HomeClientDic setObject:[NSNumber numberWithInt:EEPROM_i2cAdresse] forKey:@"eepromadresse"];
		
            // permanent anfuegen
            
      NSString* permanent = [[[note userInfo]objectForKey:@"permanent"]stringValue];
      NSLog(@"WriteStandardAktion permanent: %@",permanent);
      [HomeClientDic setObject:permanent forKey:@"permanent"];
      
		
      // Adressberechnung:
      
		uint16_t i2cStartadresse=Raum*RAUMPLANBREITE + Objekt*TAGPLANBREITE+ Wochentag*0x08;
		
      NSLog(@"i2cStartadresse: hex: %04X int: %d",i2cStartadresse,i2cStartadresse);
      NSLog(@"Raum: %d Objekt: %d Wochentag: %d",Raum,Objekt,Wochentag);
      
      // Kontrolle: Rueckwaertsberechnung im Master
      uint8_t raum = i2cStartadresse / RAUMPLANBREITE;
      uint8_t objekt = (i2cStartadresse % RAUMPLANBREITE)/ TAGPLANBREITE;
      uint8_t wochentag = (i2cStartadresse % RAUMPLANBREITE %TAGPLANBREITE) / 0x08;

      uint8_t lb = i2cStartadresse & 0x00FF;
		[HomeClientDic setObject:[NSNumber numberWithInt:lb] forKey:@"lbyte"];
		uint8_t hb = i2cStartadresse >> 8;
		
      NSString* AdresseKontrollString = [NSString stringWithFormat:@"hbyte: %2X  lbyte: %2X",hb, lb];
		[Adresse setStringValue:AdresseKontrollString];
		
		[HomeClientDic setObject:[NSNumber numberWithInt:hb] forKey:@"hbyte"];
		[HomeClientDic setObject:StundenByteArray forKey:@"stundenbytearray"];
      [Cmd setStringValue:[StundenByteArray componentsJoinedByString:@"\t"]];
		//NSLog(@"WriteStandardAktion Raum: %d wochentag: %d Objekt: %d EEPROM: %02X lb: 0x%02X hb: 0x%02X ",Raum, Wochentag, Objekt,EEPROM_i2cAdresse,lb, hb);
		
		// Information an HomeClient schicken
		
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		
      //NSLog(@"WriteStandardAktion: permanent: %d",permanent);
      if ([permanent intValue]) // schicken an EEPROM
      {
         //NSLog(@"AVRClient WriteStandardAktion mit permanent: %d ",permanent);
         [nc postNotificationName:@"HomeClientWriteStandard" object:self userInfo:HomeClientDic];
      }
      else // data in daySettingArray einsetzen
      {
         //StundenbyteArray in daySettingArray festhalten
         //daySettingArray[pos][byte]
         /*
          byte 0: raum | objekt
          byte 1: wochentag | code: aktuell: bit0, delete: bit7
          
          
          */

         uint8_t freielinie = self.freeDaySettingline;
         
         //printf("freielinie: %s\n",freielinie);
         NSLog(@"freielinie:: %d StundenByteArray: %@",freielinie,StundenByteArray);
         if (freielinie < 0xFF)
         {
            
            daySettingArray[freielinie][0] = (Raum<<4) | Objekt;
            
            uint8_t code = 0x01; // bit 0 gesetzt, data ist aktuell
            
            daySettingArray[freielinie][1] = (Wochentag<<4) | code;
            
            for (int dataindex=0;dataindex < 6; dataindex++)
            {
               
               daySettingArray[freielinie][4 + dataindex] = [StundenByteArray[dataindex]intValue];
               //    daySettingArray[Raum][Objekt][Wochentag][dataindex] = [StundenByteArray[dataindex]intValue];
               
            }
            daySettingArray[freielinie][15] = 1;
            //            daySettingArray[Raum][Objekt][Wochentag][7] = 1; // markierung temporaer
            //   
            int l = 8*16;
            SettingData = [NSMutableData dataWithBytes:daySettingArray length:l];
            [SettingData writeToFile:HomeDaySettingPfad atomically:YES];

         }
         // 
         for (int i=0;i<8;i++)
         {
            printf("daySettingArray i: %d data: %s",i,daySettingArray[i]);
            printf("\n");
         }
         
      }
      
      //NSLog(@"daySettingArray: %s",daySettingArray);
      //[nc postNotificationName:@"HomeClientWriteStandard" object:self userInfo:HomeClientDic];
		
	}
}




- (void)updatePListMitDicArray:(NSArray*)updateArray
{
   /*
    in reportFixTaste
    
    
    */
   // PList anpassen
   NSString* AblaufString = @"Update für: ";
   for (int index=0;index<[updateArray count];index++)
   {
      //NSLog(@"updatePListMitDicArray index: %d updateArray: %@",index,[[updateArray objectAtIndex:index] description]);
      int raum = [[[updateArray objectAtIndex:index]objectForKey:@"raum"]intValue];
      int objekt = [[[updateArray objectAtIndex:index]objectForKey:@"objekt"]intValue];
      int wochentag = [[[updateArray objectAtIndex:index]objectForKey:@"wochentag"]intValue];
      NSMutableArray* stundenplanarray  = [NSMutableArray arrayWithArray:[[updateArray objectAtIndex:index]objectForKey:@"stundenplanarray"]];
      //NSLog(@"updatePListMitDicArray index: %d stundenplanarray: %@",index,[stundenplanarray description]);
      [self stundenplanzeigen:stundenplanarray];
      [self setStundenplanArray:stundenplanarray forWochentag:wochentag forObjekt:objekt forRaum:raum];
      NSArray* subViews = [[[self ScrollerVonRaum:raum]documentView ]subviews];
      //NSLog(@"updatePListMitDicArray index: %d subViews: %@",index,[subViews description]);
      for (int k=0;k<[subViews count];k++)
      {
         if ([[subViews objectAtIndex:k ]isKindOfClass:[rTagplanbalken class]])
         {
         //NSLog(@"subViews k: %d titel: %@ tag: %d",k,[[subViews objectAtIndex:k]Titel],[[subViews objectAtIndex:k]tag]);
         }
      }
      NSLog(@"updatePListMitDicArray index: %d  raum: %d objekt: %d wochentag: %d",index,raum,objekt,wochentag);
      
      for (int k=0;k<[subViews count];k++)
      {
          //NSLog(@"subViews k: %d raum: %d wochentag: %d objekt: %d",k,raum,wochentag,objekt);
         if ( [[subViews objectAtIndex:k ]isKindOfClass:[rTagplanbalken class]] && ([[subViews objectAtIndex:k ]raum]==raum ) && ([[subViews objectAtIndex:k ]wochentag]==wochentag ) && ([[subViews objectAtIndex:k ]objekt] == objekt))
         {
            //NSLog(@"**subViews k: %d subview %@",k,[[subViews objectAtIndex:k ]Titel]);
            [[subViews objectAtIndex:k ]setStundenArray:stundenplanarray forKey:@"code"];
            
            [[subViews objectAtIndex:k ]setNeedsDisplay:YES];
            AblaufString = [AblaufString stringByAppendingFormat:@"raum:%d wochentag:%d objekt:%d ",raum,wochentag,objekt];
         }
         else
         {
            //NSLog(@"subViews k: %d nicht da",k);
         }
      }
      
   } // for
   
   // Daten in PList sichern
   [self saveHomeDic];
   
   // Daten auf eepromupdatedaten.txt loeschen
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"Ja"];
   [Warnung addButtonWithTitle:@"Nein"];
   [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"EEPROMUpdateDaten?"]];
   
   NSString* s1=@"Daten auf eepromupdatedaten.txt loeschen?";
   NSString* s2=@"";
   NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
   [Warnung setInformativeText:InformationString];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   
   int antwort=0;
   //antwort=[Warnung runModal];
   
   // antwort = 0;
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   NSLog(@"Warnung EEPROMDaten Antwort: %d",antwort);
   
   if (antwort == NSAlertFirstButtonReturn)
   {
      NSLog(@"Daten auf eepromupdatedaten.txt loeschen");
      [NotificationDic setObject:[NSNumber numberWithInt:13] forKey:@"perm"];
      
      
      
   }
   else if (antwort == NSAlertAlternateReturn)
   {
      NSLog(@"Daten auf eepromupdatedaten.txt behalten");
      [NotificationDic setObject:[NSNumber numberWithInt:12] forKey:@"perm"];
      
   }
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"EEPROMUpdateClear" object:self userInfo:NotificationDic]; // -> HomeClient

   [Ablauffeld setStringValue:AblaufString];
   
}


# pragma mark writeEEPROMWochenplan

- (IBAction)writeEEPROMWochenplan:(id)sender
{
   
   if (Webserver_busy)
	{
      [Errorfeld setStringValue:@"Webserver ist busy"];
      NSLog(@"UpdatePlan Webserver_busy beep");
		NSBeep();
		return;
	}
   
   if ([TWIStatusTaste state])
    {
    //NSLog(@"TWIStatustaste: %d",[TWIStatusTaste state]);
    NSAlert *Warnung = [[NSAlert alloc] init];
    [Warnung addButtonWithTitle:@"OK"];
    //	[Warnung addButtonWithTitle:@""];
    //	[Warnung addButtonWithTitle:@""];
    //	[Warnung addButtonWithTitle:@"Abbrechen"];
    [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
    
    NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
    NSString* s2=@"Quelle: writeEEPROMWochenplan";
    NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
    [Warnung setInformativeText:InformationString];
    [Warnung setAlertStyle:NSWarningAlertStyle];
    
    int antwort=[Warnung runModal];
    
       return;
    }
    
    else
    
   {
      
      [writeEEPROMcounterfeld setStringValue:@""];
      writeEEPROManzeige.intValue = 0;
      busycountfeld.intValue = 0;
      
      Webserver_busy=1;// Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
		[AdresseFeld setStringValue:@""];
		[WriteFeld setStringValue:@""];
		[ReadFeld setStringValue:@""];
		[WriteWocheFeld setStringValue:@""];
		[StatusFeld setStringValue:@"Adresse wird übertragen"];
      
      NSMutableArray* EEPROMWriteArray = [[NSMutableArray alloc]initWithCapacity:0];

      NSMutableDictionary* writeDic = [[NSMutableDictionary alloc]initWithCapacity:0];
      //AblaufString = [AblaufString stringByAppendingFormat:@"r:%d wt:%d o:%d ",raum,wochentag,objekt];
   
      int raum = [RaumPop indexOfSelectedItem];
      [writeDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
      int objekt = [ObjektPop indexOfSelectedItem];
      [writeDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
      [writeDic setObject:[NSNumber numberWithInt:0] forKey:@"wochentag"];
		[writeDic setObject:[NSNumber numberWithInt:10]forKey:@"timeoutcounter"];
      
      NSArray* raumListe = [[[WochenplanTab tabViewItemAtIndex:raum]view] subviews];// alle Views im Tab
      //NSLog(@"raumListe: %@",[raumListe description]  );
      for (int i=0;i<[raumListe count];i++)
      {
         if ([[raumListe objectAtIndex:i] isKindOfClass:[NSScrollView class]])
              {
                 NSArray* TagplanListe = [(NSScrollView*)[[raumListe objectAtIndex:i]documentView]subviews];// aktivierte Tagplaene
                 //NSLog(@"TagplanListe: %@",[TagplanListe description]  );
                 
                 for (int k=0;k<[TagplanListe count];k++)
                 {
                    if ([[TagplanListe objectAtIndex:k] isKindOfClass:[rTagplanbalken class]]) // Tagbalken suchen
                    {
                       rTagplanbalken* tempBalken = [TagplanListe objectAtIndex:k];
                       NSInteger temptag = tempBalken.tag;
                       //NSLog(@"k: %d Tagplan tag: %d: Titel: %@ Plan: %@",k,temptag,[[TagplanListe  objectAtIndex:k]Titel],[[TagplanListe  objectAtIndex:k]description]  );
                       int tempwochentag = temptag%100;
                       tempwochentag /= 10;
                       int tempobjekt = temptag%10;
                       if (tempobjekt == objekt) // Objekt stimmt
                       {
                          int temptyp = [[TagplanListe  objectAtIndex:k]tagbalkentyp];
                          //NSLog(@"raum: %d objekt: %d wochentag: %d",raum, objekt, tempwochentag);
                          NSArray* tempstundenbytearray = [[TagplanListe  objectAtIndex:k]StundenByteArray];
                          //NSLog(@"k: %d tempstundenplanarray: %@",k,[tempstundenbytearray description]);
                          uint16_t startadresse=raum*RAUMPLANBREITE + objekt*TAGPLANBREITE + tempwochentag*0x08;
                          //NSLog(@"k: %d startadresse: %d",k,startadresse);
                          
                          int lbyte=startadresse<<8;
                          lbyte &= 0xff00;
                          lbyte >>=8;
                          int hbyte=startadresse>>8;
                          
                          NSString* tempTitel = [[TagplanListe  objectAtIndex:k]Titel];
                          NSMutableDictionary* writeDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                       
                          [writeDic setObject:tempstundenbytearray forKey:@"stundenbytearray"];

                          [writeDic setObject:[NSNumber numberWithInt:raum] forKey:@"raum"];
                          [writeDic setObject:[NSNumber numberWithInt:tempwochentag] forKey:@"wochentag"];
                          [writeDic setObject:[NSNumber numberWithInt:objekt] forKey:@"objekt"];
                          [writeDic setObject:tempTitel forKey:@"titel"];
                          
                          
                          [writeDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
                          [writeDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
                          
                          [writeDic setObject:[NSNumber numberWithInt:temptyp] forKey:@"tagbalkentyp"];
                          
                          [writeDic setObject:@"A0" forKey:@"eepromadressestring"];
                          [writeDic setObject:@"160" forKey:@"eepromadresse"];
                          [writeDic setObject:[NSNumber numberWithInt:0] forKey:@"eepromadressezusatz"];
                          [writeDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];
                          [writeDic setObject:[NSNumber numberWithInt:0] forKey:@"mod"];
                          
                          
                          //NSLog(@"k: %d writeDic: %@ ",k,[writeDic description]);
                          
                          [EEPROMWriteArray addObject:writeDic];
                       }
                    
                    }
                    
                    
                 }// for k
                 
                 
                 
              } // if scroller
      }//for i
      
       NSString* AblaufString = @"Update für: ";

       
      NSMutableDictionary* EEPROMWriteDic = [[NSMutableDictionary alloc]initWithCapacity:0];
      //AblaufString = [AblaufString stringByAppendingFormat:@"r:%d wt:%d o:%d ",raum,wochentag,objekt];
      [EEPROMWriteDic setObject:EEPROMWriteArray forKey:@"updatearray"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"EEPROMWriteWoche" object:self userInfo:EEPROMWriteDic];
      

      
   }// not busy

}

- (void)updateEEPROMMitDicArray:(NSArray*)updateArray
{
   //NSLog(@"AVRClient UpdatePlan updateArray: %@",[updateArray description]);
   NSString* AblaufString = @"Update für: ";

   
   if (Webserver_busy)
	{
      [Errorfeld setStringValue:@"Webserver ist busy"];
      NSLog(@"UpdatePlan Webserver_busy beep");
		NSBeep();
		return;
	}
   
/*	if ([TWIStatusTaste state])
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
		
		//int antwort=[Warnung runModal];
		return;
	}

	else
 */
	{
      
		Webserver_busy=1;// Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
		[AdresseFeld setStringValue:@""];
		[WriteFeld setStringValue:@""];
		[ReadFeld setStringValue:@""];
		[WriteWocheFeld setStringValue:@""];
		[StatusFeld setStringValue:@"Adresse wird übertragen"];
      
      NSMutableDictionary* updateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
      //AblaufString = [AblaufString stringByAppendingFormat:@"r:%d wt:%d o:%d ",raum,wochentag,objekt];
      [updateDic setObject:updateArray forKey:@"updatearray"];
		[updateDic setObject:[NSNumber numberWithInt:10]forKey:@"timeoutcounter"];
      
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"updateEEPROM" object:self userInfo:updateDic];
      
	}
}


- (void)EEPROMLadepositionAktion:(NSNotification*)note
{
   //NSLog(@"AVRClient EEPROMLadepositionAktion userInfo: %@",[[note userInfo] description]);
   if ([[note userInfo] objectForKey:@"ladeposition"])
   {
      [writeEEPROMcounterfeld setIntValue:[[[note userInfo] objectForKey:@"ladeposition"]intValue] ];
      writeEEPROManzeige.intValue = [[[note userInfo] objectForKey:@"ladeposition"]intValue]+1;
      [WriteFeld setStringValue:@""];
   }
}

- (void)EEPROMWriteFertigAktion:(NSNotification*)note
{
   //NSLog(@"AVRClient EEPROMWriteFertigAktion userInfo: %@",[[note userInfo] description]);
   if ([[note userInfo] objectForKey:@"fertig"])
   {
      switch ([[[note userInfo] objectForKey:@"fertig"]intValue])
      {
         case 0: // fertig infolge timeout
         {
            
            NSLog(@"AVRClient EEPROMWriteFertigAktion timeout");
            [[NSSound soundNamed:@"Basso"] play];
            [writeEEPROMcounterfeld setStringValue:@"X"];
            [UpdateWaitrad stopAnimation:NULL];
            [Waitrad stopAnimation:NULL];

            
         }break;
         
         
         case 1: // fertig mit Erfolg
         {
            NSLog(@"AVRClient EEPROMWriteFertigAktion Erfolg");
            [[NSSound soundNamed:@"Glass"] play];
            [writeEEPROMcounterfeld setStringValue:@"OK"];
             // Aufraeumen
            [UpdateWaitrad stopAnimation:NULL];
            [Waitrad stopAnimation:NULL];

             NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
             for(NSView* thisPage in [EEPROMPlan subviews])
             {
             //get all the ads on this page
             //NSArray* thisPageSubviews = [thisPage subviews];
             //for(NSView* thisPageSubview in thisPageSubviews)
             //   if ([thisPageSubview isMemberOfClass:[rTagplanbalken class]])
             //{
             //[viewsToRemove addObject:thisPageSubview];
             //}
             //NSLog(@"Tagplanbalken weg");
             [viewsToRemove addObject:thisPage];
             }
             [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
             [EEPROMPlan setNeedsDisplay:YES];
             //[HomeServerFixArray removeAllObjects];
            
            
            // Daten auf eepromupdatedaten.txt loeschen
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Ja"];
           	[Warnung addButtonWithTitle:@"Nein"];
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"EEPROMUpdateDaten?"]];
            
            NSString* s1=@"Daten auf eepromupdatedaten.txt loeschen?";
            NSString* s2=@"";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            int antwort=0;
            //antwort=[Warnung runModal];
            
            // antwort = 0;
            NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            NSLog(@"Warnung EEPROMDaten Antwort: %d",antwort);
            
            if (antwort == NSAlertFirstButtonReturn)
            {
               NSLog(@"Daten auf eepromupdatedaten.txt loeschen");
               [NotificationDic setObject:[NSNumber numberWithInt:13] forKey:@"perm"];


               
            }
            else if (antwort == NSAlertAlternateReturn)
            {
               NSLog(@"Daten auf eepromupdatedaten.txt behalten");
               [NotificationDic setObject:[NSNumber numberWithInt:12] forKey:@"perm"];

            }
         
         NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"EEPROMUpdateClear" object:self userInfo:NotificationDic]; // -> HomeClient

             
            
         }break;
            
            
      }// switch
   //[self setTWIState:1];
      TWI_ON_Flag = 1;
      
   }
// TWI wieder einschalten
   
}


- (void)WriteModifierAktion:(NSNotification*)note
{
	//NSLog(@"AVRClient WriteModifierAktion userInfo: %@",[[note userInfo] description]);
	if ([TWIStatusTaste state])
	{
		NSLog(@"TWIStatustaste: %l",[TWIStatusTaste state]);
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@""];
		//	[Warnung addButtonWithTitle:@"Abbrechen"];
		[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
		
		NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
		NSString* s2=@"Quelle: WriteModifierAktion";
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
		
		NSMutableDictionary* HomeClientDic=[[NSMutableDictionary alloc]initWithDictionary:[note userInfo]];
		
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
	NSArray* Wochentage=[NSArray arrayWithObjects:@"M<",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	NSLog(@"WriteModifierTimerfunktion WriteWoche_busy: %d",WriteWoche_busy);
	NSMutableDictionary* WriteTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"WriteModifierTimerfunktion  WriteTimerDic: %@",[WriteTimerDic description]);
	int timeoutcounter=[[WriteTimerDic objectForKey:@"timeoutcounter"]intValue];
	NSLog(@"timeoutcounter: %d",timeoutcounter);
	// Webserver busy??
	if (Webserver_busy)
	{
      NSLog(@"WriteModifierTimerFunktion Webserver_busy beep");
		NSBeep();
		timeoutcounter--;
		[WriteTimerDic setObject:[NSNumber numberWithInt:timeoutcounter] forKey:@"timeoutcounter"];
		
		if (timeoutcounter == 0)
		{
			NSLog(@"timeoutcounter ist null");
			[derTimer invalidate];
			WriteWoche_busy=0;
			
			[self setTWITaste:YES];
		}
		return;
	}

	// Webserver auf busy setzen
	Webserver_busy=1; // Wird jeweils in der Finishloadaktion zurueckgestellt, sobald das writeok angekommen ist.
	timeoutcounter = 12;
	
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
		[self setTWITaste:YES];
		WriteWoche_busy=0;
		return;
		
	}
	}


- (IBAction)reportUpdateTaste:(id)sender
{
   //NSLog(@"reportUpdateTaste");
   [Errorfeld setStringValue:@""];
   [Ablauffeld setStringValue:@""];
   [WochenplanTab selectTabViewItemAtIndex:8];
   [writeEEPROMcounterfeld setStringValue:@" "];
   

   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"update"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"EEPROMUpdate" object:self userInfo:NotificationDic];
}

- (void)HomeDataUpdateAktion:(NSNotification*)note
{
   /*
    Daten aus HomeData EEPROMUpdateAktion. File eepromupdate.txt enthaelt Daten, die vom iPhone aus geaendert wurden, aber im Webinterface
    noch nicht in der PList sind.
    Aktion sucht die PListeintraege dazu und setzt zwei Tagplanbalken in den EEPROM-Scroller.
    new: Daten vom Server
    old: Daten von PList
    Auswahl mit RadioButton
    */
   //NSLog(@"HomeDataUpdateAktion note: %@",[[note userInfo]description]);
   //[EEPROMPop setDocumentView:EEPROMPlan];
   //[EEPROMTextfeld setStringValue:[[[[note userInfo]objectForKey:@"updatearray"]objectAtIndex:0]objectForKey:@"zeile"]];
   
   // **
   
   if (EEPROMScroller)
   {
       //NSLog(@"EEPROMScroller schon da");
   }
   NSRect RaumViewFeld=[EEPROMUpdatefeld frame];
   //NSRect RaumScrollerFeld=RaumViewFeld;	//	Feld fuer Scroller, in dem der RaumView liegt
   //NSScrollView* RaumScroller = [[NSScrollView alloc] initWithFrame:RaumScrollerFeld];
  // [[[WochenplanTab tabViewItemAtIndex:8]view]addSubview:RaumScroller];
   
   int AnzRaumObjekte=2;
   int RaumTitelfeldhoehe=10;
   int RaumTagbalkenhoehe=32;				//Hoehe eines Tagbalkens
   int RaumTagplanhoehe=AnzRaumObjekte*(RaumTagbalkenhoehe)+RaumTitelfeldhoehe;	// Hoehe des Tagplanfeldes mit den (AnzRaumobjekte) Tagbalken
   int RaumTagplanAbstand=RaumTagplanhoehe+10;	// Abstand zwischen den Ecken der Tagplanfelder
   int RaumKopfbereich=0;	// Bereich ueber dem Scroller
   

   // Feld im Scroller ist abhaengig von Anzahl Tagbalken
   //	NSLog(@"RaumTagplanAbstand: %d	",RaumTagplanAbstand);
   
   //	EEPROMPlan  anlegen
   if (!EEPROMPlan)
   {
      //NSLog(@"neuer EEPROMPlan");
      EEPROMPlan = [[NSView alloc]initWithFrame:RaumViewFeld];
      [EEPROMScroller setDocumentView:EEPROMPlan];
   }
   
   NSRect EEPROMUpdateFeld=[EEPROMPlan frame];
	//NSLog(@"EEPROMUpdateFeld y: %2.2f  height %2.2F",EEPROMUpdateFeld.origin.y,EEPROMUpdateFeld.size.height);
	//EEPROMUpdateFeld +=40;
   EEPROMUpdateFeld.origin.y = EEPROMUpdateFeld.size.height-40;
	EEPROMUpdateFeld.size.height = 30;
	EEPROMUpdateFeld.size.width -= 30;
	EEPROMbalken=[[rEEPROMbalken alloc]initWithFrame:EEPROMUpdateFeld];
	[EEPROMbalken BalkenAnlegen];
   
   [EEPROMScroller setBorderType:NSLineBorder];
   [EEPROMScroller setHasVerticalScroller:YES];
   [EEPROMScroller setHasHorizontalScroller:NO];
   [EEPROMScroller setLineScroll:10.0];
   [EEPROMScroller setAutohidesScrollers:NO];
   
   // **
   //EEPROMFeld.origin.y = positionY;
   NSArray* Wochentag=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
   NSRect EEPROMFeld=[EEPROMPlan frame];
   NSRect Kontrollzeilenrect = EEPROMFeld;
   Kontrollzeilenrect.size.height = 20;
   Kontrollzeilenrect.size.width = 400;

   Kontrollzeilenrect.origin.y = EEPROMFeld.size.height - 40;
   NSRect Radiorect = EEPROMFeld;
   if ([[[note userInfo]objectForKey:@"updatearray"]count]) // es hat geaenderte Daten
   {
      [FixTaste setEnabled:YES];
      //NSLog(@"EEPROMFeld origin.y: %.2f height %2.2F",EEPROMFeld.origin.y,EEPROMFeld.size.height);
      
      NSArray* UpdateArray = [[note userInfo]objectForKey:@"updatearray"];
      // keys: data: ByteArray   zeile: ByteString zeilennummer: zeilennummer auf eepromdaten.txt
      float offsetY = 100;
      NSRect newPlanrect =[EEPROMPlan frame];
      newPlanrect.size.height = [UpdateArray count] *1.0* offsetY;
      [EEPROMPlan setFrame:newPlanrect];

      float docH=[[EEPROMScroller documentView] frame].size.height;
      float contH=[[EEPROMScroller contentView] frame].size.height;
      
      //NSLog(@"RaumScroller documentView orig.y: %.2f contH: %.2f docH: %.2f",[[RaumScroller documentView] frame].origin.y,contH, docH);
		NSPoint   newRaumScrollOrigin=NSMakePoint(0.0,docH-contH);
      [[EEPROMScroller documentView] scrollPoint:newRaumScrollOrigin];
      
      float positionY = [EEPROMPlan frame].size.height - 40;
      //EEPROMFeld.origin.x +=10;
      EEPROMFeld.size.height = 30.0;
      EEPROMFeld.size.width -= 40.0;
      
      Kontrollzeilenrect.size.width -= 160;
      Kontrollzeilenrect.origin.x += 105;
      
      Radiorect.size.width = 50;
      Radiorect.size.height  = offsetY;
      
      Radiorect.origin.x  += EEPROMFeld.size.width-20;
      
      float distanzBalken = 36.0;
      float offsetKontrollzeile = 0;
      
      offsetY += 2* offsetKontrollzeile;
      

      for (int i=0;i< [UpdateArray count]; i++)
      {
         NSArray* tempZeilenArray = [[[UpdateArray objectAtIndex:i]objectForKey:@"zeile"]componentsSeparatedByString:@"\t"];
         
         //NSLog(@"tempZeilenArray: %@",[tempZeilenArray description]);
         int zeilennummer = [[tempZeilenArray objectAtIndex:0]intValue];

         int raumnummer = [[tempZeilenArray objectAtIndex:1]intValue];
         int objektnummer = [[tempZeilenArray objectAtIndex:2]intValue];
         int wochentag = [[tempZeilenArray objectAtIndex:3]intValue];
         //int hbyte = [[tempZeilenArray objectAtIndex:4]intValue];
         //int lbyte = [[tempZeilenArray objectAtIndex:5]intValue];
         int tagbalkentyp = [[tempZeilenArray objectAtIndex:14]intValue];
         //int permanent = [[tempZeilenArray objectAtIndex:15]intValue];
         //int zeitstempel = [[tempZeilenArray objectAtIndex:16]intValue];
         NSArray* tempObjektnamenArray = [[[[[HomebusArray objectAtIndex:raumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"];
         
         //NSLog(@"tempObjektnamenArray: %@",[tempObjektnamenArray description] );
         
          
         EEPROMFeld.origin.y = positionY - i*offsetY;
         Kontrollzeilenrect.origin.y = EEPROMFeld.origin.y - 22;
         Radiorect.origin.y = EEPROMFeld.origin.y - distanzBalken-28;
         
         NSButtonCell* radiozelle = [[NSButtonCell alloc]init];
         [radiozelle setTitle:@" "];
         [radiozelle setButtonType:NSRadioButton];
         [radiozelle setControlSize: NSMiniControlSize];
         
         
         NSMatrix* UpdateRadio = [[NSMatrix alloc ]initWithFrame:Radiorect
                                                            mode:NSRadioModeMatrix
                                                       prototype:(NSCell*)radiozelle
                                                    numberOfRows:2
                                                 numberOfColumns:1];
         [UpdateRadio setCellSize:NSMakeSize(20, distanzBalken + offsetKontrollzeile)];
         [UpdateRadio setTag:1000+zeilennummer];
         [UpdateRadio selectCellAtRow:0 column:0];
         
         
         //NSLog(@"EEPROMFeld i: %d origin.y: %.2f ",i,EEPROMFeld.origin.y);
         rEEPROMbalken* newEEPROMbalken=[[rEEPROMbalken alloc]initWithFrame:EEPROMFeld];
         [newEEPROMbalken BalkenAnlegen];
         [EEPROMPlan addSubview:newEEPROMbalken];
         [newEEPROMbalken setRaumString:[RaumPop itemTitleAtIndex:raumnummer]];
         [newEEPROMbalken setRaum:raumnummer];
         [newEEPROMbalken setTitel:[tempObjektnamenArray objectAtIndex:objektnummer]];
         [newEEPROMbalken setObjektString:[NSString stringWithFormat:@"%@_web",[tempObjektnamenArray objectAtIndex:objektnummer]]];
         [newEEPROMbalken setObjekt:[NSNumber numberWithInt:objektnummer]];
         [newEEPROMbalken setWochentagString:[Wochentag objectAtIndex:wochentag]];
         [newEEPROMbalken setWochentag:wochentag];
         [newEEPROMbalken setTagbalkenTyp:tagbalkentyp];
         [newEEPROMbalken setTag:2000+zeilennummer];
         
         //NSLog(@"i: %d, zeilennummer: %d",i,zeilennummer);
         NSArray* dataArray = [[[[note userInfo]objectForKey:@"updatearray"]objectAtIndex:i]objectForKey:@"data"];
         //NSLog(@"dataArray: %@",[dataArray description]);
          
         NSArray* dezstundenarray = [self StundenArrayAusDezArray:dataArray];
         //NSLog(@"dezstundenarray: %@",[dezstundenarray description]);
         
         [newEEPROMbalken setStundenArray:dezstundenarray forKey:@"code"];
         
         // Kontrollzeile neu
         NSTextField* KontrollzeilenFeld_n = [[NSTextField alloc]initWithFrame:Kontrollzeilenrect];
         [KontrollzeilenFeld_n setEditable:NO];
         //[EEPROMPlan addSubview:KontrollzeilenFeld_n];
         NSArray* KontrollByteArray = [[[[note userInfo]objectForKey:@"updatearray"]objectAtIndex:i]objectForKey:@"data"];
         //NSLog(@"i: %d KontrollByteArray: %@",i,[KontrollByteArray description]  );
         [KontrollzeilenFeld_n setStringValue:[[self StundenArrayAusDezArray:KontrollByteArray ] componentsJoinedByString:@"  "]];
         
         EEPROMFeld.origin.y -= distanzBalken + offsetKontrollzeile;
         Kontrollzeilenrect.origin.y = EEPROMFeld.origin.y - 22;
         
         NSDictionary* oldStundenplanDic = [self StundenplanDicVonRaum:raumnummer vonObjekt:objektnummer vonWochentag:wochentag];
         
         rEEPROMbalken* oldEEPROMbalken=[[rEEPROMbalken alloc]initWithFrame:EEPROMFeld];
         [oldEEPROMbalken BalkenAnlegen];
         [EEPROMPlan addSubview:oldEEPROMbalken];
         [oldEEPROMbalken setRaumString:[RaumPop itemTitleAtIndex:raumnummer]];
         [oldEEPROMbalken setRaum:raumnummer];
         [oldEEPROMbalken setObjektString:[NSString stringWithFormat:@"%@_Anzeige",[tempObjektnamenArray objectAtIndex:objektnummer]]];
         [oldEEPROMbalken setTitel:[tempObjektnamenArray objectAtIndex:objektnummer]];
         [oldEEPROMbalken setObjekt:[NSNumber numberWithInt:objektnummer]];

         [oldEEPROMbalken setWochentagString:[Wochentag objectAtIndex:wochentag]];
         [oldEEPROMbalken setWochentag:wochentag];

         [oldEEPROMbalken setTagbalkenTyp:tagbalkentyp];
         [oldEEPROMbalken setStundenArray:[oldStundenplanDic objectForKey:@"stundenplanarray"]forKey:@"code"];
         [oldEEPROMbalken setTag:4000+zeilennummer];
         
         // Kontrollzeile alt
         NSTextField* KontrollzeilenFeld_a = [[NSTextField alloc]initWithFrame:Kontrollzeilenrect];
         [KontrollzeilenFeld_a setEditable:NO];
        // [EEPROMPlan addSubview:KontrollzeilenFeld_a];
         
         [KontrollzeilenFeld_a setStringValue:[[oldStundenplanDic objectForKey:@"stundenplanarray"]componentsJoinedByString:@"  "]];
         [EEPROMPlan addSubview:UpdateRadio];
      }
      
      // Update der PList?
      //
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"PList anpassen"];
      [Warnung addButtonWithTitle:@"Ignorieren"];
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Neue Werte auf HomeServer"]];
      
      NSString* s1=@"PList anpassen?";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      int antwort=0;
      //antwort=[Warnung runModal];
      switch (antwort)
      {
         case NSAlertFirstButtonReturn://
         {
            NSLog(@"NSAlertFirstButtonReturn: PList anpassen");
            
         }break;
            
         case NSAlertSecondButtonReturn://
         {
            NSLog(@"NSAlertSecondButtonReturn: sein lassen");
            
         }break;
         case NSAlertThirdButtonReturn://
         {
            NSLog(@"NSAlertThirdButtonReturn");
            
         }break;
            
      }
      
   } // if count
   else
   {
      NSLog(@"Keine Daten fuer Update");
      [FixTaste setEnabled:NO];
      //NSTextField* KontrollzeilenFeld = [[NSTextField alloc]initWithFrame:Kontrollzeilenrect];
      //[KontrollzeilenFeld setEditable:NO];
      //[EEPROMPlan addSubview:KontrollzeilenFeld];
      //[KontrollzeilenFeld setStringValue:@"Keine Daten für Update"];
      [Ablauffeld setStringValue:@"Keine Daten für Update"];
   }
}

- (IBAction)reportFixTaste:(id)sender
{
   /*
    Stellt je nach Wert des Radiobuttons zwei Array zusammen
    
    PListFixArray: Daten vom Homeserver (und vom damit synchronisierten EEPROM) sollen in die PList geschrieben werden, Tagplanbalken soll neu gezeichnet werden.
    > updatePListMitDicArray
    
    
    HomeServerFixArray: Daten auf dem Homeserver werden verworfen, die urspruenglichen Daten aus der PList werden ins EEPROM und auf den Server geschrieben
    > updateEEPROMMitDicArray
    */
   
   NSLog(@"reportFixTaste");
   
   [writeEEPROMcounterfeld setStringValue:@""];
   
   
   NSArray* viewListe = [EEPROMPlan subviews];
   int newbalkenoffset=1000;
   int oldbalkenoffset=3000;
   NSMutableArray* PListFixArray = [[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* HomeServerFixArray = [[NSMutableArray alloc]initWithCapacity:0];
   NSString* AblaufString = @"Update für: ";
   if (viewListe && ([viewListe  count]))
   {
      for (int i=0;i<[viewListe count];i++)
      {
         if (([[viewListe objectAtIndex:i] isKindOfClass:[rTagplanbalken class]]) || ([[viewListe objectAtIndex:i] isKindOfClass:[NSMatrix class]]))
         {
            //NSLog(@"i: %d view: %@ tag: %d",i,[[viewListe objectAtIndex:i]description], [[viewListe objectAtIndex:i]tag]);
            rTagplanbalken* tempbalken =[viewListe objectAtIndex:i];
            NSInteger tempTag = tempbalken.tag;
            
            if (tempTag < 2000)
               if ([EEPROMPlan  viewWithTag:tempTag]) // Radiobutton
               {
                  int wahl = [[EEPROMPlan  viewWithTag:tempTag]selectedRow];
                  //NSLog(@"i: %d radiotag: %d wahl: %d",i,tempTag,wahl);
                  switch (wahl)
                  {
                     case 0:
                     {
                        if ([EEPROMPlan  viewWithTag:tempTag+newbalkenoffset])
                        {
                           
                           rEEPROMbalken* tempBalken = (rEEPROMbalken* )[EEPROMPlan  viewWithTag:tempTag+newbalkenoffset];
                           //NSLog(@"Balken neu raum: %d",[tempBalken Raum]);
                           //NSLog(@"Balken neu raum: %d StundenArray: %@",[tempBalken Raum], [[[tempBalken StundenArray]valueForKey:@"code"] description]);
                           NSMutableDictionary* UpdateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                           NSMutableArray* tempstundenplanarray = (NSMutableArray*)[[tempBalken StundenArray]valueForKey:@"code"];
                           [UpdateDic setObject:tempstundenplanarray forKey:@"stundenplanarray"];
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken raum]] forKey:@"raum"];
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken wochentag]] forKey:@"wochentag"];
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken objekt]] forKey:@"objekt"];
                           //NSLog(@"Titel: %@ ",[tempBalken Titel]);
                           AblaufString = [AblaufString stringByAppendingFormat:@"r:%d wt:%d o:%d ",[tempBalken raum],[tempBalken wochentag],[tempBalken objekt]];
                           
                           if ([PListFixArray count]<2)
                           {
                              //NSLog(@"PList UpdateDic: %@",[UpdateDic description]);
                           }
                           [PListFixArray addObject:UpdateDic];
                           
                           
                        }
                     }break;
                     case 1: // Anzeige  in EEPROm uebernehmen
                     {
                        if ([EEPROMPlan  viewWithTag:tempTag+oldbalkenoffset])
                        {
                           rEEPROMbalken* tempBalken = (rEEPROMbalken* )[EEPROMPlan  viewWithTag:tempTag+oldbalkenoffset];
                           //NSLog(@"Balken alt raum: %d StundenArray: %@",[tempBalken Raum], [[[tempBalken StundenArray]valueForKey:@"code"] description]);
                           NSMutableDictionary* UpdateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                           [UpdateDic setObject:[[tempBalken StundenArray]valueForKey:@"code"] forKey:@"stundenarray"];
                           
                           
                           [UpdateDic setObject:[tempBalken StundenByteArray] forKey:@"stundenbytearray"];
                           //NSLog(@"HomeServer stundenbytearray: %@",[[tempBalken StundenByteArray] description]);
                            uint16_t startadresse=[tempBalken Raum]*RAUMPLANBREITE + [tempBalken Objekt]*TAGPLANBREITE + [tempBalken Wochentag]*0x08;
                           
                           int lbyte=startadresse<<8;
                           lbyte &= 0xff00;
                           lbyte >>=8;
                           int hbyte=startadresse>>8;
                           
                           NSLog(@"Titel: %@ startadresse: %x lbyte: %x hbyte; %x",[tempBalken Titel],startadresse, lbyte,hbyte);
                           
                           
                           
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken Raum]] forKey:@"raum"];
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken Wochentag]] forKey:@"wochentag"];
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken Objekt]] forKey:@"objekt"];
                           [UpdateDic setObject:[tempBalken Titel] forKey:@"titel"];
                           
                           [UpdateDic setObject:[NSNumber numberWithInt:lbyte] forKey:@"lbyte"];
                           [UpdateDic setObject:[NSNumber numberWithInt:hbyte] forKey:@"hbyte"];
                           
                           [UpdateDic setObject:[NSNumber numberWithInt:[tempBalken tagbalkentyp]] forKey:@"tagbalkentyp"];
                           [UpdateDic setObject:@"A0" forKey:@"eepromadressestring"];
                           [UpdateDic setObject:@"160" forKey:@"eepromadresse"];
                           [UpdateDic setObject:[NSNumber numberWithInt:0] forKey:@"eepromadressezusatz"];
                           [UpdateDic setObject:[NSNumber numberWithInt:1] forKey:@"permanent"];
                           [UpdateDic setObject:[NSNumber numberWithInt:0] forKey:@"mod"];
                           
                           
                           if ([HomeServerFixArray count]<2)
                           {
                              
                              //NSLog(@"HomeServer UpdateDic: %@",[UpdateDic description]);
                           }
                           
                           
                           [HomeServerFixArray addObject:UpdateDic];
                           
                        }
                        
                     }break;
                        
                        
                  }// switch
                  
                  
                  /*
                   if ([EEPROMPlan  viewWithTag:tempTag+newbalkenoffset])
                   {
                   rEEPROMbalken* tempBalken = (rEEPROMbalken* )[EEPROMPlan  viewWithTag:tempTag+newbalkenoffset];
                   NSLog(@"Balken neu raum: %d StundenArray: %@",[tempBalken Raum], [[[tempBalken StundenArray]valueForKey:@"code"] description]);
                   if ([EEPROMPlan  viewWithTag:tempTag+oldbalkenoffset])
                   {
                   rEEPROMbalken* tempBalken = (rEEPROMbalken* )[EEPROMPlan  viewWithTag:tempTag+oldbalkenoffset];
                   NSLog(@"Balken alt raum: %d StundenArray: %@",[tempBalken Raum], [[[tempBalken StundenArray]valueForKey:@"code"] description]);
                   
                   }
                   
                   }
                   */
               }
         }
      }
      //[self updateEEPROMMitDicArray:PListFixArray];
      NSLog(@"PListFixArray count: %u",(unsigned int)[PListFixArray count]);
      NSLog(@"PListFixArray: %@",[PListFixArray description]);

      NSLog(@"HomeServerFixArray count: %u",(unsigned int)[HomeServerFixArray count]);
 //     NSLog(@"HomeServerFixArray: %@",[HomeServerFixArray description]);
      
      if ([PListFixArray count])
      {
         NSLog(@"PListFixArray count: %u",(unsigned int)[PListFixArray count]);
         
         // PList synch mit Daten im EEPROM und auf HomeServer, Anzeige updaten
         [self updatePListMitDicArray:PListFixArray];
         [Ablauffeld setStringValue:AblaufString];
         // Aufraeumen
         NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
         for(NSView* thisPage in [EEPROMPlan subviews])
         {
            //get all the ads on this page
            //NSArray* thisPageSubviews = [thisPage subviews];
            //for(NSView* thisPageSubview in thisPageSubviews)
            //   if ([thisPageSubview isMemberOfClass:[rTagplanbalken class]])
               //{
                  //[viewsToRemove addObject:thisPageSubview];
               //}
            //NSLog(@"Tagplanbalken weg");
            [viewsToRemove addObject:thisPage];
         }
         [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [EEPROMPlan setNeedsDisplay:YES];
         [PListFixArray removeAllObjects];
         
      }
      
      if ([HomeServerFixArray count])
      {
         NSLog(@"HomeServerFixArray count: %u",(unsigned int)[HomeServerFixArray count]);
         
         
         //
         if ([TWIStatusTaste state])
          {
          //NSLog(@"TWIStatustaste: %d",[TWIStatusTaste state]);
          NSAlert *Warnung = [[NSAlert alloc] init];
          [Warnung addButtonWithTitle:@"OK"];
          //	[Warnung addButtonWithTitle:@""];
          //	[Warnung addButtonWithTitle:@""];
          //	[Warnung addButtonWithTitle:@"Abbrechen"];
          [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Homebus aktiv!"]];
          
          NSString* s1=@"Der Homebus muss deaktiviert sein, um auf das EEPROM zu schreiben.";
          NSString* s2=@"Quelle: Fixtaste";
          NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
          [Warnung setInformativeText:InformationString];
          [Warnung setAlertStyle:NSWarningAlertStyle];
          
          int antwort=[Warnung runModal];
          return;
          }
         
         
         //
         
         [UpdateWaitrad startAnimation:NULL];
         [self updateEEPROMMitDicArray:HomeServerFixArray];
         
         /*
         // Aufraeumen
         NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
         for(NSView* thisPage in [EEPROMPlan subviews])
         {
            //get all the ads on this page
            //NSArray* thisPageSubviews = [thisPage subviews];
            //for(NSView* thisPageSubview in thisPageSubviews)
            //   if ([thisPageSubview isMemberOfClass:[rTagplanbalken class]])
            //{
            //[viewsToRemove addObject:thisPageSubview];
            //}
            //NSLog(@"Tagplanbalken weg");
            [viewsToRemove addObject:thisPage];
         }
         [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [viewsToRemove release];
         [EEPROMPlan setNeedsDisplay:YES];
         [HomeServerFixArray removeAllObjects];
          */
      }
      
      
      // eepromupdate.txt ueberschreiben
      //"EEPROMUpdateClear"
      // in WriteFertig verschoben
 //     NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
 //     [NotificationDic setObject:[NSNumber numberWithInt:13] forKey:@"perm"];
      
 //     NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
//      [nc postNotificationName:@"EEPROMUpdateClear" object:self userInfo:NotificationDic];
   }
   
   
   
   /*
   NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
   for(NSView* thisPage in [EEPROMPlan subviews])
   {
      //get all the ads on this page
      //NSArray* thisPageSubviews = [thisPage subviews];
      //for(NSView* thisPageSubview in thisPageSubviews)
      //   if ([thisPageSubview isMemberOfClass:[rTagplanbalken class]])
      //{
      //[viewsToRemove addObject:thisPageSubview];
      //}
      //NSLog(@"Tagplanbalken weg");
      [viewsToRemove addObject:thisPage];
   }
   [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
   [viewsToRemove release];
   [EEPROMPlan setNeedsDisplay:YES];
*/
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

- (void)setReadOK
{
   [[NSSound soundNamed:@"Glass"] play];
   [Waitrad stopAnimation:NULL];
   [AdresseFeld setStringValue:@""];
   [WriteFeld setStringValue:@""];
   [ReadFeld setStringValue:@""];
   [WriteWocheFeld setStringValue:@""];
   //NSLog(@"FinishLoadAktion  status0+ ist da: TWI_Status: %d",TWI_Status);
   [StatusFeld setStringValue:@"Kontakt mit HomeCentral hergestellt"];// TWI erfolgreich deaktiviert
   [PWFeld setStringValue:@"OK"];
   [readTagTaste setEnabled:1];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
   [readWocheTaste setEnabled:YES];
   [writeWocheTaste setEnabled:YES];
   Webserver_busy =0;

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
    //[Waitrad  stopAnimation:NULL];
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
            NSLog(@"FinishLoadAktion Kontakt beendet");
				
            
           [[NSSound soundNamed:@"Ping"] play];
            [Waitrad stopAnimation:NULL];
            [UpdateWaitrad stopAnimation:NULL];
            
            
            WebTask=idle; // nichts tun
				[StatusFeld setStringValue:@"Kontakt mit HomeCentral beendet"]; // TWI wieder aktiviert
				[readTagTaste setEnabled:0];// TWI-Status ON, EEPROM gesperrt
            [readWocheTaste setEnabled:NO];
            [writeWocheTaste setEnabled:NO];

				[PWFeld setStringValue:@""];
            [TWIStatusTaste setState:1];
            
            if ([EEPROMReadDataArray count])
            {
               //NSLog(@"EEPROMReadDataArray: %@",[EEPROMReadDataArray description]);
            }
            WebTask = idle;
				//[AdresseFeld setStringValue:@""];
				//[WriteFeld setStringValue:@""];
				//[ReadFeld setStringValue:@""];
				
            if (TWI_ON_Flag)
            {
               NSLog(@"FinishLoadAktion Kontakt beendet TWI_ON_Flag 1 ");
               [self setTWIState:1];
               TWI_ON_Flag=0;
            }
            
				
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
            //NSLog(@"FinishLoadAktion Status 0 OK beep");
				//NSBeep();
            [self performSelector:@selector(setReadOK) withObject:nil afterDelay:4];
            
				TWI_Status=0;
				/*
            [AdresseFeld setStringValue:@""];
				[WriteFeld setStringValue:@""];
				[ReadFeld setStringValue:@""];
				[WriteWocheFeld setStringValue:@""];
				//NSLog(@"FinishLoadAktion  status0+ ist da: TWI_Status: %d",TWI_Status);
				[StatusFeld setStringValue:@"Kontakt mit HomeCentral hergestellt"];// TWI erfolgreich deaktiviert
				[PWFeld setStringValue:@"OK"];
				[readTagTaste setEnabled:1];// TWI-Status muss OFF sein, um EEPROM lesen zu koennen
				Webserver_busy =0;
             */
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
      
      
      
		// Adresse fuer Lesen angekommen?
		if ([[note userInfo]objectForKey:@"radrok"]) 
		{
			Adresse_OK=[[[note userInfo]objectForKey:@"radrok"]intValue];
			// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
			
			//NSLog(@"FinishLoadAktion read EEPROM: radrok ist da: %d TWI_Status: %d",Adresse_OK,TWI_Status);
			if ((TWI_Status==0)&&Adresse_OK)// Passwort OK
			{
				//NSLog(@"radrok ist da");
				[AdresseFeld setStringValue:@"OK"];
				[StatusFeld setStringValue:@"EEPROM-Adresse angekommen"];
				
				// Request fuer Data schicken
				
				NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"rdata"];
            if ([[note userInfo]objectForKey:@"webtask"])
            {
               [NotificationDic setObject:[[note userInfo]objectForKey:@"webtask"] forKey:@"webtask"];
            }
				
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
#pragma mark writeok
		if ([[note userInfo]objectForKey:@"writeok"])
		{
			
			Write_OK=[[[note userInfo]objectForKey:@"writeok"]intValue];
			// Anzeigen, dass die EEPROM-Adresse erfolgreich uebertragen wurde: 
			//Webserver_busy =0;
			//NSLog(@"FinishLoadAktion  writeok ist da: %d",Write_OK);
			if ((TWI_Status==0)&&Write_OK)// Passwort OK
			{
				//NSLog(@"FinishLoadAktion Write und Passwort OK beep");
				//NSBeep();
				[WriteFeld setStringValue:@"OK"];
            [[NSSound soundNamed:@"Tink"] play];
				[StatusFeld setStringValue:@"EEPROM-Daten geschrieben"];
				Webserver_busy =0;
            if (TWI_ON_Flag)
            {
               //NSLog(@"FinishLoadAktion Write und TWI_Flag 1");
               [self setTWIState:1];
               TWI_ON_Flag=0;
            }
				
			}
			else 
			{
				//[WriteFeld setStringValue:@""];
				//[StatusFeld setStringValue:@"EEPROM-Daten nicht geschrieben"];
				
			}
			
		} // writeok
		
      
      // taskok
      
      if ([[note userInfo]objectForKey:@"taskok"])
      {
         
         int task_OK=[[[note userInfo]objectForKey:@"taskok"]intValue];
         // Anzeigen, dass der Master-Reset erfolgreich uebertragen wurde:
         //Webserver_busy =0;
         //NSLog(@"FinishLoadAktion  taskok ist da: %d",task_OK);
         if (task_OK)// Passwort OK
         {
            //NSLog(@"FinishLoadAktion  task Passwort OK beep");
            NSBeep();
            //[WriteFeld setStringValue:@"OK"];
            //[[NSSound soundNamed:@"Tink"] play];
            [StatusFeld setStringValue:@"Master-Reset OK"];
            
         }
         else
         {
            //[WriteFeld setStringValue:@""];
            //[StatusFeld setStringValue:@"EEPROM-Daten nicht geschrieben"];
            
         }
         
      }
      
      
	} // if okcode
	
	NSArray* EEPROMDataArray;
	if ([[note userInfo]objectForKey:@"data"]) 
	{
		Data_OK=[[[note userInfo]objectForKey:@"data"]intValue];
		// Anzeigen, dass die daten erfolgreich uebertragen wurde: 
		if ((TWI_Status==0)&&Data_OK)// Data OK
		{
			//NSLog(@"FinishLoadAktion EEPROM lesen: data ist da");
			[[NSSound soundNamed:@"Tink"] play];
         
			[ReadFeld setStringValue:@"OK"];
			[StatusFeld setStringValue:@"Daten angekommen"];
			if ([[note userInfo]objectForKey:@"eepromdatastring"])
			{
				//	[StatusFeld setStringValue:[[note userInfo]objectForKey:@"eepromdatastring"]];
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
               //NSLog(@"FinishLoadAktion WebTask: %d wochentagindex: %d  DataString: %@",WebTask, wochentagindex, DataString);
					[Cmd setStringValue:DataString];
					[EEPROMbalken setStundenArrayAusByteArray:EEPROMDataArray];
					[EEPROMbalken setWochentagString:[TagPop titleOfSelectedItem]];
					[EEPROMbalken setRaumString:[RaumPop titleOfSelectedItem]];
					[EEPROMbalken setObjektString:[ObjektPop titleOfSelectedItem]];
               
               if (WebTask == eepromreadwoche)
               {
                  [EEPROMReadDataArray addObject:[DataString lowercaseString]];
               }
               else
               {
                  NSLog(@"FinishLoadAktion DataString: %@",DataString);
               }
               
					Webserver_busy=0;
					[readTagTaste setEnabled:YES];
               [readWocheTaste setEnabled:YES];
               
				}
			
         
         
         }
			NSMutableDictionary* finishLoadTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[finishLoadTimerDic setObject:@"Read Data OK" forKey:@"timertext"];
         [finishLoadTimerDic setObject:[NSNumber numberWithInt:WebTask] forKey:@"webtask"];
         [finishLoadTimerDic setObject:[NSNumber numberWithInt:wochentagindex] forKey:@"wochentagindex"];
			
         
         //NSLog(@"TimeoutTimer start");
         
         //if ([TimeoutTimer isValid])
         {
            [TimeoutTimer invalidate];
            TimeoutTimer=nil;
         }
         
         if (WebTask == eepromreadwoche) // Fortsetzung einleiten
         {
            // 4 sekunden notwendig, da WebServer viel Zeit braucht, um die Daten aus dem EEPROM zu laden
			TimeoutTimer=[NSTimer scheduledTimerWithTimeInterval:4
																		  target:self 
																		selector:@selector(TimeoutTimerFunktion:) 
																		userInfo:finishLoadTimerDic 
																		 repeats:NO];
			}
         
	//		[self sendEEPROMData:(NSString*) dataString anAdresse:(NSString*)adresseString];
         
		}
		else 
		{
			//[ReadFeld setStringValue:@""];
			//[StatusFeld setStringValue:@"Daten nicht angekommen"];
			
		}
		
		
	} // if data
	
	
	int Error_OK=0;
	if ([[note userInfo]objectForKey:@"error"]) 
	{
		NSLog(@"FinishLoadAktion error");
      [Waitrad stopAnimation:NULL];
      [UpdateWaitrad stopAnimation:NULL];
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
   
   if ([[note userInfo]objectForKey:@"eepromupdate"])
   {
      [Errorfeld setStringValue:[[note userInfo]objectForKey:@"eepromupdate"]];
   }
   
   if ([[note userInfo]objectForKey:@"provurl"]) // fail
   {
      [Errorfeld setStringValue:[[note userInfo]objectForKey:@"provurl"]];
   }

}


- (void)webView:(WebView *)sender
didCommitLoadForFrame:(WebFrame *)frame
{
   NSLog(@"didCommitLoadForFrame: %@",[frame description]);
}


- (void)LoadFailAktion:(NSNotification*)note
{
	NSLog(@"LoadFailAktion: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"error"])
	{
		NSLog(@"LoadFailAktion  error: %@",[[note userInfo]objectForKey:@"error"]);
	}
	
	NSAlert *Warnung = [[NSAlert alloc] init];
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
	//NSLog(@"TimeoutTimerFunktion : %@",[[timer userInfo]description]);
   
   
   if (WebTask == eepromreadwoche)
   {
         //if ([[timer userInfo]objectForKey:@"wochentagindex"])
         {
            //wochentagindex = [[[timer userInfo]objectForKey:@"wochentagindex"]intValue];
            wochentagindex++;
            if (wochentagindex < 7)
            {
               [self readEthTagplanVonRaum:[RaumPop indexOfSelectedItem] vonObjekt:[ObjektPop indexOfSelectedItem] vonTag:wochentagindex];

               //[self readEthTagplanVonTag:wochentagindex];
            }
            else
            {
               NSLog(@"Woche fertig: %@",[EEPROMReadDataArray description]);
            }
         }
            
   }
      
      
   
  
	if ([[timer userInfo]objectForKey:@"timertext"])
	{
		NSAlert *Warnung = [[NSAlert alloc] init];
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
	
	//NSLog(@"AVR setWEBDATAArray: %@",[derDatenArray description]);
	
	[WEBDATA_DS setValueKeyArray:derDatenArray];
	[WEBDATATable reloadData];
}

- (int)WriteWoche_busy
{
return WriteWoche_busy;
}

- (void)stundenplanzeigen:(NSArray*)stundenplan
{
   printf("wert: \t");
   for (int k=0;k<24;k++)
   {
      printf(" %d\t",[[stundenplan objectAtIndex:k]intValue]);
   }
   printf("\n");
   
}

@end

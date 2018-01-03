//
//  rAVR.h
//  USBInterface
//
//  Created by Sysadmin on 01.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rAVR_DS.h"
#import "rDump_DS.h"

#import "rWEBDATA_DS.h"

//#import "rHeizungTagplanbalken.h"
//#import "rWerkstattplan.h"
#import "rTagplan.h"
#import "rTagplanbalken.h"
#import "rServoTagplanbalken.h"
#import "rEEPROMbalken.h"
#import "rDatenbalken.h"
#import "rWochenplan.h"
#import "datum.c"
#import "version.c"
#import "defines.h"


#define RAUMOFFSET			1000
#define WOCHENPLANOFFSET	2000
#define TAGPLANOFFSET		3000

#define SLAVE_ADRESSE 0x50
#define DCF77_ADRESSE 0x54
#define HEIZUNG_ADRESSE 0x56
#define ESTRICH_ADRESSE 0x58
#define LABOR_ADRESSE 0x60

//enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;


@interface rAVR : NSWindowController <NSTabViewDelegate, NSFileManagerDelegate,NSTableViewDataSource,NSTableViewDelegate>
{
IBOutlet	id		WochenplanTab;
IBOutlet	id		HeizungFeld;
IBOutlet	id		WerkstattFeld;
IBOutlet	id		WoZiFeld;
IBOutlet	id		BueroFeld;
IBOutlet	id		LaborFeld;
IBOutlet	id		OG1Feld;
IBOutlet	id		OG2Feld;
IBOutlet	id		EstrichFeld;
IBOutlet	id		WochenplanTable;
IBOutlet	id		TagPop;
IBOutlet	id		I2CPop;
IBOutlet	id		Adresse;
IBOutlet	id		Cmd;
IBOutlet	id		EEPROMReadTaste;
IBOutlet	id		TWIStatusTaste;
IBOutlet	id		LocalTaste;
IBOutlet	id		TestTaste;
IBOutlet	id		LoadTestTaste;
   

// Web
IBOutlet	id		readTagTaste;
IBOutlet	id		readWocheTaste;
IBOutlet	id		StatusFeld;
IBOutlet	id		PWFeld;
IBOutlet	id		AdresseFeld;
IBOutlet	id		ReadFeld;
IBOutlet	id		WriteFeld;
IBOutlet	id		WriteWocheFeld;
IBOutlet	id		writeWocheTaste;
IBOutlet	id		UpdateTaste;
   
IBOutlet	id		Waitrad;
   
IBOutlet	NSProgressIndicator*		UpdateWaitrad;

IBOutlet	id					VersionFeld;
IBOutlet	id					DatumFeld;



rEEPROMbalken*				EEPROMbalken;
rDump_DS*					Dump_DS;


 
NSMutableArray*			Wochenplan;
NSMutableDictionary*		WochenplanDic;
NSMutableArray*			WochenplanListe;
NSMutableDictionary*		HomeDic;
NSMutableArray*			HomebusArray;
NSString*					HomedataPfad;
NSString*					HomePListPfad;
NSMutableArray*			EEPROMArray;
NSMutableArray*			EEPROMTabelle;
IBOutlet	NSTableView*	EEPROMTable;

NSTimer*						IOWTimer;
NSMutableArray*			Eingangsdaten;
int							AnzahlDaten;
int							n;
int							aktuellerTag;
int							IOW_busy;
rAVR_DS*						AVR_DS;
long							aktuelleMark;


IBOutlet NSPopUpButton* ObjektPop;
IBOutlet	NSPopUpButton* RaumPop;
int							WebTask;          // Auszuführende Aktion aufgrund von Web-Requests
int							Webserver_busy;
int							WriteWoche_busy;
   
   int                  wochentagindex;   // wochentag, fuer den Daten bearbeitet werden
NSMutableArray*			EEPROMReadDataArray;

NSMutableArray*			WEBDATATabelle;

   
IBOutlet	NSTableView*	WEBDATATable;
rWEBDATA_DS*				WEBDATA_DS;

uint8_t                 daySettingArray[8][16]; // 1 Zeile pro Tag, 4 bytes code, 6 bytes Data 
   NSMutableArray *daySettingStringArray; // NSArray fuer daysettings
   NSMutableData*          SettingData;  
NSString*               HomeDaySettingPfad;   
/*
 byte 0: raum | objekt
 byte 1: wochentag | code: aktuell: bit0, delete: bit7
 
 
 */
volatile uint8_t lastwd;
   
//Simulation DataTransfer
IBOutlet	 id            maxSimAnzahlFeld;
NSTimer*                simTimer;
NSTimer*                TimeoutTimer;
   
NSTimer*                EEPROMUpdateTimer;
   
   
   

   IBOutlet id             EEPROMUpdatefeld;
   IBOutlet NSView*        EEPROMPlan;
   IBOutlet id             EEPROMScroller;
   IBOutlet id             EEPROMTextfeld;
   IBOutlet id             FixTaste;
   
   IBOutlet id             Errorfeld;
   IBOutlet id             Ablauffeld;
   int                     TWI_ON_Flag;
   IBOutlet id             writeEEPROMcounterfeld;
   int                     writeEEPROMcounter;
   int                     loadstatus;
   
   BOOL                    localNetz; // lokales Netzwerk benutzen
   
   IBOutlet NSTextField*   busycountfeld;
   
   IBOutlet NSLevelIndicator* writeEEPROManzeige;

}

- (uint8_t)freeDaySettingline;
- (NSArray*)daySettingDataVon:(uint8_t)raum vonObjekt:(uint8_t)objekt anWochentag:(uint8_t)wochentag;


- (void)setLocalStatus;
- (NSArray*)StundenArrayAusByteArray:(NSArray*)derStundenByteArray;
- (NSArray*)StundenArrayAusDezArray:(NSArray*)derStundenByteArray;
- (void)HomebusAnlegen;
- (void)setRaum:(int)derRaum;
- (void)saveLabel:(NSString*)dasLabel forRaum:(int)derRaum forSegment:(int)dasSegment;
- (void)checkHomebus;
- (NSArray*)neuerWochenplanForRaum:(int)derRaum;
- (NSArray*)neuerTagplanForTag:(int)derWochentag forRaum:(int)derRaum;
- (NSMutableArray*)neuerStundenplan;
- (int)anzAktivForRaum:(int)derRaum;
- (NSArray*)aktivObjekteArrayForRaum:(int)derRaum;
- (void)setAktiv:(int)derStatus forObjekt:(int)dasObjekt forRaum:(int)derRaum;
- (void)setTagbalkenTyp:(int)derTyp forObjekt:(int)dasObjekt forRaum:(int)derRaum;
- (void)setObjektTitel:(NSString*)derTitel forObjekt:(int)dasObjekt forRaum:(int)derRaum;
- (void)setObjektTitelVonRaum:(int)raumnummer;
- (void)setSegmentLabel:(NSString*)derTitel forSegment:(int)dasSegment forRaum:(int)derRaum;
- (void)setStundenplanArray:(NSArray*)derStundenplanArray forObjekt:(int)dasObjekt forRaum:(int)derRaum;
- (void)setStundenplanArray:(NSArray*)derStundenplanArray forWochentag:(int)derWochentag forObjekt:(int)dasObjekt forRaum:(int)derRaum;

- (NSDictionary*)StundenplanDicVonRaum:(int)raum vonObjekt:(int)objekt vonWochentag:(int)wochentag;
- (NSScrollView*)ScrollerVonRaum:(int)raum;


- (int)saveHomeDic;
- (NSArray*)HomebusArray;

//- (void)setTWIStatus:(int)derStatus;
- (void)setI2CStatus:(int)derStatus;
//- (void)writeTagplan:(id)sender;
//- (void)setWochenplan:(NSArray*) derWochenplan;
- (IBAction)sendCmd:(id)sender;
- (int)sendCmd:(NSString*)derBefehl mitDaten:(NSArray*)dieDaten;
- (int)sendData:(NSArray*)dieDaten;
- (IBAction)readTagplan:(id)sender;
- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;
//- (void)readEthTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;


- (IBAction)writeWochenplan:(id)sender;

- (IBAction)readEEPROM:(id)sender;
- (void)readEEPROM:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;
- (int)writeEEPROM:(int)i2cAdresse anAdresse:(int)startAdresse mitDaten:(NSArray*)dieDaten;
- (IBAction)clearEEPROMTabelle:(id)sender;
- (NSString*)IntToBin:(int)dieZahl;
- (void)readAVRSlave:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;
- (IBAction)readAVRSlave:(id)sender;
- (int)WriteWoche_busy;

- (IBAction)reportRaumPop:(id)sender;
- (IBAction)reportObjektPop:(id)sender;



- (BOOL)windowShouldClose:(id)sender;
@end

@interface rAVR(rAVRClient)
- (IBAction)readEthTagplan:(id)sender;
- (void)readEthTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;

- (void)readEthTagplanVonTag:(int)wochentag;
- (void)readEthTagplanVonRaum:(int)raum vonObjekt: (int)objekt vonTag:(int)wochentag;
- (IBAction)readWochenplan:(id)sender;
- (IBAction)writeEEPROMWochenplan:(id)sender;
- (void)setWEBDATAArray:(NSArray*)derDatenArray;
- (IBAction)reportTWIState:(id)sender;
- (void)setTWITaste:(int)status;
- (void)setTWIState:(int)status;
- (int)TWIStatus;
- (IBAction)reportLocalTaste:(id)sender;
- (IBAction)reportUpdateTaste:(id)sender;
- (IBAction)reportTestTaste:(id)sender;
- (IBAction)reportLoadTestTaste:(id)sender;
- (IBAction)reportFixTaste:(id)sender;
- (void)updateEEPROMMitDicArray:(NSArray*)updateArry;
- (void)updatePListMitDicArray:(NSArray*)updateArry;
- (void)stundenplanzeigen:(NSArray*)stundenplan;
@end

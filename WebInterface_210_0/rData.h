//
//  rData.h
//  WebInterface
//
//  Created by Sysadmin on 06.02.09.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rData_DS.h"
#import "rHeizungplan.h"
#import "rWerkstattplan.h"
#import "rMehrkanalDiagramm.h"
#import "rTemperaturMKDiagramm.h"
#import "rEinschaltDiagramm.h"
#import "rOrdinate.h"
#import "rDiagrammGitterlinien.h"
#import "rTagGitterlinien.h"
#import "rStatistikDiagramm.h"
#import "rBrennerStatistikDiagramm.h"
#import "rSolarDiagramm.h"
#import "rSolarEinschaltDiagramm.h"
#import "rSolarStatistikDiagramm.h"
#import "datum.c"
#import "version.c"


#import <WebKit/WebKit.h>
@class WebDownload;


@interface rData : NSWindowController 
{
IBOutlet	id				DatenplanTab;

IBOutlet	id				DatenplanTable;
IBOutlet	id				TagPop;
IBOutlet	id				I2CPop;
IBOutlet	id				Adresse;
IBOutlet	id				Cmd;

IBOutlet	id				SuchDatumFeld;
IBOutlet	id				SuchenTaste;


NSMutableArray*		Datenplan;
NSMutableArray*		DatenArray;
NSMutableArray*		DumpArray;
NSTimer*					IOWTimer;
NSMutableArray*		Eingangsdaten;
int						AnzahlDaten;
int						n;	
int						aktuellerTag;
int						IOW_busy;
rData_DS*					Data_DS;
NSArray*						Raumnamen;
NSMutableDictionary*		TemperaturDaten;
IBOutlet	id					TemperaturDiagrammScroller;
rTemperaturMKDiagramm*	TemperaturMKDiagramm;

rOrdinate*					TemperaturOrdinate;
rEinschaltDiagramm*		BrennerDiagramm;

rLegende*					BrennerLegende;
rDiagrammGitterlinien*	Gitterlinien;

rOrdinate*					TemperaturStatistikOrdinate;
rTagGitterlinien*			TagGitterlinien;
int							TemperaturNullpunkt;


IBOutlet	id					HistoryView;
IBOutlet	id					HistoryScroller;

rEinschaltDiagramm*			HistoryBrennerDiagramm;
rDiagrammGitterlinien*	HistoryGitterlinien;
rTemperaturMKDiagramm*	HistoryTemperaturMKDiagramm;



int							Scrollermass;

NSMutableArray*			GesamtDatenArray;
NSMutableArray*			DatenpaketArray;
int							AnzReports;
int							ReportErrIndex;
int							ErrZuLang;
int							ErrZuKurz;
int							AnzDaten;
int							par;
//int							oldHour;


IBOutlet	id				ErrZuLangFeld;
IBOutlet	id				ErrZuKurzFeld;
IBOutlet	id				AnzahlDatenFeld;
IBOutlet	id				StartTaste;
IBOutlet	id				StopTaste;
IBOutlet	id				ClearTaste;
IBOutlet	id				ZeitKompressionTaste;
float						ZeitKompression;
NSDate*					start;
NSDate*					LaunchZeit;
NSCalendarDate*		DatenserieStartZeit;
NSCalendarDate*		SimDatenserieStartZeit;
int						simDaySaved;
NSMutableString*		TemperaturZeilenString;
IBOutlet	id				TemperaturWertFeld;
IBOutlet	id				TemperaturDatenFeld;
IBOutlet	id				BrenndauerFeld;
IBOutlet	id				LaufzeitFeld;
IBOutlet	id				StartzeitFeld;
IBOutlet	id				ParFeld;
IBOutlet	id				IOWFehlerLog;
int						SimRun;
NSTextView*				DruckDatenView;
int						SerieSize;
NSString*				errPfad;
NSString*				errString;
int						Quelle;
NSTimer*					SimTimer;

IBOutlet NSDatePicker *Kalender;
int						Kalenderblocker;
int						Heuteblocker;

NSString*				LogString;

IBOutlet id				LoadMark;
IBOutlet id				DatumFeld;
IBOutlet id				VersionFeld;
IBOutlet id				LastDataFeld;
IBOutlet id				LastDatazeitFeld;
IBOutlet id				LoadtimeFeld;
IBOutlet id				ZaehlerFeld;
int						LastLoadzeit;
   
IBOutlet id				IPFeld;
   
   
int						anzLoads;
IBOutlet WebView *	webView;
NSURL *					URLToLoad;
NSString *				frameStatus;
	 
	 
// BrennerTab
IBOutlet id				StatistikDiagrammFeld;
IBOutlet	id				StatistikDiagrammScroller;
IBOutlet	id				StatistikJahrPop;
IBOutlet	id				StatistikMonatPop;

// StatistikTab
rStatistikDiagramm*				TemperaturStatistikDiagramm;
rLegende*							StatistikLegende;

rBrennerStatistikDiagramm*		BrennerStatistikDiagramm;
rOrdinate*							BrennerStatistikOrdinate;
rLegende*							BrennerStatistikLegende;


// SolarTab
IBOutlet id							SolarDiagrammScroller;
rSolarDiagramm*					SolarDiagramm;
rDiagrammGitterlinien*			SolarGitterlinien;
rSolarEinschaltDiagramm*		SolarEinschaltDiagramm;
rLegende*							EinschaltLegende;
IBOutlet id							SolarDatenFeld;
IBOutlet id							LastSolarDataFeld;
IBOutlet id							LastSolarDatazeitFeld;
rOrdinate*							SolarOrdinate;
int									LastSolarLoadzeit;
int									AnzSolarDaten;
int									anzSolarLoads;
IBOutlet	id							AnzahlSolarDatenFeld;
IBOutlet	id							SolarWertFeld;
IBOutlet id							SolarZaehlerFeld;
IBOutlet	id							SolarLaufzeitFeld;
IBOutlet	id							SolarZeitKompressionTaste;
float									SolarZeitKompression;
IBOutlet id							SolarLoadtimeFeld;
IBOutlet id							SolarLoadMark;
IBOutlet id							SolarStartzeitFeld;
NSCalendarDate*					SolarDatenserieStartZeit;
IBOutlet NSDatePicker *			SolarKalender;
int									SolarHeuteblocker;
int									SolarKalenderblocker;
NSMutableArray*					HeizungKanalArray;
NSMutableArray*					BrennerKanalArray;
NSMutableArray*					BrennerStatistikKanalArray;
NSMutableArray*					BrennerStatistikTemperaturKanalArray;

NSMutableArray*					SolarKanalArray;
NSMutableArray*					StatusKanalArray;

IBOutlet id							BoilerobenFeld;
IBOutlet id							BoilermitteFeld;
IBOutlet id							BoileruntenFeld;
IBOutlet id							KollektorVorlaufFeld;
IBOutlet id							KollektorRuecklaufFeld;
IBOutlet id							KollektorTemperaturFeld;

IBOutlet id							SolaranlageBild;


// SolarStatistikTab
IBOutlet id                   SolarStatistikDiagrammFeld;
IBOutlet	id                   SolarStatistikDiagrammScroller;
IBOutlet	id                   SolarStatistikJahrPop;
IBOutlet	id                   SolarStatistikMonatPop;
IBOutlet	id                   SolarStatistikTagPop;
IBOutlet	id                   SolarStatistikKalender;
IBOutlet	id                   SolarStatistikAuswahlTaste;

rStatistikDiagramm*           SolarStatistikDiagramm;
rLegende*							SolarStatistikLegende;
rDiagrammGitterlinien*        SolarStatistikGitterlinien;

rSolarStatistikDiagramm*		ElektroStatistikDiagramm;
rOrdinate*							SolarStatistikOrdinate;
rLegende*							ElektroStatistikLegende;

rTagGitterlinien*					SolarTagGitterlinien;







}

- (void)setI2CStatus:(int)derStatus;
- (void)setBrennerTagplan:(id)sender;

- (void)setDatenplan:(NSArray*) derDatenplan;
- (int)sendCmd:(NSString*)derBefehl mitDaten:(NSArray*)dieDaten;
- (int)sendData:(NSArray*)dieDaten;
- (IBAction)readTagplan:(id)sender;
- (IBAction)reportStart:(id)sender;
- (IBAction)reportStop:(id)sender;
- (IBAction)reportClear:(id)sender;
- (IBAction)reportHeute:(id)sender;
- (IBAction)reportStatistikJahr:(id)sender;
- (IBAction)reportStatistikMonat:(id)sender;
- (IBAction)reportSuchen:(id)sender;
- (IBAction)reportSolarClear:(id)sender;
- (IBAction)reportSolarZeitKompression:(id)sender;

- (void)clearSolarData;
- (IBAction)reportSolarKalender:(id)sender;
- (void)readTagplan:(int)i2cAdresse vonAdresse:(int)startAdresse anz:(int)anzDaten;
- (NSString*)IntToBin:(int)dieZahl;
- (NSString*)stringAusZeit:(NSTimeInterval) dieZeit;
- (NSTextView*)DruckDatenView;
- (NSCalendarDate*)DatenserieStartZeit;
- (NSString*)DatumSuffixVonDate:(NSDate*)dasDatum;
- (void)setKalenderBlocker:(int)derStatus;
- (NSString*)DruckDatenString;
- (void)clearData;
- (BOOL)saveErrString;
- (void)setZeitKompression;
- (void)setRouter_IP:(NSString*)dieIP;
- (int)Datenquelle;
- (void)writeIOWLog:(NSString*)derFehler;
- (IBAction)reportPrint:(id)sender;
- (void)setBrennerStatistik:(NSDictionary*)derDatenDic;
- (IBAction)reload:(id)sender;

- (void)setSolarStatistik:(NSDictionary*)derDatenDic;
- (IBAction)reportSolarUpdate:(id)sender;
- (void)setSolarKalenderBlocker:(int)derStatus;
- (IBAction)reportSolarStatistikKalender:(id)sender;
- (int)StatistikJahr;
- (int)StatistikMonat;
- (NSDictionary*)SolarStatistikDatum;
-(BOOL)windowShouldClose:(id)sender;
@end



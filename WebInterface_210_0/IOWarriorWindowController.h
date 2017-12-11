/* IOWarriorWindowController */

#import <Cocoa/Cocoa.h>

#include <netdb.h>
#import "IOWarriorLib.h"
#import "rHexEingabe.h"
#import "rADWandler.h"
#import "rAVR.h"
#import "rDump_DS.h"
#import "rData.h"
#import "rHomeData.h"
#import "rHomeClient.h"
#import "rEinstellungen.h"

@interface IOWarriorWindowController : NSObject <NSTableViewDelegate, NSTableViewDataSource,NSOpenSavePanelDelegate,NSURLConnectionDelegate>
{
	BOOL										isReading;
	BOOL										isTracking;
	NSTimer*									readTimer;
	NSTimer*									trackTimer;
	
	BOOL										ignoreDuplicates;
	int										anzDaten;
	NSMutableArray*						logEntries;
	NSMutableArray*						dumpTabelle;
	IBOutlet	NSTableView*				dumpTable;
	int										dumpCounter;
	rDump_DS*								Dump_DS;
	IBOutlet	NSTableView*				logTable;
	IBOutlet	NSWindow*					window;
	IBOutlet	NSPopUpButton*				interfacePopup;
	IBOutlet	NSPopUpButton*				macroPopup;
	IBOutlet	NSTextField*				reportIDField;	    /*" id for reports sent "*/
	IBOutlet	NSButton*					ignoreDuplicatesCheckBox; 
	IBOutlet    NSButton*				readButton;
	IBOutlet    NSButton*				addMacroButton;
	
	IBOutlet    NSPopUpButton*       AdressPop;
	IBOutlet    NSPopUpButton*       ReportIDPop;
	
	NSData*						lastValueRead; /*" The last value read"*/
	NSData*						lastDataRead; /*" The last Data read"*/
	NSData*						secureDataRead;
   
   NSURL*                  localHostIP;
   NSURL*                  webHostIP;
	int							anzDataOK;
	int							anzSessionFiles;
	int							oldHour;
	int							daySaved;
	int							newDay;
	int							beendet;
	//int							gesichert;
	int							old;
   BOOL                    localNetz;
	rADWandler*								ADWandler;
	NSMutableArray*						EinkanalDaten;
	NSDate*									DatenleseZeit;
	
	rAVR*										AVR;
	
	rData*									Data;
	
	rHomeData *								HomeData;
	int										lastDataZeit;
	NSTimer*									DownloadTimer;
	
	rHomeClient*							HomeClient;
	
	rEinstellungen*						EinstellungenFenster;
	
	IBOutlet id WindowMenu;
	IBOutlet id AblaufMenu;
	
	int										TWIStatus;
	
	// Solar
   int									lastSolarDataZeit;
	NSTimer*									SolarDownloadTimer;

}

//- (NSDateComponents*) heute;


/*" Actions methods"*/
- (IBAction)doRead:(id)sender;
- (IBAction)doWrite:(id)sender;
- (IBAction)interfacePopupChanged:(id)sender;
- (IBAction)clearLogEntries:(id)sender;
- (IBAction)macroPopupChanged:(id)sender;
- (IBAction)addMacro:(id)sender;
- (IBAction)deleteMacro:(id)sender;
- (IBAction)resetReportValues:(id)sender;
- (IBAction)duplicateCheckboxClicked:(id)sender;

/*" Interface validation "*/
- (void) populateInterfacePopup;
- (void) updateMacroPopup;

/*" Logging "*/
- (void) addLogEntryWithDirection:(NSString*) inDirection reportID:(int)inReportID
                       reportSize:(int) inSize reportData:(UInt8*) inData;
+ (NSDictionary*) logEntryWithDirection:(NSString*) inDirection reportID:(int) inReportID
                             reportSize:(int) inSize reportData:(UInt8*) inData name:(NSString*) inName;
- (void) updateInterfaceFromLogEntry:(NSDictionary*) inLogEntry;

/*" Reading "*/

- (void) startReading;
- (void) stopReading;

- (void)read:(NSTimer*) inTimer;
- (void) setLastValueRead:(NSData*) inData;
- (void) setDump:(NSArray*)derDatenArray;
- (void) setNewDump;
/*" Misc stuff "*/

- (NSString*) nameForIOWarriorInterfaceType:(int) inType;
- (BOOL) reportIdRequiredForWritingToInterfaceOfType:(int) inType;
- (IOWarriorHIDDeviceInterface**) currentInterface;
- (int) currentInterfaceType;
- (int) reportSizeForInterfaceType:(int) inType;

- (IBAction)showADWandler:(id)sender;
- (void)readPList;
- (IBAction)terminate:(id)sender;
-(void)DruckDatenSchreibenMitDatum:(NSCalendar*)dasDatum ganzerTag:(int)ganz;
/* HomeDAta */
-(void)openWithString:(NSString*)derDatenString;
-(void)openWithSolarString:(NSString*)derDatenString;

@end

@interface IOWarriorWindowController(rOutput)
- (void)WriteHexStringArray:(NSArray*)derHexStringArray;
- (void)WriteHexArray:(NSArray*)derHexArray;
- (void)writeDigiVonString:(NSString*)derString;
- (NSString*)DigiStringAusChar:(unichar)derChar;
- (NSNumber*)NumberAusHex: (NSString*)derHexString;
- (void)SendAktion:(NSNotification*)note;


@end

@interface IOWarriorWindowController(rInput)
- (void)setPortBox:(NSArray*)derPortArray;
- (void) stopTracking;
- (void) startTracking;
- (void)trackRead:(NSTimer*) inTimer;
- (void) setLastDataRead:(NSData*) inData;
@end

@interface IOWarriorWindowController(rADWandlerController)
//- (id)initWithFrame:(NSRect)frame;
- (IBAction)showADWandler:(id)sender;
- (IBAction)saveMehrkanalDaten:(id)sender;
@end

@interface IOWarriorWindowController(rAVRController)
- (IBAction)showAVR:(id)sender;
- (IBAction)InitI2C:(id)sender;
- (IBAction)ResetI2C:(id)sender;
- (void)setBrennerDatenFor:(int)dasJahr;
- (void)setStatistikDaten;
- (void)setSolarStatistikDaten;
@end

@interface IOWarriorWindowController(rDataController)
- (IBAction)showData:(id)sender;
- (void)setRaumData:(NSDictionary*) derDataDic;

- (IBAction)InitI2C:(id)sender;
- (IBAction)ResetI2C:(id)sender;
@end

@interface IOWarriorWindowController(rHomeDataController)
- (IBAction)showHomeData:(id)sender;
- (void)startHomeData;
@end

@interface IOWarriorWindowController(rEinstellungenController)
- (IBAction)showEinstellungen:(id)sender;

@end

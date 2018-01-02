/* rHomeData */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "defines.h"

@class WebDownload;

@interface rHomeData : NSWindowController <NSURLDownloadDelegate,NSURLConnectionDelegate,NSURLSessionDataDelegate>
{
	IBOutlet NSMatrix *directoryMatrix;
	IBOutlet NSButton *openButton;
	IBOutlet NSButton *decodeButton;
	IBOutlet NSButton *downloadCancelButton;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSTextField *URLField;
	IBOutlet NSDatePicker *Kalender;
	IBOutlet NSPopUpButton * URLPop;
	
	
	NSURLRequest *				HomeCentralRequest;
	NSMutableData *			HomeCentralData;
	BOOL                    isDownloading;
   BOOL                    localNetz;
	
	WebDownload *download;
	
	int receivedContentLength;
	int expectedContentLength;
	
	NSString* DownloadPfad;
	NSString* ServerPfad;
	NSString* DataSuffix;
	
	NSString* SolarDataSuffix;
   
   

	
	//rHomeData * HomeData;
	int DownloadCode;
	int lastDataZeit;
	
	NSString*		prevDataString;
	int downloadFlag;
	
	// solar
	int lastSolarDataZeit;
	NSString*		prevSolarDataString;
	NSURLRequest *				SolarCentralRequest;
	NSMutableData *			SolarCentralData;

   float                         pumpeleistungsfaktor;
   float                         elektroleistungsfaktor;
   float                         fluidleistungsfaktor;
	
   // Strom
   int lastStromDataZeit;
   NSString*               prevStromDataString;
   NSURLRequest *          StromCentralRequest;
   NSMutableData *         StromCentralData;
   NSString* StromDataSuffix;
   
   
}
- (IBAction)downloadOrCancel:(id)sender;
- (void)cancel;
- (NSString*)Router_IP;

- (NSString*)DatumSuffixVonDate:(NSDate*)dasDatum;
- (NSString*)DataVon:(NSDate*)dasDatum;
- (NSString*)DataVonHeute;
- (NSString*)LastData;

- (NSString*)SolarDataVon:(NSDate*)dasDatum;
- (NSString*)SolarDataVonHeute;
- (NSString*)LastSolarData;
- (NSString*)TestSolarData;

- (NSArray*)BrennerStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (NSArray*)TemperaturStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (int)lastDataZeitVon:(NSString*)derDatenString;

- (NSArray*)ElektroStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (IBAction)reportURLPop:(id)sender;
- (NSArray*)SolarErtragVonHeute;
- (NSArray*)SolarErtragVonJahr:(int)dasJahr Monat:(int)derMonat Tag:(int)derTag;
- (NSArray*)SolarErtragVonJahr:(int)dasJahr vonMonat:(int)monat;

- (NSArray*)KollektorMittelwerte;
- (NSArray*)KollektorMittelwerteVonJahr:(int)jahr;
- (int)tagdesjahresvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag;

-(void)setPumpeLeistungsfaktor:(float)faktor;
-(void)setElektroLeistungsfaktor:(float)faktor;
-(void)setFluidLeistungsfaktor:(float)faktor;
@end

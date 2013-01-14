/* rHomeData */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@class WebDownload;

@interface rHomeData : NSWindowController
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
	BOOL isDownloading;
	
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

	
}
- (IBAction)downloadOrCancel:(id)sender;
- (void)cancel;
- (NSArray*)Router_IP;

- (NSString*)DatumSuffixVonDate:(NSDate*)dasDatum;
- (NSString*)DataVon:(NSDate*)dasDatum;
- (NSString*)DataVonHeute;
- (NSString*)LastData;

- (NSString*)SolarDataVon:(NSDate*)dasDatum;
- (NSString*)SolarDataVonHeute;
- (NSString*)LastSolarData;

- (NSArray*)BrennerStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (NSArray*)TemperaturStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (int)lastDataZeitVon:(NSString*)derDatenString;

- (NSArray*)ElektroStatistikVonJahr:(int)dasJahr Monat:(int)derMonat;
- (IBAction)reportURLPop:(id)sender;
- (NSArray*)SolarErtragVonHeute;
- (NSArray*)SolarErtragVonJahr:(int)dasJahr Monat:(int)derMonat Tag:(int)derTag;

- (NSArray*)KollektorMittelwerte;
- (NSArray*)KollektorMittelwerteVonJahr:(int)jahr;
- (int)tagdesjahresvonJahr:(int)jahr Monat:(int)monat Tag:(int)tag;
@end

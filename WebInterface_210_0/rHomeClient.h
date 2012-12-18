//
//  rHomeClient.h
//  WebInterface
//
//  Created by Sysadmin on 15.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
//#import <WebPreferences.h>
@class WebDownload;
static NSString *HTMLDocumentType = @"HTML document";

@interface rHomeClient : NSObject 
{
	NSString* HomeCentralURL;
  // NSString* LocalHomeCentralURL;
	
   NSString* pw;
	NSString *url;
	NSString *_source;
	WebView *	webView;
	NSURL *					URLToLoad;
	NSString *frameStatus;
	NSTimer* sendTimer;
	NSTimer* confirmTimer;
	NSTimer* confirmStatusTimer;
	int maxAnzahl;
  
   // Dic fuer Senden von EEPROMDaten an HomeServer
   NSMutableDictionary* SendEEPROMDataDic;
	
}

- (void)setHomeCentralI2C:(int)derStatus;
- (void)setWebI2C:(int)derStatus;
- (NSString*)ReadURLForEEPROM:(int)EEPROMADDRESS hByte: (int)hbyte lByte:(int)lByte;
- (NSString*)WriteURLForAddress:(int)EEPROMADDRESS fromAddress: (int)startAddress ;

- (void)loadURL:(NSURL *)URL;
- (void)setURLToLoad:(NSURL *)URL;
- (void)setFrameStatus: (NSString *)s;
- (NSString *)dataRepresentationOfType:(NSString *)aType;

// Data an Homeserver schicken
- (int)sendEEPROMDataMitDic:(NSDictionary*)EEPROMDataDic;

@end

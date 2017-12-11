//
//  rHomeClient.h
//  WebInterface
//
//  Created by Sysadmin on 15.August.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "defines.h"
#import "Utils.h"

//#import <WebPreferences.h>

@class WebDownload;



//NSArray* PW_Array = [NSArray arrayWithObjects:pw_array count:64];
static NSString *HTMLDocumentType = @"HTML document";
/*
int pw_array[64] = {0x47,	0x3E,	0xD,	0x5,	0x21,	0x3D,	0x42,	0x25,0x22,	0x34,	0x3F,	0x4C,	0x10,	0x5,	0x3C,	0x63, 0x50,	0x5,	0x7,	0x0,0x3C,	0x11,	0x43,	0x4D,0x6,	0x5E,	0x0,	0x53,	0x34,	0x10,	0x41,	0x1F,0x2A,	0x5E,	0x16,	0x2B,	0x56,	0x7,	0x44,	0x62,
   0x8,	0x54,	0x18,	0x2F,	0x4D,	0x1,	0x5F,	0x4,0x9,	0x22,	0x5E,	0x36,	0x2C,	0x48,	0x45,	0x13,0x26,	0x5C,	0x4D,	0x4B,	0x32,	0x1E,	0x1D,	0x3F};
*/
enum webtaskflag{idle, eepromread, eepromwrite,eepromreadwoche,eepromwritewoche}webtaskflag;

@interface rHomeClient : NSObject <NSURLConnectionDelegate,WebFrameLoadDelegate,WebUIDelegate,WebResourceLoadDelegate>
{
	NSString* HomeCentralURL;
  // NSString* LocalHomeCentralURL;
	
   NSString*               pw;
	NSString *              url;
	NSString *              _source;
	WebView *               webView;
	NSURL *                 URLToLoad;
	NSString *              frameStatus;
	NSTimer*                sendTimer;
	NSTimer*                confirmTimer;
	NSTimer*                confirmStatusTimer;
   int                     maxAnzahl;
   int                     loadAlertOK;
   int                     loadTestStatus;
   NSString*               lastEEPROMData;
   int testdataok;
   // Dic fuer Senden von EEPROMDaten an HomeServer
   NSMutableDictionary*    SendEEPROMDataDic;
   NSTimer*                EEPROMUpdateTimer;
   BOOL                    localNetz; // lokales Netzwerk benutzen
	int							WebTask;          // Auszuführende Aktion aufgrund von Web-Requests
   int							Webserver_busy;
   int							WriteWoche_busy;
   int                     downloadflag;
   Utils*                  Util;
}

- (BOOL)localNetz;
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
- (void)KollektormittelwerteberechnenMitJahr:(int)jahr;
@end

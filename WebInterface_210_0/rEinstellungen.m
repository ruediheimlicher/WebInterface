//
//  rEinstellungen.m
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rEinstellungen.h"


@implementation rEinstellungen
- (id) init
{
	self=[super initWithWindowNibName:@"Einstellungen"];
	return self;
}

- (void)awakeFromNib
{
	NSLog(@"Einstellungen awake");
	NSFont* Tablefont;
	Tablefont=[NSFont fontWithName:@"Helvetica" size: 12];
}

- (void)windowDidLoad 
{
	NSLog(@"TheWindowPanel did load");
} // end windowDidLoad

- (void)setEinstellungen:(NSDictionary*)settings
{
   
}



- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"rEinstellungen windowShouldClose");
/*	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];

*/
	
	return YES;
}

- (IBAction)reportSave:(id)sender
{
NSLog(@"reportSave");
}

- (IBAction)reportCancel:(id)sender
{
NSLog(@"reportCancel");
}

- (IBAction)reportClose:(id)sender
{
NSLog(@"reportClose");
[[self window]close];
[[self window]orderOut:NULL];
}

/*
- (IBAction)showWindow:(id)sender
{
NSLog(@"showWindow");

[[self window]makeKeyAndOrderFront:NULL];
}
*/
@end

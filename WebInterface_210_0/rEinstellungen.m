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
   HomebusArray = [[[NSMutableArray alloc]initWithCapacity:0]retain];
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
   int startraumnummer = 0;
   int startobjektnummer = 0;
   [RaumPop removeAllItems];
   
   for (int raumnummer=0;raumnummer < [HomebusArray count];raumnummer++)
   {
      NSDictionary* tempRaumDic = [HomebusArray objectAtIndex:raumnummer];
      NSLog(@"raumnummer: %d raumname: %@",raumnummer, [tempRaumDic objectForKey:@"raumname"]);
      [RaumPop addItemWithTitle:[tempRaumDic objectForKey:@"raumname"]];
      
      
   } // for raumnummer
   [RaumPop selectItemAtIndex:startraumnummer];
   
   [self setObjektnamenVonArray:[[[[[HomebusArray objectAtIndex:startraumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"]];

} // end windowDidLoad

- (void)setEinstellungen:(NSArray*)homebusarray
{
   
   //NSLog(@"setEinstellungen homebusarray: %@",[homebusarray description]);
   [HomebusArray setArray:homebusarray];
   
   
   
   
}

- (void)setObjektnamenVonArray:(NSArray*)objektnamen
{
   for (int i=0;i< [objektnamen count];i++)
   {
      [[[RaumPop superview]viewWithTag:(100+ i)]setStringValue:[objektnamen objectAtIndex:i]];
   }
}

- (IBAction)reportRaumPop:(id)sender
{
   NSLog(@"reportRaumPop index: %d", [sender indexOfSelectedItem]);
   int raumnummer = [sender indexOfSelectedItem];
   //NSLog(@"views: %@",[[[sender superview]subviews]description]);
   [self setObjektnamenVonArray:[[[[[HomebusArray objectAtIndex:raumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"]];
   //[[[sender superview]viewWithTag:(100+ raumnummer)]setStringValue:@"eins"];
   

}

- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"rEinstellungen windowShouldClose");
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [BeendenDic setObject:[NSNumber numberWithInt:1]forKey:@"quelle"];
	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];


	[HomebusArray release];
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

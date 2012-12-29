//
//  rEinstellungenController.m
//  WebInterface
//
//  Created by Sysadmin on 11.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "IOWarriorWindowController.h"


@implementation IOWarriorWindowController(rEinstellungenController)
	//EinstellungenFenster = [[rEinstellungen alloc]init];
- (IBAction)showEinstellungen:(id)sender
{
NSLog(@"showEinstellungenFenster");
	if (!EinstellungenFenster)
	{
		//[self Alert:@"showEinstellungenFenster vor init"];
		NSLog(@"showEinstellungenFenster neu");
		
		EinstellungenFenster=[[rEinstellungen alloc]init];
		
		//[EinstellungenFenster showWindow:self];

		//[self Alert:@"showEinstellungenFenster nach init"];
	}
   [EinstellungenFenster setEinstellungen:[AVR HomebusArray]];
	[EinstellungenFenster showWindow:NULL];

}

@end

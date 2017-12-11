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
   HomebusArray = [[NSMutableArray alloc]initWithCapacity:0];
   
   NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
	[nc addObserver:self
			 selector:@selector(PopUpChangeAktion:)
				  name:@"NSControlTextDidEndEditingNotification"
				object:nil];

   	return self;
   
}

- (void)awakeFromNib
{
	NSLog(@"Einstellungen awake");
   updateIndexSet = [NSMutableIndexSet indexSet];

	NSFont* Tablefont;
	Tablefont=[NSFont fontWithName:@"Helvetica" size: 12];
   //[RaumPop setDelegate:self];
   //[[RaumPop menu] setDelegate:self];

}

- (void)windowDidLoad 
{
	//NSLog(@"Einstellungen did load");
   int startraumnummer = 0;
   int startobjektnummer = 0;
   [RaumPop removeAllItems];
   
   for (int raumnummer=0;raumnummer < [HomebusArray count];raumnummer++)
   {
      NSDictionary* tempRaumDic = [HomebusArray objectAtIndex:raumnummer];
      //NSLog(@"raumnummer: %d raumname: %@",raumnummer, [tempRaumDic objectForKey:@"raumname"]);
      [RaumPop addItemWithTitle:[tempRaumDic objectForKey:@"raumname"]];
      
      
   } // for raumnummer
   [RaumPop selectItemAtIndex:startraumnummer];
   
   [self setObjektnamenVonArray:[[[[[HomebusArray objectAtIndex:startraumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"]];
   

} // end windowDidLoad

- (void)setEinstellungen:(NSArray*)homebusarray
{
   
   //NSLog(@"setEinstellungen homebusarray: %@",[homebusarray description]);
   [updateIndexSet removeAllIndexes];
   [HomebusArray setArray:homebusarray];
   
   
   
   
}

- (void)setObjektnamenVonArray:(NSArray*)objektnamen
{
   
   for (int i=0;i< [objektnamen count];i++)
   {
      [[[RaumPop superview]viewWithTag:(100+ i)]setStringValue:[objektnamen objectAtIndex:i]];
      [[[RaumPop superview]viewWithTag:(100+ i)]setDelegate:self];
   }
}

- (IBAction)reportRaumPop:(id)sender
{
   int erfolg=[[self window]makeFirstResponder:[self window]];
   NSLog(@"reportRaumPop index: %d", [sender indexOfSelectedItem]);
   int raumnummer = [sender indexOfSelectedItem];
   //NSLog(@"views: %@",[[[sender superview]subviews]description]);
   [self setObjektnamenVonArray:[[[[[HomebusArray objectAtIndex:raumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"]];
   //[[[sender superview]viewWithTag:(100+ raumnummer)]setStringValue:@"eins"];
   

}

- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"rEinstellungen windowShouldClose: %@",[updateIndexSet description]);
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [BeendenDic setObject:[NSNumber numberWithInt:1]forKey:@"quelle"];
	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];


	return YES;
}

- (IBAction)reportSave:(id)sender
{
   NSLog(@"reportSave: %@",[updateIndexSet description]);
   //[self saveObjektnamen];
   
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* SaveDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [SaveDic setObject:HomebusArray forKey:@"homebusarray"];
	[nc postNotificationName:@"saveSettings" object:self userInfo:SaveDic];

}

- (void)saveObjektnamen
{
   int raum = [RaumPop indexOfSelectedItem];
   for (int objekt=0;objekt<6;objekt++)
   {
      NSString* ObjektTitel = [[[RaumPop superview]viewWithTag:(100+ objekt)]stringValue];
      //NSLog(@"saveObjektnamen raum: %d objekttitel: %@",raum,ObjektTitel);
      
      for (int wochentag = 0;wochentag < 7;wochentag++)
      {
     
         [[[[[[HomebusArray objectAtIndex:raum]
             objectForKey:@"wochenplanarray"]
            objectAtIndex:wochentag]
           objectForKey:@"tagplanarray"]objectAtIndex:objekt]setObject:ObjektTitel forKey:@"objektname"];
         
      }
   }
   //NSLog(@"Hombusarray: %@",[[[HomebusArray objectAtIndex:raum]objectForKey:@"wochenplanarray"]description]);

    //   [[[[[HomebusArray objectAtIndex:startraumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"];
   

}

- (void)saveObjektnamenForRaum:(int)raum forObjekt:(int)objekt
{
      NSString* ObjektTitel = [[[RaumPop superview]viewWithTag:(100+ objekt)]stringValue];
      //NSLog(@"saveObjektnamen raum: %d objekttitel: %@",raum,ObjektTitel);
      
      for (int wochentag = 0;wochentag < 7;wochentag++)
      {
         
         [[[[[[HomebusArray objectAtIndex:raum]
              objectForKey:@"wochenplanarray"]
             objectAtIndex:wochentag]
            objectForKey:@"tagplanarray"]objectAtIndex:objekt]setObject:ObjektTitel forKey:@"objektname"];
         
      }
   
   //NSLog(@"Hombusarray: %@",[[[HomebusArray objectAtIndex:raum]objectForKey:@"wochenplanarray"]description]);
   
   //   [[[[[HomebusArray objectAtIndex:startraumnummer]objectForKey:@"wochenplanarray"]objectAtIndex:0]objectForKey:@"tagplanarray"]valueForKey:@"objektname"];
}


- (IBAction)reportCancel:(id)sender
{
NSLog(@"reportCancel");
   [updateIndexSet removeAllIndexes];
}

- (IBAction)reportClose:(id)sender
{
NSLog(@"reportClose updateindex: %@",[updateIndexSet description]);
   
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

- (void)PopUpChangeAktion:(NSNotification *)aNotification
{
   //NSLog(@"PopUpChangeAktion: %@",[aNotification description]);
}
- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
   int raum = [RaumPop indexOfSelectedItem];
   int tag = [[aNotification object]tag];
   int updateindex = 1000*raum + tag;
   //NSLog(@"controlTextDidEndEditing raum: %d titel: %@ tag: %d updateindex: %d",raum,[[aNotification object]stringValue],tag,updateindex);
   [self saveObjektnamenForRaum:raum forObjekt:tag%100]; // tag ist 100+index des objekts
   [updateIndexSet addIndex:updateindex];
}

@end

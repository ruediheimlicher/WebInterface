#import "IOWarriorWindowController.h"



@implementation IOWarriorWindowController(rADWandlerController)
- (void)Alert:(NSString*)derFehler
{
   /*
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
    */
   NSAlert * DebugAlert=[[NSAlert alloc]init];
   DebugAlert.messageText= @"Debugger!";
   DebugAlert.informativeText = [NSString stringWithFormat:@"Mitteilung: \n%@",derFehler];

		[DebugAlert runModal];

}

- (void)drawRect:(NSRect)rect 
{
NSLog(@"drawRect");
    // Drawing code here.
}


- (IBAction)showADWandler:(id)sender
{
 //	[self Alert:@"showADWandler start init"];
	if (!ADWandler)
	  {
	  //[self Alert:@"showADWandler vor init"];
		//NSLog(@"showADWandler");
		ADWandler=[[rADWandler alloc]init];
		//[self Alert:@"showADWandler nach init"];
		//[ADWandler retain];
	  }
	  //[self Alert:@"showADWandler nach init"];
//	NSMutableArray* 
	EinkanalDaten=[[NSMutableArray alloc]initWithCapacity:0];
	//NSLog(@"showADWandler vor showWindow: %@",[[[ADWandler window]contentView]description]);
	//[self Alert:@"showADWandler vor showWindow"];
	 
//	if ([ADWandler window]) ;
	{
//	[self Alert:@"showADWandler window da"];

	[ADWandler showWindow:NULL];
	}
//	 [self Alert:@"showADWandler nach showWindow"];
	//NSLog(@"showADWandler nach showWindow %@",[[ADWandler window]description]);
//	[[ADWandler window]makeKeyAndOrderFront:self];
}

- (IBAction)saveMehrkanalDaten:(id)sender
{
	NSSavePanel* SichernPanel=[NSSavePanel savePanel];
	[SichernPanel setDelegate:self];
	[SichernPanel setCanCreateDirectories:YES];
	
  /*
   [SichernPanel beginSheetForDirectory:NSHomeDirectory()
									file:@"MehrkanalDaten" 
									modalForWindow:[ADWandler  window] 
						   modalDelegate:self 
						  didEndSelector:@selector(MehrkanalDatenPanelDidEnd:)
							 contextInfo:NULL];
	
   [SichernPanel beginSheetModalForWindow:[ADWandler window]
                            modalDelegate:self
                           didEndSelector:@selector(MehrkanalDatenPanelDidEnd:)
                              contextInfo:nil];
*/

   [SichernPanel beginSheetModalForWindow:[ADWandler window] completionHandler:^(NSModalResponse result)
    {
       NSNotificationCenter * nc;
       nc=[NSNotificationCenter defaultCenter];
       [nc postNotificationName:@"mehrkanaldaten" object:self];
       
    }];

}
- (void)MehrkanalDatenPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
{
NSLog(@"MehrkanalDatenPanelDidEnd ret code: %d",returnCode);
}
@end

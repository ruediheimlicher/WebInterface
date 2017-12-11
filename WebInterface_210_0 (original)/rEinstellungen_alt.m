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





- (void)setBewertung:(BOOL)mitBewertung
{
	//int s=[BewertungZeigen state];
	[BewertungZeigen setState:mitBewertung];
}

- (void)setNote:(BOOL)mitNote
{
	//int s=[BewertungZeigen state];
	[NoteZeigen setState:mitNote];
}

- (IBAction)reportClose:(id)sender
{
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* StatusDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	NSNumber* NoteStatus=[NSNumber numberWithInt:[NoteZeigen state]];
	NSLog(@"reportClose: StatusDic: %@",[StatusDic description]);
	[nc postNotificationName:@"Einstellungen" object:self userInfo:StatusDic];

    //[NSApp stopModalWithCode:1];
	[[self window]orderOut:NULL];

}
- (IBAction)reportCancel:(id)sender
{
    [NSApp stopModalWithCode:0];
	[[self window]orderOut:NULL];
}

@end

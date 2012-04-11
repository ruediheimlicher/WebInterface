/* rEinstellungen */

#import <Cocoa/Cocoa.h>

@interface rEinstellungen : NSWindowController
{
    IBOutlet id BewertungZeigen;
    IBOutlet id NoteZeigen;
	IBOutlet id TimeoutCombo;

}
- (IBAction)reportSave:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (void)setMitPasswort:(BOOL)mitPW;

- (void)setTimeoutDelay:(NSTimeInterval)derDelay;

@end

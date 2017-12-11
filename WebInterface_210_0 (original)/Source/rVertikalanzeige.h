/* rVertikalanzeige */

#import <Cocoa/Cocoa.h>
#import "defines.h"

@interface rVertikalanzeige : NSView
{
	//NSColor* penColour;
	float Feldbreite;
	float Feldhoehe;
	int AnzFelder;
	float Grenze;
	float Level;
	float max;
	float lastLevel;
	float lastMax;
	BOOL maxSet;
	BOOL delaySet;
	float fixTime;
	int holdMax;
	NSTimer* fixTimer;
	long tag;
	NSString* titel;
}
//@property (readwrite) NSInteger tag;
- (void)setLevel:(int) derLevel;
- (void)drawAnzeige;
- (void)setTag:(long)tag;
- (void)setStringLevel:(NSString*)derLevel;
@end
